////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура - обработчик события ПередЗаписью.
//
Процедура ПередЗаписью(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	// Контроль заполнения таблицы датчиков
	
	Для каждого СтрокаДатчики Из Датчики Цикл
		Если СтрокаДатчики.Датчик.Пустая() Тогда
			Отказ = Истина;
			Сообщить(НСтр("ru = 'Таблица датчиков, строка №"+СтрокаДатчики.НомерСтроки+", не указан датчик!'"));		
		КонецЕсли;
		
		Если СтрокаДатчики.Назначение.Пустая() Тогда
			Отказ = Истина;
			Сообщить(НСтр("ru = 'Таблица датчиков, строка №"+СтрокаДатчики.НомерСтроки+", не указано назначение датчика!'"));		
		КонецЕсли;
	
	КонецЦикла;
	
КонецПроцедуры

// Процедура - обработчик события ПриЗаписи.
//
Процедура ПриЗаписи(Отказ)
	
	Если ОбменДанными.Загрузка Тогда 
		Возврат;
	КонецЕсли;
	
	ItobВызовСервера.ЗаписатьСтрокуВРегистрПрав(Ссылка);
	
КонецПроцедуры
