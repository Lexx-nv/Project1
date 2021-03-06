// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	СформироватьТаблицуОстаткиАгрегатов(ДокументСсылка, СтруктураДополнительныеСвойства);
	
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	уатСписаниеАгрегатовШины.Ссылка.Дата КАК Период,
	|	уатСписаниеАгрегатовШины.Ссылка КАК Регистратор,
	|	уатСписаниеАгрегатовШины.СерияНоменклатуры.ТипАгрегата КАК ТипАгрегата,
	|	уатСписаниеАгрегатовШины.СерияНоменклатуры,
	|	уатСписаниеАгрегатовШины.ПричинаСписания,
	|	1 КАК Количество
	|ИЗ
	|	Документ.уатСписаниеАгрегатов.Шины КАК уатСписаниеАгрегатовШины
	|ГДЕ
	|	уатСписаниеАгрегатовШины.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	уатСписаниеАгрегатовАккумуляторы.Ссылка.Дата,
	|	уатСписаниеАгрегатовАккумуляторы.Ссылка,
	|	уатСписаниеАгрегатовАккумуляторы.СерияНоменклатуры.ТипАгрегата,
	|	уатСписаниеАгрегатовАккумуляторы.СерияНоменклатуры,
	|	уатСписаниеАгрегатовАккумуляторы.ПричинаСписания,
	|	1
	|ИЗ
	|	Документ.уатСписаниеАгрегатов.Аккумуляторы КАК уатСписаниеАгрегатовАккумуляторы
	|ГДЕ
	|	уатСписаниеАгрегатовАккумуляторы.Ссылка = &Ссылка
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	уатСписаниеАгрегатовПрочиеАгрегаты.Ссылка.Дата,
	|	уатСписаниеАгрегатовПрочиеАгрегаты.Ссылка,
	|	уатСписаниеАгрегатовПрочиеАгрегаты.СерияНоменклатуры.ТипАгрегата,
	|	уатСписаниеАгрегатовПрочиеАгрегаты.СерияНоменклатуры,
	|	уатСписаниеАгрегатовПрочиеАгрегаты.ПричинаСписания,
	|	1
	|ИЗ
	|	Документ.уатСписаниеАгрегатов.ПрочиеАгрегаты КАК уатСписаниеАгрегатовПрочиеАгрегаты
	|ГДЕ
	|	уатСписаниеАгрегатовПрочиеАгрегаты.Ссылка = &Ссылка";
	мЗапрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	ТаблицаПричинСписанияАгрегатов = мЗапрос.Выполнить().Выгрузить();
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ПричиныСписанияАгрегатов", ТаблицаПричинСписанияАгрегатов);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицуОстаткиАгрегатов(ДокументСсылка, СтруктураДополнительныеСвойства)
	тблОстаткиАгрегатов = Новый ТаблицаЗначений;
	тблОстаткиАгрегатов.Колонки.Добавить("Регистратор");
	тблОстаткиАгрегатов.Колонки.Добавить("Период");
	тблОстаткиАгрегатов.Колонки.Добавить("ВидДвижения");
	тблОстаткиАгрегатов.Колонки.Добавить("СерияНоменклатуры");
	тблОстаткиАгрегатов.Колонки.Добавить("Склад");
	тблОстаткиАгрегатов.Колонки.Добавить("Количество");
	
	//расход
	Для Каждого ТекСтрока Из ДокументСсылка.Шины Цикл
		НоваяСтрока = тблОстаткиАгрегатов.Добавить();
		НоваяСтрока.Регистратор = ДокументСсылка;
		НоваяСтрока.Период = ДокументСсылка.Дата;
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
		НоваяСтрока.Склад = ДокументСсылка.Склад;
		НоваяСтрока.СерияНоменклатуры = ТекСтрока.СерияНоменклатуры;
		НоваяСтрока.Количество = 1;
	КонецЦикла;
	Для Каждого ТекСтрока Из ДокументСсылка.Аккумуляторы Цикл
		НоваяСтрока = тблОстаткиАгрегатов.Добавить();
		НоваяСтрока.Регистратор = ДокументСсылка;
		НоваяСтрока.Период = ДокументСсылка.Дата;
		НоваяСтрока.ВидДвижения = ВидДвиженияНакопления.Расход;
		НоваяСтрока.Склад = ДокументСсылка.Склад;
		НоваяСтрока.СерияНоменклатуры = ТекСтрока.СерияНоменклатуры;
		НоваяСтрока.Количество = 1;
	КонецЦикла;
	Для Каждого ТекСтрока Из ДокументСсылка.ПрочиеАгрегаты Цикл
		НоваяСтрока = тблОстаткиАгрегатов.Добавить();
		НоваяСтрока.Регистратор       = ДокументСсылка;
		НоваяСтрока.Период            = ДокументСсылка.Дата;
		НоваяСтрока.ВидДвижения       = ВидДвиженияНакопления.Расход;
		НоваяСтрока.Склад             = ДокументСсылка.Склад;
		НоваяСтрока.СерияНоменклатуры = ТекСтрока.СерияНоменклатуры;
		НоваяСтрока.Количество        = 1;
	КонецЦикла;
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатОстаткиАгрегатов");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = тблОстаткиАгрегатов;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Склад"            , "Склад");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("СерияНоменклатуры", "СерияНоменклатуры");
	Блокировка.Заблокировать();

	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаОстатковАгрегатов", тблОстаткиАгрегатов);
	
