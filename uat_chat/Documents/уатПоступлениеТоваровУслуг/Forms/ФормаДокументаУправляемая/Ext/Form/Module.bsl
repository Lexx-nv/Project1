////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

&НаСервереБезКонтекста
Функция ПолучитьДанныеДатаПриИзменении(ДокументСсылка, ДатаНовая, ДатаПередИзменением)
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("РазностьДат", уатОбщегоНазначенияСервер.ПроверитьНомерДокумента(ДокументСсылка, ДатаНовая, ДатаПередИзменением));
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДатаПриИзменении()

// Получает набор данных с сервера для процедуры ДоговорПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеДоговорПриИзменении(Дата, ВалютаДокумента, Договор)
	
	СтруктураДанные = Новый Структура;
	
	СтруктураДанные.Вставить(
	"ВалютаРасчетов",
	Договор.ВалютаВзаиморасчетов
	);
	
	СтруктураДанные.Вставить(
	"ВалютаРасчетовКурсКратность",
	РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Дата, Новый Структура("Валюта", Договор.ВалютаВзаиморасчетов))
	);
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеДоговорПриИзменении()

// Получает набор данных с сервера для процедуры НоменклатураПриИзменении.
//
&НаСервереБезКонтекста
Функция ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные)
	
	Если НЕ Метаданные.Справочники.Найти("ЕдиницыИзмерения") = Неопределено Тогда
		СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.ЕдиницаХраненияОстатков);
	Иначе
		СтруктураДанные.Вставить("ЕдиницаИзмерения", СтруктураДанные.Номенклатура.БазоваяЕдиницаИзмерения);
	КонецЕсли;
	
	Возврат СтруктураДанные;
	
КонецФункции // ПолучитьДанныеНоменклатураПриИзменении()

&НаКлиенте
Процедура ПриИзмененииКонтрагентаИлиОрганизации()
	
	ДанныеОбменаССервером = Новый Структура("Организация, Контрагент, ДоговорКонтрагента, УчитыватьНДС, Дата");
	ЗаполнитьЗначенияСвойств(ДанныеОбменаССервером, Объект);
	// Получим данные с сервера
	ДанныеОбменаССервером.ДоговорКонтрагента = Объект.ДоговорКонтрагента;
	ЗначенияДляЗаполнения = ИзменениеКонтрагентаСервер(ДанныеОбменаССервером);
	Объект.ДоговорКонтрагента = ЗначенияДляЗаполнения.ДоговорКонтрагента;
	
	ДоговорПередИзменением = Договор;
	Договор = Объект.ДоговорКонтрагента;
	
	ПриИзмененииДоговора(ДоговорПередИзменением);
	
КонецПроцедуры // ПриИзмененииКонтрагентаИлиОрганизации()

// Процедура при изменении договора.
//
&НаКлиенте
Процедура ПриИзмененииДоговора(ДоговорПередИзменением)
	
	СтруктураДанные = ПолучитьДанныеДоговорПриИзменении(Объект.Дата, Объект.ВалютаДокумента, Объект.ДоговорКонтрагента);
	
	ВалютаРасчетовПередИзменением = ВалютаРасчетов;
	ВалютаРасчетов = СтруктураДанные.ВалютаРасчетов;
	
	Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда 
		Объект.КурсВзаиморасчетов	   = ?(СтруктураДанные.ВалютаРасчетовКурсКратность.Курс = 0, 1, СтруктураДанные.ВалютаРасчетовКурсКратность.Курс);
		Объект.КратностьВзаиморасчетов = ?(СтруктураДанные.ВалютаРасчетовКурсКратность.Кратность = 0, 1, СтруктураДанные.ВалютаРасчетовКурсКратность.Кратность);
	КонецЕсли;
	
	Если (ЗначениеЗаполнено(Объект.ДоговорКонтрагента)
		И ЗначениеЗаполнено(ВалютаРасчетов)
		И Объект.ДоговорКонтрагента <> ДоговорПередИзменением
		И ВалютаРасчетовПередИзменением <> СтруктураДанные.ВалютаРасчетов)
		И Объект.ВалютаДокумента <> СтруктураДанные.ВалютаРасчетов Тогда
		
		Объект.ВалютаДокумента = СтруктураДанные.ВалютаРасчетов;
		Предупреждение(НСтр("ru = 'Изменилась валюта расчетов по договору с контрагентом! Необходимо проверить валюту документа!'"));
		ОбработатьИзмененияПоКнопкеЦеныИВалюты(ВалютаРасчетовПередИзменением, Истина);
		
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИзменениеКонтрагентаСервер(ДанныеДляЗаполнения)
	СтруктураПараметровДляПолученияДоговора = уатЗаполнениеДокументов.ПолучитьСтруктуруПараметровДляПолученияДоговораПокупки();
	
	ЗначенияДляЗаполнения = уатОбщегоНазначенияСервер.ПриИзмененииЗначенияКонтрагента(ДанныеДляЗаполнения, СтруктураПараметровДляПолученияДоговора);
	Возврат ЗначенияДляЗаполнения;
