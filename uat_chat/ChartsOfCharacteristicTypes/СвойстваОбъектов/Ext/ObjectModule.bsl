﻿////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)

	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	Если НЕ ЭтоНовый() 
	   И НазначениеСвойства <> Ссылка.НазначениеСвойства 
	   И ЭтотОбъект.СуществуютСсылки() Тогда

		Сообщить("Существуют объекты, которым назначено свойство """ + Наименование + """.
		         |Назначение свойства не может быть изменено, элемент не записан.", 
		         СтатусСообщения.Важное);

		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры

// Обработчик события ПередУдалением объекта.
//
Процедура ПередУдалением(Отказ)

	Если Предопределенный Тогда
		Сообщить("Не допускается удаление предопределенных элементов!",СтатусСообщения.Внимание);
		Отказ = Истина;
	КонецЕсли;

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Функция проверяет, используется ли свойство для задания значений 
// или назначения каким-либо объектам.
//
// Параметры:
//  Нет.
//
// Возвращаемое значение:
//  Истина, если используется, Ложь, если нет.
//
Функция СуществуютСсылки() Экспорт

	Запрос = Новый Запрос();

	Запрос.Текст = 
	"ВЫБРАТЬ ПЕРВЫЕ 1
	|	РегистрСведений.ЗначенияСвойствОбъектов.Свойство КАК Свойство
	|ИЗ
	|	РегистрСведений.ЗначенияСвойствОбъектов
	|
	|ГДЕ
	|	РегистрСведений.ЗначенияСвойствОбъектов.Свойство = &Свойство
	|";

	Запрос.УстановитьПараметр("Свойство", Ссылка);

	Возврат НЕ Запрос.Выполнить().Пустой();

КонецФункции
