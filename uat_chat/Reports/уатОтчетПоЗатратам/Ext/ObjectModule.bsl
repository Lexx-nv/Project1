﻿#Если Клиент Тогда
Перем мУчетПоОбъектамСтроительства;
	
//=================================================================================
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА


// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		//уатОбщегоНазначения.уатВосстановитьРеквизитыОтчета(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	уатЗатратыТСОбороты.Период КАК Период,
	|	НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, ДЕНЬ) КАК ПериодДень,
	|	НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	|	НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, ДЕКАДА) КАК ПериодДекада,
	|	НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
	|	НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
	|	НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	|	НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, ГОД) КАК ПериодГод,
	|	уатЗатратыТСОбороты.Регистратор КАК Регистратор,
	|	уатЗатратыТСОбороты.Организация КАК Организация,
	|	уатЗатратыТСОбороты.Контрагент КАК Контрагент,
	|	уатЗатратыТСОбороты.Подразделение КАК Подразделение,
	|	//ОБЪЕКТСТРОИТЕЛЬСТВА1
	|	уатЗатратыТСОбороты.ТС КАК ТС,
	|	ВЫБОР
	|		КОГДА уатЗатратыТСОбороты.ТС.ВидМоделиТС = ЗНАЧЕНИЕ(Перечисление.уатВидыМоделейТС.Автотранспорт)
	|			ТОГДА уатЗатратыТСОбороты.ТС.ГосударственныйНомер
	|		ИНАЧЕ уатЗатратыТСОбороты.ТС.Наименование
	|	КОНЕЦ КАК ТСГосНомер,
	|	ВЫБОР
	|		КОГДА уатЗатратыТСОбороты.ТС.ВидМоделиТС = ЗНАЧЕНИЕ(Перечисление.уатВидыМоделейТС.Автотранспорт)
	|			ТОГДА уатЗатратыТСОбороты.ТС.ГаражныйНомер
	|		ИНАЧЕ уатЗатратыТСОбороты.ТС.Наименование
	|	КОНЕЦ КАК ТСГарНомер,
	|	уатЗатратыТСОбороты.ТС.Колонна КАК Колонна,
	|	уатЗатратыТСОбороты.Заказ КАК Заказ,
	|	уатЗатратыТСОбороты.ДокументВыпуска КАК ДокументВыпуска,
	|	уатЗатратыТСОбороты.СтатьяЗатрат КАК СтатьяЗатрат,
	|	уатЗатратыТСОбороты.СчетЗатрат КАК СчетЗатрат,
	|	уатЗатратыТСОбороты.Затрата КАК Затрата,
	|	уатЗатратыТСОбороты.КоличествоОборот КАК КоличествоОборот,
	|	уатЗатратыТСОбороты.СуммаОборот КАК СуммаОборот,
	|	ВЫБОР
	|		КОГДА уатЗатратыТСОбороты.ТС ССЫЛКА Справочник.уатТС
	|			ТОГДА ЗНАЧЕНИЕ(Перечисление.уатПолеОтчетаТСОборудование.ТС)
	|		ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.уатПолеОтчетаТСОборудование.Оборудование)
	|	КОНЕЦ КАК ТСОборудование
	|{ВЫБРАТЬ
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Регистратор.*,
	|	Организация.*,
	|	Контрагент.*,
	|	Подразделение.*,
	|	//ОБЪЕКТСТРОИТЕЛЬСТВА2
	|	ТС.*,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Колонна.*,
	|	Заказ.*,
	|	ДокументВыпуска.*,
	|	СтатьяЗатрат.*,
	|	СчетЗатрат.*,
	|	Затрата.*,
	|	КоличествоОборот,
	|	СуммаОборот,
	|	ТСОборудование}
	|ИЗ
	|	РегистрНакопления.уатЗатратыТС.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК уатЗатратыТСОбороты
	|{ГДЕ
	|	уатЗатратыТСОбороты.Период,
	|	(НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, ДЕНЬ)) КАК ПериодДень,
	|	(НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	|	(НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, ДЕКАДА)) КАК ПериодДекада,
	|	(НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, МЕСЯЦ)) КАК ПериодМесяц,
	|	(НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, КВАРТАЛ)) КАК ПериодКвартал,
	|	(НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, ПОЛУГОДИЕ)) КАК ПериодПолугодие,
	|	(НАЧАЛОПЕРИОДА(уатЗатратыТСОбороты.Период, ГОД)) КАК ПериодГод,
	|	уатЗатратыТСОбороты.Регистратор.*,
	|	уатЗатратыТСОбороты.Организация.*,
	|	уатЗатратыТСОбороты.Контрагент.*,
	|	уатЗатратыТСОбороты.Подразделение.*,
	|	//ОБЪЕКТСТРОИТЕЛЬСТВА3
	|	уатЗатратыТСОбороты.ТС.*,
	|	(ВЫБОР
	|			КОГДА уатЗатратыТСОбороты.ТС.ВидМоделиТС = ЗНАЧЕНИЕ(Перечисление.уатВидыМоделейТС.Автотранспорт)
	|				ТОГДА уатЗатратыТСОбороты.ТС.ГосударственныйНомер
	|			ИНАЧЕ уатЗатратыТСОбороты.ТС.Наименование
	|		КОНЕЦ) КАК ТСГосНомер,
	|	(ВЫБОР
	|			КОГДА уатЗатратыТСОбороты.ТС.ВидМоделиТС = ЗНАЧЕНИЕ(Перечисление.уатВидыМоделейТС.Автотранспорт)
	|				ТОГДА уатЗатратыТСОбороты.ТС.ГаражныйНомер
	|			ИНАЧЕ уатЗатратыТСОбороты.ТС.Наименование
	|		КОНЕЦ) КАК ТСГарНомер,
	|	уатЗатратыТСОбороты.ТС.Колонна.*,
	|	уатЗатратыТСОбороты.Заказ.*,
	|	уатЗатратыТСОбороты.ДокументВыпуска.*,
	|	уатЗатратыТСОбороты.СтатьяЗатрат.*,
	|	уатЗатратыТСОбороты.СчетЗатрат.*,
	|	уатЗатратыТСОбороты.Затрата.*,
	|	уатЗатратыТСОбороты.КоличествоОборот,
	|	уатЗатратыТСОбороты.СуммаОборот,
	|	(ВЫБОР
	|			КОГДА уатЗатратыТСОбороты.ТС ССЫЛКА Справочник.уатТС
	|				ТОГДА ЗНАЧЕНИЕ(Перечисление.уатПолеОтчетаТСОборудование.ТС)
	|			ИНАЧЕ ЗНАЧЕНИЕ(Перечисление.уатПолеОтчетаТСОборудование.Оборудование)
	|		КОНЕЦ) КАК ТСОборудование,
	|	(ВЫБОР
	|			КОГДА уатЗатратыТСОбороты.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			КОГДА уатЗатратыТСОбороты.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЛОЖЬ
	|		КОНЕЦ) КАК ТСВыбыло}
	|{УПОРЯДОЧИТЬ ПО
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Регистратор.*,
	|	Организация.*,
	|	Контрагент.*,
	|	Подразделение.*,
	|	//ОБЪЕКТСТРОИТЕЛЬСТВА4
	|	ТС.*,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Колонна.*,
	|	Заказ.*,
	|	ДокументВыпуска.*,
	|	СтатьяЗатрат.*,
	|	СчетЗатрат.*,
	|	Затрата.*,
	|	КоличествоОборот,
	|	СуммаОборот,
	|	ТСОборудование}
	|ИТОГИ
	|	СУММА(КоличествоОборот),
	|	СУММА(СуммаОборот)
	|ПО
	|	Контрагент,
	|	Заказ,
	|	Регистратор,
	|	ДокументВыпуска,
	|	СтатьяЗатрат,
	|	Затрата,
	|	СчетЗатрат,
	|	Период,
	|	Организация,
	|	ТС,
	|	//ОБЪЕКТСТРОИТЕЛЬСТВА5
	|	Подразделение
	|{ИТОГИ ПО
	|	Период,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Регистратор.*,
	|	Организация.*,
	|	Контрагент.*,
	|	Подразделение.*,
	|	//ОБЪЕКТСТРОИТЕЛЬСТВА6
	|	ТС.*,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Колонна.*,
	|	Заказ.*,
	|	ДокументВыпуска.*,
	|	СтатьяЗатрат.*,
	|	СчетЗатрат.*,
	|	Затрата.*,
	|	ТСОборудование}";
	
	Если мУчетПоОбъектамСтроительства Тогда
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ОБЪЕКТСТРОИТЕЛЬСТВА1", "уатЗатратыТСОбороты.ОбъектСтроительства КАК ОбъектСтроительства,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ОБЪЕКТСТРОИТЕЛЬСТВА2", "ОбъектСтроительства.*,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ОБЪЕКТСТРОИТЕЛЬСТВА3", "уатЗатратыТСОбороты.ОбъектСтроительства.*,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ОБЪЕКТСТРОИТЕЛЬСТВА4", "ОбъектСтроительства.*,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ОБЪЕКТСТРОИТЕЛЬСТВА5", "ОбъектСтроительства,");
		ТекстЗапроса = СтрЗаменить(ТекстЗапроса, "//ОБЪЕКТСТРОИТЕЛЬСТВА6", "ОбъектСтроительства.*,");
	КонецЕсли;
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	//Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
	//	
	//	// Добавление свойств и категорий поля запроса в таблицу полей.
	//	// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
	//	
	//	// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , 
	//                                                  <ПсевдонимПоля>, <Представление>, <Назначение>);
	//	УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("уатДТП.Заказчик", "Заказчик", "Заказчик", 
	//                                ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
	//	
	//	// Добавление свойств и категорий в исходный текст запроса.
	//	УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
	//	
	//КонецЕсли;
	
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	Пока УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Количество() > 0 Цикл
		
		УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Удалить(УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки[0]);
		
	КонецЦикла;
	
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТС"            , "ТС (все поля)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГарНомер"    , "ТС (гар. номер)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГосНомер"    , "ТС (гос. номер)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСОборудование", "Тип объекта отчета (ТС или оборудование)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтатьяЗатрат"  , "Статья затрат");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СчетЗатрат"    , "Счет затрат");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСВыбыло"		 , "ТС выбыло");
	Если мУчетПоОбъектамСтроительства Тогда
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ОбъектСтроительства", "Объект строительства");
	КонецЕсли;
	
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("СтатьяЗатрат");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Затрата");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоОборот", "Количество", Истина,"ЧДЦ=3",);
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаОборот"     , "Сумма"     , Истина,"ЧДЦ=2",);

	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	УниверсальныйОтчет.ДобавитьОтбор("ТСГосНомер",Ложь,ВидСравнения.Содержит);
	УниверсальныйОтчет.ДобавитьОтбор("СтатьяЗатрат");
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ВыполнениеЗаказовНаТС", "ЗаказНаТС");	
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	//УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТСГосНомер"      , ТипРазмещенияРеквизитовИзмерений.Отдельно);
	
	//ПутьКДанным, Размещение = Неопределено, Положение = 3
	
КонецПроцедуры // УстановитьНачальныеНастройки()

//=================================================================================
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 

// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);
	ТабличныйДокумент.ТолькоПросмотр = уатПраваИНастройки.уатПраво("ЗащитаПечатныхФорм", глПраваУАТ);
	
КонецПроцедуры // СформироватьОтчет()

//=================================================================================
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = уатОбщегоНазначения.уатСохранитьРеквизитыОтчета(ЭтотОбъект);
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	уатОбщегоНазначения.уатСохранитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	уатОбщегоНазначения.уатВосстановитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 
// 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
УниверсальныйОтчет.мРежимВводаПериода = 0;

мУчетПоОбъектамСтроительства = уатОбщегоНазначенияТиповые.уатЕстьИзмерениеРегистра("ОбъектСтроительства", РегистрыНакопления.уатЗатратыТС.СоздатьНаборЗаписей());

#КонецЕсли
