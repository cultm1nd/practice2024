-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 28 2024 г., 22:32
-- Версия сервера: 8.0.30
-- Версия PHP: 8.1.9

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- База данных: `borovinskikh_p3`
--

-- --------------------------------------------------------

--
-- Структура таблицы `failed_jobs`
--

CREATE TABLE `failed_jobs` (
  `id` bigint UNSIGNED NOT NULL,
  `uuid` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `connection` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `queue` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `payload` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `exception` longtext CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `failed_at` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `genres`
--

CREATE TABLE `genres` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `genres`
--

INSERT INTO `genres` (`id`, `name`, `created_at`, `updated_at`) VALUES
(1, 'Драма', NULL, NULL),
(2, 'Комедия', NULL, NULL),
(3, 'Мистерия', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `korzinas`
--

CREATE TABLE `korzinas` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `korzinas`
--

INSERT INTO `korzinas` (`id`, `user_id`, `created_at`, `updated_at`) VALUES
(1, 2, NULL, NULL),
(2, 3, NULL, NULL),
(3, 4, NULL, NULL),
(4, 5, '2024-11-27 08:20:08', '2024-11-27 08:20:08'),
(6, 6, '2024-11-27 10:03:48', '2024-11-27 10:03:48'),
(7, 7, '2024-11-28 16:07:13', '2024-11-28 16:07:13');

-- --------------------------------------------------------

--
-- Структура таблицы `korzinticks`
--

CREATE TABLE `korzinticks` (
  `id` bigint UNSIGNED NOT NULL,
  `korzina_id` int NOT NULL,
  `production_id` int NOT NULL,
  `count` int NOT NULL,
  `place` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `korzinticks`
--

INSERT INTO `korzinticks` (`id`, `korzina_id`, `production_id`, `count`, `place`, `created_at`, `updated_at`) VALUES
(1, 1, 1, 2, '5,6', NULL, NULL),
(8, 6, 2, 2, '1', '2024-11-28 08:24:55', '2024-11-28 08:26:12'),
(10, 6, 4, 1, '1', '2024-11-28 08:26:42', '2024-11-28 08:26:42');

-- --------------------------------------------------------

--
-- Структура таблицы `migrations`
--

CREATE TABLE `migrations` (
  `id` int UNSIGNED NOT NULL,
  `migration` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `batch` int NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `migrations`
--

INSERT INTO `migrations` (`id`, `migration`, `batch`) VALUES
(1, '2014_10_12_000000_create_users_table', 1),
(2, '2014_10_12_100000_create_password_reset_tokens_table', 1),
(3, '2019_08_19_000000_create_failed_jobs_table', 1),
(4, '2019_12_14_000001_create_personal_access_tokens_table', 1),
(5, '2024_11_27_050447_genre', 1),
(6, '2024_11_27_050612_productions', 1),
(7, '2024_11_27_050708_prodgens', 1),
(8, '2024_11_27_050726_korzinas', 1),
(9, '2024_11_27_050845_korzinticks', 1),
(10, '2024_11_27_050932_orders', 1),
(11, '2024_11_27_051000_ordticks', 1);

-- --------------------------------------------------------

--
-- Структура таблицы `orders`
--

CREATE TABLE `orders` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` int NOT NULL,
  `status` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `orders`
--

INSERT INTO `orders` (`id`, `user_id`, `status`, `created_at`, `updated_at`) VALUES
(1, 3, 'новый', '2024-09-13 10:04:45', '2024-11-28 11:53:32'),
(2, 2, 'подтвержденый', '2024-11-11 16:38:44', NULL),
(3, 3, 'отмененый', '2024-11-23 16:38:53', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `ordticks`
--

CREATE TABLE `ordticks` (
  `id` bigint UNSIGNED NOT NULL,
  `order_id` int NOT NULL,
  `production_id` int NOT NULL,
  `count` int NOT NULL,
  `place` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `ordticks`
--

INSERT INTO `ordticks` (`id`, `order_id`, `production_id`, `count`, `place`, `created_at`, `updated_at`) VALUES
(1, 1, 3, 1, '10', NULL, NULL),
(2, 2, 6, 2, '9,6', NULL, NULL),
(3, 3, 2, 1, '17', NULL, NULL),
(4, 3, 5, 1, '20', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `password_reset_tokens`
--

CREATE TABLE `password_reset_tokens` (
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `personal_access_tokens`
--

CREATE TABLE `personal_access_tokens` (
  `id` bigint UNSIGNED NOT NULL,
  `tokenable_type` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `tokenable_id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `token` varchar(64) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `abilities` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `last_used_at` timestamp NULL DEFAULT NULL,
  `expires_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `prodgens`
--

CREATE TABLE `prodgens` (
  `id` bigint UNSIGNED NOT NULL,
  `production_id` int NOT NULL,
  `genre_id` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `prodgens`
--

INSERT INTO `prodgens` (`id`, `production_id`, `genre_id`, `created_at`, `updated_at`) VALUES
(9, 9, 1, '2024-11-28 15:42:44', '2024-11-28 15:42:50'),
(10, 10, 0, '2024-11-28 15:43:17', '2024-11-28 16:28:10'),
(11, 11, 3, '2024-11-28 15:43:59', '2024-11-28 15:43:59');

-- --------------------------------------------------------

--
-- Структура таблицы `productions`
--

CREATE TABLE `productions` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `img` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `show_date` date NOT NULL,
  `age_limit` int NOT NULL,
  `price` int NOT NULL,
  `count_ticket` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `productions`
--

INSERT INTO `productions` (`id`, `name`, `img`, `show_date`, `age_limit`, `price`, `count_ticket`, `created_at`, `updated_at`) VALUES
(9, 'Драма номер 5', '3.jpg', '2024-12-07', 18, 1000, 100, '2024-11-28 15:42:44', '2024-11-28 16:18:41'),
(10, 'Смайлик', 'njn234hj1jj.jfif', '2024-11-30', 6, 500, 50, '2024-11-28 15:43:17', '2024-11-28 16:09:32'),
(11, 'Петербург', '10.jpg', '2024-12-30', 16, 1000, 100, '2024-11-28 15:43:59', '2024-11-28 15:43:59');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `surname` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `patronymic` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `login` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `isAdmin` int NOT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `surname`, `patronymic`, `login`, `email`, `password`, `isAdmin`, `created_at`, `updated_at`) VALUES
(1, 'Алена', 'Никифорова', 'Андреевна', 'admin', 'niki@gmail.com', '$2y$12$wApbCgg6Bo/9Q5gRw2NsUuiGREt36jEFwJIN0jvNYy0PUJdGnnI2u', 1, NULL, NULL),
(2, 'stODcBHKdF', 'WYgYMpyLrm', 'XkZ50QsKKH', '3SrQLFcMi7', 'XRnu6Bh5zt@gmail.com', '$2y$12$uqq/MpmjDkweTiiDaf7QLe/z3xa.iDGJdcJcCnPqn.uNcWuyqwTNq', 0, NULL, NULL),
(3, 'Poq53pHJYS', 'Jm6CwGWOjk', 'OsCiAAhvap', 'h63C7m3Ibi', 'laH3TPHdcS@gmail.com', '$2y$12$jAhR0mxcywfcSkV6DQLur.HW3Cq9zq7O.R6g8gdtcMO8X/pcpOa5y', 0, NULL, NULL),
(4, 'апавп', 'Поа', 'вапавп', 'user4', 'nisddsfd@gmail.com', '$2y$12$WybryBAaG7c38SaiUUqmjOoU6djQ99U8DqL6MzJJEhrCwIs13WEXG', 0, '2024-11-27 08:09:46', '2024-11-27 08:09:46'),
(5, 'апавп', 'Поа', 'вапавп', 'user5', 'nid@gmail.com', '$2y$12$UEnbjecr19U8xxNYXwANCuO1jJf4w.0BfY6GNM7gzU5dPAQs9jK..', 0, '2024-11-27 08:21:00', '2024-11-27 08:21:00'),
(6, 'апавп', 'Поа', 'вапавп', 'user6', 'ffgfd@gmail.com', '$2y$12$zHEj9DbhZDDoDgh5ST1k2e/k3ebT11n61/0e.xstKJSxEnAn3tTI6', 0, '2024-11-27 10:03:48', '2024-11-27 10:03:48'),
(7, 'Полина', 'Полина', 'Полина', 'cultm1nd', 'cultm1nd@mail.ru', '$2y$12$VTx9pdsMmpEDzJYy0x9NmOkFwITGTk1jOVJ0wOT/cZYuB5ynuWl8W', 0, '2024-11-28 16:07:13', '2024-11-28 16:07:13');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `failed_jobs`
--
ALTER TABLE `failed_jobs`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `failed_jobs_uuid_unique` (`uuid`);

--
-- Индексы таблицы `genres`
--
ALTER TABLE `genres`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `korzinas`
--
ALTER TABLE `korzinas`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `korzinticks`
--
ALTER TABLE `korzinticks`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `migrations`
--
ALTER TABLE `migrations`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `ordticks`
--
ALTER TABLE `ordticks`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `password_reset_tokens`
--
ALTER TABLE `password_reset_tokens`
  ADD PRIMARY KEY (`email`);

--
-- Индексы таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `personal_access_tokens_token_unique` (`token`),
  ADD KEY `personal_access_tokens_tokenable_type_tokenable_id_index` (`tokenable_type`,`tokenable_id`);

--
-- Индексы таблицы `prodgens`
--
ALTER TABLE `prodgens`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `productions`
--
ALTER TABLE `productions`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `users_login_unique` (`login`),
  ADD UNIQUE KEY `users_email_unique` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `failed_jobs`
--
ALTER TABLE `failed_jobs`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `genres`
--
ALTER TABLE `genres`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `korzinas`
--
ALTER TABLE `korzinas`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT для таблицы `korzinticks`
--
ALTER TABLE `korzinticks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT для таблицы `migrations`
--
ALTER TABLE `migrations`
  MODIFY `id` int UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `orders`
--
ALTER TABLE `orders`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT для таблицы `ordticks`
--
ALTER TABLE `ordticks`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `personal_access_tokens`
--
ALTER TABLE `personal_access_tokens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT для таблицы `prodgens`
--
ALTER TABLE `prodgens`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `productions`
--
ALTER TABLE `productions`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