КонецФункции

// Процедура выполняет пересчет в табличной части документа после изменений 
// в форме "Цены и валюта".Выполняется пересчет колонок: цена, скидка, сумма,
// сумма НДС, всего.
//
&НаКлиенте
Процедура ОбработатьИзмененияПоКнопкеЦеныИВалюты(Знач ВалютаРасчетовПередИзменением, ПересчитатьЦены = Ложь)
	
	// 1. Формируем структуру параметров для заполнения формы "Цены и Валюта".
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ВалютаДокумента",		  Объект.ВалютаДокумента);
	СтруктураПараметров.Вставить("Курс",				  Объект.КурсВзаиморасчетов);
	СтруктураПараметров.Вставить("Кратность",			  Объект.КратностьВзаиморасчетов);
	СтруктураПараметров.Вставить("Контрагент",			  Объект.Контрагент);
	СтруктураПараметров.Вставить("Договор",				  Объект.ДоговорКонтрагента);
	СтруктураПараметров.Вставить("Организация",			  Объект.Организация);
	СтруктураПараметров.Вставить("ДатаДокумента",		  Объект.Дата);
	СтруктураПараметров.Вставить("ПерезаполнитьЦены",	  Ложь);
	СтруктураПараметров.Вставить("ПересчитатьЦены",		  ПересчитатьЦены);
	СтруктураПараметров.Вставить("БылиВнесеныИзменения",  Ложь);
	СтруктураПараметров.Вставить("СуммаВключаетНДС",      Объект.СуммаВключаетНДС);
	СтруктураПараметров.Вставить("НалогообложениеНДС",	  Объект.УчитыватьНДС);
	
	// 2. Открываем форму "Цены и Валюта".
	СтруктураЦеныИВалюта = ОткрытьФормуМодально("ОбщаяФорма.ФормаЦеныИВалютаУправляемая", СтруктураПараметров);
	
	// 3. Перезаполняем табличную часть "Номенклатура", если были внесены изменения в форме "Цены и Валюта".
	Если ТипЗнч(СтруктураЦеныИВалюта) = Тип("Структура") И СтруктураЦеныИВалюта.БылиВнесеныИзменения Тогда
		
		Объект.ВалютаДокумента		   = СтруктураЦеныИВалюта.ВалютаДокумента;
		Объект.КурсВзаиморасчетов	   = СтруктураЦеныИВалюта.КурсРасчетов;
		Объект.КратностьВзаиморасчетов = СтруктураЦеныИВалюта.КратностьРасчетов;
		Объект.СуммаВключаетНДС		   = СтруктураЦеныИВалюта.СуммаВключаетНДС;
		Объект.УчитыватьНДС			   = СтруктураЦеныИВалюта.НалогообложениеНДС;
		
		// Пересчитываем сумму если изменился признак Налогообложение НДС.
		Если СтруктураЦеныИВалюта.НалогообложениеНДС <> СтруктураЦеныИВалюта.ПредНалогообложениеНДС Тогда
			ЗаполнитьСтавкуНДСПоНалогообложениеНДС();		
		КонецЕсли;
		
		// Пересчитываем цены по валюте.
		Если НЕ СтруктураЦеныИВалюта.ПерезаполнитьЦены И СтруктураЦеныИВалюта.ПересчитатьЦены Тогда	
			уатОбщегоНазначенияКлиент.ПересчитатьЦеныТабличнойЧастиПоВалюте(ЭтаФорма, ВалютаРасчетовПередИзменением, "Товары");
			уатОбщегоНазначенияКлиент.ПересчитатьЦеныТабличнойЧастиПоВалюте(ЭтаФорма, ВалютаРасчетовПередИзменением, "Услуги");
		КонецЕсли;
		
		// Пересчитываем сумму если изменился признак "Сумма включает НДС".
		Если СтруктураЦеныИВалюта.СуммаВключаетНДС <> СтруктураЦеныИВалюта.ПредСуммаВключаетНДС Тогда
			уатОбщегоНазначенияКлиент.ПересчитаемСуммуТабличнойЧастиПоФлагуСуммаВключаетНДС(ЭтаФорма, "Товары");
			уатОбщегоНазначенияКлиент.ПересчитаемСуммуТабличнойЧастиПоФлагуСуммаВключаетНДС(ЭтаФорма, "Услуги");
		КонецЕсли;
	КонецЕсли;
	
	// Сформируем надпись цены и валюты.
	СтруктураНадписи = Новый Структура;
	СтруктураНадписи.Вставить("ВалютаДокумента", Объект.ВалютаДокумента);
	СтруктураНадписи.Вставить("ВалютаРасчетов", ВалютаРасчетов);
	СтруктураНадписи.Вставить("Курс", Объект.КурсВзаиморасчетов);
	СтруктураНадписи.Вставить("КурсНациональнаяВалюта", КурсНациональнаяВалюта);
	СтруктураНадписи.Вставить("СуммаВключаетНДС", Объект.СуммаВключаетНДС);
	СтруктураНадписи.Вставить("УчитыватьНДС", Объект.УчитыватьНДС);
	ЦеныИВалюта = СформироватьНадписьЦеныИВалюта(СтруктураНадписи);
	
	ОбновитьИнфНадпись();
