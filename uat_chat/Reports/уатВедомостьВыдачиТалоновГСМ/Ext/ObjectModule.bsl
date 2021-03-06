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
	|	уатОборотыПоЗаправкамГСМОбороты.Период КАК Период,
	|	уатОборотыПоЗаправкамГСМОбороты.Регистратор КАК Регистратор,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Регистратор.Дата, ДЕНЬ) КАК ДатаВыдачиТалона,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, ДЕНЬ) КАК ПериодДень,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, ДЕКАДА) КАК ПериодДекада,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	|	НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, ГОД) КАК ПериодГод,
	|	уатОборотыПоЗаправкамГСМОбороты.АЗС КАК АЗС,
	|	уатОборотыПоЗаправкамГСМОбороты.ТС КАК ТС,
	|	уатОборотыПоЗаправкамГСМОбороты.ТС.ГаражныйНомер КАК ТСГарНомер,
	|	уатОборотыПоЗаправкамГСМОбороты.ТС.ГосударственныйНомер КАК ТСГосНомер,
	|	уатОборотыПоЗаправкамГСМОбороты.Водитель КАК Водитель,
	|	уатОборотыПоЗаправкамГСМОбороты.ПутевойЛист КАК ПутевойЛист,
	|	уатНоменклатураГСМ.НоминалТалона КАК НоминалТалона,
	|	уатНоменклатураГСМ.ГСМТалона КАК ГСМТалона,
	|	уатОборотыПоЗаправкамГСМОбороты.ГСМ КАК Талон,
	|	уатОборотыПоЗаправкамГСМОбороты.НомераТалонов КАК НомераТалонов,
	|	уатОборотыПоЗаправкамГСМОбороты.КоличествоОборот КАК КоличествоЛитров,
	|	уатОборотыПоЗаправкамГСМОбороты.КоличествоТалоновОборот КАК КоличествоТалонов
	|{ВЫБРАТЬ
	|	Период,
	|	Регистратор.*,
	|	ДатаВыдачиТалона КАК ДатаВыдачиТалона,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	АЗС.*,
	|	ТС.*,
	|	ТСГарНомер КАК ТСГарНомер,
	|	ТСГосНомер КАК ТСГосНомер,
	|	Водитель.*,
	|	ПутевойЛист.*,
	|	НоминалТалона,
	|	ГСМТалона.*,
	|	НомераТалонов,
	|	КоличествоЛитров,
	|	КоличествоТалонов,
	|	Талон.*}
	|ИЗ
	|	РегистрНакопления.уатОборотыПоЗаправкамГСМ.Обороты(&ДатаНачала, &ДатаКонца, Регистратор, ВидЗаправки = ЗНАЧЕНИЕ(Перечисление.уатВидыДвиженияГСМ.ЗаправкаТалоны)) КАК уатОборотыПоЗаправкамГСМОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатНоменклатураГСМ КАК уатНоменклатураГСМ
	|		ПО уатОборотыПоЗаправкамГСМОбороты.НоменклатураТалонов = уатНоменклатураГСМ.Номенклатура
	|{ГДЕ
	|	уатОборотыПоЗаправкамГСМОбороты.Период,
	|	уатОборотыПоЗаправкамГСМОбороты.Регистратор.*,
	|	уатОборотыПоЗаправкамГСМОбороты.Регистратор.Дата КАК ДатаВыдачиТалона,
	|	(НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, ДЕНЬ)) КАК ПериодДень,
	|	(НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	|	(НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, ДЕКАДА)) КАК ПериодДекада,
	|	(НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, МЕСЯЦ)) КАК ПериодМесяц,
	|	(НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, КВАРТАЛ)) КАК ПериодКвартал,
	|	(НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, ПОЛУГОДИЕ)) КАК ПериодПолугодие,
	|	(НАЧАЛОПЕРИОДА(уатОборотыПоЗаправкамГСМОбороты.Период, ГОД)) КАК ПериодГод,
	|	уатОборотыПоЗаправкамГСМОбороты.АЗС.*,
	|	уатОборотыПоЗаправкамГСМОбороты.ТС.*,
	|	уатОборотыПоЗаправкамГСМОбороты.ТС.ГаражныйНомер КАК ТСГарНомер,
	|	уатОборотыПоЗаправкамГСМОбороты.ТС.ГосударственныйНомер КАК ТСГосНомер,
	|	уатОборотыПоЗаправкамГСМОбороты.Водитель.*,
	|	уатОборотыПоЗаправкамГСМОбороты.ПутевойЛист.*,
	|	уатНоменклатураГСМ.НоминалТалона,
	|	уатНоменклатураГСМ.ГСМТалона.*,
	|	уатОборотыПоЗаправкамГСМОбороты.НомераТалонов,
	|	уатОборотыПоЗаправкамГСМОбороты.КоличествоОборот,
	|	уатОборотыПоЗаправкамГСМОбороты.КоличествоТалоновОборот,
	|	(ВЫБОР
	|			КОГДА уатОборотыПоЗаправкамГСМОбороты.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			КОГДА уатОборотыПоЗаправкамГСМОбороты.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЛОЖЬ
	|		КОНЕЦ) КАК ТСВыбыло}
	|{УПОРЯДОЧИТЬ ПО
	|	Период,
	|	Регистратор.*,
	|	ДатаВыдачиТалона КАК ДатаВыдачиТалона,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	АЗС.*,
	|	ТС.*,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Водитель.*,
	|	ПутевойЛист.*,
	|	НоминалТалона,
	|	ГСМТалона.*,
	|	НомераТалонов,
	|	КоличествоЛитров,
	|	КоличествоТалонов,
	|	Талон.*}
	|ИТОГИ
	|	СУММА(КоличествоЛитров),
	|	СУММА(КоличествоТалонов)
	|ПО
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	АЗС,
	|	ТС,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Водитель,
	|	ПутевойЛист,
	|	НоминалТалона,
	|	ГСМТалона,
	|	НомераТалонов,
	|	Период,
	|	Регистратор,
	|	ДатаВыдачиТалона
	|{ИТОГИ ПО
	|	Период,
	|	Регистратор.*,
	|	ДатаВыдачиТалона КАК ДатаВыдачиТалона,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	АЗС.*,
	|	ТС.*,
	|	ТСГарНомер,
	|	ТСГосНомер,
	|	Водитель.*,
	|	ПутевойЛист.*,
	|	НоминалТалона,
	|	ГСМТалона.*,
	|	НомераТалонов,
	|	Талон.*}";	
	
	
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
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТС"              , "ТС / оборудование (все поля)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГарНомер"      , "ТС (гар. номер)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГосНомер"      , "ТС (гос. номер)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Период"          , "Дата выдачи талона");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ПутевойЛист"     , "Путевой лист");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("НоминалТалона"   , "Номинал талона");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ГСМТалона"       , "ГСМ талона");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("НомераТалонов"   , "Номера талонов");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("Талон"           , "Вид талона");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ДатаВыдачиТалона", "Дата выдачи талона");
	
	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ГСМТалона");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Талон");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоЛитров" , "Количество литров" , Истина,"ЧДЦ=3", , );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоТалонов", "Количество талонов", Истина,"ЧДЦ=3", , );

	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	УниверсальныйОтчет.ДобавитьОтбор("ТСГосНомер", Ложь  , ВидСравнения.Содержит);
	УниверсальныйОтчет.ДобавитьОтбор("ТСВыбыло"	 , Истина, ВидСравнения.Равно, Ложь);
	
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
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ДатаВыдачиТалона", ТипРазмещенияРеквизитовИзмерений.Отдельно);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("НоминалТалона"   , ТипРазмещенияРеквизитовИзмерений.Отдельно);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("НомераТалонов"   , ТипРазмещенияРеквизитовИзмерений.Отдельно);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ПутевойЛист"     , ТипРазмещенияРеквизитовИзмерений.Отдельно);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТСГосНомер"      , ТипРазмещенияРеквизитовИзмерений.Отдельно);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("Водитель"        , ТипРазмещенияРеквизитовИзмерений.Отдельно);
	
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
	
#КонецЕсли
