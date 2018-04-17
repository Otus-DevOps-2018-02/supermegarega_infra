# supermegarega_infra
supermegarega Infra repository

# Конфигурация
Создал два экземпляра VM  bastion и someinternalhost.
Настроил ssh Forwarding для подключения.
Настроил OpenVPN сервер для подключения.
Настроил подключение в одну команду и с использованием алиаса.
```
bastion_IP = 35.195.174.202
someinternalhost_IP = 10.132.0.3
```

Запуск ssh агента
`ssh-agent`

Добавление приватного ключа
`ssh-add ~/.ssh/appuser`

ssh Forwarding
`~/.ssh/config`
```
Host bastion
  Hostname 35.195.174.202
  User appuser

Host someinternalhost
  Hostname 10.132.0.3
  User appuser
  ProxyCommand ssh -v bastion -W %h:%p
```
Подключение в одну команду
`ssh -i ~/.ssh/appuser -A appuser@someinternalhost`

Подключение по алиасу
`~/.bash_profile`
```
...
...
alias someinternalhost='ssh -i ~/.ssh/appuser -A appuser@someinternalhost'
```
`ssh someinternalhost`

# Конфигурация cloud-testapp.
reddit-app_IP = 35.205.66.67
testapp_IP = 35.205.66.67
testapp_PORT = 9292
install_ruby.sh - скрипт установки Ruby
install_mongodb.sh - скрипт установки Mongodb
deploy.sh - скрипт установки Puma
startup_script.sh - скрипт автоматической установки и деплоя Puma.

# Создание VM с помощью gcloud CLI.

gcloud compute instances create reddit-app \
  --boot-disk-size=10GB \
  --image-family ubuntu-1604-lts \
  --image-project=ubuntu-os-cloud \
  --machine-type=g1-small \
  --tags puma-server \
  --restart-on-failure \
  --metadata-from-file startup-script=/home/smr/supermegarega_infra/startup_script.sh

gcloud compute --project=infra-198011 firewall-rules create default-puma-server \
  --direction=INGRESS \
  --priority=1000 \
  --network=default \
  --action=ALLOW \
  --rules=tcp:9292 \
  --source-ranges=0.0.0.0/0 \
  --target-tags=puma-server

#Зависимости
google-cloud-sdk
ruby-full
ruby-bundler
build-essential
mongodb-org

#Homework-6 Сборка образов VM при помощи Packer

#Конфигурация
reddit-app_ip = 35.195.206.35

packer/files/puma.service - systemd unit для Puma
packer/scripts/deploy-puma.sh - скрипт для установки Puma.
packer/immutable.json - immutable шаблон для создания образа.
packer/ubuntu16.json - шаблон для создания образа.
config-scripts/create-reddit-vm.sh - скрипт для создания инстанса.

#Как запустить проект
выполнить config-scripts/create-reddit-vm.sh

#Как проверить работоспособность
Перейти по ссылке http://35.195.206.35:9292
Зарегистрироваться.

#Homework-7 Практика IaC с использованием Terraform

#Конфигурация
terraform/main.tf - main configuration
terraform/variables.tf - variables
terraform/outputs.tf - output variables
terraform/lb.tf - load balancer configuration
terraform/files/deploy.sh - script for deploy Puma
terraform/files/puma.service - systemd unit for Puma

#Homework-8 Terraform: ресурсы, модули, окружения и работа в команде

#Конфигурация
terraform/modules/ - Terraformmodules
terraform/prod/ - Prod environment
terraform/stage/ - Stage environment
terraform/storage-bucket.tf - Remote storage for terraform.tfstate
terraform/prod/backend.tf - Backend config

#Homework-9 Знакомство с Ansible

#Конфигурация
ansible/inventory - Inventory ini
ansible/inventory.yml - Inventory YAML
ansible/inventory.json - Inventory JSON
ansible/inventory.sh - Bash script for dinamic inventory
ansible/clone.yml - Playbook clone repo

#Homework-10 Деплой и управление конфигурацией с Ansible

ansible/reddit_app_one_play.yml - One play
ansible/reddit_app_multiple_plays.yml - Multiple play
ansible/packer_app.yml - Packer App play
ansible/packer_db.yml - Packer DB play
ansible/gce.py - GCP dinamic inventory
ansible/gce.ini.example - ini for gce.py
ansible/app.yml - App play
ansible/db.yml - DB play
ansible/deploy.yml - Puma play
ansible/site.yml - app,db,deploy in one play
ansible/templates/db_config.j2 - Template DB url
ansible/templates/mongod.conf.j2 - Template mongo

#Homework-11 Ansible: работа с ролями и окружениями

# Trytravis build -  https://travis-ci.org/supermegarega/trytravis

ansible/environments/prod/ - Prod environment
ansible/environments/stage/ - Stage environment
ansible/roles/app/ - App role
ansible/roles/db/ - DB role
ansible/roles/jdauphant.nginx/ - Nginx role
ansible/vault.key - Key
