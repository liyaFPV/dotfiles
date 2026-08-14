#скрпит для поиска видео на youtube
#!/bin/bash

if [ -z "$*" ]; then
  # если ничего не передано
  nohup firefox "https://www.youtube.com" >/dev/null 2>&1 &
else
  query=$(echo "$*" | sed 's/ /+/g')
  nohup firefox "https://www.youtube.com/results?search_query=$query" >/dev/null 2>&1 &
fi