<?php
/*
Plugin Name: Akakul Booking
Description: Плагин для бронирования товаров. Добавляет кнопку "Забронировать" рядом с кнопкой "Купить", переводит на отдельную страницу для бронирования и отправляет подтверждение по email.
Version: 1.2
Author: sk8work
*/

if (!defined('ABSPATH')) {
    exit; // Выход, если файл вызывается напрямую
}

// Создаем таблицу при активации плагина
register_activation_hook(__FILE__, 'create_booking_table');

function create_booking_table() {
    global $wpdb;
    $table_name = $wpdb->prefix . 'woocommerce_bookings';
    $charset_collate = $wpdb->get_charset_collate();

    $sql = "CREATE TABLE $table_name (
        id mediumint(9) NOT NULL AUTO_INCREMENT,
        product_id mediumint(9) NOT NULL,
        parent_name varchar(255) NOT NULL,
        child_name varchar(255) NOT NULL,
        email varchar(255) NOT NULL,
        phone varchar(50) NOT NULL,
        child_bdate varchar(50) NOT NULL,
        booking_date datetime DEFAULT CURRENT_TIMESTAMP NOT NULL,
        confirmation_token varchar(64) DEFAULT NULL,
        is_confirmed tinyint(1) DEFAULT 0,
        PRIMARY KEY (id)
    ) $charset_collate;";

    require_once(ABSPATH . 'wp-admin/includes/upgrade.php');
    dbDelta($sql);
}

// Создаем страницу для бронирования при активации плагина
register_activation_hook(__FILE__, 'create_booking_page');

function create_booking_page() {
    // Проверяем, существует ли уже страница бронирования
    $page = get_page_by_path('booking');
    if (!$page) {
        $page = array(
            'post_title'   => __('Бронирование товара', 'woocommerce-booking'),
            'post_content' => '[woocommerce_booking_page]',
            'post_status'  => 'publish',
            'post_author'  => 1,
            'post_type'    => 'page',
            'post_name'    => 'booking',
        );

        wp_insert_post($page);
    }
}

// Добавляем кнопку "Забронировать" рядом с кнопкой "Купить"
add_action('woocommerce_after_add_to_cart_button', 'add_booking_button');

function add_booking_button() {
    global $product;
    $booking_url = home_url('/bronirovanie/?product_id=' . $product->get_id());
    echo '<a href="' . esc_url($booking_url) . '" class="button">' . __('Забронировать', 'woocommerce-booking') . '</a>';
}

// Шорткод для отображения страницы бронирования
add_shortcode('woocommerce_booking_page', 'render_booking_page');

function render_booking_page() {
    if (!isset($_GET['product_id'])) {
        return __('Товар не выбран.', 'woocommerce-booking');
    }

    $product_id = intval($_GET['product_id']);
    $product = wc_get_product($product_id);

    if (!$product) {
        return __('Товар не найден.', 'woocommerce-booking');
    }

    // Если данные для бронирования отправлены
    if (isset($_POST['submit_booking'])) {
        return handle_booking_request($product_id);
    }

    // Отображаем форму бронирования
    return get_booking_form($product);
}

// Форма бронирования
function get_booking_form($product) {
    ob_start();
    ?>
    <div class="woocommerce-booking-form">
        <h2><?php echo __('Бронирование товара:', 'woocommerce-booking') . ' ' . $product->get_name(); ?></h2>
        <form method="post">
            <p class="form-row">
                <label for="billing_first_name"><?php _e('Ф.И.О. родителя', 'woocommerce-booking'); ?></label>
                <input type="text" id="billing_first_name" name="billing_first_name" required>
            </p>
            <p class="form-row">
                <label for="billing_child_name"><?php _e('Ф.И.О. ребенка', 'woocommerce-booking'); ?></label>
                <input type="text" id="billing_child_name" name="billing_child_name" required>
            </p>
            <p class="form-row">
                <label for="billing_wooccm11"><?php _e('Дата рождения ребенка', 'woocommerce-booking'); ?></label>
                <input type="date" id="billing_wooccm11" name="billing_wooccm11" required>
            </p>
            <p class="form-row">
                <label for="billing_email"><?php _e('Email', 'woocommerce-booking'); ?></label>
                <input type="email" id="billing_email" name="billing_email" required>
            </p>
            <p class="form-row">
                <label for="billing_phone"><?php _e('Телефон', 'woocommerce-booking'); ?></label>
                <input type="tel" id="billing_phone" name="billing_phone" required>
            </p>
            <button type="submit" name="submit_booking" class="button alt"><?php _e('Забронировать', 'woocommerce-booking'); ?></button>
        </form>
    </div>
    <?php
    return ob_get_clean();
}

