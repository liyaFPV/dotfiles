#скрипт для поиска в браузера
#!/bin/bash

if [ -z "$*" ]; then
  # если ничего не передано
  nohup firefox >/dev/null 2>&1 &
else
  query=$(echo "$*" | sed 's/ /+/g')
  nohup firefox "https://www.google.com/search?q=$query" >/dev/null 2>&1 &
fi