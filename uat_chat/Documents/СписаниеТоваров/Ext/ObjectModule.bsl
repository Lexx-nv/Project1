
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	#Если Клиент тогда
		Предупреждение("Создание документа ""Списание товаров"" невозможно.
					|Данный объект используется в решениях, объединенных с типовыми конфигурациями 1С.");		
	#КонецЕсли
	Отказ = Истина;	
КонецПроцедуры
