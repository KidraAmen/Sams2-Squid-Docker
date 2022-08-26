Демон sams2deamon и setup.php <b>не запустится</b> если, не существует базы данных sams2bd.

Для добавления базы данных нужно использовать команды.<br>
<b>mysql -uroot -e "CREATE DATABASE IF NOT EXISTS sams2db DEFAULT CHARACTER SET utf8 DEFAULT COLLATE utf8_general_ci;"<br>
mysql -uroot -e "GRANT ALL PRIVILEGES ON sams2db.* TO sams2user@localhost IDENTIFIED BY 'sams2password';"<br></b>

Создается пользователь sams2user с паролем sams2password.
В файле <b>/usr/etc/sams2.conf</b> храниться конфигурация sams2, включая настройку пользователя для подключения sams2 к mysql.

После добавления базы данных в браузере открыть ip_address/setup.php и пройти процедуру создания базы.
Для входа в систему sams2 использовать логин <b>admin</b> и пароль <b>qwerty</b>.

В директории files файл sams2.sql содержит бекап базы данных.
Желательно после конфигурации базы данных с помощью setup.php, создать новый шаблон пользователя и стандартный удалить.

Sams2 для хранения пользователей в режиме ncsa использует файл <b>/etc/squid/sams2.ncsa</b>.

Для самостоятельного запуска демона sams использовать команду.
<b>/usr/bin/sams2daemon -C /usr/etc/sams2.conf -f -d 9 -l file:/var/log/sams2.log</b>
