
Процедура Алга(ФлтСтк) Экспорт
	Если ТипЗнч(ФлтСтк.ТС) = Тип("СправочникСсылка.уатТС") Тогда
		Наб = РегистрыСведений.уатДокументыТС.СоздатьНаборЗаписей();
		Наб.отбор.ТС.Значение = флтСтк.ТС;
		Наб.Отбор.ТС.Использование = Истина;
		Наб.отбор.ВидДокумента.Значение = флтСтк.ВидДокумента;
		Наб.Отбор.ВидДокумента.Использование = Истина;
		Наб.Прочитать();
		
		Если Наб.Количество()=0 ТОгда Возврат; КонецеСЛИ;
		
		Зап = РегистрыСведений.уатДокументыТС.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Зап,Наб[0],"ТС,ВидДокумента,Серия,Номер");
		Зап.Прочитать();
		Если Зап.Выбран() Тогда
			Зап.ПолучитьФорму("ФормаЗаписи",,"111").Открыть();
		КонецЕСЛИ;
	Иначе
		флтСтк.Вставить("Сотрудник",флтСтк.ТС);
		Наб = РегистрыСведений.уатДокументыВодителей.СоздатьНаборЗаписей();
		Наб.отбор.Сотрудник.Значение = флтСтк.ТС;
		Наб.Отбор.Сотрудник.Использование = Истина;
		Наб.отбор.ВидДокумента.Значение = флтСтк.ВидДокумента;
		Наб.Отбор.ВидДокумента.Использование = Истина;
		Наб.Прочитать();
		
		Если Наб.Количество()=0 ТОгда Возврат; КонецеСЛИ;
		
		Зап = РегистрыСведений.уатДокументыВодителей.СоздатьМенеджерЗаписи();
		ЗаполнитьЗначенияСвойств(Зап,Наб[0],"Сотрудник,ВидДокумента,Серия,Номер");
		Зап.Прочитать();
		Если Зап.Выбран() Тогда
			Зап.ПолучитьФорму("ФормаЗаписи",,"111").Открыть();
		КонецЕСЛИ;
	КонецЕсли;	
	
	
	
	
	
	
КонецПроцедуры
