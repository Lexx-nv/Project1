﻿#Если Клиент Тогда
	
////////////////////////////////////////////////////////////////////////////////
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
		
		УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	уатЗаказыНаТСОстаткиИОбороты.Период КАК Период,
		|	НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, ДЕНЬ) КАК ПериодДень,
		|	НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
		|	НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, ДЕКАДА) КАК ПериодДекада,
		|	НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
		|	НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
		|	НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
		|	НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, ГОД) КАК ПериодГод,
		|	уатЗаказыНаТСОстаткиИОбороты.Регистратор КАК Регистратор,
		|	уатЗаказыНаТСОстаткиИОбороты.Заказчик КАК Заказчик,
		|	уатЗаказыНаТСОстаткиИОбороты.ЗаказНаТС КАК ЗаказНаТС,
		|	уатЗаказыНаТСОстаткиИОбороты.Номенклатура КАК Номенклатура,
		|	уатЗаказыНаТСОстаткиИОбороты.ЕдиницаИзмерения КАК ЕдиницаИзмерения,
		|	уатЗаказыНаТСОстаткиИОбороты.ДатаВыполнения КАК ДатаВыполнения,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоПриход КАК КоличествоПриход,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоРасход КАК КоличествоРасход,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоОборот КАК КоличествоОборот
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
		|	Номенклатура.*,
		|	Заказчик.*,
		|	ЗаказНаТС.*,
		|	ДатаВыполнения,
		|	ЕдиницаИзмерения.*,
		|	КоличествоНачальныйОстаток,
		|	КоличествоПриход,
		|	КоличествоРасход,
		|	КоличествоКонечныйОстаток,
		|	КоличествоОборот}
		|ИЗ
		|	РегистрНакопления.уатЗаказыНаТС.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК уатЗаказыНаТСОстаткиИОбороты
		|{ГДЕ
		|	уатЗаказыНаТСОстаткиИОбороты.Период,
		|	(НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, ДЕНЬ)) КАК ПериодДень,
		|	(НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
		|	(НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, ДЕКАДА)) КАК ПериодДекада,
		|	(НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, МЕСЯЦ)) КАК ПериодМесяц,
		|	(НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, КВАРТАЛ)) КАК ПериодКвартал,
		|	(НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, ПОЛУГОДИЕ)) КАК ПериодПолугодие,
		|	(НАЧАЛОПЕРИОДА(уатЗаказыНаТСОстаткиИОбороты.Период, ГОД)) КАК ПериодГод,
		|	уатЗаказыНаТСОстаткиИОбороты.Регистратор.*,
		|	уатЗаказыНаТСОстаткиИОбороты.Номенклатура.*,
		|	уатЗаказыНаТСОстаткиИОбороты.Заказчик.*,
		|	уатЗаказыНаТСОстаткиИОбороты.ЗаказНаТС.*,
		|	уатЗаказыНаТСОстаткиИОбороты.ЕдиницаИзмерения.*,
		|	уатЗаказыНаТСОстаткиИОбороты.ДатаВыполнения,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоНачальныйОстаток,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоПриход,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоРасход,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоКонечныйОстаток,
		|	уатЗаказыНаТСОстаткиИОбороты.КоличествоОборот}
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
		|	Номенклатура.*,
		|	Заказчик.*,
		|	ЗаказНаТС.*,
		|	ЕдиницаИзмерения.*,
		|	ДатаВыполнения,
		|	КоличествоНачальныйОстаток,
		|	КоличествоПриход,
		|	КоличествоРасход,
		|	КоличествоКонечныйОстаток,
		|	КоличествоОборот}
		|ИТОГИ
		|	СУММА(КоличествоНачальныйОстаток),
		|	СУММА(КоличествоПриход),
		|	СУММА(КоличествоРасход),
		|	СУММА(КоличествоКонечныйОстаток),
		|	СУММА(КоличествоОборот)
		|ПО
		|	ОБЩИЕ,
		|	ЗаказНаТС,
		|	Номенклатура,
		|	Заказчик,
		|	Регистратор,
		|	Период
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
		|	Номенклатура.*,
		|	ЗаказНаТС.*,
		|	Заказчик.*}";
		
		
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
		
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоНачальныйОстаток", "Количество (начальный остаток)");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоКонечныйОстаток" , "Количество (конечный остаток)");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоОборот"			 , "Количество (оборот)");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоПриход"			 , "Количество (приход)");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоРасход"			 , "Количество (расход)");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаВыполнения"			 , "Дата выполнения");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДокументДвижения"			 , "Регистратор");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЕдиницаИзмерения"			 , "Единица измерения");
		УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ЗаказНаТС"				 , "Заказ на ТС");
		
		УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
		
		//// Заполнение начальных настроек универсального отчета
		//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
		
		// Добавление предопределенных группировок строк отчета.
		// Необходимо вызывать для каждой добавляемой группировки строки.
		// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
		
		УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ЗаказНаТС");
		УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
		
		УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток", "Начальный остаток", Истина,"ЧДЦ=3", "Количество","Количество");
		УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриход"          , "Приход"		   , Истина,"ЧДЦ=3", "Количество","Количество");
		УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасход"          , "Расход"		   , Истина,"ЧДЦ=3", "Количество","Количество");
		УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток" , "Конечный остаток" , Истина,"ЧДЦ=3", "Количество","Количество");
		УниверсальныйОтчет.ДобавитьПоказатель("КоличествоОборот"		  , "Оборот"		   , Ложь,"ЧДЦ=3", "Количество","Количество");
		
		// Добавление предопределенных отборов отчета.
		// Необходимо вызывать для каждого добавляемого отбора.
		УниверсальныйОтчет.ДобавитьОтбор("ЗаказНаТС");
		УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
		УниверсальныйОтчет.ДобавитьОтбор("Заказчик");	
		
		// Установка связи подчиненных и родительских полей
		// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
		
		// Установка связи полей и измерений
		// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
		//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ВыполнениеЗаказовНаТС", "ЗаказНаТС");	
		
		// Заполнение начальных настроек универсального отчета
		УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
		
		// Добавление дополнительных полей
		// Необходимо вызывать для каждого добавляемого дополнительного поля.
		
	КонецПроцедуры // УстановитьНачальныеНастройки()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА

// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);
	ТабличныйДокумент.ТолькоПросмотр = уатПраваИНастройки.уатПраво("ЗащитаПечатныхФорм", глПраваУАТ);

КонецПроцедуры // СформироватьОтчет()


////////////////////////////////////////////////////////////////////////////////
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
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал,
//	6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
// УниверсальныйОтчет.мРежимВводаПериода = 1;


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ
	
#КонецЕсли
