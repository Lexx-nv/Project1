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
	|	уатТС.Ссылка КАК ТС,
	|	уатТС.ГаражныйНомер КАК ТСГарНомер,
	|	уатТС.ГосударственныйНомер КАК ТСГосНомер,
	|	уатТС.Модель КАК Модель,
	|	уатТС.ТипТС КАК ТипТС,
	|	уатМестонахождениеТССрезПоследних.Организация КАК Организация,
	|	уатМестонахождениеТССрезПоследних.Подразделение КАК Подразделение,
	|	уатМестонахождениеТССрезПоследних.Колонна КАК Колонна,
	|	уатТС.ГодВыпуска КАК ГодВыпуска,
	|	1 КАК Количество
	|{ВЫБРАТЬ
	|	ТС.* КАК ТС,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Модель.*,
	|	ТипТС.*,
	|	Организация.*,
	|	Подразделение.*,
	|	Колонна.*,
	|	ГодВыпуска,
	|	Количество,
	|	уатТС.ДатаВводаВЭксплуатацию,
	|	уатТС.МодельДвигателя,
	|	уатТС.ВидМоделиТС}
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаКон, ) КАК уатМестонахождениеТССрезПоследних
	|		ПО (уатМестонахождениеТССрезПоследних.ТС = уатТС.Ссылка)
	|ГДЕ
	|	(уатТС.ДатаВыбытия > &ДатаКонца
	|			ИЛИ уатТС.ДатаВыбытия = &ПустаяДата)
	|{ГДЕ
	|	уатТС.Ссылка.* КАК ТС,
	|	уатТС.ГаражныйНомер КАК ТСГарНомер,
	|	уатТС.ГосударственныйНомер КАК ТСГосНомер,
	|	уатТС.Модель.*,
	|	уатТС.ТипТС.*,
	|	уатМестонахождениеТССрезПоследних.Организация.*,
	|	уатМестонахождениеТССрезПоследних.Подразделение.*,
	|	уатМестонахождениеТССрезПоследних.Колонна.*,
	|	уатТС.ГодВыпуска,
	|	(ВЫБОР
	|			КОГДА уатТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			КОГДА уатТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЛОЖЬ
	|		КОНЕЦ) КАК ТСВыбыло}
	|
	|УПОРЯДОЧИТЬ ПО
	|	уатТС.ВидМоделиТС УБЫВ
	|{УПОРЯДОЧИТЬ ПО
	|	ТС.*,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Модель.*,
	|	ТипТС.*,
	|	Организация.*,
	|	Подразделение.*,
	|	Колонна.*,
	|	ГодВыпуска,
	|	Количество}
	|ИТОГИ
	|	СУММА(Количество)
	|ПО
	|	ОБЩИЕ,
	|	ТС,
	|	ТСГосНомер,
	|	ТипТС,
	|	Подразделение,
	|	Модель,
	|	Организация,
	|	Колонна,
	|	ГодВыпуска
	|{ИТОГИ ПО
	|	ТС.*,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Модель.*,
	|	ТипТС.*,
	|	Организация.*,
	|	Подразделение.*,
	|	Колонна.*,
	|	ГодВыпуска}";
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустаяДата",Дата('00010101'));
	
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
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТС"               , "ТС / оборудование (все поля)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГарНомер"       , "ТС (гар. номер)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГосНомер"       , "ТС (гос. номер)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Организация"      , "Организация");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Подразделение"    , "Подразделение");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСВыбыло"			, "ТС выбыло");
	
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Организация");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ТипТС");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Модель");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ТС");
	
	УниверсальныйОтчет.ДобавитьПоказатель("Количество", "Количество"             , Истина,, , );

	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	УниверсальныйОтчет.ДобавитьОтбор("Модель"     , Ложь);
	УниверсальныйОтчет.ДобавитьОтбор("ТипТС"      , Ложь);
	УниверсальныйОтчет.ДобавитьОтбор("Организация", Ложь);
	УниверсальныйОтчет.ДобавитьОтбор("ТСВыбыло"	  , Истина, ВидСравнения.Равно, Ложь);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);

	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТСГосНомер",ТипРазмещенияРеквизитовИзмерений.Отдельно);

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
УниверсальныйОтчет.мРежимВводаПериода = 1;
	
#КонецЕсли
