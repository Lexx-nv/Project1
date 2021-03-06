////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения.

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
	
	// Функция помещает в структуру все данные, отображаемые при печати документа.
	// Вызывается из функции ПечатьДокумента и из веб-приложения
	//
	// Возвращаемое значение:
	//  Структура
	//
	Функция ПолучитьДанныеДляПечатиДокумента() Экспорт
		
		ПараметрыПечати = Новый Структура;
		
		Запрос = Новый Запрос;
		Запрос.УстановитьПараметр("ТекущийДокумент", Ссылка);
		
		Запрос.Текст =
		"ВЫБРАТЬ
		|	уатИнвентаризацияАгрегатов.Номер КАК Номер,
		|	уатИнвентаризацияАгрегатов.Дата КАК Дата,
		|	уатИнвентаризацияАгрегатов.Организация КАК Организация,
		|	уатИнвентаризацияАгрегатов.Склад КАК Склад,
		|	уатИнвентаризацияАгрегатов.АгрегатыСклад.(
		|		Ссылка,
		|		НомерСтроки,
		|		Агрегат,
		|		Наличие,
		|		НаличиеУчет
		|	),
		|	уатИнвентаризацияАгрегатов.АгрегатыТС.(
		|		Ссылка,
		|		НомерСтроки,
		|		Агрегат,
		|		Наличие,
		|		НаличиеУчет,
		|		ТС
		|	)
		|ИЗ
		|	Документ.уатИнвентаризацияАгрегатов КАК уатИнвентаризацияАгрегатов
		|ГДЕ
		|	уатИнвентаризацияАгрегатов.Ссылка = &ТекущийДокумент";
		
		Шапка = Запрос.Выполнить().Выбрать();
		Шапка.Следующий();
		ВыборкаСтрокСклад = Шапка.АгрегатыСклад.Выбрать();
		ВыборкаСтрокТС = Шапка.АгрегатыТС.Выбрать();
		
		// Выводим шапку накладной
		ПараметрыПечати.Вставить("ТекстЗаголовка", уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(Шапка, "Инвентаризация агрегатов"));
		
		// Выводим данные об организации и складе
		ПараметрыПечати.Вставить("ПредставлениеОрганизации", ФормированиеПечатныхФорм.ОписаниеОрганизации(УправлениеКонтактнойИнформацией.СведенияОЮрФизЛице(Шапка.Организация, Шапка.Дата), "ПолноеНаименование,"));
		ПараметрыПечати.Вставить("ПредставлениеСклада", Шапка.Склад);
		
		Позиции = Новый Массив;
		
		НомерСтроки = 1;		
		Пока ВыборкаСтрокСклад.Следующий() Цикл
			
			ПараметрыПозиции = Новый Структура;
			ПараметрыПозиции.Вставить("Агрегат"    , ВыборкаСтрокСклад.Агрегат);		
			ПараметрыПозиции.Вставить("НомерСтроки", НомерСтроки);		
			ПараметрыПозиции.Вставить("Наличие"    , ВыборкаСтрокСклад.Наличие);
			ПараметрыПозиции.Вставить("НаличиеУчет", ВыборкаСтрокСклад.НаличиеУчет);
			
			НомерСтроки = НомерСтроки + 1;	
			Позиции.Добавить(ПараметрыПозиции);
			
		КонецЦикла;
		
		НомерСтроки = 1;		
		Пока ВыборкаСтрокТС.Следующий() Цикл
			
			ПараметрыПозиции = Новый Структура;
			ПараметрыПозиции.Вставить("Агрегат"    , ВыборкаСтрокТС.Агрегат);		
			ПараметрыПозиции.Вставить("ТС"		   , уатОбщегоНазначения.уатПредставлениеТС(ВыборкаСтрокТС.ТС,Неопределено));		
			ПараметрыПозиции.Вставить("НомерСтроки", НомерСтроки);		
			ПараметрыПозиции.Вставить("Наличие"    , ВыборкаСтрокТС.Наличие);
			ПараметрыПозиции.Вставить("НаличиеУчет", ВыборкаСтрокТС.НаличиеУчет);
			
			НомерСтроки = НомерСтроки + 1;	
			Позиции.Добавить(ПараметрыПозиции);
			
		КонецЦикла;
		
		ПараметрыПечати.Вставить("Позиции", Позиции);
		
		Возврат ПараметрыПечати;
		
	КонецФункции //ПолучитьДанныеДляПечатиДокумента()	
	
	// Функция формирует табличный документ с печатной формой накладной,
	// разработанной методистами
	//
	// Возвращаемое значение:
	//  Табличный документ - печатная форма накладной
	//
	Функция ПечатьДокумента()
		
		ПараметрыПечати = ПолучитьДанныеДляПечатиДокумента();
		
		Если ЭтотОбъект.ВидОперации = Перечисления.уатВидыДокументаИнвентаризацияАгрегатов.ИнвентаризацияНаСкладах Тогда
			ОбластьШапки  = "ШапкаТаблицыСклад";
			ОбластьСтроки = "СтрокаСклад";
		Иначе
			ОбластьШапки  = "ШапкаТаблицыТС";
			ОбластьСтроки = "СтрокаТС";
		КонецЕсли;			
			
		ТабДокумент = Новый ТабличныйДокумент;
		ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ИнвентаризацияТоваровНаСкладе_ИнвентаризацияТоваровНаСкладе";
		
		Макет = ПолучитьМакет("ИнвентаризацияАгрегатов");
		
		// Выводим шапку накладной
		ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Вывести(ОбластьМакета);
		
		// Выводим данные об организации и складе
		ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Вывести(ОбластьМакета);
		
		// Выводим шапку таблицы
		ОбластьМакета = Макет.ПолучитьОбласть(ОбластьШапки);		
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Вывести(ОбластьМакета);
		
		ОбластьМакета    = Макет.ПолучитьОбласть(ОбластьСтроки);
		Для каждого ПараметрыПозиции Из ПараметрыПечати.Позиции Цикл	
			
			ОбластьМакета.Параметры.Заполнить(ПараметрыПозиции);
			ТабДокумент.Вывести(ОбластьМакета);
			
		КонецЦикла;
	
		// Выводим подписи к документу
		ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
		ОбластьМакета.Параметры.Заполнить(ПараметрыПечати);
		ТабДокумент.Вывести(ОбластьМакета);
		
		Возврат ТабДокумент;
		
	КонецФункции // ПечатьДокумента()
	
	// Процедура осуществляет печать документа. Можно направить печать на 
	// экран или принтер, а также распечатать необходимое количество копий.
	//
	//  Название макета печати передается в качестве параметра,
	// по переданному названию находим имя макета в соответствии.
	//
	// Параметры:
	//  НазваниеМакета - строка, название макета.
	//
	Процедура Печать(НазваниеМакета = "", КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
		
		Если ЭтоНовый() Тогда
			Предупреждение("Документ можно распечатать только после его записи");
			Возврат;
		КонецЕсли;
		
		Если Не РаботаСДиалогами.ПроверитьМодифицированность(ЭтотОбъект) Тогда
			Возврат;
		КонецЕсли;
		
		Если ТипЗнч(НазваниеМакета) = Тип("СправочникСсылка.ВнешниеОбработки") Тогда
			
			ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
			ОбъектВнешнейФормы = НазваниеМакета.ПолучитьОбъект();
			Если ОбъектВнешнейФормы = Неопределено Тогда
				Сообщить("Ошибка получения внешней формы документа. Возможно форма была удалена", СтатусСообщения.Важное);
				Возврат;
			КонецЕсли;			
			ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
			ДвоичныеДанные.Записать(ИмяФайла);
			Обработка = ВнешниеОбработки.Создать(ИмяФайла);
			Попытка
				Обработка.СсылкаНаОбъект = Ссылка;
				ТабДокумент = Обработка.Печать();
				уатОбщегоНазначенияТиповые.уатНапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Права);
			Исключение
				Сообщить("Ошибка формата внешней обработки. Возможно выбрана обработка не для печати.", СтатусСообщения.Важное);
			КонецПопытки;
			
		Иначе
			Если НазваниеМакета = "ИнвентаризацияАгрегатов" Тогда
				ТабДокумент = ПечатьДокумента();
				уатОбщегоНазначенияТиповые.уатНапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()));
			КонецЕсли;
		КонецЕсли;
		
	КонецПроцедуры // Печать
	
	// Возвращает доступные варианты печати документа
	//
	// Возвращаемое значение:
	//  Структура, каждая строка которой соответствует одному из вариантов печати
	//  
	//Функция ПолучитьСписокПечатныхФорм() Экспорт
	Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
		
		СтруктураМакетов = Новый Структура;
		
		СтруктураМакетов.Вставить("ИнвентаризацияАгрегатов", "Инвентаризация агрегатов");
		
		Возврат СтруктураМакетов ;
		
	КонецФункции // ПолучитьСтруктуруПечатныхФорм()
	
	
