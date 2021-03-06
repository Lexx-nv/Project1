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
	|	уатВыручкаОбороты.Период КАК Период,
	|	НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, ДЕНЬ) КАК ПериодДень,
	|	НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	|	НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, ДЕКАДА) КАК ПериодДекада,
	|	НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
	|	НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
	|	НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	|	НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, ГОД) КАК ПериодГод,
	|	уатВыручкаОбороты.Регистратор КАК Регистратор,
	|	уатВыручкаОбороты.Организация КАК Организация,
	|	уатВыручкаОбороты.ТС КАК ТС,
	|	уатВыручкаОбороты.Сотрудник КАК Сотрудник,
	|	уатВыручкаОбороты.Маршрут КАК Маршрут,
	|	уатВыручкаОбороты.Автостанция КАК Автостанция,
	|	уатВыручкаОбороты.Билет КАК Билет,
	|	уатВыручкаОбороты.ПутевойЛист КАК ПутевойЛист,
	|	уатВыручкаОбороты.КоличествоОборот КАК КоличествоОборот,
	|	уатВыручкаОбороты.СуммаОборот КАК СуммаОборот,
	|	уатВыручкаОбороты.КомиссияАвтостанцииОборот КАК КомиссияАвтостанцииОборот
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
	|	ТС.*,
	|	Сотрудник.*,
	|	Маршрут.*,
	|	Автостанция.*,
	|	Билет.*,
	|	ПутевойЛист.*,
	|	КоличествоОборот,
	|	СуммаОборот,
	|	КомиссияАвтостанцииОборот}
	|ИЗ
	|	РегистрНакопления.уатВыручка.Обороты(&ДатаНач, &ДатаКон, Регистратор, Автостанция <> ЗНАЧЕНИЕ(Справочник.уатПунктыНазначения.ПустаяСсылка)) КАК уатВыручкаОбороты
	|{ГДЕ
	|	уатВыручкаОбороты.Период,
	|	(НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, ДЕНЬ)) КАК ПериодДень,
	|	(НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	|	(НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, ДЕКАДА)) КАК ПериодДекада,
	|	(НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, МЕСЯЦ)) КАК ПериодМесяц,
	|	(НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, КВАРТАЛ)) КАК ПериодКвартал,
	|	(НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, ПОЛУГОДИЕ)) КАК ПериодПолугодие,
	|	(НАЧАЛОПЕРИОДА(уатВыручкаОбороты.Период, ГОД)) КАК ПериодГод,
	|	уатВыручкаОбороты.Регистратор.*,
	|	уатВыручкаОбороты.Организация.*,
	|	уатВыручкаОбороты.ТС.*,
	|	уатВыручкаОбороты.Сотрудник.*,
	|	уатВыручкаОбороты.Маршрут.*,
	|	уатВыручкаОбороты.Автостанция.*,
	|	уатВыручкаОбороты.Билет.*,
	|	уатВыручкаОбороты.ПутевойЛист.*,
	|	уатВыручкаОбороты.КоличествоОборот,
	|	уатВыручкаОбороты.СуммаОборот,
	|	уатВыручкаОбороты.КомиссияАвтостанцииОборот}
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
	|	ТС.*,
	|	Сотрудник.*,
	|	Маршрут.*,
	|	Автостанция.*,
	|	Билет.*,
	|	ПутевойЛист.*,
	|	КоличествоОборот,
	|	СуммаОборот,
	|	КомиссияАвтостанцииОборот}
	|ИТОГИ
	|	СУММА(КоличествоОборот),
	|	СУММА(СуммаОборот),
	|	СУММА(КомиссияАвтостанцииОборот)
	|ПО
	|	Автостанция,
	|	Маршрут,
	|	Билет,
	|	Сотрудник
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
	|	ТС.*,
	|	Сотрудник.*,
	|	Маршрут.*,
	|	Автостанция.*,
	|	Билет.*,
	|	ПутевойЛист.*}";
		
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
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Автостанция");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Билет");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Сотрудник");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ТС");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Регистратор");
		
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоОборот", "Количество билетов", Истина, , "КоличествоОборот", "Количество");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаОборот" , "Сумма" , Истина, "ЧДЦ=2", "СуммаОборот", "Сумма");
	УниверсальныйОтчет.ДобавитьПоказатель("КомиссияАвтостанцииОборот", "Комиссия автостанции", Истина, "ЧДЦ=2", "КомиссияАвтостанцииОборот", "Комиссия автостанции");
		
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ВыполнениеЗаказовНаТС", "ЗаказНаТС");	
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	УниверсальныйОтчет.ДобавитьОтбор("Автостанция");
	УниверсальныйОтчет.ДобавитьОтбор("ТС");
	УниверсальныйОтчет.ДобавитьОтбор("Маршрут");
	УниверсальныйОтчет.ДобавитьОтбор("Сотрудник");
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТС.ГаражныйНомер", ТипРазмещенияРеквизитовИзмерений.ВместеСИзмерениями, 2);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТС.ГосударственныйНомер", ТипРазмещенияРеквизитовИзмерений.ВместеСИзмерениями);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТС.Модель", ТипРазмещенияРеквизитовИзмерений.Отдельно);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Билет.ВидБилета", ТипРазмещенияРеквизитовИзмерений.Отдельно);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Билет.Серия", ТипРазмещенияРеквизитовИзмерений.Отдельно);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Билет.Цена", ТипРазмещенияРеквизитовИзмерений.Отдельно);
	
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
