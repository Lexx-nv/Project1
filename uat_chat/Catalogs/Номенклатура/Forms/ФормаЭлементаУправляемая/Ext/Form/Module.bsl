﻿////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ

&НаКлиенте
Процедура УстановитьОтбор()
	флЭлементНайден = Ложь;
	Для Каждого ТекЭл Из ЕдиницыИзмерения.Отбор.Элементы Цикл
		Если ТекЭл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец") Тогда
			флЭлементНайден = Истина;
			Прервать;
		КонецЕсли;
	КонецЦикла;
	Если НЕ флЭлементНайден Тогда
		ТекЭл = ЕдиницыИзмерения.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
		ТекЭл.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Владелец");
	КонецЕсли;
	ТекЭл.ВидСравнения = ВидСравненияКомпоновкиДанных.Равно;
	ТекЭл.ПравоеЗначение = Объект.Ссылка;
	ТекЭл.Использование = Истина;
	
	Элементы.СписокЕдиницыИзмерения.Обновить();
КонецПроцедуры

&НаКлиенте
// Процедура заполняет на форме реквизит ВидНоменклатуры по признакам Услуги 
//
// Параметры:
//  Нет.
//
Процедура ЗаполнитьВидНоменклатурыПоПризнакам()

	Если Объект.Услуга Тогда
		ВидНоменклатуры = "Услуга";
	Иначе
		ВидНоменклатуры = "Товар";
	КонецЕсли;

КонецПроцедуры // ЗаполнитьВидНоменклатурыПоПризнакам()

&НаКлиенте
// Процедура заполняет по реквизиту формы ВидНоменклатуры признаки Услуга 
//
// Параметры:
//  Нет.
//
Процедура ЗаполнитьПризнакиПоВидуНоменклатуры()

	Объект.Услуга = Ложь;
	Если ВидНоменклатуры = "Услуга" Тогда
		Объект.Услуга = Истина;
	КонецЕсли;

	Если Объект.Услуга Тогда
		Объект.НомерГТД = Неопределено;
		Объект.СтранаПроисхождения = Неопределено;
	КонецЕсли;

КонецПроцедуры // ЗаполнитьПризнакиПоВидуНоменклатуры()

// Процедура устанавливает автоотметку незаполненного.
//
// Параметры:
//  Нет.
//
Процедура УстановитьАвтоотметку()

	Если НЕ Объект.Услуга Тогда

		Элементы.БазоваяЕдиницаИзмерения.АвтоОтметкаНезаполненного = Истина;
		Элементы.ЕдиницаХраненияОстатков.АвтоОтметкаНезаполненного = Истина;

	Иначе

		Элементы.БазоваяЕдиницаИзмерения.АвтоОтметкаНезаполненного = Ложь;
		Элементы.БазоваяЕдиницаИзмерения.ОтметкаНезаполненного     = Ложь;
		Элементы.ЕдиницаХраненияОстатков.АвтоОтметкаНезаполненного = Ложь;
		Элементы.ЕдиницаХраненияОстатков.ОтметкаНезаполненного     = Ложь;

	КонецЕсли;

КонецПроцедуры // УстановитьАвтоотметку()

&НаКлиенте
// Процедура устанавливает доступность реквизитов формы.
//
Процедура УстановитьДоступность()

	Элементы.НомерГТД.Доступность			 = НЕ Объект.Услуга;
	Элементы.СтранаПроисхождения.Доступность = НЕ Объект.Услуга;

КонецПроцедуры // УстановитьДоступность()

// Процедура проверяет, необходимо ли формировать полное наименование автоматически или нет,
// и, если необходимо, формирует его.
//
// Параметры:
//  Нет.
//
Процедура СформироватьНаименованиеПолноеАвтоматически()

	Если ФормироватьНаименованиеПолноеАвтоматически Тогда
		Объект.НаименованиеПолное = Объект.Наименование;
	КонецЕсли;

КонецПроцедуры // СформироватьНаименованиеПолноеАвтоматически()

// Процедура проверяет, совпадало ли ранее полное наименование с наименованием,
// и присваивает соответствующее значение переменной мФормироватьНаименованиеПолноеАвтоматически.
//
// Параметры:
//  Нет.
//
Процедура УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

	Если ПустаяСтрока(Объект.НаименованиеПолное) 
	 ИЛИ Объект.НаименованиеПолное = Объект.Наименование Тогда
		ФормироватьНаименованиеПолноеАвтоматически = Истина;
	Иначе
		ФормироватьНаименованиеПолноеАвтоматически = Ложь;
	КонецЕсли;

КонецПроцедуры // УстановитьФлагФормироватьНаименованиеПолноеАвтоматически()

