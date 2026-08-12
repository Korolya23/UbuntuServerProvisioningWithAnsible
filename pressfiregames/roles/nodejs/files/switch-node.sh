#!/bin/bash
if [ -z "$1" ]; then
  echo "Использование: switch-node <версия>"
  echo "Например: switch-node 22.11.0"
  exit 1
fi

# Запускаем n с sudo, чтобы перезаписать симлинки в /usr/local
sudo n "$1"
echo "Готово. Текущая версия: $(node -v)"