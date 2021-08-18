﻿// Обработчик события ПередЗаписью объекта.
//
Процедура ПередЗаписью(Отказ)

	Если НЕ ОбменДанными.Загрузка И ЗначениеЗаполнено(БазовыйТипЦен) Тогда
		// Если цена расчетная и введена на основании расчетной - это неправильно - записывать нельзя
		Если БазовыйТипЦен.Рассчитывается Тогда
			ОбщегоНазначения.СообщитьОбОшибке("Базовый тип цен не может быть динамическим!", Отказ);
			Возврат;
		КонецЕсли;
	КонецЕсли;

	Если НЕ ОбменДанными.Загрузка И Не ЭтоГруппа Тогда
		Если Рассчитывается Тогда
			// Если цена расчетная и на основании её введена уже расчетная - это неправильно - записывать нельзя
			Запрос = Новый Запрос;
			Запрос.УстановитьПараметр("ТекущийТипЦен", ЭтотОбъект.Ссылка);

			Запрос.Текст =
			"ВЫБРАТЬ
			|	ТипЦен.Рассчитывается КАК Рассчитывается,
			|	ТипЦен.БазовыйТипЦен КАК БазовыйТипЦен
			|ИЗ
			|	Справочник.ТипыЦенНоменклатуры КАК ТипЦен
			|
			|ГДЕ
			|	ТипЦен.БазовыйТипЦен = &ТекущийТипЦен
			| И ТипЦен.Рассчитывается = Истина";

			ВыборкаЦен = Запрос.Выполнить().Выбрать();
			Если ВыборкаЦен.Следующий() Тогда
				ОбщегоНазначения.СообщитьОбОшибке("Этот тип цен уже используется как базовый, он уже не может быть динамическим!", Отказ);
				Возврат;
			КонецЕсли;
		КонецЕсли;
	КонецЕсли;

КонецПроцедуры

