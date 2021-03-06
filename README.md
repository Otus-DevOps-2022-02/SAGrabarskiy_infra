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

 # Выполнено ДЗ № 10

 - [Научиться базовым командам настройки и подключения к существующим хостам ВМ, запуска команд на удаленных хостах, освоить работу с inventory.yaml и inventory] Основное ДЗ
 - [Создать скрипт\программу для проверки работоспособности динамического inventory] Дополнительное ДЗ

## В процессе сделано:
- Настроен inventory файл с настройками статических адресов доступных серверов
	```
	$ ansible -i inventory_plug.exe app -m ping
	51.250.74.248 | SUCCESS => {
		"ansible_facts": {
			"discovered_interpreter_python": "/usr/bin/python3"
		},
		"changed": false,
		"ping": "pong"
	}
	```

- Настроен inventory.yaml файл с настройками статических адресов доступных серверов, аналогично проверена его работоспособность
- Проверено выполнение команд на удаленном хосте:

```
  ansible app -m shell -a 'ruby -v; bundler -v'
  ansible db -m command -a 'systemctl status mongod'
  ansible db -m shell -a 'systemctl status mongod'
  ansible db -m systemd -a name=mongod
  ansible db -m service -a name=mongod

  ansible app -m git -a 'repo=https://github.com/express42/reddit.git dest=/home/ubuntu/reddit'
  ansible app -m command -a 'git clone https://github.com/express42/reddit.git /home/ubuntu/reddit'

```
- Проверена установка и удаление репозитория приложения на удаленном хосте с помощью плейбука clone.yml:
```
	---
	- name: Clone
	  hosts: app
	  tasks:
		- name: Clone repo
		  git:
			repo: https://github.com/express42/reddit.git
			dest: /home/ubuntu/reddit
```
- Команды запуска и проверки
```
	ansible-playbook clone.yml
	ansible app -m shell -a 'rm -rf ~/reddit'
	result :
	appserver | CHANGED | rc=0 >>
```

## Как запустить проект:
- С помощью golang создано приложение для работы с ansible c использованием динамического inventory.
Код приложения в директории ansible/inventory_plug. Сборка (при наличии установленного стандартного окружения go):
```
  cd /inventory_plug/
  go get github.com/yandex-cloud/go-sdk
  go build -ldflags="-s -w"
```
## Как проверить работоспособность:
```
  $ ansible -i inventory_plug.exe app -m ping

51.250.74.248 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```
```
  $ ansible -i inventory_plug.exe all -m ping

51.250.74.248 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
51.250.95.254 | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3"
    },
    "changed": false,
    "ping": "pong"
}
```

 # Выполнено ДЗ № 11

 - [Научиться работе с плейбуками ansible] Основное ДЗ
 - [Научиться работе с провиженероами ansible в parcker] Дополнительное ДЗ

## В процессе сделано:
### Один плейбук, один сценарий (reddit_app_one_play.yml)
Теги привязаны к задаче  внутри сценария, поэтому необходимо также указывать хост, для которго выполняеся сценарий:
```
- name: Configure hosts & deploy application # <-- Словесное описание сценария(name)
  hosts: all # <-- Для каких хостов будут выполняться описанные ниже таски (hosts)
  vars:
    mongo_bind_ip: 0.0.0.0
    db_host: 51.250.93.178
  tasks:

```
Команды для проверки:

```
ansible-playbook reddit_app.yml --check --limit db
nsible-playbook reddit_app.yml --check --limit app --tags app-tag

```
### Один плейбук, много сценариев (reddit_app_multiple_plays.yml)
Теги привязаны к конкретному сценарию, хост указан также в начале сценария, поэтому не обязательно указывать хост при запуске:

```
- name: Configure MongoDB
  hosts: db
  tags: db-tag
  become: true
  vars:
    mongo_bind_ip: 0.0.0.0
```
Команды для проверки:

```
ansible-playbook reddit_app2.yml --tags db-tag --check
ansible-playbook reddit_app2.yml --tags db-tag --check

```
### Много плейбуков(app.yml,db.yml,deploy.yml,site.yml)
Плейбуки выносятся в разные файлы app.yml,db.yml,deploy.yml и вызываются в итоговом site.yml, поэтому теги не нужны, их можно убрать, хост для которого выполнен сценарий остается:

```
- name: Configure MongoDB
  hosts: db
  become: true
  vars:
    mongo_bind_ip: 0.0.0.0
  tasks:
```

