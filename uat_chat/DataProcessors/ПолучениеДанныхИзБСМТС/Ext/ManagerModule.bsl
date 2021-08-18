﻿Функция ПолучитьПереченьПЛ(НачалоПериода,КонецПериода,ПутевойЛист = Неопределено) Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	уатПутевойЛист.Ссылка Как ПутевойЛист,
		|	уатПутевойЛист.Проведен КАК Проведен,
		|	уатПутевойЛист.ТранспортноеСредство.СистемаМониторинга КАК СистемаМониторинга,
		|	уатПутевойЛист.ТранспортноеСредство КАК ТранспортноеСредство
		|ИЗ
		|	Документ.уатПутевойЛист КАК уатПутевойЛист
		|		Левое СОЕДИНЕНИЕ РегистрСведений.ксДанныеАтографа КАК ксДанныеАтографа
		|		ПО уатПутевойЛист.Ссылка = ксДанныеАтографа.ПутевойЛист
		|			И уатПутевойЛист.ТранспортноеСредство = ксДанныеАтографа.ТранспортноеСредство
		//Следующие 2 условия позволяют вычленить путевые листы, у которых были изменены дата/время выезда/заезда, а данные из БСМТС остались по прежним дате/времени
		//Данные БСМТС по таким путевым листам обновляем в обязательном порядке
		|			И уатПутевойЛист.ДатаВыезда = ксДанныеАтографа.ДтНач
		|			И уатПутевойЛист.ДатаВозвращения = ксДанныеАтографа.ДтКон
		|ГДЕ
		|	
		|	ксДанныеАтографа.ПутевойЛист ЕСТЬ NULL
		|	И ВЫБОР
		|			КОГДА &ПутевойЛист = НЕОПРЕДЕЛЕНО
		|				ТОГДА ((уатПутевойЛист.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания) И (уатПутевойЛист.Проведен = ИСТИНА))
		|			ИНАЧЕ уатПутевойЛист.Ссылка = &ПутевойЛист
		|		КОНЕЦ
		|	И НЕ уатПутевойЛист.ТранспортноеСредство.СистемаМониторинга = ЗНАЧЕНИЕ(Справочник.СистемыМониторинга.ПустаяСсылка)
		|
		|УПОРЯДОЧИТЬ ПО
		|	СистемаМониторинга,
		|	ТранспортноеСредство,
		|	ПутевойЛист.Дата
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ДатаНачала", НачалоПериода);
	Запрос.УстановитьПараметр("ДатаОкончания", КонецПериода);
	Запрос.УстановитьПараметр("ПутевойЛист", ПутевойЛист);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция ПолучитьДатуЗакрытияГСМ() Экспорт
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	РасходГСМзаМесяц.Дата КАК ДатаЗакрытияГСМ
		|ИЗ
		|	Документ.РасходГСМзаМесяц КАК РасходГСМзаМесяц
		|ГДЕ
		|	РасходГСМзаМесяц.Дата МЕЖДУ &ДатаНачала И &ДатаОкончания
		|	И РасходГСМзаМесяц.Проведен = ИСТИНА
		|
		|УПОРЯДОЧИТЬ ПО
		|	РасходГСМзаМесяц.Дата УБЫВ";
	
	Запрос.УстановитьПараметр("ДатаНачала", ДобавитьМесяц(ТекущаяДата(),-6));
	Запрос.УстановитьПараметр("ДатаОкончания", ТекущаяДата());
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка.ДатаЗакрытияГСМ;
	КонецЕсли;	
	Возврат Дата(1,1,1);
КонецФункции	

Процедура ПолучитьДанныеБСМТС(ПутевойЛист = Неопределено) Экспорт
	Если ПутевойЛист <> Неопределено Тогда
		ТЗ = ПолучитьПереченьПЛ(ПутевойЛист.Дата,ПутевойЛист.Дата,ПутевойЛист)
	Иначе
		ДатаЗакрытияГСМ = ПолучитьДатуЗакрытияГСМ();
		Если ДатаЗакрытияГСМ <> Дата(1,1,1) Тогда
			ТЗ = ПолучитьПереченьПЛ(ДатаЗакрытияГСМ + 1,ТекущаяДата())
		КонецЕсли;	
	КонецЕсли;	
	
	ЗагрузитьДанныеИзБСМТС(ТЗ," - регл");
	
КонецПроцедуры	

// ТЗ - таблица значений, которую необходимо обработать
Процедура ЗагрузитьДанныеИзБСМТС(ТЗ,ФлагРегл = "") Экспорт
	
	
	Если ТЗ.Количество() <> 0 Тогда
		
		ТЗ.Сортировать("СистемаМониторинга");
		
		ТекСисМон = "Начало";
		
		Для Каждого ХХХ Из ТЗ Цикл
			
			ДатаС = ХХХ.ПутевойЛист.ДатаВыезда;
			ДатаПо = ХХХ.ПутевойЛист.ДатаВозвращения;
			Если  ХХХ.ТранспортноеСредство.СистемаМониторинга.ВидСистемыGPS = Перечисления.ВидСистемыGPS.Автограф Тогда
				ТекстОшибки = "";
				Рез = глСистемыМониторингаСервер.АвтоГРАФ5_ПолучитьДанныеДляПЛПоТС(ДатаС, ДатаПо, ХХХ.ТранспортноеСредство, ТекстОшибки, ХХХ.ТранспортноеСредство.СистемаМониторинга);
			ИначеЕсли ХХХ.ТранспортноеСредство.СистемаМониторинга.ВидСистемыGPS = Перечисления.ВидСистемыGPS.Виалон Тогда
				//Вот здесь пошел виалон и нам надо 1 раз получить ИДДанные
				Если ТекСисМон = "Начало" Тогда
					ИДДанные = глАвтограф.ПолучитьИДДанные(ХХХ.ТранспортноеСредство.СистемаМониторинга);
					ТекСисМон = "Виалон"
				КонецЕсли;	
				Рез = глАвтограф.ПолучитьДанныеПоТС(ХХХ.ТранспортноеСредство,ДатаС,ДатаПо,ИДДанные,Ложь);
			Иначе
				Продолжить;
			КонецЕсли;
			
			//Если мы получили структуру, то запишем данные в регистр сведений
			Если ТипЗнч(Рез) = Тип("Структура")  Тогда
				Зап = РегистрыСведений.ксДанныеАтографа.СоздатьМенеджерЗаписи();
				ЗаполнитьЗначенияСвойств(Зап,Рез);
				Зап.ПутевойЛист = ХХХ.ПутевойЛист;
				Зап.Лог = Строка(ТекущаяДата()) + " - " + Строка(ИмяПользователя() + ФлагРегл);
				Зап.ДтНач = ДатаС;
				Зап.ДтКон = ДатаПо;
				Зап.ТранспортноеСредство = ХХХ.ТранспортноеСредство;
				//+Lexx - запишем в реквизит с типом "ХранилищеЗначений" весь перечень параметров из БСМТС
				Хранилище = Новый ХранилищеЗначения(Рез.ПараметрыБСМТС);
				Зап.ПараметрыБСМТС = Хранилище;
				Зап.Записать();
			КонецЕсли;	
			
		КонецЦикла;	
		
	КонецЕсли;	
	
КонецПроцедуры	