КонецПроцедуры // СформироватьТаблицуОстаткиАгрегатов()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ДокументСсылка);
	
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	уатОстаткиАгрегатовОстатки.Склад,
	|	уатОстаткиАгрегатовОстатки.СерияНоменклатуры,
	|	уатОстаткиАгрегатовОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.уатОстаткиАгрегатов.Остатки(
	|			&Период,
	|			Склад = &Склад
	|				И (СерияНоменклатуры В (&мсвШины)
	|					ИЛИ СерияНоменклатуры В (&мсвАккумуляторы) 
	|					ИЛИ СерияНоменклатуры В (&мсвПрочиеАгрегаты))) КАК уатОстаткиАгрегатовОстатки
	|ГДЕ
	|	уатОстаткиАгрегатовОстатки.КоличествоОстаток < 0";
	мЗапрос.УстановитьПараметр("Период"           , Новый Граница(ДокументСсылка.Дата, ВидГраницы.Включая));
	мЗапрос.УстановитьПараметр("Склад"            , ДокументСсылка.Склад);
	мЗапрос.УстановитьПараметр("мсвШины"          , ДокументСсылка.Шины.Выгрузить().ВыгрузитьКолонку("СерияНоменклатуры"));
	мЗапрос.УстановитьПараметр("мсвАккумуляторы"  , ДокументСсылка.Аккумуляторы.Выгрузить().ВыгрузитьКолонку("СерияНоменклатуры"));
	мЗапрос.УстановитьПараметр("мсвПрочиеАгрегаты", ДокументСсылка.ПрочиеАгрегаты.Выгрузить().ВыгрузитьКолонку("СерияНоменклатуры"));
	
	
	Выборка = мЗапрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		Если Выборка.СерияНоменклатуры.ТипАгрегата = Справочники.уатТипыАгрегатов.Аккумулятор тогда
			ТекстСообщения = "Аккумулятор """;
		ИначеЕсли Выборка.СерияНоменклатуры.ТипАгрегата = Справочники.уатТипыАгрегатов.Шина тогда
			ТекстСообщения = "Шина """;
		Иначе
			ТекстСообщения = "Агрегат """;
		КонецЕсли;
		ТекстСообщения = ТекстСообщения + Выборка.СерияНоменклатуры.СерийныйНомер + """ отсутствует на складе """ + ДокументСсылка.Склад + """";
		
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);	
	КонецЦикла;
	
КонецПроцедуры
