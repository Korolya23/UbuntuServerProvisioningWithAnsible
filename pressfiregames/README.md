# Тестовое задание Press Fire Games – Ansible

Автоматическая настройка Ubuntu 24.04 с помощью Ansible.

## Что делает
- Создаёт пользователей (любое количество), прописывает им shell и SSH-ключи.
- Настраивает сеть: DHCP или статика (IP, DNS, маршруты).
- Устанавливает Docker и плагин docker compose (v2).
- Поднимает в контейнерах Traefik 3 и Nginx (Nginx отдаёт дефолтную страницу приветствия).
- *Бонус*: ставит три LTS-версии Node.js (18, 20, 22) и даёт скрипт для мгновенного переключения.

## Структура
- hosts.ini # куда подключаемся
- setup.yml # основной плейбук
- group_vars/
  - all.yml # все переменные (пользователи, сеть, версии)
- roles/
  - base # пользователи + сеть
  - docker # установка Docker
  - traefik_nginx # запуск Traefik + Nginx через compose
  - nodejs # установка и переключение Node.js


## Перед запуском
1. Поставить коллекцию community.docker:
   ```bash
   ansible-galaxy collection install community.docker

Убедитесь, что на целевой машине Ubuntu 24.04 и работает SSH.

## Настройка
### hosts.ini

Замените IP, пользователя и способ подключения:
   ```bash 
   [servers]
   target ansible_host=192.168.64.2 ansible_user=ubuntu ansible_become=true
   ```
Если нужен пароль для SSH/Sudo, добавьте ```ansible_ssh_pass``` и ```ansible_become_pass```.

## group_vars/all.yml

Поменять под себя:

- users – список пользователей с shell и публичными ключами.
- net_mode – dhcp или static.
- docker_compose_ver – версия compose-плагина.
- nodejs_versions – какие LTS ставить.

## Запуск

Из папки проекта выполни:
```
ansible-playbook -i hosts.ini setup.yml -K
```
Если пароли уже в hosts.ini, флаг -K не нужен.

## Проверка

- Nginx: откройте браузер на http://IP_сервера (порт 80). Увидите "Welcome to nginx!".
- Пользователи: попробуй зайти по SSH под созданным логином с соответствующим ключом.
- Node.js: внутри сервера выполни ```switch-node 20.11.0```, затем ```node -v```.

## Переключение Node.js

На сервере доступна команда ```switch-node```. Пример:

```bash
switch-node 22.11.0
```
Скрипт глобально меняет активную версию для всех пользователей.

## Важно

- Сетевая конфигурация генерируется через netplan. При смене IP через static Ansible может потерять соединение.
- Тестировалось на ARM64 (Apple Silicon, UTM). Для x86_64 заменить arch=arm64 на arch=amd64 в роли docker.