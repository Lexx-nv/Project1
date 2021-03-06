

//==================================================================================
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ 

// Определяет курс документа, который равен либо курсу документа (если в документе он существует),
// либо курсу взаиморасчетов, либо 1.
//
// Параметры: 
//  ДокументОбъект                 - объект документа, курс которого надо получить
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//
// Возвращаемое значение:
//  Число - курс документа.
//
Функция КурсДокумента(ДокументОбъект, ВалютаРегламентированногоУчета) Экспорт

	// Если валюта документа совпадает с валютой регл. учета, то курс 1.
	Если ДокументОбъект.ВалютаДокумента <> ВалютаРегламентированногоУчета Тогда
	
		МетаданныеДокумента = ДокументОбъект.Метаданные();

		// Если есть реквизит КурсДокумента - его и вернем
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КурсДокумента", МетаданныеДокумента) Тогда
			Возврат ДокументОбъект.КурсДокумента;
		КонецЕсли;

		// Если нет КурсДокумента и валюта документа не совпадает с валютой регл. учета, 
		// то такой документ может быть выписан только в валюте взаиморасчетов,
		// если есть реквизит КурсВзаиморасчетов - его и вернем.
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КурсВзаиморасчетов", МетаданныеДокумента) Тогда
			Возврат ДокументОбъект.КурсВзаиморасчетов;
		КонецЕсли;

	КонецЕсли;

	Возврат 1;

КонецФункции // КурсДокумента()

// Определяет кратность документа, которая равен либо кратности документа (если в документе она существует),
// либо кратности взаиморасчетов, либо 1.
//
// Параметры: 
//  ДокументОбъект - объект документа, курс которого надо получить
//  ВалютаРегламентированногоУчета - валюта регламентированного учета
//
// Возвращаемое значение:
//  Число - кратность валюты в документе.
//
Функция КратностьДокумента(ДокументОбъект, ВалютаРегламентированногоУчета) Экспорт

	// Если валюта документа совпадает с валютой регл. учета, то кратность 1.
	Если ДокументОбъект.ВалютаДокумента <> ВалютаРегламентированногоУчета Тогда
	
		МетаданныеДокумента = ДокументОбъект.Метаданные();

		// Если есть реквизит КратностьДокумента - его и вернем
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КратностьДокумента", МетаданныеДокумента) Тогда
			Возврат ДокументОбъект.КратностьДокумента;
		КонецЕсли;

		// Если нет КратностьДокумента и валюта документа не совпадает с валютой регл. учета, 
		// то такой документ может быть выписан только в валюте взаиморасчетов,
		// если есть реквизит КратностьВзаиморасчетов - его и вернем.
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КратностьВзаиморасчетов", МетаданныеДокумента) Тогда
			Возврат ДокументОбъект.КратностьВзаиморасчетов;
		КонецЕсли;

	КонецЕсли;

	Возврат 1;

КонецФункции // КратностьДокумента()

//==================================================================================
// ПРИ ИЗМЕНЕНИИ

// Процедура выполняет общие действия при изменении контрагента
//
// Параметры:
//  ДокументОбъект - объект редактируемого документа,
//
Процедура ПриИзмененииЗначенияКонтрагента(ДокументОбъект) Экспорт

	МетаданныеДокумента = ДокументОбъект.Метаданные();
	
	Если ДокументОбъект.Контрагент = Неопределено Тогда
		ДокументОбъект.Контрагент = Справочники.Контрагенты.ПустаяСсылка();
	КонецЕсли; 
	
	Если ТипЗнч(ДокументОбъект.Контрагент) <> Тип("СправочникСсылка.Контрагенты") Тогда
		Если НЕ ЗначениеЗаполнено(ДокументОбъект.Контрагент) Тогда
			Если ТипЗнч(ДокументОбъект.Контрагент) = Тип("Строка") Тогда
				КонтактноеЛицо = "";
			Иначе
				КонтактноеЛицо = Справочники.КонтактныеЛица.ПустаяСсылка();
			КонецЕсли; 
		КонецЕсли;
		ДоговорКонтрагента = Справочники.ДоговорыКонтрагентов.ПустаяСсылка();
	Иначе
		ДоговорКонтрагента = ДокументОбъект.Контрагент.ОсновнойДоговорКонтрагента;
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("КонтактноеЛицо", МетаданныеДокумента) Тогда
			Если НЕ ЗначениеЗаполнено(ДокументОбъект.КонтактноеЛицо)
			 ИЛИ ТипЗнч(ДокументОбъект.КонтактноеЛицо) <> Тип("СправочникСсылка.КонтактныеЛица") Тогда
				КонтактноеЛицо = ДокументОбъект.Контрагент.ОсновноеКонтактноеЛицо;
			Иначе
				Если ДокументОбъект.КонтактноеЛицо.Владелец <> ДокументОбъект.Контрагент Тогда
					КонтактноеЛицо = ДокументОбъект.Контрагент.ОсновноеКонтактноеЛицо;
				КонецЕсли; 
			КонецЕсли; 
		КонецЕсли; 
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитДокумента("ДоговорКонтрагента", МетаданныеДокумента) Тогда
		Если ОбщегоНазначения.ЕстьРеквизитДокумента("Организация", МетаданныеДокумента) Тогда
			Если НЕ ЗначениеЗаполнено(ДокументОбъект.Организация) Тогда
				ДокументОбъект.ДоговорКонтрагента = ДоговорКонтрагента;
				ДокументОбъект.Организация           = ДоговорКонтрагента.Организация;
			ИначеЕсли ДокументОбъект.Организация = ДоговорКонтрагента.Организация Тогда
				ДокументОбъект.ДоговорКонтрагента = ДоговорКонтрагента;
			Иначе
				ДокументОбъект.ДоговорКонтрагента = Неопределено; // Очистить старый договор
			КонецЕсли;
		Иначе
			ДокументОбъект.ДоговорКонтрагента = ДоговорКонтрагента;
		КонецЕсли;
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитДокумента("КонтактноеЛицо", МетаданныеДокумента) И КонтактноеЛицо <> Неопределено Тогда
		ДокументОбъект.КонтактноеЛицо = КонтактноеЛицо;
	КонецЕсли; 

	Если ОбщегоНазначения.ЕстьРеквизитДокумента("Сделка", МетаданныеДокумента) Тогда
		ДокументОбъект.Сделка = Неопределено; // Для сделки нет значения по умолчанию в договоре
	КонецЕсли;

	Если ОбщегоНазначения.ЕстьРеквизитДокумента("ТипЦен", МетаданныеДокумента)
	   И ЗначениеЗаполнено(ДокументОбъект.ТипЦен)
	   И ДокументОбъект.ТипЦен.Метаданные().Имя = "ТипыЦенНоменклатурыКонтрагентов"
	   И Не ДокументОбъект.ТипЦен.Владелец = ДокументОбъект.Контрагент Тогда
		// очистим тип цен
		ДокументОбъект.ТипЦен =  Неопределено;
	КонецЕсли;

	//Если ОбщегоНазначения.ЕстьРеквизитДокумента("БанковскийСчетКонтрагента", МетаданныеДокумента) Тогда
	//	ДокументОбъект.БанковскийСчетКонтрагента = ДокументОбъект.Контрагент.ОсновнойБанковскийСчет;
	//КонецЕсли;

КонецПроцедуры // ПриИзмененииЗначенияКонтрагента()
