﻿#Если Клиент Тогда
	
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
	|	уатОстаткиГСМнаТСОстаткиИОбороты.ТС КАК ТС,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.ТС.ГосударственныйНомер КАК ТСГосНомер,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.ТС.ГаражныйНомер КАК ТСГарНомер,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.ГСМ КАК ГСМ,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.Партия КАК Партия,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоПриход КАК КоличествоПриход,
	|	ВЫБОР
	|		КОГДА (НЕ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ)
	|			ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоРасход
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КоличествоРасход,
	|	ВЫБОР
	|		КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ
	|			ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоРасход
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК КоличествоВозврат,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьНачальныйОстаток КАК СтоимостьНачальныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьПриход КАК СтоимостьПриход,
	|	ВЫБОР
	|		КОГДА (НЕ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ)
	|			ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьРасход
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтоимостьРасход,
	|	ВЫБОР
	|		КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ
	|			ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьРасход
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтоимостьВозврат,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьКонечныйОстаток КАК СтоимостьКонечныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрНачальныйОстаток КАК СтоимостьУпрНачальныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрПриход КАК СтоимостьУпрПриход,
	|	ВЫБОР
	|		КОГДА (НЕ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ)
	|			ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрРасход
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтоимостьУпрРасход,
	|	ВЫБОР
	|		КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ
	|			ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрРасход
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК СтоимостьУпрВозврат,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрКонечныйОстаток КАК СтоимостьУпрКонечныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.Период КАК Период,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор КАК Регистратор,
	|	ВЫБОР
	|		КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор = NULL
	|				ИЛИ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор = НЕОПРЕДЕЛЕНО
	|			ТОГДА уатМестонахождениеТССрезПоследних.Организация
	|		ИНАЧЕ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор.Организация
	|	КОНЕЦ КАК Организация,
	|	НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, ДЕНЬ) КАК ПериодДень,
	|	НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	|	НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, ДЕКАДА) КАК ПериодДекада,
	|	НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, МЕСЯЦ) КАК ПериодМесяц,
	|	НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, КВАРТАЛ) КАК ПериодКвартал,
	|	НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	|	НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, ГОД) КАК ПериодГод
	|{ВЫБРАТЬ
	|	ТС.*,
	|	ТСГосНомер,
	|	ТСГарНомер,
	|	ГСМ.*,
	|	Партия.*,
	|	КоличествоНачальныйОстаток,
	|	КоличествоПриход,
	|	КоличествоРасход,
	|	КоличествоВозврат,
	|	КоличествоКонечныйОстаток,
	|	СтоимостьНачальныйОстаток,
	|	СтоимостьПриход,
	|	СтоимостьРасход,
	|	СтоимостьВозврат,
	|	СтоимостьКонечныйОстаток,
	|	СтоимостьУпрНачальныйОстаток,
	|	СтоимостьУпрПриход,
	|	СтоимостьУпрРасход,
	|	СтоимостьУпрВозврат,
	|	СтоимостьУпрКонечныйОстаток,
	|	Организация,
	|	Период,
	|	Регистратор.*,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод}
	|ИЗ
	|	РегистрНакопления.уатОстаткиГСМнаТС.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор, , ) КАК уатОстаткиГСМнаТСОстаткиИОбороты
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаКонца, ) КАК уатМестонахождениеТССрезПоследних
	|		ПО уатОстаткиГСМнаТСОстаткиИОбороты.ТС = уатМестонахождениеТССрезПоследних.ТС
	|{ГДЕ
	|	уатОстаткиГСМнаТСОстаткиИОбороты.ТС.*,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.ТС.ГосударственныйНомер КАК ТСГосНомер,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.ТС.ГаражныйНомер КАК ТСГарНомер,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.ГСМ.*,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.Партия.*,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоНачальныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоПриход,
	|	(ВЫБОР
	|			КОГДА (НЕ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ)
	|				ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоРасход
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоРасход,
	|	(ВЫБОР
	|			КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ
	|				ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоРасход
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК КоличествоВозврат,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.КоличествоКонечныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьНачальныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьПриход,
	|	(ВЫБОР
	|			КОГДА (НЕ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ)
	|				ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьРасход
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СтоимостьРасход,
	|	(ВЫБОР
	|			КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ
	|				ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьРасход
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СтоимостьВозврат,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьКонечныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрНачальныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрПриход,
	|	(ВЫБОР
	|			КОГДА (НЕ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ)
	|				ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрРасход
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СтоимостьУпрРасход,
	|	(ВЫБОР
	|			КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ
	|				ТОГДА уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрРасход
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК СтоимостьУпрВозврат,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.СтоимостьУпрКонечныйОстаток,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.Период,
	|	уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор.*,
	|	ВЫБОР
	|		КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор = NULL
	|				ИЛИ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор = НЕОПРЕДЕЛЕНО
	|			ТОГДА уатМестонахождениеТССрезПоследних.Организация
	|		ИНАЧЕ уатОстаткиГСМнаТСОстаткиИОбороты.Регистратор.Организация
	|	КОНЕЦ КАК Организация,
	|	(НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, ДЕНЬ)) КАК ПериодДень,
	|	(НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	|	(НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, ДЕКАДА)) КАК ПериодДекада,
	|	(НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, МЕСЯЦ)) КАК ПериодМесяц,
	|	(НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, КВАРТАЛ)) КАК ПериодКвартал,
	|	(НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, ПОЛУГОДИЕ)) КАК ПериодПолугодие,
	|	(НАЧАЛОПЕРИОДА(уатОстаткиГСМнаТСОстаткиИОбороты.Период, ГОД)) КАК ПериодГод,
	|	(ВЫБОР
	|			КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			КОГДА уатОстаткиГСМнаТСОстаткиИОбороты.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЛОЖЬ
	|		КОНЕЦ) КАК ТСВыбыло}
	|{УПОРЯДОЧИТЬ ПО
	|	ТС.*,
	|	ТСГосНомер,
	|	ТСГарНомер,
	|	ГСМ.*,
	|	Партия.*,
	|	Организация,
	|	КоличествоНачальныйОстаток,
	|	КоличествоПриход,
	|	КоличествоРасход,
	|	КоличествоВозврат,
	|	КоличествоКонечныйОстаток,
	|	СтоимостьНачальныйОстаток,
	|	СтоимостьПриход,
	|	СтоимостьРасход,
	|	СтоимостьВозврат,
	|	СтоимостьКонечныйОстаток,
	|	СтоимостьУпрНачальныйОстаток,
	|	СтоимостьУпрПриход,
	|	СтоимостьУпрРасход,
	|	СтоимостьУпрВозврат,
	|	СтоимостьУпрКонечныйОстаток,
	|	Период,
	|	Регистратор.*,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод}
	|ИТОГИ
	|	СУММА(КоличествоНачальныйОстаток),
	|	СУММА(КоличествоПриход),
	|	СУММА(КоличествоРасход),
	|	СУММА(КоличествоВозврат),
	|	СУММА(КоличествоКонечныйОстаток),
	|	СУММА(СтоимостьНачальныйОстаток),
	|	СУММА(СтоимостьПриход),
	|	СУММА(СтоимостьРасход),
	|	СУММА(СтоимостьВозврат),
	|	СУММА(СтоимостьКонечныйОстаток),
	|	СУММА(СтоимостьУпрНачальныйОстаток),
	|	СУММА(СтоимостьУпрПриход),
	|	СУММА(СтоимостьУпрРасход),
	|	СУММА(СтоимостьУпрВозврат),
	|	СУММА(СтоимостьУпрКонечныйОстаток)
	|ПО
	|	Общие,
	|	ТС,
	|	ГСМ,
	|	Партия,
	|	Период,
	|	Организация
	|{ИТОГИ ПО
	|	ТС.*,
	|	ТСГосНомер,
	|	ТСГарНомер,
	|	ГСМ.*,
	|	Партия.*,
	|	Период,
	|	Организация,
	|	Регистратор.*,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод}";
	
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
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТС"        , "ТС / оборудование (все поля)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГарНомер", "ТС (гар. номер)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГосНомер", "ТС (гос. номер)"); 
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ГСМ"		 , "ГСМ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСВыбыло"  , "ТС выбыло");

	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Организация");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ТС");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ГСМ");
	//УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Партия");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток", "Количество", Истина,"ЧДЦ=3", "НачальныйОстаток","Начальный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьНачальныйОстаток" , "Стоимость" , Истина,"ЧДЦ=2", "НачальныйОстаток","Начальный остаток" );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоПриход"          , "Количество", Истина,"ЧДЦ=3", "приход","Приход");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьПриход"           , "Стоимость" , Истина,"ЧДЦ=2", "приход","Приход" );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоРасход"          , "Количество", Истина,"ЧДЦ=3", "Расход","Расход");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьРасход"           , "Стоимость" , Истина,"ЧДЦ=2", "Расход","Расход" );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоВозврат"         , "Количество", Истина,"ЧДЦ=3", "Возврат","Возврат на склад");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьВозврат"          , "Стоимость" , Истина,"ЧДЦ=2", "Возврат","Возврат на склад" );
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток" , "Количество", Истина,"ЧДЦ=3", "КонечныйОстаток","Конечный остаток");
	УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьКонечныйОстаток"  , "Стоимость" , Истина,"ЧДЦ=2", "КонечныйОстаток","Конечный остаток" );
	
	Если уатРаботаСМетаданными.уатЕстьКонстанта("ВалютаУправленческогоУчета") тогда
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрНачальныйОстаток", "Стоимость (упр)" , Истина,"ЧДЦ=2", "НачальныйОстаток","Начальный остаток" );
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрПриход"          , "Стоимость (упр)" , Истина,"ЧДЦ=2", "приход" ,"Приход" );
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрРасход"          , "Стоимость (упр)" , Истина,"ЧДЦ=2", "Расход" ,"Расход" );
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрВозврат"         , "Стоимость (упр)" , Истина,"ЧДЦ=2", "Возврат","Возврат на склад" );
		УниверсальныйОтчет.ДобавитьПоказатель("СтоимостьУпрКонечныйОстаток" , "Стоимость (упр)" , Истина,"ЧДЦ=2", "КонечныйОстаток","Конечный остаток" );
	КонецЕсли;

	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	УниверсальныйОтчет.ДобавитьОтбор("ТСГосНомер", Ложь  , ВидСравнения.Содержит);
	УниверсальныйОтчет.ДобавитьОтбор("ГСМ");
	УниверсальныйОтчет.ДобавитьОтбор("ТСВыбыло"  , Истина, ВидСравнения.Равно, Ложь);
	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ВыполнениеЗаказовНаТС", "ЗаказНаТС");	
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТСГосНомер",);
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТС.Модель");

	
	ЗапросПоОрганизациям = Новый Запрос;
	ЗапросПоОрганизациям.Текст = "ВЫБРАТЬ
	|	уатПраваИНастройки.Объект КАК Организация,
	|	уатПраваИНастройки.Значение КАК ТочностьОстатковТоплива
	|ИЗ
	|	РегистрСведений.уатПраваИНастройки КАК уатПраваИНастройки
	|ГДЕ
	|	уатПраваИНастройки.Объект ССЫЛКА Справочник.Организации
	|	И уатПраваИНастройки.ПравоНастройка = ЗНАЧЕНИЕ(ПланВидовХарактеристик.уатПраваИНастройки.ТочностьОстатковТоплива)";
	
	Организации = ЗапросПоОрганизациям.Выполнить().Выгрузить();
	Для Каждого ТекСтрока Из Организации Цикл
		ЭлементУслОформления = УниверсальныйОтчет.ПостроительОтчета.УсловноеОформление.Добавить(""); 
		ЭлементУслОформления.Использование = Истина; 
		
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("КоличествоНачальныйОстаток", "КоличествоНачальныйОстаток", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("КоличествоПриход", "КоличествоПриход", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("КоличествоРасход", "КоличествоРасход", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("КоличествоВозврат", "КоличествоВозврат", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("КоличествоКонечныйОстаток", "КоличествоКонечныйОстаток", ТипОбластиОформления.Поле); 
		
		ЭлементОтбор = ЭлементУслОформления.Отбор.Добавить("Организация", "Организация", "Организация"); 
		ЭлементОтбор.Использование = Истина; 
		ЭлементОтбор.ВидСравнения = ВидСравнения.Равно; 
		ЭлементОтбор.Значение = ТекСтрока.Организация;
		
		ЭлементОформления = ЭлементУслОформления.Оформление.Формат; 
		ЭлементОформления.Использование = Истина; 
		ЭлементОформления.Значение = "ЧДЦ=" + ТекСтрока.ТочностьОстатковТоплива;
	КонецЦикла;

	
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
