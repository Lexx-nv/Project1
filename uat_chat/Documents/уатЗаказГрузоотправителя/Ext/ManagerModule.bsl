﻿// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	уатЗаказГрузоотправителяТовары.Номенклатура,
	|	уатЗаказГрузоотправителяТовары.ЕдиницаИзмерения,
	|	уатЗаказГрузоотправителяТовары.Ссылка.КрайнийСрокОтработки КАК ДатаВыполнения,
	|	уатЗаказГрузоотправителяТовары.ПараметрВыработки,
	|	&СТРОКАКОЛИЧЕСТВО,
	|	СУММА(уатЗаказГрузоотправителяТовары.КоличествоПараметрВыработки) КАК КоличествоПараметрВыработки,
	|	уатЗаказГрузоотправителяТовары.Ссылка КАК Регистратор,
	|	уатЗаказГрузоотправителяТовары.Ссылка.Дата КАК Период,
	|	уатЗаказГрузоотправителяТовары.Ссылка КАК ЗаказНаТС,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	уатЗаказГрузоотправителяТовары.Ссылка.Контрагент КАК Заказчик
	|ИЗ
	|	Документ.уатЗаказГрузоотправителя.Товары КАК уатЗаказГрузоотправителяТовары
	|ГДЕ
	|	уатЗаказГрузоотправителяТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	уатЗаказГрузоотправителяТовары.Номенклатура,
	|	уатЗаказГрузоотправителяТовары.ЕдиницаИзмерения,
	|	уатЗаказГрузоотправителяТовары.ПараметрВыработки,
	|	уатЗаказГрузоотправителяТовары.Ссылка,
	|	уатЗаказГрузоотправителяТовары.Ссылка.КрайнийСрокОтработки,
	|	уатЗаказГрузоотправителяТовары.Ссылка.Дата,
	|	уатЗаказГрузоотправителяТовары.Ссылка.Контрагент,
	|	уатЗаказГрузоотправителяТовары.Ссылка
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	уатЗаказГрузоотправителяУслуги.Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(Перечисление.уатПолучателиУслуг.Контрагент) КАК ПолучательУслуг,
	|	уатЗаказГрузоотправителяУслуги.Ссылка.Организация,
	|	уатЗаказГрузоотправителяУслуги.Ссылка.ДоговорКонтрагента,
	|	уатЗаказГрузоотправителяУслуги.Номенклатура,
	|	уатЗаказГрузоотправителяУслуги.Содержание,
	|	уатЗаказГрузоотправителяУслуги.Количество,
	|	ВЫБОР
	|		КОГДА уатЗаказГрузоотправителяУслуги.Ссылка.СуммаВключаетНДС
	|			ТОГДА уатЗаказГрузоотправителяУслуги.Сумма
	|		ИНАЧЕ уатЗаказГрузоотправителяУслуги.Сумма + уатЗаказГрузоотправителяУслуги.СуммаНДС
	|	КОНЕЦ КАК Сумма,
	|	уатЗаказГрузоотправителяУслуги.СтавкаНДС,
	|	уатЗаказГрузоотправителяУслуги.СуммаНДС,
	|	ВЫБОР
	|		КОГДА уатЗаказГрузоотправителяУслуги.Ссылка.СуммаВключаетНДС
	|			ТОГДА уатЗаказГрузоотправителяУслуги.Сумма
	|		ИНАЧЕ уатЗаказГрузоотправителяУслуги.Сумма + уатЗаказГрузоотправителяУслуги.СуммаНДС
	|	КОНЕЦ КАК СуммаРегл,
	|	уатЗаказГрузоотправителяУслуги.Ссылка.Дата КАК Период
	|ИЗ
	|	Документ.уатЗаказГрузоотправителя.Услуги КАК уатЗаказГрузоотправителяУслуги
	|ГДЕ
	|	уатЗаказГрузоотправителяУслуги.Ссылка = &Ссылка
	|	И уатЗаказГрузоотправителяУслуги.Ссылка.Контрагент ССЫЛКА Справочник.Контрагенты
	|;
	|
	|////////////////////////////////////////////////////////////////////////////////
	|ВЫБРАТЬ
	|	уатЗаказГрузоотправителяТовары.Ссылка.Дата КАК Период,
	|	уатЗаказГрузоотправителяТовары.Ссылка КАК Регистратор,
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	уатЗаказГрузоотправителяТовары.Ссылка.Контрагент,
	|	уатЗаказГрузоотправителяТовары.Ссылка.ДоговорКонтрагента,
	|	уатЗаказГрузоотправителяТовары.Ссылка КАК ЗаказГрузоотправителя,
	|	уатЗаказГрузоотправителяТовары.Номенклатура,
	|	уатЗаказГрузоотправителяТовары.ЕдиницаИзмерения,
	|	&СТРОКАКОЛИЧЕСТВО
	|ИЗ
	|	Документ.уатЗаказГрузоотправителя.Товары КАК уатЗаказГрузоотправителяТовары
	|ГДЕ
	|	уатЗаказГрузоотправителяТовары.Ссылка = &Ссылка
	|
	|СГРУППИРОВАТЬ ПО
	|	уатЗаказГрузоотправителяТовары.Ссылка.Дата,
	|	уатЗаказГрузоотправителяТовары.Ссылка,
	|	уатЗаказГрузоотправителяТовары.Ссылка.Контрагент,
	|	уатЗаказГрузоотправителяТовары.Ссылка.ДоговорКонтрагента,
	|	уатЗаказГрузоотправителяТовары.Номенклатура,
	|	уатЗаказГрузоотправителяТовары.ЕдиницаИзмерения,
	|	уатЗаказГрузоотправителяТовары.Ссылка";

	Если уатРаботаСМетаданными.естьСпрЕдиницыИзмерения() тогда
		мЗапрос.Текст = СтрЗаменить(мЗапрос.Текст,"&СТРОКАКОЛИЧЕСТВО","	СУММА(уатЗаказГрузоотправителяТовары.Количество * уатЗаказГрузоотправителяТовары.ЕдиницаИзмерения.Коэффициент / уатЗаказГрузоотправителяТовары.Номенклатура.ЕдиницаХраненияОстатков.Коэффициент) КАК Количество ");
	Иначе
		мЗапрос.Текст = СтрЗаменить(мЗапрос.Текст,"&СТРОКАКОЛИЧЕСТВО","	СУММА(уатЗаказГрузоотправителяТовары.Количество) КАК Количество ");
	КонецЕсли;
	
	мЗапрос.УстановитьПараметр("ссылка",ДокументСсылка);
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	ТаблицаДокумента = МассивРезультатов[0].Выгрузить();
	ТаблицаПредоставленныхУслуг = МассивРезультатов[1].выгрузить();
	Для каждого ТекСтрока ИЗ ТаблицаПредоставленныхУслуг Цикл
		
		ТекСтрока.Сумма     = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.Сумма,
									ДокументСсылка.ВалютаДокумента,
									ДокументСсылка.ДоговорКонтрагента.ВалютаВзаиморасчетов,
									уатОбщегоНазначенияТиповые.уатКурсДокумента(ДокументСсылка,СтруктураДополнительныеСвойства.ВалютаРеглУчета),
									ДокументСсылка.КурсВзаиморасчетов,
									уатОбщегоНазначенияТиповые.уатКратностьДокумента(ДокументСсылка,СтруктураДополнительныеСвойства.ВалютаРеглУчета),
									ДокументСсылка.КратностьВзаиморасчетов);
		ТекСтрока.СуммаРегл = уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.СуммаРегл,
									ДокументСсылка.ВалютаДокумента,
									СтруктураДополнительныеСвойства.ВалютаРеглУчета,
									уатОбщегоНазначенияТиповые.уатКурсДокумента(ДокументСсылка,СтруктураДополнительныеСвойства.ВалютаРеглУчета),
									1,
									уатОбщегоНазначенияТиповые.уатКратностьДокумента(ДокументСсылка,СтруктураДополнительныеСвойства.ВалютаРеглУчета),
									1);
		ТекСтрока.СуммаНДС 	= уатОбщегоНазначенияТиповые.ПересчитатьИзВалютыВВалюту(ТекСтрока.СуммаНДС,
									ДокументСсылка.ВалютаДокумента,
									СтруктураДополнительныеСвойства.ВалютаРеглУчета,
									уатОбщегоНазначенияТиповые.уатКурсДокумента(ДокументСсылка,СтруктураДополнительныеСвойства.ВалютаРеглУчета),
									1,
									уатОбщегоНазначенияТиповые.уатКратностьДокумента(ДокументСсылка,СтруктураДополнительныеСвойства.ВалютаРеглУчета),
									1);
	КонецЦикла;

	//управляемая блокировка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатЗаказыНаТС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ТаблицаДокумента;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Заказчик", "Заказчик");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ЗаказНаТС", "ЗаказНаТС");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Номенклатура", "Номенклатура");
	Блокировка.Заблокировать();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗаказовНаТС"            , ТаблицаДокумента);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПредоставленныхУслуг"   , ТаблицаПредоставленныхУслуг);
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗаказовГрузоотправителя", МассивРезультатов[2].выгрузить());
	
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ДокументСсылка);
	
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	уатЗаказыГрузоотправителейОстатки.Контрагент,
	|	уатЗаказыГрузоотправителейОстатки.Номенклатура,
	|	уатЗаказыГрузоотправителейОстатки.КоличествоОстаток
	|ИЗ
	|	РегистрНакопления.уатЗаказыГрузоотправителей.Остатки(&МоментКонтроля, ЗаказГрузоотправителя = &Ссылка) КАК уатЗаказыГрузоотправителейОстатки
	|ГДЕ
	|	уатЗаказыГрузоотправителейОстатки.КоличествоОстаток < 0";
	Запрос.УстановитьПараметр("Ссылка", ДокументСсылка);
	Запрос.УстановитьПараметр("МоментКонтроля", ДополнительныеСвойства.ДляПроведения.МоментКонтроля);
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ТекстСообщения = "Получены отрицательные остатки по заказчику """ + Выборка.Контрагент + """ для номенклатуры " + Выборка.Номенклатура;
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок, СтатусСообщения.Внимание);	
	КонецЦикла;
КонецПроцедуры
