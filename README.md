# SAGrabarskiy_infra
# Выполнено ДЗ № 5

```
 bastion_IP = 51.250.70.142
 someinternalhost_IP = 10.128.0.3
 os = Ubuntu 20.04 LTS
```

 - [Исследовать способ подключения к someinternalhost в одну
команду из вашего рабочего устройства, проверить работоспособность
найденного решения и внести его в README.md в вашем репозитории] Основное ДЗ
 - [Предложить вариант решения для подключения из консоли при помощи
команды вида ssh someinternalhost из локальной консоли рабочего
устройства, чтобы подключение выполнялось по алиасу
someinternalhost] Дополнительное ДЗ
- [Выполните задание про подключение через бастион хост] Основное ДЗ
- [С помощью сервисов / и реализуйте использование валидного сертификата для панели управления VPNсервера] Дополнительное ДЗ

## В процессе сделано:

- Пункт 1
  Предварительно должен быть запущен ssh-agent и добавлен приватный ключ ssh.
  Далее выполняется команда:

  ``` ssh -J appuser@51.250.70.142 appuser@10.128.0.3 ```

  где 51.250.71.57 - внешний адрес cloud-bastion,
      10.128.0.3 внутрненний someinternalhost

- Пункт 2
 В ssh конфиг добавляем:

```
  #### The Bastion Host
	Host cloud-bastion
	HostName 51.250.70.142
	User appuser
	IdentityFile ~/.ssh/appuser_pub

  #### The Remote Host
	Host someinternalhost
	HostName 10.128.0.3
	ProxyJump cloud-bastion
	User appuser
	IdentityFile ~/.ssh/appuser_pub
```

- Пункт 3
В ветку cloud-bastion добавлены файл установки VPN Сервера prinutl - файл setupvpn.sh, а также файл конфигурации клиента prinutl - cloud-bastion.ovpn.
В файле setupvpn.sh, в соответствии с документацией https://docs.pritunl.com/docs/installation#other-providers-ubuntu-2004, был подготовлен скрипт установки служб prinutl + mongodb
Настройка сервера реализована в соответствии с алгоритмом, описанным в ДЗ с использованием web интерфейса

- Пункт 4
Для валидации сертификата при обращении к моему серверу pritunl по ip в настройке Lets Encrypt Domian в web-интерфейсе необходимо указать адрес 51.250.70.142.sslip.io, что позволит обращаться к серверу по адресу https://51.250.70.142.sslip.io

# Выполнено ДЗ № 6

```
 testapp_IP = 51.250.78.153
 testapp_port = 9292
```
 - [Команды по настройке системы и деплоя приложения нужно завернуть в
баш скрипты, чтобы не вбивать эти команды вручную] Основное ДЗ
 - [В качестве доп. задания используйте созданные ранее скрипты для
создания, который будет запускаться при создании инстанса] Дополнительное ДЗ

## В процессе сделано:

В процессе выполнения всех пунктов проверялось, что запущен web-сервер puma и тестовое приложение express42, которое крутится на нем

- Пункт 1
Устновлена yandex console, создана виртуальная машина с заданными по ДЗ настройками

- Пункт 2
Добавлены скрипт install_ruby.sh, install_mongodb.sh, deploy.sh, а также общий startup.sh в соответствии с требованиями к ДЗ

- Пункт 3
Создан скрипт startup.yaml, который запускается при создании инстанса VM и передается в качестве параметра в

```--metadata-from-file user-data=startup.yaml:```

``` yc compute instance create --name reddit-app --hostname reddit-app --memory=2 --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=15GB --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 --metadata-from-file user-data=startup.yaml --metadata serial-port-enable=1 ```

```
[   70.221165] cloud-init[1102]:   Puma starting in single mode...
[   70.222438] cloud-init[1102]: * Version 3.10.0 (ruby 2.3.1-p112), codename: Russell's Teapot
[   70.223507] cloud-init[1102]: * Min threads: 0, max threads: 16
[   70.223663] cloud-init[1102]: * Environment: development
[   70.223841] cloud-init[1102]: * Daemonizing...
```

# Выполнено ДЗ № 7

 - [9.1. Параметр Параметризирование шаблона] Основное ДЗ
 - [9.2. Другие опции билдера] Основное ДЗ
 - [10.1* Построение bake-образа (по желанию)] Дополнительное ДЗ
 - [10.2* Автоматизация создания ВМ (по желанию)] Дополнительное ДЗ

## В процессе сделано:

Финальный скрипт создания двух образов (reddit-base-test и на его основе reddit-base-immutable), а также запуск виртуальной машины yc находятся в скрипте create-reddit-vm.sh
Для того, чтобы связать все три скрипта (создания двух обраов и ВМ) использовались фиксированные названия параметров builder-а image-name и image-source-name вместо timestamp (который был приведен в качестве примера)