// Генерация уникального токена
function generate_booking_token() {
    return bin2hex(random_bytes(16)); // Генерация случайного токена
}

// Обработка бронирования
function handle_booking_request($product_id) {
    $product = wc_get_product($product_id);

    if (!$product || !$product->is_in_stock()) {
        return __('Товар недоступен для бронирования.', 'woocommerce-booking');
    }

    // Проверяем, заполнены ли данные покупателя
    if (empty($_POST['billing_first_name']) || empty($_POST['billing_child_name']) || empty($_POST['billing_wooccm11']) || empty($_POST['billing_email']) || empty($_POST['billing_phone'])) {
        return __('Все поля обязательны для заполнения.', 'woocommerce-booking');
    }

    // Собираем данные покупателя
    $parent_name = sanitize_text_field($_POST['billing_first_name']);
    $child_name  = sanitize_text_field($_POST['billing_child_name']);
    $child_bdate = $_POST['billing_wooccm11'];
    $email       = sanitize_email($_POST['billing_email']);
    $phone       = sanitize_text_field($_POST['billing_phone']);

    // Генерация токена
    $confirmation_token = generate_booking_token();

    // Логируем бронирование
    $booking_id = log_booking($product_id, $parent_name, $child_name, $child_bdate, $email, $phone, $confirmation_token);

    // Отправляем email с подтверждением
    $subject = __('Подтверждение бронирования', 'woocommerce-booking');
    $confirmation_url = home_url('/confirm-booking/?token=' . $confirmation_token);
    $message = sprintf(
        __('Здравствуйте, %s! Ваш товар "%s" успешно забронирован. Пожалуйста, подтвердите бронирование, перейдя по ссылке: %s', 'woocommerce-booking'),
        $parent_name,
        $product->get_name(),
        $confirmation_url
    );
    wp_mail($email, $subject, $message);

    return __('Бронирование успешно завершено! Пожалуйста, проверьте вашу почту для подтверждения.', 'woocommerce-booking');
}

// Логируем бронирование
function log_booking($product_id, $parent_name, $child_name, $child_bdate, $email, $phone, $confirmation_token) {
    global $wpdb;
    $table_name = $wpdb->prefix . 'woocommerce_bookings';

    $wpdb->insert(
        $table_name,
        array(
            'product_id' => $product_id,
            'parent_name' => $parent_name,
            'child_name'  => $child_name,
            'child_bdate'  => $child_bdate,
            'email'      => $email,
            'phone'      => $phone,
            'confirmation_token' => $confirmation_token,
        )
    );

    return $wpdb->insert_id;
}

// Обработка подтверждения бронирования
add_action('init', 'handle_booking_confirmation');

function handle_booking_confirmation() {
    if (isset($_GET['token'])) {
        global $wpdb;
        $table_name = $wpdb->prefix . 'woocommerce_bookings';
        $token = sanitize_text_field($_GET['token']);

        // Находим бронирование по токену
        $booking = $wpdb->get_row($wpdb->prepare(
            "SELECT * FROM $table_name WHERE confirmation_token = %s",
            $token
        ));

        if ($booking) {
            // Подтверждаем бронирование
            $wpdb->update(
                $table_name,
                array('is_confirmed' => 1),
                array('id' => $booking->id)
            );

            // Отправляем email с подтверждением
            $subject = __('Бронирование подтверждено', 'woocommerce-booking');
            $message = sprintf(
                __('Здравствуйте, %s! Ваше бронирование товара "%s" подтверждено.', 'woocommerce-booking'),
                $booking->parent_name,
                wc_get_product($booking->product_id)->get_name()
            );
            wp_mail($booking->email, $subject, $message);

            // Выводим сообщение об успешном подтверждении
            wp_die(__('Бронирование успешно подтверждено!', 'woocommerce-booking'), __('Подтверждение бронирования', 'woocommerce-booking'));
        } else {
            wp_die(__('Недействительный токен подтверждения.', 'woocommerce-booking'), __('Ошибка', 'woocommerce-booking'));
        }
    }
}