КонецПроцедуры // ОбработатьИзмененияПоКнопкеЦеныИВалюты()

// Процедура заполняет Ставку НДС в табличной части по системе налогообложения.
// 
&НаСервере
Процедура ЗаполнитьСтавкуНДСПоНалогообложениеНДС()
	
	Если Объект.УчитыватьНДС Тогда
		
		Элементы.ТоварыСтавкаНДС.Видимость = Истина;
		Элементы.ТоварыСуммаНДС.Видимость  = Истина;
		Элементы.УслугиСтавкаНДС.Видимость = Истина;
		Элементы.УслугиСуммаНДС.Видимость  = Истина;
		
	Иначе
		
		Элементы.ТоварыСтавкаНДС.Видимость = Ложь;
		Элементы.ТоварыСуммаНДС.Видимость  = Ложь;
		Элементы.УслугиСтавкаНДС.Видимость = Ложь;
		Элементы.УслугиСуммаНДС.Видимость  = Ложь;
		
		СтавкаНДСПоУмолчанию = уатОбщегоНазначенияПовтИсп.ПолучитьСтавкуНДСНоль();
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Товары Цикл
			
			СтрокаТабличнойЧасти.СтавкаНДС = СтавкаНДСПоУмолчанию;
			СтрокаТабличнойЧасти.СуммаНДС = 0;
			
		КонецЦикла;
		
		Для каждого СтрокаТабличнойЧасти Из Объект.Услуги Цикл
			
			СтрокаТабличнойЧасти.СтавкаНДС = СтавкаНДСПоУмолчанию;
			СтрокаТабличнойЧасти.СуммаНДС = 0;
			
		КонецЦикла;
		
	КонецЕсли;	
	
КонецПроцедуры // ЗаполнитьСтавкуНДСПоНалогообложениеНДС()

&НаКлиенте
Процедура РедактироватьЦеныИВалюту(Команда)
	
	ОбработатьИзмененияПоКнопкеЦеныИВалюты(Объект.ВалютаДокумента);
	РассчитатьСуммуДокумента();
	
КонецПроцедуры

// Процедура рассчитывает сумму в строке табличной части.
//
&НаКлиенте
Процедура РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти = Неопределено)
	
	Если СтрокаТабличнойЧасти = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
	
	РассчитатьСуммуНДС(СтрокаТабличнойЧасти);
	
КонецПроцедуры // РассчитатьСуммуВСтрокеТабличнойЧасти()

// Рассчитывается сумма НДС в строке табличной части.
//
&НаКлиенте
Процедура РассчитатьСуммуНДС(СтрокаТабличнойЧасти)
	
	СтавкаНДС = уатОбщегоНазначенияПовтИсп.ПолучитьЗначениеСтавкиНДС(СтрокаТабличнойЧасти.СтавкаНДС);
	
	СтрокаТабличнойЧасти.СуммаНДС = ?(Объект.СуммаВключаетНДС, 
	СтрокаТабличнойЧасти.Сумма - (СтрокаТабличнойЧасти.Сумма) / ((СтавкаНДС + 100) / 100),
	СтрокаТабличнойЧасти.Сумма * СтавкаНДС / 100);
	
