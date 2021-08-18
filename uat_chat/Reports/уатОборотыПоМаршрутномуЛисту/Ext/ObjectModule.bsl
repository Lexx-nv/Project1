﻿#Если Клиент Тогда
	
	//=================================================================================
	// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА
	
	Функция СформироватьТекстЗапроса()
		
		ТекстЗапроса = 
		"ВЫБРАТЬ
		|	уатОборотыПоМаршрутномуЛистуОбороты.ТС КАК ТС,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Водитель1 КАК Водитель1,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Водитель2 КАК Водитель2,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Сотрудник1 КАК Сотрудник1,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Сотрудник2 КАК Сотрудник2,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ВремяВПутиОборот КАК ВремяВПути,
		|	уатОборотыПоМаршрутномуЛистуОбороты.РасстояниеОборот КАК Расстояние,
		|	уатОборотыПоМаршрутномуЛистуОбороты.КоличествоЗаказовОборот КАК КоличествоЗаказов,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ОбъемОборот КАК Объем,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ВесБруттоОборот КАК ВесБрутто,
		|	уатОборотыПоМаршрутномуЛистуОбороты.КоличествоМестОборот КАК КоличествоМест,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Регистратор КАК Регистратор
		|{ВЫБРАТЬ
		|	ТС.*,
		|	Водитель1.*,
		|	Водитель2.*,
		|	Сотрудник1.*,
		|	Сотрудник2.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ВремяВПутиОборот КАК ВремяВПути,
		|	уатОборотыПоМаршрутномуЛистуОбороты.РасстояниеОборот КАК Расстояние,
		|	уатОборотыПоМаршрутномуЛистуОбороты.КоличествоЗаказовОборот КАК КоличествоЗаказов,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ОбъемОборот КАК Объем,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ВесБруттоОборот КАК ВесБрутто,
		|	уатОборотыПоМаршрутномуЛистуОбороты.КоличествоМестОборот КАК КоличествоМест,
		|	Регистратор.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодДень,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодНеделя,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодДекада,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодМесяц,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодКвартал,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодПолугодие,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодГод}
		|ИЗ
		|	РегистрНакопления.уатОборотыПоМаршрутномуЛисту.Обороты(, , Авто, ) КАК уатОборотыПоМаршрутномуЛистуОбороты
		|{ГДЕ
		|	уатОборотыПоМаршрутномуЛистуОбороты.ТС.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Водитель1.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Водитель2.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Сотрудник1.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Сотрудник2.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Регистратор.*,
		|	(ВЫБОР
		|			КОГДА уатОборотыПоМаршрутномуЛистуОбороты.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
		|				ТОГДА ИСТИНА
		|			КОГДА уатОборотыПоМаршрутномуЛистуОбороты.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
		|				ТОГДА ЛОЖЬ
		|		КОНЕЦ) КАК ТСВыбыло}		
		|
		|СГРУППИРОВАТЬ ПО
		|	уатОборотыПоМаршрутномуЛистуОбороты.ТС,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Водитель1,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Водитель2,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Сотрудник1,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Сотрудник2,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ВремяВПутиОборот,
		|	уатОборотыПоМаршрутномуЛистуОбороты.РасстояниеОборот,
		|	уатОборотыПоМаршрутномуЛистуОбороты.КоличествоЗаказовОборот,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ОбъемОборот,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ВесБруттоОборот,
		|	уатОборотыПоМаршрутномуЛистуОбороты.КоличествоМестОборот,
		|	уатОборотыПоМаршрутномуЛистуОбороты.Регистратор
		|{УПОРЯДОЧИТЬ ПО
		|	ТС.*,
		|	Водитель1.*,
		|	Водитель2.*,
		|	Сотрудник1.*,
		|	Сотрудник2.*,
		|	Регистратор.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ВремяВПутиОборот КАК ВремяВПути ,
		|	уатОборотыПоМаршрутномуЛистуОбороты.РасстояниеОборот КАК Расстояние,
		|	уатОборотыПоМаршрутномуЛистуОбороты.КоличествоЗаказовОборот КАК КоличествоЗаказов,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ОбъемОборот КАК Объем,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ВесБруттоОборот КАК ВесБрутто,
		|	уатОборотыПоМаршрутномуЛистуОбороты.КоличествоМестОборот}
		|ИТОГИ
		|	СУММА(ВремяВПути),
		|	СУММА(Расстояние),
		|	СУММА(КоличествоЗаказов),
		|	СУММА(Объем),
		|	СУММА(ВесБрутто),
		|	СУММА(КоличествоМест)
		|ПО
		|	ТС,
		|	Водитель1,
		|	Водитель2,
		|	Сотрудник1,
		|	Сотрудник2,
		|	Регистратор
		|{ИТОГИ ПО
		|	ТС.*,
		|	Водитель1.*,
		|	Водитель2.*,
		|	Сотрудник1.*,
		|	Сотрудник2.*,
		|	Регистратор.*,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодДень,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодНеделя,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодДекада,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодМесяц,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодКвартал,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодПолугодие,
		|	уатОборотыПоМаршрутномуЛистуОбороты.ПериодГод}";
		
		Возврат ТекстЗапроса;	
		
	КонецФункции
	
	
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

	ТекстЗапроса = СформироватьТекстЗапроса();


	// В универсальном отчете включен флаг использования свойств и категорий.
	//Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
	//	
	//	// Добавление свойств и категорий поля запроса в таблицу полей.
	//	// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
	//	
	//	// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>,
	//		<Представление>, <Назначение>);
	//	УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("уатДТП.Заказчик", "Заказчик", "Заказчик",
	//		ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
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
		
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТС"         , "Транспортное средство");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Водитель1"  , "Водитель 1");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Водитель2"  , "Водитель 2");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Сотрудник1" , "Сотрудник 1");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Сотрудник2" , "Сотрудник 2");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Период"     , "Период");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Регистратор", "Регистратор");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСВыбыло"	  , "ТС выбыло");

	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ПериодМесяц");
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("ТС");
	УниверсальныйОтчет.ДобавитьОтбор("Водитель1");
	УниверсальныйОтчет.ДобавитьОтбор("Водитель2");
	УниверсальныйОтчет.ДобавитьОтбор("ТСВыбыло", Истина, ВидСравнения.Равно, Ложь);
	
	УниверсальныйОтчет.ДобавитьПоказатель("Расстояние"     , "Расстояние, км"                , Истина,"ЧДЦ=3", , );
	УниверсальныйОтчет.ДобавитьПоказатель("Времявпути"  , "Время в пути, мин"             , Истина,, , );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоЗаказов", "Количество заказов"           , Истина,, , );
	УниверсальныйОтчет.ДобавитьПоказатель("ВесБрутто"              , "Перевезенный вес, кг"         , Истина,"ЧДЦ=3", , );
	УниверсальныйОтчет.ДобавитьПоказатель("Объем"            , "Перевезенный объем, м3"       , Истина,"ЧДЦ=3", , );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоМест"   , "Перевезенное количество мест" , Истина,, , );
	
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ВыполнениеЗаказовНаТС", "ЗаказНаТС");	
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	УниверсальныйОтчет.ВыводитьДетальныеЗаписи = Истина;
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Водитель1");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Водитель2");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Сотрудник1");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Сотрудник2");

	КонецПроцедуры // УстановитьНачальныеНастройки()
	
	//=================================================================================
	// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 
	
	// Процедура формирования отчета
	//
	Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
		
		//ОтборВыполнениеЗаказовНаТС = Новый СписокЗначений;
		//Если Выполнено = Истина Тогда
		//	ОтборВыполнениеЗаказовНаТС.Добавить("Выполнено");
		//КонецЕсли;
		//Если ВыполненоЧастично = Истина Тогда
		//	ОтборВыполнениеЗаказовНаТС.Добавить("ВыполненоЧастично", "Выполнено частично");
		//КонецЕсли;
		//Если НеВыполнено = Истина Тогда
		//	ОтборВыполнениеЗаказовНаТС.Добавить("НеВыполнено", "Не выполнено");
		//КонецЕсли;
		//
		//УниверсальныйОтчет.ДобавитьОтбор("ВыполнениеЗаказовНаТС", СостояниеВыполненияЗаказов,
		//	ВидСравнения.ВСписке, ОтборВыполнениеЗаказовНаТС);
		
		УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);
		ТабличныйДокумент.ТолькоПросмотр = уатПраваИНастройки.уатПраво("ЗащитаПечатныхФорм", глПраваУАТ);
		
		//УниверсальныйОтчет.ПостроительОтчета.Отбор.Удалить(УниверсальныйОтчет.ПостроительОтчета.Отбор.Индекс(
		//	УниверсальныйОтчет.ПостроительОтчета.Отбор["ВыполнениеЗаказовНаТС"]));
		//УниверсальныйОтчет.ПостроительОтчета.ДоступныеПоля.ВыполнениеЗаказовНаТС.Отбор = Ложь;

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
	// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 4 - месяц, 5 - квартал,
	//	6 - полугодие, 7 - год
	// Значение по умолчанию: 0
	// Пример:
	// УниверсальныйОтчет.мРежимВводаПериода = 1;
	
#КонецЕсли
