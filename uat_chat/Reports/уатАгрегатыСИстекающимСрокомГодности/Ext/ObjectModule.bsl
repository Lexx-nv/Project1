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
	
	УниверсальныйОтчет.ОтрицательноеКрасным = Истина;
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		//уатОбщегоНазначения.уатВосстановитьРеквизитыОтчета(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.Агрегат КАК Агрегат,
	|	ВложенныйЗапрос.Количество КАК Количество,
	|	ВложенныйЗапрос.ТипАгрегата КАК ТипАгрегата,
	|	ВложенныйЗапрос.ДнейОсталось КАК ДнейОсталось,
	|	ВложенныйЗапрос.СкладТС КАК СкладТС,
	|	ВложенныйЗапрос.ГоденДо
	|{ВЫБРАТЬ
	|	Агрегат.*,
	|	Количество,
	|	ТипАгрегата.*,
	|	ДнейОсталось,
	|	СкладТС.*,
	|	ГоденДо}
	|ИЗ
	|	(ВЫБРАТЬ
	|		уатОстаткиАгрегатовОстатки.Склад КАК СкладТС,
	|		уатОстаткиАгрегатовОстатки.СерияНоменклатуры КАК Агрегат,
	|		уатОстаткиАгрегатовОстатки.КоличествоОстаток КАК Количество,
	|		уатОстаткиАгрегатовОстатки.СерияНоменклатуры.ГоденДо КАК ГоденДо,
	|		уатОстаткиАгрегатовОстатки.СерияНоменклатуры.ТипАгрегата КАК ТипАгрегата,
	|		ВЫБОР
	|			КОГДА РАЗНОСТЬДАТ(&ДатаКонца, уатОстаткиАгрегатовОстатки.СерияНоменклатуры.ГоденДо, ДЕНЬ) = 0
	|				ТОГДА 0
	|			ИНАЧЕ РАЗНОСТЬДАТ(&ДатаКонца, уатОстаткиАгрегатовОстатки.СерияНоменклатуры.ГоденДо, ДЕНЬ)
	|		КОНЕЦ КАК ДнейОсталось
	|	ИЗ
	|		РегистрНакопления.уатОстаткиАгрегатов.Остатки(&ДатаКон, ) КАК уатОстаткиАгрегатовОстатки
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		уатАгрегатыТССрезПоследних.ТС,
	|		уатАгрегатыТССрезПоследних.СерияНоменклатуры,
	|		1,
	|		уатАгрегатыТССрезПоследних.СерияНоменклатуры.ГоденДо,
	|		уатАгрегатыТССрезПоследних.СерияНоменклатуры.ТипАгрегата,
	|		ВЫБОР
	|			КОГДА РАЗНОСТЬДАТ(&ДатаКонца, уатАгрегатыТССрезПоследних.СерияНоменклатуры.ГоденДо, ДЕНЬ) = 0
	|				ТОГДА 0
	|			ИНАЧЕ РАЗНОСТЬДАТ(&ДатаКонца, уатАгрегатыТССрезПоследних.СерияНоменклатуры.ГоденДо, ДЕНЬ)
	|		КОНЕЦ
	|	ИЗ
	|		РегистрСведений.уатАгрегатыТС.СрезПоследних(&ДатаКон, ) КАК уатАгрегатыТССрезПоследних
	|	{ГДЕ
	|		(ВЫБОР
	|				КОГДА уатАгрегатыТССрезПоследних.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА ИСТИНА
	|				КОГДА уатАгрегатыТССрезПоследних.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|					ТОГДА ЛОЖЬ
	|			КОНЕЦ) КАК ТСВыбыло}) КАК ВложенныйЗапрос
	|ГДЕ
	|	ВложенныйЗапрос.ТипАгрегата <> ЗНАЧЕНИЕ(Справочник.уатТипыАгрегатов.Шина)
	|{ГДЕ
	|	ВложенныйЗапрос.Агрегат.*,
	|	ВложенныйЗапрос.Количество,
	|	ВложенныйЗапрос.ТипАгрегата.*,
	|	ВложенныйЗапрос.ДнейОсталось,
	|	ВложенныйЗапрос.СкладТС.*,
	|	ВложенныйЗапрос.ГоденДо,
	|	(ВЫБОР
	|			КОГДА ВложенныйЗапрос.Агрегат.ГоденДо = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			ИНАЧЕ ЛОЖЬ
	|		КОНЕЦ) КАК ВывестиСПустымСрокомГодности}
	|
	|УПОРЯДОЧИТЬ ПО
	|	ВложенныйЗапрос.ТипАгрегата,
	|	ВложенныйЗапрос.Агрегат,
	|	СкладТС
	|{УПОРЯДОЧИТЬ ПО
	|	Агрегат.*,
	|	Количество,
	|	ТипАгрегата.*,
	|	ДнейОсталось}
	|ИТОГИ
	|	СУММА(Количество),
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.Агрегат ЕСТЬ NULL 
	|			ТОГДА 0
	|		ИНАЧЕ СУММА(ДнейОсталось)
	|	КОНЕЦ КАК ДнейОсталось
	|ПО
	|	ТипАгрегата,
	|	Агрегат
	|{ИТОГИ ПО
	|	Агрегат.*,
	|	Количество,
	|	ТипАгрегата.*,
	|	СкладТС.*}";                 
	
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
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ТипАгрегата", Справочники.уатТипыАгрегатов.Аккумулятор);
	
	Пока УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Количество() > 0 Цикл
		
		УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Удалить(УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки[0]);
		
	КонецЦикла;
	
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("СкладТС"            		    , "Склад / ТС");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Агрегат"			            , "Агрегат");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТипАгрегата"   			    , "Тип агрегата");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ГоденДо"  					, "Годен до");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("КоличествоОстаток"            , "Количество");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДнейОсталось"       		    , "Дней осталось");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ВывестиСПустымСрокомГодности" , "Вывести агрегаты с пустым сроком годности");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСВыбыло" 					, "ТС выбыло");
	
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ТипАгрегата");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("СкладТС");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Агрегат");
		
	УниверсальныйОтчет.ДобавитьПоказатель("Количество"    , "Количество, шт" , Истина, "ЧН=0", );
	УниверсальныйОтчет.ДобавитьПоказатель("ДнейОсталось"  , "Дней осталось"  , Истина, "ЧН=0", );
	
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	УниверсальныйОтчет.ДобавитьОтбор("ДнейОсталось"				   , Истина, ВидСравнения.Меньше, 30);
	УниверсальныйОтчет.ДобавитьОтбор("ВывестиСПустымСрокомГодности", Истина, ВидСравнения.Равно , Ложь);
	УниверсальныйОтчет.ДобавитьОтбор("ТСВыбыло"					   , Истина, ВидСравнения.Равно , Ложь);
	
	ЭлементУслОформления = УниверсальныйОтчет.ПостроительОтчета.УсловноеОформление.Добавить(""); 
	ЭлементУслОформления.Использование = Истина; 
	ЭлементОбласть = ЭлементУслОформления.Область.Добавить("ДнейОсталось", "ДнейОсталось", ТипОбластиОформления.Поле); 
		
	ЭлементОформления = ЭлементУслОформления.Оформление.Формат; 
	ЭлементОформления.Использование = Истина; 
	ЭлементОформления.Значение = "ЧН=' '";
	
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
УниверсальныйОтчет.мРежимВводаПериода = 1;
	
#КонецЕсли