КонецПроцедуры // РассчитатьСуммуНДС()

&НаКлиенте
Процедура РассчитатьСуммуДокумента()
	НДСВсего = Объект.Товары.Итог("СуммаНДС") + Объект.Услуги.Итог("СуммаНДС");
	Объект.СуммаДокумента = Объект.Товары.Итог("Сумма") + Объект.Услуги.Итог("Сумма");
	Если Объект.УчитыватьНДС И НЕ Объект.СуммаВключаетНДС Тогда
		Объект.СуммаДокумента = Объект.СуммаДокумента + НДСВсего;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПодбор(Команда)
	ДействиеПодбор("Товары");
КонецПроцедуры

&НаКлиенте
Процедура УслугиПодбор(Команда)
	ДействиеПодбор("Услуги");
КонецПроцедуры

&НаКлиенте
Процедура ДействиеПодбор(ИмяТабличнойЧасти)
	ЕстьУслуги = Ложь;
	Если ИмяТабличнойЧасти = "Товары" Тогда
		Команда = "ПодборВТабличнуюЧастьТовары";
	ИначеЕсли ИмяТабличнойЧасти = "Услуги" Тогда
		Команда = "ПодборВТабличнуюЧастьУслуги";
		ЕстьУслуги = Истина;
	КонецЕсли;
	СтруктураПараметровПодбора = Новый Структура();
	СтруктураПараметровПодбора.Вставить("Команда", Команда);
	
	СтруктураПараметровПодбора.Вставить("ПодбиратьУслуги", ЕстьУслуги);
	СтруктураПараметровПодбора.Вставить("ОтборУслугПоСправочнику", Истина);
	
	ВременнаяДатаРасчетов = ?(НачалоДня(Объект.Дата) = НачалоДня(ТекущаяДата()), Неопределено, Объект.Дата);
	СтруктураПараметровПодбора.Вставить("ДатаРасчетов", ВременнаяДатаРасчетов);
	СтруктураПараметровПодбора.Вставить("Склад", Объект.Склад);
	
	РаботаСДиалогамиКлиент.ОткрытьПодборНоменклатуры(ЭтаФорма, СтруктураПараметровПодбора);
	
КонецПроцедуры //

// Производит заполнение документа переданными из формы подбора данными.
//
// Параметры:
//  ТабличнаяЧасть    - табличная часть, в которую надо добавлять подобранную позицию номенклатуры;
//  ЗначениеВыбора    - структура, содержащая параметры подбора.
//
&НаКлиенте
Процедура ОбработкаПодбора(ИмяТабличнойЧасти, ЗначениеВыбора) Экспорт
	
	Перем Номенклатура, ЕдиницаИзмерения, Количество;
	
	// Получим параметры подбора из структуры подбора.
	ЗначениеВыбора.Свойство("Номенклатура",		Номенклатура);
	ЗначениеВыбора.Свойство("ЕдиницаИзмерения",	ЕдиницаИзмерения);
	ЗначениеВыбора.Свойство("Количество",		Количество);
	
	// Ищем выбранную позицию в таблице подобранной номенклатуры.
	// Если найдем - увеличим количество; не найдем - добавим новую строку.
	СтруктураОтбора = Новый Структура();
	
	СтруктураОтбора.Вставить("Номенклатура",     Номенклатура);
	Если ИмяТабличнойЧасти <> "Услуги" Тогда
		СтруктураОтбора.Вставить("ЕдиницаИзмерения", ЕдиницаИзмерения);
	КонецЕсли;
	
	МассивСтрок = Объект[ИмяТабличнойЧасти].НайтиСтроки(СтруктураОтбора);
	Если МассивСтрок.Количество() = 0 Тогда
		СтрокаТабличнойЧасти = Неопределено;
	Иначе
		СтрокаТабличнойЧасти = МассивСтрок[0];
	КонецЕсли;
	
	Если СтрокаТабличнойЧасти <> Неопределено Тогда
		// Нашли, увеличиваем количество в первой найденной строке.
		СтрокаТабличнойЧасти.Количество = СтрокаТабличнойЧасти.Количество + Количество;
		РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
	Иначе
		// Не нашли - добавляем новую строку.
		СтрокаТабличнойЧасти = Объект[ИмяТабличнойЧасти].Добавить();
		СтрокаТабличнойЧасти.Номенклатура	  = Номенклатура;
		СтрокаТабличнойЧасти.Количество  	  = Количество;
		СтрокаТабличнойЧасти.СтавкаНДС		  = Номенклатура.СтавкаНДС;
		Если ИмяТабличнойЧасти = "Услуги" Тогда
			СтрокаТабличнойЧасти.Содержание = Номенклатура.НаименованиеПолное;
		Иначе
			СтрокаТабличнойЧасти.ЕдиницаИзмерения = ЕдиницаИзмерения;
		КонецЕсли;
	КонецЕсли;
	РассчитатьСуммуДокумента();
