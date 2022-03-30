# SAGrabarskiy_infra
# Выполнено ДЗ № 5

 bastion_IP = 51.250.70.142
 someinternalhost_IP = 10.128.0.3
 os = Ubuntu 20.04 LTS

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
	IdentityFile ~/.ssh/appuser_pub ```

- Пункт 3
В ветку cloud-bastion добавлены файл установки VPN Сервера prinutl - файл setupvpn.sh, а также файл конфигурации клиента prinutl - cloud-bastion.ovpn.
В файле setupvpn.sh, в соответствии с документацией https://docs.pritunl.com/docs/installation#other-providers-ubuntu-2004, был подготовлен скрипт установки служб prinutl + mongodb
Настройка сервера реализована в соответствии с алгоритмом, описанным в ДЗ с использованием web интерфейса

- Пункт 4
Для валидации сертификата при обращении к моему серверу pritunl по ip в настройке Lets Encrypt Domian в web-интерфейсе необходимо указать адрес 51.250.70.142.sslip.io, что позволит обращаться к серверу по адресу https://51.250.70.142.sslip.io