// Добавляем страницу в админке
add_action('admin_menu', 'add_booking_admin_page');

function add_booking_admin_page() {
    add_menu_page(
        __('Бронирования', 'woocommerce-booking'), // Заголовок страницы
        __('Бронирования', 'woocommerce-booking'), // Название в меню
        'manage_options', // Права доступа
        'woocommerce-bookings', // Slug страницы
        'render_booking_admin_page', // Функция для отображения страницы
        'dashicons-calendar-alt', // Иконка
        6 // Позиция в меню
    );
}

// Функция для отображения страницы
function render_booking_admin_page() {
    global $wpdb;
    $table_name = $wpdb->prefix . 'woocommerce_bookings';

    // Фильтры
    $filter_product = isset($_GET['filter_product']) ? intval($_GET['filter_product']) : '';
    $filter_customer = isset($_GET['filter_customer']) ? sanitize_text_field($_GET['filter_customer']) : '';
    $filter_date = isset($_GET['filter_date']) ? sanitize_text_field($_GET['filter_date']) : '';

    // Формируем SQL-запрос с учетом фильтров
    $where = array();
    if ($filter_product) {
        $where[] = $wpdb->prepare("product_id = %d", $filter_product);
    }
    if ($filter_customer) {
        $where[] = $wpdb->prepare("(parent_name LIKE %s OR child_name LIKE %s)", "%$filter_customer%", "%$filter_customer%");
    }
    if ($filter_date) {
        $where[] = $wpdb->prepare("DATE(booking_date) = %s", $filter_date);
    }
    $where = $where ? 'WHERE ' . implode(' AND ', $where) : '';

    // Пагинация
    $per_page = 20;
    $current_page = isset($_GET['paged']) ? max(1, intval($_GET['paged'])) : 1;
    $offset = ($current_page - 1) * $per_page;

    // Общее количество записей
    $total_items = $wpdb->get_var("SELECT COUNT(id) FROM $table_name $where");

    // Получаем записи с учетом фильтров и пагинации
    $bookings = $wpdb->get_results($wpdb->prepare(
        "SELECT * FROM $table_name $where ORDER BY booking_date DESC LIMIT %d OFFSET %d",
        $per_page,
        $offset
    ));

    echo '<div class="wrap">';
    echo '<h1>' . __('Бронирования', 'woocommerce-booking') . '</h1>';

    // Форма фильтрации
    echo '<form method="get" action="' . admin_url('admin.php') . '">
            <input type="hidden" name="page" value="woocommerce-bookings">
            <div class="tablenav top">
                <div class="alignleft actions">
                    <label for="filter_product">Товар:</label>
                    <input type="text" name="filter_product" id="filter_product" value="' . esc_attr($filter_product) . '">
                    <label for="filter_customer">Покупатель:</label>
                    <input type="text" name="filter_customer" id="filter_customer" value="' . esc_attr($filter_customer) . '">
                    <label for="filter_date">Дата:</label>
                    <input type="date" name="filter_date" id="filter_date" value="' . esc_attr($filter_date) . '">
                    <input type="submit" class="button" value="Фильтровать">
                </div>
            </div>
          </form>';

    // Кнопка экспорта
    echo '<div class="tablenav top">';
    echo '<a href="' . admin_url('admin.php?page=woocommerce-bookings&action=export_csv') . '" class="button">Экспорт в CSV</a>';
    echo '</div>';

    // Пагинация
    $pagination = paginate_links(array(
        'base'    => add_query_arg('paged', '%#%'),
        'format'  => '',
        'current' => $current_page,
        'total'   => ceil($total_items / $per_page),
    ));

    if ($pagination) {
        echo '<div class="tablenav top">';
        echo '<div class="tablenav-pages">' . $pagination . '</div>';
        echo '</div>';
    }

    // Таблица с записями
    echo '<table class="wp-list-table widefat fixed striped">';
    echo '<thead>
            <tr>
                <th>ID</th>
                <th>Товар</th>
                <th>Ф.И.О. родителя</th>
                <th>Ф.И.О. ребенка</th>
                <th>Дата рождения ребенка</th>
                <th>Email</th>
                <th>Телефон</th>
                <th>Дата бронирования</th>
                <th>Подтверждено</th>
                <th>Действия</th>
            </tr>
          </thead>';
    echo '<tbody>';

    foreach ($bookings as $booking) {
        $product = wc_get_product($booking->product_id);
        $product_name = $product ? $product->get_name() : 'Товар удален';

        echo '<tr>
                <td>' . esc_html($booking->id) . '</td>
                <td>' . esc_html($product_name) . '</td>
                <td>' . esc_html($booking->parent_name) . '</td>
                <td>' . esc_html($booking->child_name) . '</td>
                <td>' . esc_html($booking->child_bdate) . '</td>
                <td>' . esc_html($booking->email) . '</td>
                <td>' . esc_html($booking->phone) . '</td>
                <td>' . esc_html($booking->booking_date) . '</td>
                <td>' . ($booking->is_confirmed ? 'Да' : 'Нет') . '</td>
                <td>
                    <a href="' . wp_nonce_url(admin_url('admin.php?page=woocommerce-bookings&action=delete&id=' . $booking->id), 'delete_booking_' . $booking->id) . '" class="button button-secondary">Удалить</a>
                </td>
              </tr>';
    }

    echo '</tbody>';
    echo '</table>';

    if ($pagination) {
        echo '<div class="tablenav bottom">';
        echo '<div class="tablenav-pages">' . $pagination . '</div>';
        echo '</div>';
    }

    echo '</div>';
}