КонецПроцедуры //


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ УПРАВЛЕНИЯ ВНЕШНИМ ВИДОМ ФОРМЫ

&НаКлиенте
Процедура УстановитьВидимость()
	
	// Колонки налога показываем только тогда, когда его учитываем.
	Если Объект.УчитыватьНДС <> Элементы.ТоварыСтавкаНДС.Видимость Тогда
		Элементы.ТоварыСтавкаНДС.Видимость = Объект.УчитыватьНДС;
	КонецЕсли;
	Если Объект.УчитыватьНДС <> Элементы.УслугиСтавкаНДС.Видимость Тогда
		Элементы.УслугиСтавкаНДС.Видимость = Объект.УчитыватьНДС;
	КонецЕсли;
	
	Если Объект.УчитыватьНДС <> Элементы.ТоварыСуммаНДС.Видимость Тогда
		Элементы.ТоварыСуммаНДС.Видимость = Объект.УчитыватьНДС;
	КонецЕсли;
	Если Объект.УчитыватьНДС <> Элементы.УслугиСуммаНДС.Видимость Тогда
		Элементы.УслугиСуммаНДС.Видимость = Объект.УчитыватьНДС;
	КонецЕсли;
	
	Элементы.ОтражатьВНалоговомУчете.Доступность = Объект.ОтражатьВБухгалтерскомУчете;
	
	// Услуги на комиссию не принимаем.
	ВидимостьЗакладкиУслуг = (Объект.ДоговорКонтрагента.ВидДоговора <> Перечисления.ВидыДоговоровКонтрагентов.СКомитентом);
	Элементы.ГруппаУслуги.Видимость = ВидимостьЗакладкиУслуг;
	
	// Сформируем надпись цены и валюты.
	СтруктураНадписи = Новый Структура("ВалютаДокумента, ВалютаРасчетов, Курс, КурсНациональнаяВалюта, СуммаВключаетНДС, УчитыватьНДС", Объект.ВалютаДокумента, ВалютаРасчетов, Объект.КурсВзаиморасчетов, КурсНациональнаяВалюта, Объект.СуммаВключаетНДС, Объект.УчитыватьНДС);
	ЦеныИВалюта = СформироватьНадписьЦеныИВалюта(СтруктураНадписи);
	
КонецПроцедуры

