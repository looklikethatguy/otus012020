#!/bin/bash

# Переменные и пути к файлам
LOGFILE=access.log
LOCKFILE=mylockfile
WORKFILE=myworkfile
RESULTFILE=result
RUNTIME=`date +%d/%b/%Y:%T`
SCRIPTLOG=scriptlog

# Проверка наличия локфайла
if [[ -f $LOCKFILE ]]; then
  echo "script is already run!" >&2
  exit 1
fi

touch $LOCKFILE

cat $LOGFILE > $WORKFILE

# Проверка лога скрипта на наличие записей
if [ ! -f  $SCRIPTLOG ]; then
   # Если первый запуск скрипта, то ставим самую первую дату из лога
   FIRSTRUN=`head -1 "$WORKFILE" | awk '{print substr($4,2)}'`
   echo $FIRSTRUN > $SCRIPTLOG
else
   # Иначе берем последнюю дату из файла
   LASTRUNTIME=`tail -1 "$SCRIPTLOG" | sed 's%/%\\\\/%g'` # << замечательная регулярка, которая экранирует символы "/" в переменной, чтобы sed мог вывести значение
fi

# Убираем в рабочем файле строки, которые старше даты последнего окончания обработки файла
sed -ir '0,/'"$LASTRUNTIME"'/d' $WORKFILE

# Формируем сводные данные
parse(){
DATE_FROM=`head -1 $WORKFILE | awk '{print substr($4,2)}'`
DATE_TO=`tail -1 $WORKFILE | awk '{print substr($4,2)}'`
echo "Начало работы скрипта: "$RUNTIME >> $RESULTFILE
echo "***********************************************" >> $RESULTFILE
echo "Данные представлены с "$DATE_FROM "по "$DATE_TO >> $RESULTFILE
echo "***********************************************" >> $RESULTFILE
echo "Хосты с наибольшим количеством запросов:" >> $RESULTFILE
cat $WORKFILE | awk '{print $1}' | sort | uniq -c | sort -rn | head >> $RESULTFILE
echo "***********************************************" >> $RESULTFILE
echo "Адреса с наибольшим количеством запросов:" >> $RESULTFILE
cat $WORKFILE | awk '{print $7}' | sort | uniq -c | sort -rn | head >> $RESULTFILE
echo "***********************************************" >> $RESULTFILE
echo "Коды возврата и их количество:" >> $RESULTFILE
cat $WORKFILE | awk '{print $9}' | sort | uniq -c | sort -rn | head >> $RESULTFILE
#| sed -e '1,/'"$FROMDATE"'/d' 
echo "***********************************************" >> $RESULTFILE
echo "Все ошибки и их количество:" >> $RESULTFILE
cat $WORKFILE | awk '{if ( $9 ~ /(4[0-9][0-9]|5[0-9][0-9])/ ) { print $9 }}' | sort | uniq -c | sort -rn >> $RESULTFILE
echo "***********************************************" >> $RESULTFILE
}
# Вызываем функцию без аргументов
parse

# Сохраняем последнюю строку в лог скрипта
LASTRUNTIME=`tail -1 $WORKFILE | awk '{print substr ($4,2)}'`
echo "$LASTRUNTIME" >> $SCRIPTLOG
# Отправляем письмо с отчётом адресату
cat "$RESULTFILE" | mail -s "Log data" root@localhost

# Прибираемся
rm -f $WORKFILE $RESULTFILE 
trap "rm $LOCKFILE" INT TERM EXIT
exit 0


