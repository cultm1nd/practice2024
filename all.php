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
    $wpdb->query("DROP TABLE IF EXISTS $table_name");
    $charset_collate = $wpdb->get_charset_collate();

    $sql = "CREATE TABLE $table_name (
        id mediumint(9) NOT NULL AUTO_INCREMENT,
        product_id mediumint(9) NOT NULL,
        product_name varchar(255) NOT NULL,
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

// Удаляем таблицу при удалении плагина
register_uninstall_hook(__FILE__, 'delete_booking_table');

function delete_booking_table() {
    global $wpdb;
    $table_name = $wpdb->prefix . 'woocommerce_bookings';

    // Удаляем таблицу, если она существует
    $wpdb->query("DROP TABLE IF EXISTS $table_name");
}

// Добавляем кнопку "Забронировать" рядом с кнопкой "Купить"
add_action('woocommerce_after_add_to_cart_button', 'add_booking_button');

function add_booking_button() {
    global $product;
    $booking_url = home_url('/booking/?product_id=' . $product->get_id());
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
        <form method="post" style="margin-bottom: 3rem;">
            <p class="form-row">
                <label for="billing_first_name"><?php _e('Ф.И.О. родителя или представителя полностью', 'woocommerce-booking'); ?><abbr class="required" title="Required Field">*</abbr></label>
                <input type="text" id="billing_first_name" name="billing_first_name" required>
            </p>
            <p class="form-row">
                <label for="billing_child_name"><?php _e('Ф.И.О. ребенка полностью', 'woocommerce-booking'); ?><abbr class="required" title="Required Field">*</abbr></label>
                <input type="text" id="billing_child_name" name="billing_child_name" required>
            </p>
            <p class="form-row">
                <label for="billing_wooccm11"><?php _e('Дата рождения ребенка', 'woocommerce-booking'); ?><abbr class="required" title="Required Field">*</abbr></label>
                <input type="date" id="billing_wooccm11" name="billing_wooccm11" required>
            </p>
            <p class="form-row">
                <label for="billing_email"><?php _e('Email', 'woocommerce-booking'); ?><abbr class="required" title="Required Field">*</abbr></label>
                <input type="email" id="billing_email" name="billing_email" required>
            </p>
            <p class="form-row">
                <label for="billing_phone"><?php _e('Телефон', 'woocommerce-booking'); ?><abbr class="required" title="Required Field">*</abbr></label>
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

    // Собираем данные покупателя и название товара
    $parent_name = sanitize_text_field($_POST['billing_first_name']);
    $product_name = $product->get_name();
    $child_name  = sanitize_text_field($_POST['billing_child_name']);
    $child_bdate = $_POST['billing_wooccm11'];
    $email       = sanitize_email($_POST['billing_email']);
    $phone       = sanitize_text_field($_POST['billing_phone']);

    // Генерация токена
    $confirmation_token = generate_booking_token();

    // Логируем бронирование
    $booking_id = log_booking($product_id, $product_name, $parent_name, $child_name, $child_bdate, $email, $phone, $confirmation_token);

    // Отправляем email с подтверждением
    $subject = __('Подтверждение бронирования', 'woocommerce-booking');
    $confirmation_url = home_url('/confirm-booking/?token=' . $confirmation_token);
    $message = sprintf(
        __('Здравствуйте, %s! Ваш товар "%s" успешно забронирован. Пожалуйста, подтвердите бронирование, перейдя по ссылке: %s', 'woocommerce-booking'),
        $parent_name,
        $product_name,
        $confirmation_url
    );
    wp_mail($email, $subject, $message);

    return __('Бронирование успешно завершено! Пожалуйста, проверьте вашу почту для подтверждения.', 'woocommerce-booking');
}

