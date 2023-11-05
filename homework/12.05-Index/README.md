# Домашнее задание к занятию "Индексы" - Пешева Ирина


### Задание 1

Напишите запрос к учебной базе данных, который вернёт процентное отношение общего размера всех индексов к общему размеру всех таблиц.

### Решение 1

Для наглядности выведем не только итоговое значение, но и промежуточные значения. Тогда:

```sql
SELECT
	SUM(DATA_LENGTH) as all_tables_data_length,
	SUM(INDEX_LENGTH) AS all_tables_index_length,
	SUM(INDEX_LENGTH)/SUM(DATA_LENGTH) AS ratio,
	CONCAT(ROUND(SUM(INDEX_LENGTH)/SUM(DATA_LENGTH) * 100, 2), "%") AS percent_of_index_length
FROM
	INFORMATION_SCHEMA.TABLES;
```

![Alt text](img/12.5.1.png)

---
### Задание 2

Выполните explain analyze следующего запроса:
```sql
select distinct concat(c.last_name, ' ', c.first_name), sum(p.amount) over (partition by c.customer_id, f.title)
from payment p, rental r, customer c, inventory i, film f
where date(p.payment_date) = '2005-07-30' and p.payment_date = r.rental_date and r.customer_id = c.customer_id and i.inventory_id = r.inventory_id
```
- перечислите узкие места;
- оптимизируйте запрос: внесите корректировки по использованию операторов, при необходимости добавьте индексы.


### Решение 2

---


## Дополнительные задания (со звездочкой*)

Эти задания дополнительные (не обязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. Вы можете их выполнить, если хотите глубже и/или шире разобраться в материале.

### Задание 3

Самостоятельно изучите, какие типы индексов используются в PostgreSQL. Перечислите те индексы, которые используются в PostgreSQL, а в MySQL — нет.

*Приведите ответ в свободной форме.*

### Решение 3

---


