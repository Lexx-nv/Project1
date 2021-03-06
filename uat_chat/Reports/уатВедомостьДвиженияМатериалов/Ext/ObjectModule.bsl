#Если Клиент Тогда
	
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
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Период КАК Период,
    |	НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, ДЕНЬ) КАК ПериодДень,
    |	НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
    |	НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, ДЕКАДА) КАК ПериодДекада,
    |	НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
    |	НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
    |	НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
    |	НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, ГОД) КАК ПериодГод,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Регистратор КАК Регистратор,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Номенклатура КАК Номенклатура,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Склад КАК Склад,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Партия КАК Партия,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.КоличествоПриход КАК КоличествоПриход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.КоличествоРасход КАК КоличествоРасход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьНачальныйОстаток КАК СтоимостьНачальныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьПриход КАК СтоимостьПриход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьРасход КАК СтоимостьРасход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьКонечныйОстаток КАК СтоимостьКонечныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьУпрНачальныйОстаток КАК СтоимостьУпрНачальныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьУпрПриход КАК СтоимостьУпрПриход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьУпрРасход КАК СтоимостьУпрРасход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьУпрКонечныйОстаток КАК СтоимостьУпрКонечныйОстаток
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
    |	Склад.*,
    |	Партия.*,
    |	КоличествоНачальныйОстаток,
    |	КоличествоПриход,
    |	КоличествоРасход,
    |	КоличествоКонечныйОстаток,
    |	СтоимостьНачальныйОстаток,
    |	СтоимостьПриход,
    |	СтоимостьРасход,
    |	СтоимостьКонечныйОстаток,
    |	СтоимостьУпрНачальныйОстаток,
    |	СтоимостьУпрПриход,
    |	СтоимостьУпрРасход,
    |	СтоимостьУпрКонечныйОстаток}
    |ИЗ
    |	РегистрНакопления.уатПартииТоваровНаСкладах.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК уатПартииТоваровНаСкладахОстаткиИОбороты
    |{ГДЕ
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Период,
    |	(НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, ДЕНЬ)) КАК ПериодДень,
    |	(НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
    |	(НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, ДЕКАДА)) КАК ПериодДекада,
    |	(НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, МЕСЯЦ)) КАК ПериодМесяц,
    |	(НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, КВАРТАЛ)) КАК ПериодКвартал,
    |	(НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, ПОЛУГОДИЕ)) КАК ПериодПолугодие,
    |	(НАЧАЛОПЕРИОДА(уатПартииТоваровНаСкладахОстаткиИОбороты.Период, ГОД)) КАК ПериодГод,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Регистратор.*,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Номенклатура.*,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Склад.*,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.Партия.*,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.КоличествоНачальныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.КоличествоПриход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.КоличествоРасход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.КоличествоКонечныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьНачальныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьПриход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьРасход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьКонечныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьУпрНачальныйОстаток,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьУпрПриход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьУпрРасход,
    |	уатПартииТоваровНаСкладахОстаткиИОбороты.СтоимостьУпрКонечныйОстаток}
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
    |	Склад.*,
    |	Партия.*,
    |	КоличествоНачальныйОстаток,
    |	КоличествоПриход,
    |	КоличествоРасход,
    |	КоличествоКонечныйОстаток,
    |	СтоимостьНачальныйОстаток,
    |	СтоимостьПриход,
    |	СтоимостьРасход,
    |	СтоимостьКонечныйОстаток,
    |	СтоимостьУпрНачальныйОстаток,
    |	СтоимостьУпрПриход,
    |	СтоимостьУпрРасход,
    |	СтоимостьУпрКонечныйОстаток}
    |ИТОГИ
    |	СУММА(КоличествоНачальныйОстаток),
    |	СУММА(КоличествоПриход),
    |	СУММА(КоличествоРасход),
    |	СУММА(КоличествоКонечныйОстаток),
    |	СУММА(СтоимостьНачальныйОстаток),
    |	СУММА(СтоимостьПриход),
    |	СУММА(СтоимостьРасход),
    |	СУММА(СтоимостьКонечныйОстаток),
    |	СУММА(СтоимостьУпрНачальныйОстаток),
    |	СУММА(СтоимостьУпрПриход),
    |	СУММА(СтоимостьУпрРасход),
    |	СУММА(СтоимостьУпрКонечныйОстаток)
    |ПО
	|	ОБЩИЕ,
    |	Партия,
    |	Номенклатура,
    |	Склад,
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
    |	Склад.*,
    |	Партия.*}";
	
	
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
	
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Склад");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Номенклатура");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Партия");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток", "Количество", Истина,"ЧДЦ=3", "НачальныйОстаток","Начальный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьНачальныйОстаток" , "Стоимость" , Истина,"ЧДЦ=2", "НачальныйОстаток","Начальный остаток" );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриход"          , "Количество", Истина,"ЧДЦ=3", "приход","Приход");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьПриход"           , "Стоимость" , Истина,"ЧДЦ=2", "приход","Приход" );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасход"          , "Количество", Истина,"ЧДЦ=3", "Расход","Расход");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьРасход"           , "Стоимость" , Истина,"ЧДЦ=2", "Расход","Расход" );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток" , "Количество", Истина,"ЧДЦ=3", "КонечныйОстаток","Конечный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьКонечныйОстаток"  , "Стоимость" , Истина,"ЧДЦ=2", "КонечныйОстаток","Конечный остаток" );
	
	Если уатРаботаСМетаданными.уатЕстьКонстанта("ВалютаУправленческогоУчета") тогда
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрНачальныйОстаток", "Стоимость (упр)" , Истина,"ЧДЦ=2", "НачальныйОстаток","Начальный остаток" );
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрПриход"          , "Стоимость (упр)" , Истина,"ЧДЦ=2", "приход","Приход" );
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрРасход"          , "Стоимость (упр)" , Истина,"ЧДЦ=2", "Расход","Расход" );
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрКонечныйОстаток" , "Стоимость (упр)" , Истина,"ЧДЦ=2", "КонечныйОстаток","Конечный остаток" );
	КонецЕсли;

	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	УниверсальныйОтчет.ДобавитьОтбор("Склад");
	УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	
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
	
#КонецЕсли