#КонецЕсли

// Выполняет необходимые действия при изменении реквизита Организация
//
Процедура ПриИзмененииОрганизации(ПодменюДействияФормы = Неопределено, ЭлементыФормыНомер = Неопределено) Экспорт
	
	Если Не ПустаяСтрока(Номер) Тогда
		уатОбщегоНазначенияТиповые.уатСброситьУстановленныйКодНомерОбъекта(ЭтотОбъект, "Номер", ПодменюДействияФормы, ЭлементыФормыНомер);
	КонецЕсли;
	
КонецПроцедуры // ПриИзмененииОрганизации()

// Заполняет документ по остаткам на складе
// 
Процедура ЗаполнитьПоОстаткамНаСкладе(ТолькоУчетные = Ложь) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	уатОстаткиАгрегатовОстатки.СерияНоменклатуры КАК Агрегат
	|ИЗ
	|	РегистрНакопления.уатОстаткиАгрегатов.Остатки(&МоментДокумента, Склад = &Склад) КАК уатОстаткиАгрегатовОстатки";
	
	Запрос.УстановитьПараметр("Склад", Склад);
	Если ЭтоНовый() Тогда
		Запрос.УстановитьПараметр("МоментДокумента", КонецДня(Дата));
	Иначе
		Запрос.УстановитьПараметр("МоментДокумента", МоментВремени());
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТабличнойЧасти = АгрегатыСклад.Добавить();
		
		СтрокаТабличнойЧасти.Агрегат       = Выборка.Агрегат;
		СтрокаТабличнойЧасти.НаличиеУчет   = Истина;
		СтрокаТабличнойЧасти.Наличие       = ?(ТолькоУчетные, Ложь, Истина);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПоОстаткамНаСкладе()

