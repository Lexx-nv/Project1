﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки текста запроса построителя отчета
//
Процедура УстановитьТекстЗапроса(ЕстьПолеРегистратор = Истина)

	// Описание исходного текста запроса.
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Сделка КАК Сделка,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Организация КАК Организация,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Контрагент КАК Контрагент,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Регистратор КАК Регистратор,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период КАК Период,
	|	НАЧАЛОПЕРИОДА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период, ДЕНЬ) КАК ПериодДень,
	|	НАЧАЛОПЕРИОДА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	|	НАЧАЛОПЕРИОДА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период, ДЕКАДА) КАК ПериодДекада,
	|	НАЧАЛОПЕРИОДА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
	|	НАЧАЛОПЕРИОДА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
	|	НАЧАЛОПЕРИОДА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	|	НАЧАЛОПЕРИОДА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период, ГОД) КАК ПериодГод,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовНачальныйОстаток) КАК СуммаВзаиморасчетовНачальныйОстаток,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовКонечныйОстаток) КАК СуммаВзаиморасчетовКонечныйОстаток,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовОборот) КАК СуммаВзаиморасчетовОборот,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовПриход) КАК СуммаВзаиморасчетовПриход,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовРасход) КАК СуммаВзаиморасчетовРасход,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрНачальныйОстаток) КАК СуммаУпрНачальныйОстаток,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрКонечныйОстаток) КАК СуммаУпрКонечныйОстаток,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрОборот) КАК СуммаУпрОборот,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрПриход) КАК СуммаУпрПриход,
	|	СУММА(уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрРасход) КАК СуммаУпрРасход
	|{ВЫБРАТЬ
	|	ДоговорКонтрагента.*,
	|	Сделка.*,
	|	Организация.*,
	|	Контрагент.*,
	|	Регистратор.*,
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	СуммаВзаиморасчетовНачальныйОстаток,
	|	СуммаВзаиморасчетовКонечныйОстаток,
	|	СуммаВзаиморасчетовОборот,
	|	СуммаВзаиморасчетовПриход,
	|	СуммаВзаиморасчетовРасход,
	|	СуммаУпрНачальныйОстаток,
	|	СуммаУпрКонечныйОстаток,
	|	СуммаУпрОборот,
	|	СуммаУпрПриход,
	|	СуммаУпрРасход}
	|ИЗ
	|	РегистрНакопления.уатВзаиморасчетыСКонтрагентами.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Запись {(&Периодичность)}, , {(ДоговорКонтрагента).* КАК ДоговорКонтрагента, (Сделка).* КАК Сделка, (Контрагент).* КАК Контрагент, (Организация).* КАК Организация, (ДоговорКонтрагента.ВалютаВзаиморасчетов).* КАК ВалютаВзаиморасчетов}) КАК уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты
	|{ГДЕ
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.ДоговорКонтрагента.*,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Сделка.*,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Организация.*,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Контрагент.*,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Регистратор.*,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовНачальныйОстаток,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовКонечныйОстаток,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовОборот,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовПриход,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаВзаиморасчетовРасход,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрНачальныйОстаток,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрКонечныйОстаток,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрОборот,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрПриход,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.СуммаУпрРасход}
	|
	|СГРУППИРОВАТЬ ПО
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.ДоговорКонтрагента,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Сделка,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Организация,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Контрагент,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Регистратор,
	|	уатВзаиморасчетыСКонтрагентамиОстаткиИОбороты.Период
	|{УПОРЯДОЧИТЬ ПО
	|	ДоговорКонтрагента.*,
	|	Сделка.*,
	|	Организация.*,
	|	Контрагент.*,
	|	Регистратор.*,
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	СуммаВзаиморасчетовНачальныйОстаток,
	|	СуммаВзаиморасчетовКонечныйОстаток,
	|	СуммаВзаиморасчетовОборот,
	|	СуммаВзаиморасчетовПриход,
	|	СуммаВзаиморасчетовРасход,
	|	СуммаУпрНачальныйОстаток,
	|	СуммаУпрКонечныйОстаток,
	|	СуммаУпрОборот,
	|	СуммаУпрПриход,
	|	СуммаУпрРасход}
	|ИТОГИ
	|	СУММА(СуммаВзаиморасчетовНачальныйОстаток),
	|	СУММА(СуммаВзаиморасчетовКонечныйОстаток),
	|	СУММА(СуммаВзаиморасчетовОборот),
	|	СУММА(СуммаВзаиморасчетовПриход),
	|	СУММА(СуммаВзаиморасчетовРасход),
	|	СУММА(СуммаУпрНачальныйОстаток),
	|	СУММА(СуммаУпрКонечныйОстаток),
	|	СУММА(СуммаУпрОборот),
	|	СУММА(СуммаУпрПриход),
	|	СУММА(СуммаУпрРасход)
	|ПО
	|	Регистратор,
	|	Контрагент,
	|	ДоговорКонтрагента,
	|	Организация,
	|	Период,
	|	Сделка,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод
	|{ИТОГИ ПО
	|	ДоговорКонтрагента.*,
	|	Сделка.*,
	|	Организация.*,
	|	Контрагент.*,
	|	Регистратор.*,
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодКвартал,
	|	ПериодМесяц,
	|	ПериодПолугодие,
	|	ПериодГод}";

	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;

