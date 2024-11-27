-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 27 2024 г., 22:40
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
-- База данных: `pract3`
--

-- --------------------------------------------------------

--
-- Структура таблицы `bookings`
--

CREATE TABLE `bookings` (
  `id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `total_price` decimal(10,2) NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `payed` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `events`
--

CREATE TABLE `events` (
  `id` bigint UNSIGNED NOT NULL,
  `title` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `category` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `date` datetime NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `capacity` int NOT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `events`
--

INSERT INTO `events` (`id`, `title`, `description`, `category`, `date`, `price`, `capacity`, `created_at`, `updated_at`) VALUES
(3, 'Спектакль1', 'Очень хороший спектакль', 'Драма', '2024-11-27 22:33:23', '800.00', 8, '2024-11-27 19:33:56', '2024-11-27 19:33:56'),
(4, 'Спектакль2', 'Очень хороший спектакль', 'Мистерия', '2024-11-27 22:34:10', '1000.00', 18, '2024-11-27 19:34:35', '2024-11-27 19:34:35'),
(5, 'Спектакль3', 'Очень хороший спектакль', 'Комедия', '2024-11-27 22:34:39', '700.00', 7, '2024-11-27 19:35:01', '2024-11-27 19:37:35');

-- --------------------------------------------------------

--
-- Структура таблицы `reviews`
--

CREATE TABLE `reviews` (
  `id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `rating` tinyint NOT NULL,
  `comment` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `roles`
--

CREATE TABLE `roles` (
  `id` bigint UNSIGNED NOT NULL,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `roles`
--

INSERT INTO `roles` (`id`, `name`, `description`, `created_at`, `updated_at`) VALUES
(1, 'Посетитель', NULL, '2024-11-27 05:37:11', '2024-11-27 05:37:11'),
(2, 'Клиент', NULL, '2024-11-27 05:37:11', '2024-11-27 05:37:11'),
(3, 'Администратор', NULL, '2024-11-27 05:37:11', '2024-11-27 05:37:11');

-- --------------------------------------------------------

--
-- Структура таблицы `seats`
--

CREATE TABLE `seats` (
  `id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `row` int NOT NULL,
  `seat_number` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `is_available` tinyint(1) NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `section` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Дамп данных таблицы `seats`
--

INSERT INTO `seats` (`id`, `event_id`, `row`, `seat_number`, `price`, `is_available`, `created_at`, `updated_at`, `section`) VALUES
(141, 2, 3, 3, '200.00', 1, '2024-11-27 06:26:00', '2024-11-27 06:26:00', 'A'),
(170, 1, 1, 1, '400.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(171, 1, 1, 2, '410.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(172, 1, 1, 3, '420.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(173, 1, 1, 4, '430.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(174, 1, 1, 5, '440.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(175, 1, 1, 6, '450.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(176, 1, 1, 7, '460.00', 0, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(177, 1, 1, 8, '470.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(178, 1, 1, 9, '480.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(179, 1, 1, 10, '490.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(190, 1, 2, 1, '400.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(191, 1, 2, 2, '410.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(192, 1, 2, 3, '420.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(193, 1, 2, 4, '430.00', 0, '2024-11-27 07:22:21', '2024-11-27 07:34:51', 'A'),
(194, 1, 2, 5, '440.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(195, 1, 2, 6, '450.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(196, 1, 2, 7, '460.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(197, 1, 2, 8, '470.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(198, 1, 2, 9, '480.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(199, 1, 2, 10, '490.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(210, 1, 3, 1, '400.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(211, 1, 3, 2, '410.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(212, 1, 3, 3, '420.00', 0, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(213, 1, 3, 4, '430.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(214, 1, 3, 5, '440.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(215, 1, 3, 6, '450.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(216, 1, 3, 7, '460.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(217, 1, 3, 8, '470.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(218, 1, 3, 9, '480.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(219, 1, 3, 10, '490.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(230, 1, 4, 1, '400.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(231, 1, 4, 2, '410.00', 0, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(232, 1, 4, 3, '420.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(233, 1, 4, 4, '430.00', 0, '2024-11-27 07:22:21', '2024-11-27 05:24:54', 'A'),
(234, 1, 4, 5, '440.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(235, 1, 4, 6, '450.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(236, 1, 4, 7, '460.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(237, 1, 4, 8, '470.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(238, 1, 4, 9, '480.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(239, 1, 4, 10, '490.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(250, 1, 5, 1, '400.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(251, 1, 5, 2, '410.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(252, 1, 5, 3, '420.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(253, 1, 5, 4, '430.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(254, 1, 5, 5, '440.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(255, 1, 5, 6, '450.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(256, 1, 5, 7, '460.00', 0, '2024-11-27 07:22:21', '2024-11-27 04:55:26', 'A'),
(257, 1, 5, 8, '470.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(258, 1, 5, 9, '480.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(259, 1, 5, 10, '490.00', 1, '2024-11-27 07:22:21', '2024-11-27 07:22:21', 'A'),
(270, 1, 6, 1, '400.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(271, 1, 6, 2, '410.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(272, 1, 6, 3, '420.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(273, 1, 6, 4, '430.00', 0, '2024-11-27 07:30:04', '2024-11-27 07:12:15', 'A'),
(274, 1, 6, 5, '440.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(275, 1, 6, 6, '450.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(276, 1, 6, 7, '460.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(277, 1, 6, 8, '470.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(278, 1, 6, 9, '480.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(279, 1, 6, 10, '490.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(280, 1, 7, 1, '400.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(281, 1, 7, 2, '410.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(282, 1, 7, 3, '420.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(283, 1, 7, 4, '430.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(284, 1, 7, 5, '440.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(285, 1, 7, 6, '450.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(286, 1, 7, 7, '460.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(287, 1, 7, 8, '470.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(288, 1, 7, 9, '480.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(289, 1, 7, 10, '490.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(290, 1, 8, 1, '400.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(291, 1, 8, 2, '410.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(292, 1, 8, 3, '420.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(293, 1, 8, 4, '430.00', 0, '2024-11-27 07:30:04', '2024-11-27 04:35:14', 'A'),
(294, 1, 8, 5, '440.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(295, 1, 8, 6, '450.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(296, 1, 8, 7, '460.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(297, 1, 8, 8, '470.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(298, 1, 8, 9, '480.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(299, 1, 8, 10, '490.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(300, 1, 9, 1, '400.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(301, 1, 9, 2, '410.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(302, 1, 9, 3, '420.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(303, 1, 9, 4, '430.00', 0, '2024-11-27 07:30:04', '2024-11-27 05:11:42', 'A'),
(304, 1, 9, 5, '440.00', 0, '2024-11-27 07:30:04', '2024-11-27 04:39:07', 'A'),
(305, 1, 9, 6, '450.00', 0, '2024-11-27 07:30:04', '2024-11-27 04:39:16', 'A'),
(306, 1, 9, 7, '460.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(307, 1, 9, 8, '470.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(308, 1, 9, 9, '480.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(309, 1, 9, 10, '490.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(310, 1, 10, 1, '400.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(311, 1, 10, 2, '410.00', 0, '2024-11-27 07:30:04', '2024-11-27 05:14:40', 'A'),
(312, 1, 10, 3, '420.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(313, 1, 10, 4, '430.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(314, 1, 10, 5, '440.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(315, 1, 10, 6, '450.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(316, 1, 10, 7, '460.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(317, 1, 10, 8, '470.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(318, 1, 10, 9, '480.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A'),
(319, 1, 10, 10, '490.00', 1, '2024-11-27 07:30:04', '2024-11-27 07:30:04', 'A');

-- --------------------------------------------------------

--
-- Структура таблицы `shopping_cart`
--

CREATE TABLE `shopping_cart` (
  `id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `quantity` int NOT NULL DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- --------------------------------------------------------

--
-- Структура таблицы `tickets`
--

CREATE TABLE `tickets` (
  `id` bigint UNSIGNED NOT NULL,
  `booking_id` bigint UNSIGNED NOT NULL,
  `seat_id` bigint UNSIGNED NOT NULL,
  `event_id` bigint UNSIGNED NOT NULL,
  `user_id` bigint UNSIGNED DEFAULT NULL,
  `is_used` tinyint(1) NOT NULL DEFAULT '0',
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `tickets`
--

INSERT INTO `tickets` (`id`, `booking_id`, `seat_id`, `event_id`, `user_id`, `is_used`, `created_at`, `updated_at`) VALUES
(1, 1, 101, 1, 1, 0, NULL, NULL),
(2, 1, 102, 1, 1, 0, NULL, NULL),
(3, 2, 103, 1, 2, 0, NULL, NULL),
(4, 7, 304, 1, NULL, 0, '2024-11-27 04:39:07', '2024-11-27 04:39:07'),
(5, 8, 305, 1, NULL, 0, '2024-11-27 04:39:16', '2024-11-27 04:39:16'),
(6, 9, 256, 1, NULL, 0, '2024-11-27 04:55:26', '2024-11-27 04:55:26'),
(7, 10, 303, 1, NULL, 0, '2024-11-27 05:11:14', '2024-11-27 05:11:14'),
(8, 11, 303, 1, NULL, 0, '2024-11-27 05:11:42', '2024-11-27 05:11:42'),
(9, 12, 311, 1, NULL, 1, '2024-11-27 05:13:34', '2024-11-27 05:14:52'),
(10, 13, 311, 1, NULL, 1, '2024-11-27 05:14:40', '2024-11-27 05:24:41'),
(11, 14, 233, 1, NULL, 1, '2024-11-27 05:24:54', '2024-11-27 05:24:56'),
(12, 15, 273, 1, NULL, 1, '2024-11-27 07:12:15', '2024-11-27 07:12:30'),
(13, 16, 193, 1, NULL, 1, '2024-11-27 07:34:51', '2024-11-27 07:34:58');

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` bigint UNSIGNED NOT NULL,
  `username` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL,
  `role` enum('Посетитель','Клиент','Администратор') CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Посетитель',
  `first_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `last_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `phone` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT NULL,
  `updated_at` timestamp NULL DEFAULT NULL,
  `login` varchar(100) NOT NULL,
  `patronymic` varchar(100) NOT NULL,
  `surname` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `username`, `password`, `email`, `role`, `first_name`, `last_name`, `phone`, `created_at`, `updated_at`, `login`, `patronymic`, `surname`) VALUES
(7, 'Иван', '$2y$12$Edc2uEMUuQS03Levm2M34e5Wf1St5akNnkg8ve3G8D1nQGbsaDGXq', 'ivan@mail.ru', 'Посетитель', NULL, NULL, '+7953-602-49-32', '2024-11-27 07:11:49', '2024-11-27 07:11:49', 'ivan', 'Иван', 'Иван'),
(8, 'Полина', '$2y$12$ue7Rsgazf4ZPHwtEv43RmuBCHcuAeSzDA0Tmgm/rISw/29tv0BpEW', 'admin@mail.ru', 'Администратор', NULL, NULL, '+7953-602-49-32', '2024-11-27 16:29:45', '2024-11-27 16:29:45', 'admin', 'Александровна', 'Боровинских');

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `bookings`
--
ALTER TABLE `bookings`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `events`
--
ALTER TABLE `events`
  ADD PRIMARY KEY (`id`),
  ADD KEY `idx_events_category` (`category`);

--
-- Индексы таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD PRIMARY KEY (`id`),
  ADD KEY `event_id` (`event_id`),
  ADD KEY `user_id` (`user_id`);

--
-- Индексы таблицы `roles`
--
ALTER TABLE `roles`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `seats`
--
ALTER TABLE `seats`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `shopping_cart`
--
ALTER TABLE `shopping_cart`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `cart_user_event` (`user_id`,`event_id`),
  ADD KEY `event_id` (`event_id`);

--
-- Индексы таблицы `tickets`
--
ALTER TABLE `tickets`
  ADD PRIMARY KEY (`id`),
  ADD KEY `tickets_booking_id_foreign` (`booking_id`),
  ADD KEY `tickets_seat_id_foreign` (`seat_id`),
  ADD KEY `tickets_event_id_foreign` (`event_id`),
  ADD KEY `tickets_user_id_foreign` (`user_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `username_unique` (`username`),
  ADD UNIQUE KEY `email_unique` (`email`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `bookings`
--
ALTER TABLE `bookings`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT для таблицы `events`
--
ALTER TABLE `events`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `reviews`
--
ALTER TABLE `reviews`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `roles`
--
ALTER TABLE `roles`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT для таблицы `seats`
--
ALTER TABLE `seats`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=320;

--
-- AUTO_INCREMENT для таблицы `shopping_cart`
--
ALTER TABLE `shopping_cart`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT для таблицы `tickets`
--
ALTER TABLE `tickets`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` bigint UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `bookings`
--
ALTER TABLE `bookings`
  ADD CONSTRAINT `bookings_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `bookings_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `reviews`
--
ALTER TABLE `reviews`
  ADD CONSTRAINT `reviews_ibfk_1` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `reviews_ibfk_2` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE;

--
-- Ограничения внешнего ключа таблицы `shopping_cart`
--
ALTER TABLE `shopping_cart`
  ADD CONSTRAINT `shopping_cart_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `shopping_cart_ibfk_2` FOREIGN KEY (`event_id`) REFERENCES `events` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