// Заполняет документ по остаткам на ТС
// 
Процедура ЗаполнитьПоОстаткамНаТС(СтруктураВозврата) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	уатАгрегатыТССрезПоследних.СерияНоменклатуры КАК Агрегат,
	|	уатАгрегатыТССрезПоследних.ТС
	|ИЗ
	|	РегистрСведений.уатАгрегатыТС.СрезПоследних(
	|			&МоментДокумента,
	|			СостояниеАгрегата = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВРаботе)
	|				ИЛИ СостояниеАгрегата = ЗНАЧЕНИЕ(Перечисление.уатСостоянияАгрегатов.УстановленоВЗапас)
	|					И ТС В (&ТС)) КАК уатАгрегатыТССрезПоследних";
	
	Запрос.УстановитьПараметр("ТС", СтруктураВозврата.ТаблицаТС.ВыгрузитьКолонку("Ссылка"));
	Если ЭтоНовый() Тогда
		Запрос.УстановитьПараметр("МоментДокумента", КонецДня(Дата));
	Иначе
		Запрос.УстановитьПараметр("МоментДокумента", МоментВремени());
	КонецЕсли;
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		
		СтрокаТабличнойЧасти = АгрегатыТС.Добавить();
		
		СтрокаТабличнойЧасти.Агрегат       = Выборка.Агрегат;
		СтрокаТабличнойЧасти.ТС			   = Выборка.ТС;
		СтрокаТабличнойЧасти.НаличиеУчет   = Истина;
		СтрокаТабличнойЧасти.Наличие       = ?(СтруктураВозврата.ТолькоУчетные, Ложь, Истина);
		
	КонецЦикла;
	
КонецПроцедуры // ЗаполнитьПоОстаткамНаСкладе()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВДокументах(ЭтотОбъект, Отказ, , Права);
	
КонецПроцедуры // ПередЗаписью()

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли
