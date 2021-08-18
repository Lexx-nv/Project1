﻿// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	мЗапрос = Новый Запрос;
	мЗапрос.МенеджерВременныхТаблиц = СтруктураДополнительныеСвойства.ДляПроведения.СтруктураВременныеТаблицы.МенеджерВременныхТаблиц;
	мЗапрос.УстановитьПараметр("ссылка",ДокументСсылка);
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.НомерСтроки,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.ТС,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.СерияНоменклатуры,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.Состояние,
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.Ссылка
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.уатОперацииСАгрегатами.ПрочиеАгрегаты КАК уатОперацииСАгрегатамиПрочиеАгрегаты
	|ГДЕ
	|	уатОперацииСАгрегатамиПрочиеАгрегаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	ТаблицаДокумента.СерияНоменклатуры,
	|	ТаблицаДокумента.Ссылка.СкладОтправитель КАК Склад
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента";
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	//управляемая блокировка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатОстаткиАгрегатов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = МассивРезультатов[1];
	Для каждого КолонкаРезультатЗапроса Из МассивРезультатов[1].Колонки Цикл
		ЭлементБлокировки.ИспользоватьИзИсточникаДанных(КолонкаРезультатЗапроса.Имя, КолонкаРезультатЗапроса.Имя);
	КонецЦикла;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.уатАгрегатыТС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = МассивРезультатов[1];
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("СерияНоменклатуры", "СерияНоменклатуры");
	Блокировка.Заблокировать();

	мЗапрос.Текст = "
	|ВЫБРАТЬ
	|	""0 - Таблица таблица состав ТС"" КАК СлужебноеПолеИмяТаблицы,
	|	ТаблицаДокумента.Ссылка КАК Регистратор,
	|	ТаблицаДокумента.Ссылка.Дата КАК Период,
	|	ТаблицаДокумента.СерияНоменклатуры,
	|	ТаблицаДокумента.ТС КАК ТС,
	|	ТаблицаДокумента.Состояние КАК СостояниеАгрегата
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""1 - Таблица остатков агрегатов на складах"" КАК СлужебноеПолеИмяТаблицы,
	|	ТаблицаДокумента.Ссылка КАК Регистратор,
	|	ТаблицаДокумента.Ссылка.Дата КАК Период,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	ТаблицаДокумента.СерияНоменклатуры,
	|	ТаблицаДокумента.Ссылка.СкладПолучатель КАК Склад,
	|	1 КАК Количество
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	""1 - Таблица остатков агрегатов на складах"",
	|	ТаблицаДокумента.Ссылка,
	|	ТаблицаДокумента.Ссылка.Дата,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Расход),
	|	ТаблицаДокумента.СерияНоменклатуры,
	|	ТаблицаДокумента.Ссылка.СкладОтправитель,
	|	1 КАК Количество
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|ГДЕ
	|	ТаблицаДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)";
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаАгрегатовТС"       , МассивРезультатов[0].Выгрузить());
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОстатковАгрегатов" , МассивРезультатов[1].Выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ДокументСсылка);
	
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	ПрочиеАгрегаты.СерияНоменклатуры,
	|	ПрочиеАгрегаты.Состояние,
	|	ПрочиеАгрегаты.ТС
	|ПОМЕСТИТЬ ТаблицаДокумента
	|ИЗ
	|	Документ.уатОперацииСАгрегатами.ПрочиеАгрегаты КАК ПрочиеАгрегаты
	|ГДЕ
	|	ПрочиеАгрегаты.Ссылка = &Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""1 - Таблица проверки что нигде уже не установлено"" КАК СлужебноеПолеИмяТаблицы,
	|	уатАгрегатыТССрезПоследних.СерияНоменклатуры КАК СерияНоменклатуры,
	|	уатАгрегатыТССрезПоследних.ТС КАК ТС,
	|	уатАгрегатыТССрезПоследних.МестоУстановки
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатАгрегатыТС.СрезПоследних(&МоментВремениИсключая, ) КАК уатАгрегатыТССрезПоследних
	|		ПО ТаблицаДокумента.СерияНоменклатуры = уатАгрегатыТССрезПоследних.СерияНоменклатуры
	|ГДЕ
	|	(НЕ уатАгрегатыТССрезПоследних.СерияНоменклатуры ЕСТЬ NULL )
	|	И уатАгрегатыТССрезПоследних.СостояниеАгрегата <> ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)
	|	И ТаблицаДокумента.Состояние = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""2 - Таблица проверки остатков на складе"" КАК СлужебноеПолеИмяТаблицы,
	|	ТаблицаДокумента.СерияНоменклатуры,
	|	уатОстаткиАгрегатовОстатки.Склад
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатОстаткиАгрегатов.Остатки(
	|				&МоментВремениВключая,
	|				Склад = &СкладОтправитель
	|					И СерияНоменклатуры В
	|						(ВЫБРАТЬ
	|							ТаблицаДокумента.СерияНоменклатуры
	|						ИЗ
	|							ТаблицаДокумента)) КАК уатОстаткиАгрегатовОстатки
	|		ПО ТаблицаДокумента.СерияНоменклатуры = уатОстаткиАгрегатовОстатки.СерияНоменклатуры
	|ГДЕ
	|	ТаблицаДокумента.Состояние <> ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.Снято)
	|	И уатОстаткиАгрегатовОстатки.КоличествоОстаток < 0
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	""3 - Таблица проверки, что снимаем агрегат, который не установлен на ТС"" КАК СлужебноеПолеИмяТаблицы,
	|	ТаблицаДокумента.СерияНоменклатуры КАК СерияНоменклатуры,
	|	ТаблицаДокумента.ТС КАК ТС,
	|	ТаблицаДокумента.Состояние КАК Состояние,
	|	уатАгрегатыТССрезПоследних.ТС КАК АгрегатыТС_ТС,
	|	уатАгрегатыТССрезПоследних.СостояниеАгрегата КАК АгрегатыТС_Состояние
	|ИЗ
	|	ТаблицаДокумента КАК ТаблицаДокумента
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатАгрегатыТС.СрезПоследних(&МоментВремениИсключая, ) КАК уатАгрегатыТССрезПоследних
	|		ПО ТаблицаДокумента.СерияНоменклатуры = уатАгрегатыТССрезПоследних.СерияНоменклатуры
	|			И ТаблицаДокумента.ТС = уатАгрегатыТССрезПоследних.ТС";
	
	мЗапрос.УстановитьПараметр("Ссылка"          , ДокументСсылка);
	мЗапрос.УстановитьПараметр("МоментВремениИсключая", Новый Граница(ДокументСсылка.МоментВремени(),ВидГраницы.Исключая));
	мЗапрос.УстановитьПараметр("МоментВремениВключая" , Новый Граница(ДокументСсылка.МоментВремени(),ВидГраницы.Включая));
	мЗапрос.УстановитьПараметр("СкладОтправитель", ДокументСсылка.СкладОтправитель);
	мЗапрос.УстановитьПараметр("СкладПолучатель" , ДокументСсылка.СкладПолучатель);
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	ВыборкаКонтроля = МассивРезультатов[1].Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
	Пока ВыборкаКонтроля.следующий() Цикл
		ТекстСообщения = "Агрегат " + ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер + " уже установлен";
		ТекстСообщения = ТекстСообщения + " на транспортном средстве """ + уатОбщегоНазначения.уатПредставлениеТС(ВыборкаКонтроля.ТС, ДокументСсылка.Организация) + """";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок, СтатусСообщения.Внимание);	
	КонецЦикла;
	
	ВыборкаКонтроля = МассивРезультатов[2].Выбрать();
	Пока ВыборкаКонтроля.Следующий() Цикл
		ТекстСообщения = "Для агрегата """ + ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер + """ (" + ВыборкаКонтроля.СерияНоменклатуры.Модель + ") получены отрицательные остатки на складе """ + ВыборкаКонтроля.Склад + """";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок, СтатусСообщения.Внимание);	
	КонецЦикла;
	
	ВыборкаКонтроля = МассивРезультатов[3].Выбрать();
	Пока ВыборкаКонтроля.Следующий() Цикл
		Если ВыборкаКонтроля.Состояние = Перечисления.уатСостоянияАгрегатов.Снято И
			(ВыборкаКонтроля.АгрегатыТС_ТС = NULL ИЛИ ВыборкаКонтроля.АгрегатыТС_Состояние = Перечисления.уатСостоянияАгрегатов.Снято) Тогда
			ТекстСообщения = "Агрегат """ + ВыборкаКонтроля.СерияНоменклатуры.СерийныйНомер + """ (" + ВыборкаКонтроля.СерияНоменклатуры.Модель
			+ ") не установлен на ТС """ + уатОбщегоНазначения.уатПредставлениеТС(ВыборкаКонтроля.ТС, ДокументСсылка.Организация) + """";
			
			ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок, СтатусСообщения.Внимание);
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры