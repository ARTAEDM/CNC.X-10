# Раскладчик проволоки

Предназначен для равномерного распределения отработанной проволоки по приёмной катушке.
При протяжке проволоки раскладчик совершает равномерное движение между **начальным** и **конечным** положением.
Информация о положении и направлении движения сохраняется в СЧПУ перед отключением питания и восстанавливается при следующем запуске.

## Сброс начального положения

Раскладчик не оборудован датчиками крайнего положения. Для правильной работы необходимо периодически выполнять сброс начального положения.
Для этого необходимо через 1с после включения станка нажать кнопку заправки. После этого раскладчик выйдет в 0 положение до упора и затем перейдёт в начальное положение.

## Регулировки 

Для корректной настройки раскладчика необходимо указать в параметрах: 

1. **0430** - **Отступ раскладчика**[мм] (начальное положение) 
2. **0431** - **Ход раскладчика**[мм] (**0430**+**0431** = конечное положение)

в файле конфигурации возможно настроить скорость движения раскладчика:

~~~
[wire]
pikup.speed=150	; скорость 1-255
~~~