КонецПроцедуры

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	
	УстановитьТекстЗапроса();
	
	ЭтоОбъединениеСБП = уатОбщегоНазначения.ЭтоОбъединениеСБП();
	Если НЕ ЭтоОбъединениеСБП Тогда
		ВалютаУпр = "(" + СокрЛП(глЗначениеПеременной("ВалютаУправленческогоУчета").Наименование) + ")";
	КонецЕсли;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДоговорКонтрагента", "Договор контрагента");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокументРасчетовСКонтрагентом", "Документ расчетов с контрагентом");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовНачальныйОстаток", "Сумма взаиморасчетов начальный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовКонечныйОстаток", "Сумма взаиморасчетов конечный остаток");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовПриход", "Сумма взаиморасчетов приход");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаВзаиморасчетовРасход", "Сумма взаиморасчетов расход");
	Если НЕ ЭтоОбъединениеСБП Тогда
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрНачальныйОстаток", "Сумма " + ВалютаУпр + " начальный остаток");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрКонечныйОстаток", "Сумма " + ВалютаУпр + " конечный остаток");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрПриход", "Сумма " + ВалютаУпр + " приход");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаУпрРасход", "Сумма " + ВалютаУпр + " расход");
	КонецЕсли;
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВалютаВзаиморасчетов", "Валюта взаиморасчетов");
	
	// Добавление показателей
	// Необходимо вызывать для каждого добавляемого показателя.
	// УниверсальныйОтчет.ДобавитьПоказатель(<ИмяПоказателя>, <ПредставлениеПоказателя>, <ВключенПоУмолчанию>, <Формат>, <ИмяГруппы>, <ПредставлениеГруппы>);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовПриход", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовРасход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаВзаиморасчетовКонечныйОстаток",  "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаВзаиморасчетов", "Сумма взаиморасчетов");
	Если НЕ ЭтоОбъединениеСБП Тогда
		УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрНачальныйОстаток", "нач. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
		УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрПриход", "приход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
		УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрРасход", "расход", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
		УниверсальныйОтчет.ДобавитьПоказатель("СуммаУпрКонечныйОстаток", "кон. остаток", Истина, "ЧЦ=15; ЧДЦ=2", "СуммаУпр", "Сумма " + ВалютаУпр);
	КонецЕсли;
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	Пока УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Количество() > 0 Цикл
		УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Удалить(УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки[0]);
	КонецЦикла;
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Организация");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Контрагент");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДоговорКонтрагента");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ДокументРасчетовСКонтрагентом");
	
	// Добавление предопределенных группировок колонок отчета.
	// Необходимо вызывать для каждой добавляемой группировки колонки.
	// УниверсальныйОтчет.ДобавитьИзмерениеКолонки(<ПутьКДанным>);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	УниверсальныйОтчет.ДобавитьОтбор("Контрагент");
	УниверсальныйОтчет.ДобавитьОтбор("ДоговорКонтрагента");
	
	// Добавление предопределенных полей порядка отчета.
	// Необходимо вызывать для каждого добавляемого поля порядка.
	// УниверсальныйОтчет.ДобавитьПорядок(<ПутьКДанным>);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДаннымРодитель>);
	УниверсальныйОтчет.УстановитьСвязьПолей("ВалютаВзаиморасчетов", "ДоговорКонтрагента");
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	
	// Установка представлений полей
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка типов значений свойств в отборах отчета
	УниверсальныйОтчет.УстановитьТипыЗначенийСвойствДляОтбора();
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ВалютаВзаиморасчетов");
	
КонецПроцедуры // УстановитьНачальныеНастройки()

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	// Перед формированием отчета можно установить необходимые параметры универсального отчета
	
	ЕстьПолеРегистратор = Ложь;
	Для каждого ВыбранноеПоле Из УниверсальныйОтчет.ПостроительОтчета.ВыбранныеПоля Цикл
	
		ЕстьПолеРегистратор = Найти(ВыбранноеПоле.ПутьКДанным, "Регистратор") > 0;
		Если ЕстьПолеРегистратор Тогда
			Прервать;
		КонецЕсли;
	
	КонецЦикла;
	
	НастройкиПостроителя = УниверсальныйОтчет.ПостроительОтчета.ПолучитьНастройки(); 
	УстановитьТекстЗапроса(ЕстьПолеРегистратор);
	УниверсальныйОтчет.ПостроительОтчета.УстановитьНастройки(НастройкиПостроителя); 
	
	Если ЕстьПолеРегистратор Тогда
		
		НетГруппировкиПоДоговору = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("ДоговорКонтрагента") = Неопределено;
		Если НетГруппировкиПоДоговору Тогда
		
			НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("Контрагент");
			Если НужноеИзмерение = Неопределено Тогда
				НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("Организация");
			КонецЕсли;
			Если НужноеИзмерение = Неопределено Тогда
				НужноеИзмерение = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Найти("ВалютаВзаиморасчетов");
			КонецЕсли;
			
			Если НужноеИзмерение = Неопределено Тогда
				ИндексДоговора = 0;
			Иначе
				ИндексДоговора = УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Индекс(НужноеИзмерение) + 1;
			КонецЕсли;
				
			УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Вставить("ДоговорКонтрагента", , , , , ИндексДоговора);
		
		КонецЕсли;
	
	КонецЕсли;
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент,,, ЭтотОбъект);

КонецПроцедуры // СформироватьОтчет()

Функция ПолучитьТекстСправкиФормы() Экспорт
	
	Возврат "";
	
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);

КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;

#КонецЕсли
