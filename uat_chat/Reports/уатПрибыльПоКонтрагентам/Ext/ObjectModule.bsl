#Если Клиент Тогда

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
	
	// Описание исходного текста запроса.
	ТекстЗапроса =
	"ВЫБРАТЬ
	|	Доходы.Контрагент КАК Контрагент,
	|	Доходы.ТС КАК ТС,
	|	Доходы.Организация КАК Организация,
	|	Доходы.СуммаОборот КАК СуммаДоходов,
	|	0 КАК СуммаЗатрат,
	|	Доходы.СуммаОборот КАК Прибыль
	|{ВЫБРАТЬ
	|	Организация.*,
	|	Контрагент.*,
	|	ТС.*,
	|	СуммаЗатрат,
	|	СуммаДоходов,
	|	Прибыль}
	|ИЗ
	|	РегистрНакопления.уатВыработкаПоСтоимости.Обороты(&ДатаНач, &ДатаКон, , {(Организация).* КАК Организация, (Контрагент).* КАК Контрагент, (ТС).* КАК ТС, (ПараметрВыработки).* КАК ПараметрВыработки, (Маршрут).* КАК Маршрут, (ПутЛист).* КАК ПутЛист}) КАК Доходы
	|ГДЕ
	|	Доходы.Контрагент <> &ПустойКонтрагент
	|	И Доходы.ТС <> &ПустоеТС
	|{ГДЕ
	|	(ВЫБОР
	|			КОГДА Доходы.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			КОГДА Доходы.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЛОЖЬ
	|		КОНЕЦ) КАК ТСВыбыло}
	|
	|ОБЪЕДИНИТЬ ВСЕ
	|
	|ВЫБРАТЬ
	|	Затраты.Контрагент,
	|	Затраты.ТС,
	|	Затраты.Организация,
	|	0,
	|	Затраты.СуммаОборот,
	|	-Затраты.СуммаОборот
	|ИЗ
	|	РегистрНакопления.уатЗатратыТС.Обороты(&ДатаНач, &ДатаКон, , {(Контрагент).* КАК Контрагент, (Организация).* КАК Организация, (ТС).* КАК ТС, (СтатьяЗатрат).* КАК СтатьяЗатрат, (Затрата).* КАК Затрата}) КАК Затраты
	|ГДЕ
	|	Затраты.Контрагент <> &ПустойКонтрагент
	|	И Затраты.ТС <> &ПустоеТС
	|{ГДЕ
	|	(ВЫБОР
	|			КОГДА Затраты.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			КОГДА Затраты.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЛОЖЬ
	|		КОНЕЦ) КАК ТСВыбыло}	
	|{УПОРЯДОЧИТЬ ПО
	|	Контрагент.*,
	|	ТС.*,
	|	Организация.*,
	|	СуммаДоходов,
	|	СуммаЗатрат,
	|	Прибыль}
	|ИТОГИ
	|	СУММА(СуммаДоходов),
	|	СУММА(СуммаЗатрат),
	|	СУММА(Прибыль)
	|ПО
	|	ОБЩИЕ,
	|	Контрагент,
	|	ТС
	|{ИТОГИ ПО
	|	Контрагент.*,
	|	Организация.*,
	|	ТС.*}";
	
	// В универсальном отчете включен флаг использования свойств и категорий.
	Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
		
		// Добавление свойств и категорий поля запроса в таблицу полей.
		// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
		
		// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , <ПсевдонимПоля>,
		//	<Представление>, <Назначение>);
		УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("Доходы.Контрагент", "Контрагент", "Контрагент", ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
		// Добавление свойств и категорий в исходный текст запроса.
		УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
		
	КонецЕсли;
	
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	Пока УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Количество() > 0 Цикл
		
		УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Удалить(УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки[0]);
		
	КонецЦикла;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Контрагент", "Контрагент");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТС", "ТС");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Организация", "Организация");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Номенклатура", "Номенклатура");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Маршрут", "Маршрут");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПараметрВыработки", "Параметр выработки");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПутЛист", "Путевой лист");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СтатьяЗатрат", "Статья затрат");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Затрата", "Затрата");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСВыбыло", "ТС выбыло");
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаЗатрат", "Сумма затрат");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СуммаДоходов", "Сумма доходов");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Прибыль", "Прибыль");
	
	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаЗатрат" , "Сумма затрат" , Истина,"ЧДЦ=2");
	УниверсальныйОтчет.ДобавитьПоказатель("СуммаДоходов", "Сумма доходов", Истина,"ЧДЦ=2");
	УниверсальныйОтчет.ДобавитьПоказатель("Прибыль"     , "Прибыль"      , Истина,"ЧДЦ=2");
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Контрагент");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Организация");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ТС");
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	// УниверсальныйОтчет.ДобавитьОтбор(<ПутьКДанным>);
	УниверсальныйОтчет.ДобавитьОтбор("Организация");
	УниверсальныйОтчет.ДобавитьОтбор("ТС");
	УниверсальныйОтчет.ДобавитьОтбор("Номенклатура");
	УниверсальныйОтчет.ДобавитьОтбор("ТСВыбыло", Истина, ВидСравнения.Равно, Ложь);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ВыполнениеЗаказовНаТС", "ЗаказНаТС");	
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	// УниверсальныйОтчет.ДобавитьДополнительноеПоле(<ПутьКДанным>, <Размещение>, <Положение>);
	
КонецПроцедуры // УстановитьНачальныеНастройки()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 

// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустойКонтрагент", Справочники.Контрагенты.ПустаяСсылка());
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустоеТС", Справочники.уатТС.ПустаяСсылка());
	
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