// Функция возвращает текст надписи "Цены и валюта".
//
&НаКлиентеНаСервереБезКонтекста
Функция СформироватьНадписьЦеныИВалюта(СтруктураНадписи)
	
	ТекстНадписи = "";
	
	// Валюта.
	Если ЗначениеЗаполнено(СтруктураНадписи.ВалютаДокумента) Тогда
		ТекстНадписи = НСтр("ru = 'Валюта: %Валюта%, курс: %Курс%'");
		ТекстНадписи = СтрЗаменить(ТекстНадписи, "%Валюта%", СокрЛП(Строка(СтруктураНадписи.ВалютаДокумента)));
		ТекстНадписи = СтрЗаменить(ТекстНадписи, "%Курс%", ?((НЕ ЗначениеЗаполнено(СтруктураНадписи.ВалютаРасчетов)) ИЛИ СтруктураНадписи.ВалютаДокумента = СтруктураНадписи.ВалютаРасчетов, СокрЛП(Строка(СтруктураНадписи.Курс)), СокрЛП(Строка(СтруктураНадписи.КурсНациональнаяВалюта))));	
	Иначе
		ТекстНадписи = НСтр("ru = 'Валюта: <нет>'");
	КонецЕсли;
	
	// Налогообложение НДС.
	Если ПустаяСтрока(ТекстНадписи) Тогда
		ТекстНадписи = ТекстНадписи + НСтр("ru = '%НалогообложениеНДС%'");
	Иначе
		ТекстНадписи = ТекстНадписи + НСтр("ru = '; %НалогообложениеНДС%'");
	КонецЕсли;
	ТекстНадписи = СтрЗаменить(ТекстНадписи, "%НалогообложениеНДС%", ?(СтруктураНадписи.УчитыватьНДС, "Учитывать НДС", "Не учитывать НДС"));
	
	// Флаг сумма включает НДС.
	Если СтруктураНадписи.УчитыватьНДС Тогда
		Если ПустаяСтрока(ТекстНадписи) Тогда
			ТекстНадписи = ТекстНадписи + НСтр("ru = '%СуммаВключаетНДС%'");
		Иначе
			ТекстНадписи = ТекстНадписи + НСтр("ru = '; %СуммаВключаетНДС%'");
		КонецЕсли;
		ТекстНадписи = СтрЗаменить(ТекстНадписи, "%СуммаВключаетНДС%", ?(СтруктураНадписи.СуммаВключаетНДС, "Сумма вкл. НДС", "Сумма не вкл. НДС"));
	КонецЕсли;
	
	Возврат ТекстНадписи;
	
КонецФункции // СформироватьНадписьЦеныИВалюта()

&НаКлиенте
Процедура ОбновитьИнфНадпись()
	ВременнаяСтрока = "";
	
	Если (ЗначениеЗаполнено(Объект.ВалютаДокумента))
		И (Объект.ВалютаДокумента <> мВалютаРегламентированногоУчета) Тогда
		
		ВременнаяСтрока = ВременнаяСтрока + РаботаСДиалогами.ПолучитьИнформациюКурсаВалютыСтрокой(Объект.ВалютаДокумента, 
		Объект.КурсВзаиморасчетов,
		Объект.КратностьВзаиморасчетов,
		мВалютаРегламентированногоУчета) + ", ";
		
	КонецЕсли;
	
	Элементы.ИнфНадпись.Заголовок = ВременнаяСтрока;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ШАПКИ

&НаКлиенте
Процедура ДатаПриИзменении(Элемент)
	
	ДатаПередИзменением = ДатаДокумента;
	ДатаДокумента = Объект.Дата;
	Если Объект.Дата <> ДатаПередИзменением Тогда
		СтруктураДанные = ПолучитьДанныеДатаПриИзменении(Объект.Ссылка, Объект.Дата, ДатаПередИзменением);
		Если СтруктураДанные.РазностьДат <> 0 Тогда
			Объект.Номер = "";
		КонецЕсли;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОтражатьВБухгалтерскомУчетеПриИзменении(Элемент)
	Если Объект.ДоговорКонтрагента.ВидДоговора = Перечисления.ВидыДоговоровКонтрагентов.СКомитентом Тогда
		Объект.ОтражатьВНалоговомУчете = Ложь;
	Иначе
		Объект.ОтражатьВНалоговомУчете = Объект.ОтражатьВБухгалтерскомУчете;
	КонецЕсли;
	
	УстановитьВидимость();
КонецПроцедуры

