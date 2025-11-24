-- CRUD
DROP TABLE internet_customer;

CREATE TABLE internet_customer (
	internet_customer_id int NOT NULL,
	login varchar(20) NOT NULL,
	first_name varchar(20) NOT NULL,
	last_name varchar(20) NOT NULL,
	patronymic varchar(20) NULL,
	rating float DEFAULT (0) NOT NULL,
	birthday date NULL,
	registered timestamp DEFAULT(now()) NOT NULL,
	deleted bool DEFAULT(FALSE) NOT NULL
);

-- char - фикс длина, дополняет пробелами недостающие
-- varchar - не хранит доп. пробелы
-- nvarchar - есть в некоторых СУБД для всех символов уникода, но там также есть отдельный varchar - только для лат. символов (возможно еще и цифр)
-- float float4 real 4 байта - быстрее, но нельзя для денег и сравнений после мат. операций
-- double presicion float8 8 байт - быстрее, но нельзя для денег и сравнений после мат. операций
-- numeric(n, m) decimal(n, m) - 1 234 567.890 (10, 3) - лучше для точных операций, например, с деньгами
-- date - только дата
-- timestamp - дата и время
-- time - только время
-- interval - интервал времени
-- now() - функция, которая возвращает текущие дату и время

INSERT
	INTO
	internet_customer
(	login,
	first_name,
	last_name,
	patronymic,
	birthday)
VALUES
('login1',
'Иван',
'Зернов',
'Семёнович',
'1988-06-26'),
('login2',
'Акакий',
'Ступин',
'Евграфович',
'1978-05-28'),
('login3',
'Леонид',
'Кротов',
'Леонидович',
'1999-07-20');

--Добавление колонок в таблицу
ALTER TABLE internet_customer ADD COLUMN confirmed bool DEFAULT(FALSE) NOT NULL;

-- Удаление колонок из таблицы
ALTER TABLE internet_customer DROP COLUMN confirmed;

-- заполнение таблицы из уже имеющихся данных
INSERT
	INTO
	internet_customer
(internet_customer_id,
	login,
	first_name,
	last_name,
	patronymic,
	birthday)
SELECT
	ROW_NUMBER() OVER() + 3,
	substring(first_name, 1, 1) || '.' || last_name,
	a.first_name,
	a.last_name,
	NULL,
	NULL
FROM
	actor a;

-- без указания колонок в insert
INSERT
	INTO
	internet_customer
SELECT
	ROW_NUMBER() OVER() + 3,
	substring(first_name, 1, 1) || '.' || last_name,
	a.first_name,
	a.last_name,
	NULL,
	0,
	NULL,
	now(),
	false
FROM
	actor a;

SELECT * FROM internet_customer;


DROP TABLE internet_customer;

CREATE TABLE internet_customer (
	internet_customer_id serial NOT NULL, -- для автоматического проставления значений
	login varchar(20) NOT NULL,
	first_name varchar(20) NOT NULL,
	last_name varchar(20) NOT NULL,
	patronymic varchar(20) NULL,
	rating float DEFAULT (0) NOT NULL,
	birthday date NULL,
	registered timestamp DEFAULT(now()) NOT NULL,
	deleted bool DEFAULT(FALSE) NOT NULL
);

INSERT
	INTO
	internet_customer
(
	login,
	first_name,
	last_name,
	patronymic,
	birthday)
SELECT
	substring(first_name, 1, 1) || '.' || last_name,
	a.first_name,
	a.last_name,
	NULL,
	NULL
FROM
	actor a;

DELETE -- удаление строк
FROM
	internet_customer
WHERE
	last_name LIKE 'G%';

UPDATE internet_customer
SET login = 'test_login'
WHERE first_name = 'Акакий';