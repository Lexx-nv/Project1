
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	#Если Клиент тогда
	Предупреждение("Создание документа ""Акт об оказании производственных услуг"" невозможно.
					|Данный объект используется в решениях, объединенных с типовыми конфигурациями 1С.");
	#КонецЕсли
	Отказ = Истина;
КонецПроцедуры