&НаКлиенте
Процедура ОрганизацияПриИзменении(Элемент)
	// Обработка события изменения организации.
	Объект.Номер = "";
	
	Если НЕ уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Объект.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВестиСкладскойУчетУАТ) Тогда
		Предупреждение("В обработке ""Установка прав и настроек"" для организации """ + Объект.Организация + """
		|отключена возможность ведения складского учета документами УАТ!", 5);
	КонецЕсли;
	
	
	ПриИзмененииКонтрагентаИлиОрганизации();
	
	СтруктураНадписи = Новый Структура("ВалютаДокумента, ВалютаРасчетов, Курс, КурсНациональнаяВалюта, СуммаВключаетНДС, УчитыватьНДС", Объект.ВалютаДокумента, ВалютаРасчетов, Объект.КурсВзаиморасчетов, КурсНациональнаяВалюта, Объект.СуммаВключаетНДС, Объект.УчитыватьНДС);
	ЦеныИВалюта = СформироватьНадписьЦеныИВалюта(СтруктураНадписи);
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)
	КонтрагентПередИзменением = Контрагент;
	Контрагент = Объект.Контрагент;
	
	Если КонтрагентПередИзменением <> Объект.Контрагент Тогда
		
		ПриИзмененииКонтрагентаИлиОрганизации();
		
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ДоговорКонтрагентаПриИзменении(Элемент)
	ДоговорПередИзменением = Договор;
	Договор = Объект.ДоговорКонтрагента;
	
	Если ДоговорПередИзменением <> Объект.ДоговорКонтрагента Тогда
		
		ПриИзмененииДоговора(ДоговорПередИзменением);
		
	КонецЕсли;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТЧ ТОВАРЫ

&НаКлиенте
Процедура ТоварыНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	СтруктураДанные = Новый Структура();
	СтруктураДанные.Вставить("Номенклатура",	 СтрокаТабличнойЧасти.Номенклатура);
	
	СтруктураДанные = ПолучитьДанныеНоменклатураПриИзменении(СтруктураДанные);
	
	СтрокаТабличнойЧасти.ЕдиницаИзмерения = СтруктураДанные.ЕдиницаИзмерения;
	Если НЕ ЗначениеЗаполнено(СтрокаТабличнойЧасти.Количество) тогда
		СтрокаТабличнойЧасти.Количество = 1;
	КонецЕсли;
	
	СтрокаТабличнойЧасти.СтавкаНДС = СтрокаТабличнойЧасти.Номенклатура.СтавкаНДС;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСтавкаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	РассчитатьСуммуНДС(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	Если СтрокаТабличнойЧасти.Количество <> 0 Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Сумма / СтрокаТабличнойЧасти.Количество;
	КонецЕсли;
	
	РассчитатьСуммуНДС(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыПослеУдаления(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура ТоварыЕдиницаИзмеренияОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	СтрокаТабличнойЧасти = Элементы.Товары.ТекущиеДанные;
	
	Если НЕ уатРаботаСМетаданными.естьСпрЕдиницыИзмерения() 
		ИЛИ СтрокаТабличнойЧасти.ЕдиницаИзмерения = ВыбранноеЗначение ИЛИ СтрокаТабличнойЧасти.Цена = 0 Тогда
		Возврат;
	КонецЕсли;	
	
	Если СтрокаТабличнойЧасти.ЕдиницаИзмерения.Коэффициент <> 0 Тогда
		СтрокаТабличнойЧасти.Цена = СтрокаТабличнойЧасти.Цена * ВыбранноеЗначение.Коэффициент / СтрокаТабличнойЧасти.ЕдиницаИзмерения.Коэффициент;
	КонецЕсли; 		
	
	СтрокаТабличнойЧасти.Сумма = СтрокаТабличнойЧасти.Количество * СтрокаТабличнойЧасти.Цена;
	
	ТоварыСуммаПриИзменении(Элемент);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ТЧ УСЛУГИ

&НаКлиенте
Процедура УслугиКоличествоПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура УслугиЦенаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура УслугиСуммаПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура УслугиСтавкаНДСПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	РассчитатьСуммуНДС(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура УслугиНоменклатураПриИзменении(Элемент)
	СтрокаТабличнойЧасти = Элементы.Услуги.ТекущиеДанные;
	
	СтрокаТабличнойЧасти.Содержание = СтрокаТабличнойЧасти.Номенклатура.НаименованиеПолное;
	
	СтрокаТабличнойЧасти.СтавкаНДС = СтрокаТабличнойЧасти.Номенклатура.СтавкаНДС;
	
	РассчитатьСуммуВСтрокеТабличнойЧасти(СтрокаТабличнойЧасти);
КонецПроцедуры

&НаКлиенте
Процедура УслугиПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	РассчитатьСуммуДокумента();
КонецПроцедуры

&НаКлиенте
Процедура УслугиПослеУдаления(Элемент)
	РассчитатьСуммуДокумента();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Объект.Ссылка.Пустая() Тогда
		ТекОрганизация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	Иначе
		ТекОрганизация = Объект.Организация;
	КонецЕсли;
	Если ЗначениеЗаполнено(ТекОрганизация) И НЕ уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(ТекОрганизация, ПланыВидовХарактеристик.уатПраваИНастройки.ВестиСкладскойУчетУАТ) Тогда
		#Если Клиент тогда
			Предупреждение("В обработке ""Установка прав и настроек"" для организации """ + ТекОрганизация + """
			|отключена возможность ведения складского учета документами УАТ!");
		#КонецЕсли
		Отказ = Истина;
	КонецЕсли;
	
	уатОбщегоНазначенияСервер.ЗаполнитьШапкуДокумента(
	Объект,
	,
	Параметры.ЗначениеКопирования,
	Параметры.Основание,
	,
	,
	,
	Параметры.ЗначенияЗаполнения
	);
	
	// Установка реквизитов формы.
	ДатаДокумента = Объект.Дата;
	Если НЕ ЗначениеЗаполнено(ДатаДокумента) Тогда
		ДатаДокумента = ТекущаяДата();
	КонецЕсли;
	
	// Инициализация реквизитов формы.	
	Если НЕ ЗначениеЗаполнено(Объект.Ссылка)
		И ЗначениеЗаполнено(Объект.Контрагент) Тогда
		Если НЕ ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
			Объект.ДоговорКонтрагента = Объект.Контрагент.ДоговорПоУмолчанию;
		КонецЕсли;
		Если ЗначениеЗаполнено(Объект.ДоговорКонтрагента) Тогда
			Объект.ВалютаДокумента         = Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов;
			ВалютаРасчетовКурсКратность    = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Объект.Дата, Новый Структура("Валюта", Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов));
			Объект.КурсВзаиморасчетов      = ?(ВалютаРасчетовКурсКратность.Курс = 0, 1, ВалютаРасчетовКурсКратность.Курс);
			Объект.КратностьВзаиморасчетов = ?(ВалютаРасчетовКурсКратность.Кратность = 0, 1, ВалютаРасчетовКурсКратность.Кратность);
		КонецЕсли;
	КонецЕсли;
	
	мВалютаРегламентированногоУчета = глЗначениеПеременной("ВалютаРегламентированногоУчета");
	
	Контрагент = Объект.Контрагент;
	Договор = Объект.ДоговорКонтрагента;
	ВалютаРасчетов = Объект.ДоговорКонтрагента.ВалютаВзаиморасчетов;
	НациональнаяВалюта = мВалютаРегламентированногоУчета;
	СтруктураПоВалюте = РегистрыСведений.КурсыВалют.ПолучитьПоследнее(Объект.Дата, Новый Структура("Валюта", НациональнаяВалюта));
	КурсНациональнаяВалюта = СтруктураПоВалюте.Курс;
	КратностьНациональнаяВалюта = СтруктураПоВалюте.Кратность;
	
	ЭтоОбъединеннаяКонфигурация = Метаданные.Справочники.Найти("РегистрацияВИФНС") <> Неопределено;
	Если ЭтоОбъединеннаяКонфигурация Тогда
		КоманднаяПанель.ПодчиненныеЭлементы.ФормаПечать.ПодчиненныеЭлементы.ФормаДокументуатПоступлениеТоваровУслугТОРГ4.Видимость = Ложь;
		КоманднаяПанель.ПодчиненныеЭлементы.ФормаПечать.ПодчиненныеЭлементы.ФормаДокументуатПоступлениеТоваровУслугМ4.Видимость = Ложь;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	// Установить видимость реквизитов и заголовков колонок.
	УстановитьВидимость();
	
	Если НЕ Метаданные.Справочники.Найти("ЕдиницыИзмерения") = Неопределено Тогда
		Элементы.ТоварыЕдиницаИзмерения.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.ЕдиницыИзмерения");
	Иначе	
		Элементы.ТоварыЕдиницаИзмерения.ОграничениеТипа = Новый ОписаниеТипов("СправочникСсылка.КлассификаторЕдиницИзмерения");
	КонецЕсли;
	
	Элементы.ТоварыЕдиницаИзмерения.ВыбиратьТип = Ложь;
	
	Элементы.Сделка.ОграничениеТипа = Новый ОписаниеТипов("ДокументСсылка.уатСчетНаОплатуПоставщика");
	Элементы.Сделка.ВыбиратьТип = Ложь;
	
	РассчитатьСуммуДокумента();
	
	ОбновитьИнфНадпись();
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	Перем Команда;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		
		ВыбранноеЗначение.Свойство("Команда", Команда);
		
		Если Команда = "ПодборВТабличнуюЧастьТовары" Тогда
			ОбработкаПодбора("Товары", ВыбранноеЗначение);
		ИначеЕсли Команда = "ПодборВТабличнуюЧастьУслуги" Тогда
			ОбработкаПодбора("Услуги", ВыбранноеЗначение);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры
