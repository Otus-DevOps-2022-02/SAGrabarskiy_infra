# SAGrabarskiy_infra
SAGrabarskiy Infra repository
# Выполнено ДЗ № 5

 - [Запуск VM в Yandex Cloud, управление правилами фаервола, настройка SSH подключения, настройка SSH подключения через Bastion Host, настройка VPN сервера и VPN-подключения.] Основное ДЗ

## В процессе сделано:

 Пункт 1 - Исследовать способ подключения к someinternalhost в одну
команду из вашего рабочего устройства, проверить работоспособность
найденного решения.
 Решение:
  ssh -J appuser@51.250.71.57 appuser@10.128.0.3
  где 51.250.71.57 - внешний адрес cloud-bastion
	  10.128.0.3 внутрненний ip someinternalhost

 Пункт 2 - Предложить вариант решения для подключения из консоли при помощи
команды вида ssh someinternalhost из локальной консоли рабочего
устройства, чтобы подключение выполнялось по алиасу
someinternalhost.
 Решение:
 В ssh конфиг добавляем
     ### The Bastion Host
	 Host cloud-bastion
	  HostName 51.250.71.57
	  User appuser
	  IdentityFile ~/.ssh/appuser_pub

	 ### The Remote Host
	 Host someinternalhost
	  HostName 10.128.0.3
	  ProxyJump cloud-bastion
	  User appuser
	  IdentityFile ~/.ssh/appuser_pub
