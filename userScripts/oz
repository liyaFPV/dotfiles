#поиск на ozon.ru
#!/bin/bash

if [ -z "$*" ]; then
  # если ничего не передано
  nohup firefox "https://www.ozon.ru/" >/dev/null 2>&1 &
else
  query=$(echo "$*" | sed 's/ /+/g')
  nohup firefox "https://www.ozon.ru/search/?text=$query" >/dev/null 2>&1 &
fi