// Логируем бронирование
function log_booking($product_id, $product_name, $parent_name, $child_name, $child_bdate, $email, $phone, $confirmation_token) {
    global $wpdb;
    $table_name = $wpdb->prefix . 'woocommerce_bookings';

    $wpdb->insert(
        $table_name,
        array(
            'product_id'          => $product_id,
            'product_name'        => $product_name,
            'parent_name'         => $parent_name,
            'child_name'          => $child_name,
            'child_bdate'         => $child_bdate,
            'email'               => $email,
            'phone'               => $phone,
            'confirmation_token'  => $confirmation_token,
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

    // Обработка снятия бронирования
    if (isset($_GET['action']) && $_GET['action'] === 'unbook' && isset($_GET['id'])) {
        if (!wp_verify_nonce($_GET['_wpnonce'], 'unbook_booking_' . $_GET['id'])) {
            wp_die(__('Недействительный запрос.', 'woocommerce-booking'));
        }

        $booking_id = intval($_GET['id']);
        $wpdb->update(
            $table_name,
            array('is_confirmed' => 0), // Снимаем бронирование
            array('id' => $booking_id)
        );

        wp_redirect(admin_url('admin.php?page=woocommerce-bookings'));
        exit;
    }

    // Обработка подтверждения бронирования
    if (isset($_GET['action']) && $_GET['action'] === 'confirm' && isset($_GET['id'])) {
        if (!wp_verify_nonce($_GET['_wpnonce'], 'confirm_booking_' . $_GET['id'])) {
            wp_die(__('Недействительный запрос.', 'woocommerce-booking'));
        }

        $booking_id = intval($_GET['id']);
        $wpdb->update(
            $table_name,
            array('is_confirmed' => 1), // Подтверждаем бронирование
            array('id' => $booking_id)
        );

        wp_redirect(admin_url('admin.php?page=woocommerce-bookings'));
        exit;
    }

    // Фильтры
    $filter_id = isset($_GET['filter_id']) ? sanitize_text_field($_GET['filter_id']) : '';
    $filter_product_name = isset($_GET['filter_product']) ? sanitize_text_field($_GET['filter_product_name']) : '';
    $filter_parent_name = isset($_GET['filter_parent_name']) ? sanitize_text_field($_GET['filter_parent_name']) : '';
    $filter_child_name = isset($_GET['filter_child_name']) ? sanitize_text_field($_GET['filter_child_name']) : '';
    $filter_child_bdate = isset($_GET['filter_child_bdate']) ? sanitize_text_field($_GET['filter_child_bdate']) : '';
    $filter_email = isset($_GET['filter_email']) ? sanitize_text_field($_GET['filter_email']) : '';
    $filter_phone = isset($_GET['filter_phone']) ? sanitize_text_field($_GET['filter_phone']) : '';
    $filter_booking_date = isset($_GET['filter_booking_date']) ? sanitize_text_field($_GET['filter_booking_date']) : '';
    $filter_confirmed = isset($_GET['filter_confirmed']) ? sanitize_text_field($_GET['filter_confirmed']) : '';

    // Формируем SQL-запрос с учетом фильтров
    $where = array();
    if ($filter_id) {
        $where[] = $wpdb->prepare("id = %d", $filter_id);
    }
    if ($filter_product_name) {
        $where[] = $wpdb->prepare("product_name LIKE %s", "%$filter_product_name%");
    }
    if ($filter_parent_name) {
        $where[] = $wpdb->prepare("parent_name LIKE %s", "%$filter_parent_name%");
    }
    if ($filter_child_name) {
        $where[] = $wpdb->prepare("child_name LIKE %s", "%$filter_child_name%");
    }
    if ($filter_child_bdate) {
        $where[] = $wpdb->prepare("child_bdate = %s", $filter_child_bdate);
    }
    if ($filter_email) {
        $where[] = $wpdb->prepare("email LIKE %s", "%$filter_email%");
    }
    if ($filter_phone) {
        $where[] = $wpdb->prepare("phone LIKE %s", "%$filter_phone%");
    }
    if ($filter_booking_date) {
        $where[] = $wpdb->prepare("DATE(booking_date) = %s", $filter_booking_date);
    }
    if ($filter_confirmed !== '') {
        $where[] = $wpdb->prepare("is_confirmed = %d", $filter_confirmed);
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
                    <label for="filter_id">ID:</label>
                    <input type="text" name="filter_id" id="filter_id" value="' . esc_attr($filter_id) . '">

                    <label for="filter_product">Товар:</label>
                    <input type="text" name="filter_product_name" id="filter_product_name" value="' . esc_attr($filter_product_name) . '">

                    <label for="filter_parent_name">Ф.И.О. родителя:</label>
                    <input type="text" name="filter_parent_name" id="filter_parent_name" value="' . esc_attr($filter_parent_name) . '">

                    <label for="filter_child_name">Ф.И.О. ребенка:</label>
                    <input type="text" name="filter_child_name" id="filter_child_name" value="' . esc_attr($filter_child_name) . '">

                    <label for="filter_child_bdate">Дата рождения ребенка:</label>
                    <input type="date" name="filter_child_bdate" id="filter_child_bdate" value="' . esc_attr($filter_child_bdate) . '">

                    <label for="filter_email">Email:</label>
                    <input type="text" name="filter_email" id="filter_email" value="' . esc_attr($filter_email) . '">

                    <label for="filter_phone">Телефон:</label>
                    <input type="text" name="filter_phone" id="filter_phone" value="' . esc_attr($filter_phone) . '">

                    <label for="filter_booking_date">Дата бронирования:</label>
                    <input type="date" name="filter_booking_date" id="filter_booking_date" value="' . esc_attr($filter_booking_date) . '">

                    <label for="filter_confirmed">Подтверждено:</label>
                    <select name="filter_confirmed" id="filter_confirmed">
                        <option value="">Все</option>
                        <option value="1"' . selected($filter_confirmed, '1', false) . '>Да</option>
                        <option value="0"' . selected($filter_confirmed, '0', false) . '>Нет</option>
                    </select>

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
        'add_args' => array(
            'filter_id' => $filter_id,
            'filter_product_name' => $filter_product_name,
            'filter_parent_name' => $filter_parent_name,
            'filter_child_name' => $filter_child_name,
            'filter_child_bdate' => $filter_child_bdate,
            'filter_email' => $filter_email,
            'filter_phone' => $filter_phone,
            'filter_booking_date' => $filter_booking_date,
            'filter_confirmed' => $filter_confirmed,
        ),
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
                <td>';

        if ($booking->is_confirmed) {
            // Если бронирование подтверждено, показываем кнопку "Снять бронирование"
            echo '<a style="width: 100%;text-align: center;" href="' . wp_nonce_url(admin_url('admin.php?page=woocommerce-bookings&action=unbook&id=' . $booking->id), 'unbook_booking_' . $booking->id) . '" class="button button-secondary">Снять</a>';
        } else {
            // Если бронирование не подтверждено, показываем кнопку "Подтвердить бронирование"
            echo '<a style="width: 100%;text-align: center;" href="' . wp_nonce_url(admin_url('admin.php?page=woocommerce-bookings&action=confirm&id=' . $booking->id), 'confirm_booking_' . $booking->id) . '" class="button button-secondary">Подтвердить</a>';
        }

        echo '<a style="width: 100%;text-align: center;" href="' . wp_nonce_url(admin_url('admin.php?page=woocommerce-bookings&action=delete&id=' . $booking->id), 'delete_booking_' . $booking->id) . '" class="button button-primary">Удалить</a>
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
                $booking->product_name,
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

// Добавляем страницу в админке для бронирования товара
add_action('admin_menu', 'add_admin_booking_page');

function add_admin_booking_page() {
    add_submenu_page(
        'woocommerce-bookings', // Родительский slug (страница бронирований)
        __('Забронировать товар', 'woocommerce-booking'), // Заголовок страницы
        __('Забронировать товар', 'woocommerce-booking'), // Название в меню
        'manage_options', // Права доступа
        'admin-booking', // Slug страницы
        'render_admin_booking_page' // Функция для отображения страницы
    );
}

// Функция для отображения страницы бронирования
function render_admin_booking_page() {
    // Проверяем права доступа
    if (!current_user_can('manage_options')) {
        wp_die(__('У вас недостаточно прав для доступа к этой странице.', 'woocommerce-booking'));
    }

    // Обработка отправки формы
    if (isset($_POST['submit_admin_booking'])) {
        $result = handle_admin_booking_request();
        if ($result) {
            echo '<div class="notice notice-success"><p>' . __('Бронирование успешно создано!', 'woocommerce-booking') . '</p></div>';
        } else {
            echo '<div class="notice notice-error"><p>' . __('Ошибка при создании бронирования.', 'woocommerce-booking') . '</p></div>';
        }
    }

    // Получаем все товары WooCommerce
    $products = wc_get_products(array(
        'status' => 'publish',
        'limit' => -1, // Получить все товары
    ));

    // Отображаем форму бронирования
    echo '<div class="wrap">';
    echo '<h1>' . __('Забронировать товар', 'woocommerce-booking') . '</h1>';
    echo '<form method="post" action="">';

    // Поля для данных покупателя
    echo '<table class="form-table" role="presentation">';
    echo '<tbody>';
    echo '<tr>';
    echo '<th scope="row"><label for="product_id">' . __('Выберите товар:', 'woocommerce-booking') . '</label></th>';
    echo '<td><select id="product_id" name="product_id" required>';
    foreach ($products as $product) {
        echo '<option value="' . esc_attr($product->get_id()) . '">' . esc_html($product->get_name()) . '</option>';
    }
    echo '</select>';
    echo '</td>';
    echo '</tr>';

    echo '<tr>';
    echo '<th><label for="parent_name">' . __('Ф.И.О. родителя:', 'woocommerce-booking') . '</label></th>';
    echo '<td><input type="text" id="parent_name" name="parent_name" required></td>';
    echo '</tr>';

    echo '<tr>';
    echo '<th><label for="child_name">' . __('Ф.И.О. ребенка:', 'woocommerce-booking') . '</label></th>';
    echo '<td><input type="text" id="child_name" name="child_name" required></td>';
    echo '</tr>';

    echo '<tr>';
    echo '<th><label for="child_bdate">' . __('Дата рождения ребенка:', 'woocommerce-booking') . '</label></th>';
    echo '<td><input type="date" id="child_bdate" name="child_bdate" required></td>';
    echo '</tr>';

    echo '<tr>';
    echo '<th><label for="email">' . __('Email:', 'woocommerce-booking') . '</label></th>';
    echo '<td><input type="email" id="email" name="email" required></td>';
    echo '</tr>';

    echo '<tr>';
    echo '<th><label for="phone">' . __('Телефон:', 'woocommerce-booking') . '</label></th>';
    echo '<td><input type="tel" id="phone" name="phone" required></td>';
    echo '</tr>';

    echo '</tbody>';
    echo '</table>';

    // Кнопка отправки формы
    echo '<p class="submit">
            <input type="submit" name="submit_admin_booking" class="button button-primary" value="' . __('Забронировать', 'woocommerce-booking') . '">
          </p>';

    echo '</form>';
    echo '</div>';
}

// Обработка данных формы бронирования
function handle_admin_booking_request() {
    global $wpdb;
    $table_name = $wpdb->prefix . 'woocommerce_bookings';

    // Проверяем, заполнены ли все поля
    if (empty($_POST['product_id']) || empty($_POST['parent_name']) || empty($_POST['child_name']) || empty($_POST['child_bdate']) || empty($_POST['email']) || empty($_POST['phone'])) {
        return false;
    }

    $current_product = wc_get_product(intval($_POST['product_id']));

    // Собираем данные из формы
    $product_id = intval($_POST['product_id']);
    $product_name = sanitize_text_field($current_product->get_name());
    $parent_name = sanitize_text_field($_POST['parent_name']);
    $child_name = sanitize_text_field($_POST['child_name']);
    $child_bdate = sanitize_text_field($_POST['child_bdate']);
    $email = sanitize_email($_POST['email']);
    $phone = sanitize_text_field($_POST['phone']);

    // Генерация токена подтверждения
    $confirmation_token = generate_booking_token();

    // Сохраняем бронирование в базу данных
    $result = $wpdb->insert(
        $table_name,
        array(
            'product_id' => $product_id,
            'product_name' => $product_name,
            'parent_name' => $parent_name,
            'child_name' => $child_name,
            'child_bdate' => $child_bdate,
            'email' => $email,
            'phone' => $phone,
            'confirmation_token' => $confirmation_token,
            'is_confirmed' => 1, // Автоматически подтверждаем бронирование, созданное администратором
        )
    );

    return $result !== false;
}

?>