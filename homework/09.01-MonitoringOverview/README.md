# Домашнее задание к занятию "Обзор систем ИТ-мониторинга" - Пешева Ирина


### Задание 1
Создайте виртуальную машину в Yandex Compute Cloud и с помощью Yandex Monitoring создайте дашборд, на котором будет видно загрузку процессора.

#### Процесс выполнения
1. В окне браузера откройте облачную платформу Yandex Cloud
2. Перейдите в раздел "Все сервисы" > "Инфраструктура и сеть" > "Compute Cloud"
3. Нажмите на синюю кнопку "Создать ВМ" в правом верхнем углу окна браузера
4. Задайте имя виртуальной машины. Используйте английские буквы и цифры.
5. Выберите операционную систему Debian 11
6. Установите объём HDD равный 3ГБ
7. Выберите платформу Intel Ice Lake
8. Установите количество vCPU равное 2
9. Установите гарантированную долю vCPU равную 20%
10. Задайте количество RAM равное 1ГБ
11. Поставьте галочку "Прерываемая"
12. В разделе "Доступ" выберите сервисный аккаунт с ролью monitoring.editor. Если такого аккаунта нету, нажмите на кнопку "Создать новый". Задайте имя аккаунта английскими буквами, напротив надписи "Роли в каталоге" нажмите на знак "плюс". Прокручивая колесо мыши на себя, найдите роль monitoring.editor и нажмите на неё левой кнопкой мыши. Теперь вы сможете найти только что созданную роль в выпадающем списке аккаунтов.
13. Задайте логин учётной записи вашей виртуальной машины
14. Вставьте публичный SHH-ключ в поле SSH-ключ. Если этого ключа у вас нету, создайте его с помощью утилиты PuTTYgen
15. Поставьте галочку "Установить" в пункте "Агент сбора метрик"
16. Нажмите на синюю кнопку "Создать ВМ"
17. Перейдите в раздел "Все сервисы" > "Инфраструктура и сеть" > "Monitoring"
18. Нажмите на кнопку "Создать дашборд", расположенную в разделе "Возможности сервиса" > "Дашборды"
19. В открывшемся окне в разделе "Добавить виджет" нажмите на "График"
20. Пред вам предстанет конструктор запросов, выберите "Запрос А"
21. В параметре service конструктора запросов выберите Compute Cloud
22. В появившемся параметре name конструктора запросов выберите cpu_utilization
23. Поправьте диапазон времени отрисовки графика нажав на кнопку "Сейчас" в верху экрана, левее кнопок 3m, 1h, 1d, 1w, "Отменить".
24. Нажмите на кнопку "Сохранить" в правом верхнем углу экрана
25. Задайте имя дашборда, если появится окно ввода имени дашборда
26. Сделайте скриншот

#### Требования к результату
* прикрепите в файл README.md скриншот вашего дашборда в Yandex Monitoring с мониторингом загрузки процессора виртуальной машины

### Решение 1
Та-даааа

![Screenshot](img/1.png)

---

## Дополнительные задания (со звездочкой*)

Эти задания дополнительные (не обязательные к выполнению) и никак не повлияют на получение вами зачета по этому домашнему заданию. Вы можете их выполнить, если хотите глубже и/или шире разобраться в материале.

### Задание 2
С помощью Yandex Monitoring сделайте 2 алерта на загрузку процессора: WARN и ALARM. Создайте уведомление по e-mail.

#### Требования к результату
* прикрепите в файл README.md скриншот уведомления в Yandex Monitoring 

### Решение 2

Были добавлены алерты: при превышении 50% загрузки поднимается warning, при первышении 80% -- alarm.

![Alt text](img/2.png)

На почту были отправлены соответствующие сообщения:

![Alt text](img/3.png)

![Alt text](img/4.png)
