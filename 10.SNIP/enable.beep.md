# Включение звукового извещателя

По умолчанию звуковой извещатель отключен и скрыт в настройках станка.
Для его использования необходимо [отредактировать](config.edit.md#доступ-к-файлу) файл конфигурации.

В разделе ```[settings]``` нужно удалить из параметра ```hide``` значения ```0103;0105;```.

Например:

```
;БЫЛО
[settings]
hide="0102;0103;0105;1111;1112;0405;0406;0407;0408;0420;РЕГУЛЯТОР"

;СТАЛО
[settings]
hide="0102;1111;1112;0405;0406;0407;0408;0420;РЕГУЛЯТОР"

```

# Логика работы звукового извещателя

Звуковой извещатель может находиться в 3х режимах (параметр *0103*):

1. ВЫКЛЮЧЕН		- не используется
2. АВАРИЯ		- активируется при возникновении аварийной ситуации
3. АВАРИЯ+ОСТАНОВ	- активируется при возникновении аварийной ситуации или программного останова выполнения программы

Звуковой извещатель активируется только по истечении времени заданного в параметре *0105* с момента последней команды оператора.