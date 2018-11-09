## Глобусный поворотный стол 

Основная координата **A** (ход +/- 110 градусов), зависимая координата **B** (ход 360 градусов). 
Поворотный стол выполнен на приводах требующих выход в *ДОМАШНЮЮ* позицию, 
т.к. после обесточивания фиксация координаты пропадает и координата смещается в положение с минимальной потенциальной энергией.
Эту особенность следует учитывать для избежания повреждения инструмента и заготовки.

Для выхода в *ДОМАШНЮЮ* позицию после загрузки СЧПУ нужно перейти в режим **F6-Установки**, выбрать раздел **КОНФИГУРАЦИЯ** и 
выполнить последовательно *Выставить ось A/B (HOMING)*. После удачного завершения процедуры символ соответствующей координаты в нижнем правом углу
отобразиться *синим*  цветом, а при возникновении неисправности *красным*. 

Процедура *Выставить ось A/B (HOMING)* вызывает следующие действия:
* привод выполняет поиск референсной метки
* в этом положении станочная координата назначается равной *Координата точки HOME на A/B*
* привод перемещается в ранее сохранённую координату

Процедура определения координаты точки HOME:
* выйти в станочный 0 по выбранной координате, либо выполнить сброс МРВ (сброс МРВ=ДА + перезагрузка SHIFT+ESC)
* *Выставить ось A/B (HOMING)*
* *выкатать* ось по индикатору
* занести значение станочной координаты в поле *Координата точки HOME на A/B* с противоположенным знаком
* проверить повторным *HOMING*