- Пункт 9.1
Установлен packer. Созданы файлы variables.json, ubuntu16.json, в создание базового образа в ubuntu16.json добавлена установка git (для дальнейшего удобства создания дочерних образов)

- Пункт 9.2
Проверка параметризации image-source-name, image-name, subnet_id, zone, use_ipv4_nat

- Пункт 10.1
Создан файл конфигурации immutable.json, который создается на основе базового ubuntu16.json, созданного в пункте 9.1, а также ДЗ 6 (установка reddit-app) + puma.service

- Пункт 10.2
Объединение предыдущих пунктов - 9.1,9.2,10.1 + добавление скрипта создания YC VM create-yc-vm.sh с параметром названия immutable образа, созданного в 10.1,
в финальный create-reddit-vm.sh, который был размещен по требованию ДЗ в папке config-scripts

# Выполнено ДЗ № 8

 - [Определить input переменную для приватного ключа connection, Определите input переменную для задания зоны в ресурсе
"yandex_compute_instance" "app", сделать рядом файл terraform.tfvars.example, в котором будут указаны переменные для образца] Основное ДЗ
 - [Создайте файл lb.tf и опишите в нем в коде terraform создание
HTTP балансировщика, направляющего трафик на наше
развернутое приложение на инстансе reddit-app. Проверьте
доступность приложения по адресу балансировщика. Добавьте в
output переменные адрес балансировщика.] Дополнительное ДЗ
 - [Добавьте в код еще один terraform ресурс для нового инстанса
приложения, например reddit-app2, добавьте его в
балансировщик и проверьте, что при остановке на одном из
инстансов приложения (например systemctl stop puma),
приложение продолжает быть доступным по адресу
балансировщика; Добавьте в output переменные адрес второго
инстанса;] Дополнительное ДЗ
 - [Удалите описание reddit-app2 и попробуйте подход с заданием
количества инстансов через параметр ресурса count.
Переменная count должна задаваться в параметрах и по
умолчанию равна 1.] Дополнительное ДЗ

## В процессе сделано:

- В файл variables.tf добавлены переменные variable "yc_instance_zone" { default = "ru-central1-a" }, variable "private_key_path" {}. Создан файл terraform.tfvars.example, в котором указаны переменные для образца
- Добавлен файл lb.tf, в котором добавлен балансировщик YC "yandex_lb_network_load_balancer.lb-reddit-app", добавлена переменная var.target_port для проверки доступности приложения веб-сервера reddit-app.Проверен доступ к приложению
по адресу балансировщика
- Добавлен дополнительный инстанс сервера приложения reddit-app2, в output переменные выведен адрес второго сервера yandex_compute_instance.app[1].network_interface.0.nat_ip_address. Неудобство создания нового инстанса с помощью дублирования кода.
- Удалено описание нового инстанса reddit-app2. В ресурс yandex_compute_instance.app добавлен объект count, для создания одинаковых ресурсов, с использованием переменной variable "yc_instance_app_count" { default = 1 } и значением yc_instance_app_count = 2 для создания двух инстансов

# Выполнено ДЗ № 9

 - [Разделить конфигурацию виртуальной машины из предыдущего ДЗ на две - одну для mongodb, вторую для reddit-app] Основное ДЗ
 - [Настроить хранение состояния текущей конфигурации в yandex object storage] Дополнительное ДЗ
 - [Настроить запуск приложения на одной ВМ и хранения данных в другой] Дополнительное ДЗ

## В процессе сделано:

- Из конфигурации образа диска parker ubuntu16.json выделено два конфига - app.json и db.json для образов дисков с предустановленной mongodb для db и ruby для app. Освоена работа с модулями terraform - из файла main.tf выделено два модуля terraform (app и db) - для запуска приложения reddit-app и для бэкенда mongodb. Также создано две конфигурации - stage и prod для проверки создания двух vm.
- Выделена конфигурация backend для хранения текущего состояния terraform. Для этого созданы файлы buckets/bucket.tf и в каждой конфигурации prod и stage задан конфиг бэкенда config.s3.tfbackend и файл конфигурации backend.tf.
Применение командой terraform init -backend-config=config.s3.tfbackend.
- Настроены провиженеры переноса заранее подготовленного конфига mongodb
```
storage:
   dbPath: /var/lib/mongodb
net:
   port: 27017
   bindIp: 0.0.0.0
 ```

 ```
   provisioner "file" {
    source      = "../files/mongod.conf"
    destination = "/tmp/mongod.conf"
  }
 ```
  а также подготовим конфиг службы приложения́ с использованием функции templatefile и  provisioner "file" :

```
  provisioner "file" {
    content     = templatefile("../files/puma.env.tftpl", {database_ip = var.database_ip})
    destination = "/tmp/puma.env"
  }
 ```

  Для передачи ip адреса VM mongodb использована переменная из модуля db module.db.external_ip_address_db.
  Так как terraform сам определяет зависимые модули и порядок их установки, то порядок их положения в конфиге не принципиален.
