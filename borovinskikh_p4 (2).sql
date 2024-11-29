-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Хост: 127.0.0.1:3306
-- Время создания: Ноя 29 2024 г., 11:46
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
-- База данных: `borovinskikh_p4`
--

-- --------------------------------------------------------

--
-- Структура таблицы `drivers`
--

CREATE TABLE `drivers` (
  `id` int NOT NULL,
  `name` varchar(45) NOT NULL,
  `birth_date` date NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(40) NOT NULL,
  `avatar` varchar(50) NOT NULL DEFAULT 'avatar.png',
  `vehicle_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `drivers`
--

INSERT INTO `drivers` (`id`, `name`, `birth_date`, `email`, `phone`, `avatar`, `vehicle_id`) VALUES
(1, 'Иванов И.И.', '2014-06-15', 'ivanov@mail.ru', '9175465465', 'avatar.png', 1),
(2, 'ivan', '2012-05-20', 'ivan@mail.ru', '88005553535', '94611d50c39c60a393bbff3db63a2cc5.jpg', NULL),
(3, 'hgfgdf', '2012-05-20', 'cultm1nd@mail.ru', '88005535357', 'avatar.png', NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `lines`
--

CREATE TABLE `lines` (
  `id` int NOT NULL,
  `name` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL,
  `start_time_operation` time NOT NULL,
  `end_time_operation` time NOT NULL,
  `type` varchar(30) NOT NULL DEFAULT '',
  `map` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `lines`
--

INSERT INTO `lines` (`id`, `name`, `start_time_operation`, `end_time_operation`, `type`, `map`) VALUES
(1, 'Линия №47', '07:00:00', '20:00:00', 'Автобусы', 'map.png'),
(3, 'паип', '01:00:00', '10:00:00', 'Nightliner', 'BIPHAPS_LE_Karte-Auto-und-Flug.jpg'),
(4, 'new', '02:00:00', '14:00:00', 'Nightliner', '220px-Verwaltung_Leipzig.svg.png');

-- --------------------------------------------------------

--
-- Структура таблицы `stations`
--

CREATE TABLE `stations` (
  `id` int NOT NULL,
  `name` varchar(80) NOT NULL,
  `line_id` int DEFAULT '0',
  `position_station` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `stations`
--

INSERT INTO `stations` (`id`, `name`, `line_id`, `position_station`) VALUES
(1, 'Деревня универсиад', 1, NULL),
(8, 'kukguiglui', NULL, NULL);

-- --------------------------------------------------------

--
-- Структура таблицы `users`
--

CREATE TABLE `users` (
  `id` int NOT NULL,
  `name` varchar(50) NOT NULL,
  `gender` char(2) NOT NULL,
  `birth_date` date NOT NULL,
  `email` varchar(50) NOT NULL,
  `login` varchar(40) NOT NULL,
  `password` varchar(40) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `users`
--

INSERT INTO `users` (`id`, `name`, `gender`, `birth_date`, `email`, `login`, `password`) VALUES
(1, 'Иванов И.И.', 'М', '1984-05-01', 'ivanov@mail.ru', 'admin', 'kazan');

-- --------------------------------------------------------

--
-- Структура таблицы `vehicles`
--

CREATE TABLE `vehicles` (
  `id` int NOT NULL,
  `name` varchar(30) NOT NULL,
  `capacity` int NOT NULL,
  `type` varchar(30) NOT NULL DEFAULT '',
  `line_id` int DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;

--
-- Дамп данных таблицы `vehicles`
--

INSERT INTO `vehicles` (`id`, `name`, `capacity`, `type`, `line_id`) VALUES
(1, 'Форд спринтер', 17, 'Автобусы', 1),
(3, 'Тойота Супра', 100, 'Nightliner', NULL),
(4, 'Volkswagen passat b5', 193, 'Tram', NULL);

--
-- Индексы сохранённых таблиц
--

--
-- Индексы таблицы `drivers`
--
ALTER TABLE `drivers`
  ADD PRIMARY KEY (`id`),
  ADD KEY `vehicle_id` (`vehicle_id`);

--
-- Индексы таблицы `lines`
--
ALTER TABLE `lines`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `stations`
--
ALTER TABLE `stations`
  ADD PRIMARY KEY (`id`),
  ADD KEY `line_id` (`line_id`),
  ADD KEY `line_id_2` (`line_id`);

--
-- Индексы таблицы `users`
--
ALTER TABLE `users`
  ADD PRIMARY KEY (`id`);

--
-- Индексы таблицы `vehicles`
--
ALTER TABLE `vehicles`
  ADD PRIMARY KEY (`id`),
  ADD KEY `id` (`id`),
  ADD KEY `line_id` (`line_id`);

--
-- AUTO_INCREMENT для сохранённых таблиц
--

--
-- AUTO_INCREMENT для таблицы `drivers`
--
ALTER TABLE `drivers`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT для таблицы `lines`
--
ALTER TABLE `lines`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT для таблицы `stations`
--
ALTER TABLE `stations`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=10;

--
-- AUTO_INCREMENT для таблицы `users`
--
ALTER TABLE `users`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT для таблицы `vehicles`
--
ALTER TABLE `vehicles`
  MODIFY `id` int NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Ограничения внешнего ключа сохраненных таблиц
--

--
-- Ограничения внешнего ключа таблицы `drivers`
--
ALTER TABLE `drivers`
  ADD CONSTRAINT `drivers_ibfk_1` FOREIGN KEY (`vehicle_id`) REFERENCES `vehicles` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `stations`
--
ALTER TABLE `stations`
  ADD CONSTRAINT `stations_ibfk_1` FOREIGN KEY (`line_id`) REFERENCES `lines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;

--
-- Ограничения внешнего ключа таблицы `vehicles`
--
ALTER TABLE `vehicles`
  ADD CONSTRAINT `vehicles_ibfk_1` FOREIGN KEY (`line_id`) REFERENCES `lines` (`id`) ON DELETE CASCADE ON UPDATE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