Site.yml:
```
- import_playbook: db.yml
- import_playbook: app.yml
- import_playbook: deploy.yml
```
Команды для проверки:

```
ansible-playbook site.yml --check
```

### Замена провижн образов Packer на Ansible-плейбуки (packer_db.yml,packer_app.yml):
В пакер образах провиженеры запуска shell скриптов заменены:
- для packer/app.json  на:
```
"provisioners": [
		{
			"type": "ansible",
			"user": "ubuntu",
			"playbook_file": "ansible/packer_app.yml"
		}
	]
```
- для packer/db.json  на:
```
"provisioners": [
		{
			"type": "ansible",
			"user": "ubuntu",
			"playbook_file": "ansible/packer_db.yml"
		}
	]
```

Для предотвращения сбоев в работе сети при автоматическом развертывании, дистрибутив mongo 4.4 был заранее получен с официального сайта mongo и подготовлен плейбук с развертыванием нужной конфигурации (mongod.conf) без обновления по сети

```
 ansible packer_db.yml
```

Команды для проверки:
```
packer build --var-file=./packer/variables.json ./packer/app.json
packer build --var-file=./packer/variables.json ./packer/db.json
terraform destroy
terraform apply
ansible-playbook site.yml --check
ansible-playbook site.yml
```

Примечание:
Так как в новом провиженере packer_db.yml я сразу настроил запуск mongo c нужной конфигурацией, то из сценария site.yml в этом пункте ДЗ был исключен импорт плейбука db.yml (в котором происходила настройка конфига для mongo).

 # Выполнено ДЗ № 12

 - [Научиться работе с ролями ansible] Основное ДЗ
 - [Научиться работе с vault] Основное ДЗ

## В процессе сделано:
### Освоен инструмент использования ролей ansible:

Инициализация:
```
ansible-galaxy init app
ansible-galaxy init db
```

Сценарии плейбуков, переменные и шаблоны, а также обработчики перенесены в соотвествующие директории ролей, а в основном файле плейбука (db.yml, app.yml)
скрипт плейбука заменен на вызов соотвествующей роли, пример для app:

```
- name: Configure App
  hosts: app
  become: true

  roles:
    - app
```
### Освоен инструмент использования окружений:

Структура:
```
ansible\environments\prod
 -\group_vars
   -all
   -app
   -db
 -\inventory
ansible\environments\stage
 -\group_vars
    -all
   -app
   -db
 -\inventory
```

В конфиге ansible.cfg можно указать окружение по умолчанию:

```
[defaults]
inventory = ./environments/stage/inventory # Inventory по-умолчанию задается здесь
```

Запуск плейбука в определенном окружении:
```
ansible-playbook -i environments/prod/inventory deploy.yml
```
```
ansible-playbook playbooks/site.yml --check
```

### Освоен инструмент ролей community репозитория:
Установка роли:

requirements.yml:
```
- src: jdauphant.nginx
  version: v2.21.1
```
скрипт установки:
```
ansible-galaxy install -r environments/stage/requirements.yml
```
Добавление роли в плейбук, пример app.yml:
```
- name: Configure App
  hosts: app
  become: true

  roles:
    - app
    - jdauphant.nginx

```
### Освоен инструмент шифрования-дешифрования с помощью ansible-vault:
Создан файл vault.key c произвольной строкой
Новый файл добавлен в конфиг ansible.cfg:
```
vault_password_file = ~/.ansible/vault.key
```
Добавлен плейбук для создания пользователей ansible/playbooks/users.yml
и два credentials файла для prod и stage окружений с логинаим и праолями
```
ansible/environments/prod/credentials.yml
ansible/environments/stage/credentials.yml
```

Эти файлы далее были зашифрованы спомощью команд:
```
ansible-vault encrypt environments/prod/credentials.yml
ansible-vault encrypt environments/stage/credentials.yml
```
В файл site.yml добавлен импорт плейбука users.yml

```
---
- import_playbook: db.yml
- import_playbook: app.yml
- import_playbook: deploy.yml
- import_playbook: users.yml
```
Проверена авторизация пользователей после создания виртуалки:
```
ansible-playbook site.yml --check
ansible-playbook site.yml
```
Примечание:
при проверке сценария site.yml проверка ansible-playbook site.yml —check не проходит, так как роль jdauphant.nginx еще не создавалась (во время проверки сценария установки роли jdauphant.nginx выполняется тест наличия файлов конфигураци службы nginx по пути, которые создаются только в момент выполнения сценария)