// Обработка удаления записи
add_action('admin_init', 'handle_delete_booking');

function handle_delete_booking() {
    if (isset($_GET['action']) && $_GET['action'] === 'delete' && isset($_GET['id'])) {
        if (!wp_verify_nonce($_GET['_wpnonce'], 'delete_booking_' . $_GET['id'])) {
            wp_die(__('Недействительный запрос.', 'woocommerce-booking'));
        }

        global $wpdb;
        $table_name = $wpdb->prefix . 'woocommerce_bookings';
        $wpdb->delete($table_name, array('id' => intval($_GET['id'])));

        wp_redirect(admin_url('admin.php?page=woocommerce-bookings'));
        exit;
    }
}

// Обработка экспорта в CSV
add_action('admin_init', 'handle_export_csv');

function handle_export_csv() {
    if (isset($_GET['action']) && $_GET['action'] === 'export_csv') {
        global $wpdb;
        $table_name = $wpdb->prefix . 'woocommerce_bookings';

        // Получаем все записи
        $bookings = $wpdb->get_results("SELECT * FROM $table_name ORDER BY booking_date DESC");

        // Заголовки CSV
        $headers = array('ID', 'Товар', 'Ф.И.О. родителя', 'Ф.И.О. ребенка', 'Дата рождения ребенка', 'Email', 'Телефон', 'Дата бронирования', 'Подтверждено');

        // Открываем поток для вывода CSV
        header('Content-Type: text/csv');
        header('Content-Disposition: attachment; filename="bookings.csv"');

        $output = fopen('php://output', 'w');
        fputcsv($output, $headers);

        // Записываем данные
        foreach ($bookings as $booking) {
            $product = wc_get_product($booking->product_id);
            $product_name = $product ? $product->get_name() : 'Товар удален';

            fputcsv($output, array(
                $booking->id,
                $product_name,
                $booking->parent_name,
                $booking->child_name,
                $booking->child_bdate,
                $booking->email,
                $booking->phone,
                $booking->booking_date,
                $booking->is_confirmed ? 'Да' : 'Нет',
            ));
        }

        fclose($output);
        exit;
    }
}