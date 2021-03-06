&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	#Если ВебКлиент Тогда
		ФорматMXL  = Истина;
		ФорматXLS  = Ложь;
		ФорматHTML = Ложь;
		Элементы.ФорматXLS.Доступность  = Ложь;
		Элементы.ФорматHTML.Доступность = Ложь;
	#КонецЕсли
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТОВ ФОРМЫ

&НаКлиенте
Процедура КнопкаОтменаВыполнить()
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Процедура КнопкаОКВыполнить()
	
	Если Не ФорматMXL И Не ФорматXLS И Не ФорматHTML Тогда
		Предупреждение(НСтр("ru = 'Необходимо указать как минимум один из форматов: MXL, XLS или HTML!'"));
		Возврат;
	КонецЕсли;
	
	Результат = Новый Структура;
	Результат.Вставить("ЗапаковатьZIP", ЗапаковатьZIP);
	Результат.Вставить("ФорматMXL",     ФорматMXL);
	Результат.Вставить("ФорматXLS",     ФорматXLS);
	Результат.Вставить("ФорматHTML",    ФорматHTML);
	
	Закрыть(Результат);
	
КонецПроцедуры