// Процедура записывает единицу хранения остатков номенклатуры.
//
&НаСервере
Процедура ПроверитьЕдиницуХраненияОстатков(ТекущийОбъект, Отказ)

	Если ЗначениеЗаполнено(ТекущийОбъект.ЕдиницаХраненияОстатков) Тогда
		Возврат;
	КонецЕсли;

	ВыборкаЕдиниц = Справочники.ЕдиницыИзмерения.Выбрать(, ТекущийОбъект.Ссылка);
	Если ВыборкаЕдиниц.Следующий() Тогда
		НайденнаяЕдиница = ВыборкаЕдиниц.Ссылка;
	Иначе
		НайденнаяЕдиницаОбъект = Справочники.ЕдиницыИзмерения.СоздатьЭлемент();
		НайденнаяЕдиницаОбъект.Наименование            = ТекущийОбъект.БазоваяЕдиницаИзмерения.Наименование;
		НайденнаяЕдиницаОбъект.ЕдиницаПоКлассификатору = ТекущийОбъект.БазоваяЕдиницаИзмерения;
		НайденнаяЕдиницаОбъект.Коэффициент             = 1;
		НайденнаяЕдиницаОбъект.Владелец                = ТекущийОбъект.Ссылка;

		Попытка
			НайденнаяЕдиницаОбъект.Записать();
		Исключение
			ТекстОшибки = НСтр("ru = 'Не удалось записать единицу хранения остатков: '");
			ОбщегоНазначения.СообщитьОбОшибке(ТекстОшибки + ОписаниеОшибки(), Отказ,,, ТекущийОбъект.Ссылка);
			Возврат;
		КонецПопытки;

		НайденнаяЕдиница = НайденнаяЕдиницаОбъект.Ссылка;
	КонецЕсли;

	ТекущийОбъект.ЕдиницаХраненияОстатков = НайденнаяЕдиница;
	Попытка
	
		ТекущийОбъект.Записать();	
	
	Исключение
		Отказ = Истина;
	КонецПопытки; 

КонецПроцедуры // ПроверитьЕдиницуХраненияОстатков()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ РЕКВИЗИТОВ ФОРМЫ

&НаКлиенте
Процедура ВидНоменклатурыПриИзменении(Элемент)
	Если НЕ ЗначениеЗаполнено(ВидНоменклатуры) Тогда
		ВидНоменклатуры = "Товар";
	КонецЕсли;
	
	ЗаполнитьПризнакиПоВидуНоменклатуры();
	
	УстановитьДоступность();
	УстановитьАвтоотметку();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПриИзменении(Элемент)
	СформироватьНаименованиеПолноеАвтоматически();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеПриИзменении(Элемент)
	УстановитьФлагФормироватьНаименованиеПолноеАвтоматически();
КонецПроцедуры

&НаКлиенте
Процедура НаименованиеПолноеНачалоВыбораИзСписка(Элемент, СтандартнаяОбработка)
	СтандартнаяОбработка = Ложь;

	// Формирование списка выбора.

	Список = Новый СписокЗначений();

	Список.Добавить(Объект.Наименование);

	// Выбор из списка и обработка выбора.

	РезультатВыбора = ВыбратьИзСписка(Список, Элементы.НаименованиеПолное);

	Если РезультатВыбора <> Неопределено Тогда

		Объект.НаименованиеПолное				   = РезультатВыбора.Значение;
		ФормироватьНаименованиеПолноеАвтоматически = Истина;

	КонецЕсли;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СОБЫТИЙ ФОРМЫ

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	Список = Элементы.ВидНоменклатуры.СписокВыбора;
	Список.Очистить();
	Список.Добавить("Товар");
	Список.Добавить("Услуга");
	
	ЗаполнитьВидНоменклатурыПоПризнакам();
	
	УстановитьДоступность();
	УстановитьАвтоотметку();
	
	УстановитьОтбор();
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если ПустаяСтрока(Объект.НаименованиеПолное)
	 ИЛИ Объект.НаименованиеПолное = Объект.Наименование Тогда
		ФормироватьНаименованиеПолноеАвтоматически = Истина;
	Иначе
		ФормироватьНаименованиеПолноеАвтоматически = Ложь;
	КонецЕсли;
	
	Если Объект.Ссылка.Пустая() Тогда
		Если НЕ ЗначениеЗаполнено(Объект.БазоваяЕдиницаИзмерения) Тогда
			Объект.БазоваяЕдиницаИзмерения = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяЕдиницаПоКлассификатору");
		КонецЕсли;
		Если НЕ ЗначениеЗаполнено(Объект.СтавкаНДС) Тогда
			Объект.СтавкаНДС               = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяСтавкаНДС");
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаСервере
Процедура ПриЗаписиНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)
	
	Если ТекущийОбъект.Услуга Тогда
		Если ЗначениеЗаполнено(ТекущийОбъект.БазоваяЕдиницаИзмерения) Тогда
			ПроверитьЕдиницуХраненияОстатков(ТекущийОбъект, Отказ);
		КонецЕсли;
	Иначе
		ПроверитьЕдиницуХраненияОстатков(ТекущийОбъект, Отказ);
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)
	УстановитьОтбор();
КонецПроцедуры
