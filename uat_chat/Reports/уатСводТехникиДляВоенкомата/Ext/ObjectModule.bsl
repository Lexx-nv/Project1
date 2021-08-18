﻿#Если Клиент Тогда

////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	Текст =	
	
	"ВЫБРАТЬ
	|	1 КАК КоличествоТС,
	|	уатТС.ОсновноеСредство,
	|	уатМестонахождениеТССрезПоследних.Колонна,
	|	уатМестонахождениеТССрезПоследних.Организация,
	|	""Исправен"" КАК ТехническоеСостояние,
	|	уатТС.ГосударственныйНомер,
	|	уатТС.ГаражныйНомер,
	|	уатТС.Модель.ОбъемБака КАК ОбъемБака,
	|	уатТС.ГодВыпуска,
	|	уатТС.Модель,
	|	уатТС.ТипТС,
	|	уатТС.ТипТС.ВидТС КАК ТипТСУкрупненный,
	|	уатТС.Модель.ОсновноеТопливо КАК ОсновноеТопливо,
	|	уатТС.СобственныйВес КАК МассаБезНагрузки,
	|	уатТС.СобственныйВес + уатТС.Модель.Грузоподъемность КАК МассаПолная,
	|	уатТС.Модель.Код КАК КодМарки,
	|	уатВыработкаТСОбороты.КоличествоОборот,
	|	ВЫБОР
	|		КОГДА уатТС.Модель.НаличиеСпидометра
	|			ТОГДА уатВыработкаТСОбороты.КоличествоОборот + уатТС.НачальныйПробег
	|		ИНАЧЕ уатВыработкаТСОбороты.КоличествоОборот / 3600 + уатТС.НачальнаяНаработка
	|	КОНЕЦ КАК Пробег,
	|	ВложенныйЗапрос.ДатаОкончания,
	|	ВложенныйЗапрос.Серия КАК ПТССерия,
	|	ВложенныйЗапрос.Номер КАК ПТСНомер,
	|	ВложенныйЗапрос.ДатаОкончания КАК ПТСДатаОкончания,
	|	уатТС.ДатаПостановкиНаУчетГИБДД
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаКон, ) КАК уатМестонахождениеТССрезПоследних
	|		ПО (уатМестонахождениеТССрезПоследних.ТС = уатТС.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.уатВыработкаТС.Обороты(
	|				,
	|				&ДатаКон,
	|				,
	|				ПараметрВыработки = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ВремяВРаботе)
	|					ИЛИ ПараметрВыработки = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ПробегОбщий)) КАК уатВыработкаТСОбороты
	|		ПО (уатВыработкаТСОбороты.ТС = уатТС.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ ПЕРВЫЕ 1
	|			уатДокументыТС.ТС КАК ТС,
	|			уатДокументыТС.ВидДокумента КАК ВидДокумента,
	|			уатДокументыТС.ДатаОкончания КАК ДатаОкончания,
	|			уатДокументыТС.Серия КАК Серия,
	|			уатДокументыТС.Номер КАК Номер
	|		ИЗ
	|			РегистрСведений.уатДокументыТС КАК уатДокументыТС
	|		ГДЕ
	|			уатДокументыТС.ВидДокумента = ЗНАЧЕНИЕ(Справочник.уатВидыДДД.ПТС)
	|			И уатДокументыТС.Архив = ЛОЖЬ
	|		
	|		СГРУППИРОВАТЬ ПО
	|			уатДокументыТС.ТС,
	|			уатДокументыТС.ВидДокумента,
	|			уатДокументыТС.ДатаОкончания,
	|			уатДокументыТС.Серия,
	|			уатДокументыТС.Номер
	|		
	|		ИМЕЮЩИЕ
	|			уатДокументыТС.ДатаОкончания = МАКСИМУМ(уатДокументыТС.ДатаОкончания)) КАК ВложенныйЗапрос
	|		ПО уатТС.Ссылка = ВложенныйЗапрос.ТС
	|ГДЕ
	|	уатМестонахождениеТССрезПоследних.Организация = &Организация
	|	И уатТС.ДатаВыбытия = &ПустаяДата
	|	И уатТС.ВидМоделиТС = ЗНАЧЕНИЕ(Перечисление.уатВидыМоделейТС.Автотранспорт)";
	
	ПостроительОтчета.Текст = Текст;
	
	ПостроительОтчета.ЗаполнитьНастройки();
	
	//заплняем поля отбора

	мОтборОрганизация 				= ПостроительОтчета.Отбор.Добавить("Организация");
	мОтборОрганизация.Значение 		= Организация;
	мОтборОрганизация.Использование = Истина;
	//
	//ПостроительОтчета.Отбор.Добавить("Модель").Использование	= Ложь;
	//ПостроительОтчета.Отбор.Добавить("Колонна").Использование	= Ложь;

	
	//ПостроительОтчета.ИзмеренияСтроки.Очистить();
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//  ДокументРезультат - табличный документ, формируемый отчетом
//
Процедура СформироватьОтчет(ДокументРезультат,  ПоказыватьЗаголовок = Истина, ВысотаЗаголовка = 0) Экспорт
	
	ДокументРезультат.Очистить();
	
	// Если организация не заполнена, то фильтр по ней отключаем
	ПостроительОтчета.Отбор["Организация"].Использование = ЗначениеЗаполнено(Организация);
	
	Макет       = ПолучитьМакет("Макет");
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");
	
	// Вывод заголовка отчета
	ОбластьЗаголовка = СформироватьЗаголовок();
	ВысотаЗаголовка  = ОбластьЗаголовка.ВысотаТаблицы;
	
	ДокументРезультат.Вывести(ОбластьЗаголовка, 1);
	
	МассивГруппировок = Новый Массив;
	
	Для Сч=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1  Цикл
		МассивГруппировок.Добавить(ПостроительОтчета.ИзмеренияСтроки[Сч].Имя);
	КонецЦикла;
	
	МассивПоказателей = Новый Массив;
	
	МассивПоказателей.Добавить("Колонна");
	МассивПоказателей.Добавить("ГаражныйНомер");
	МассивПоказателей.Добавить("ДатаПостановкиНаУчетГИБДД");
	МассивПоказателей.Добавить("КодМарки");
	МассивПоказателей.Добавить("ТипТС");
	МассивПоказателей.Добавить("Модель");
	МассивПоказателей.Добавить("ГодВыпуска");
	МассивПоказателей.Добавить("ГосударственныйНомер");
	МассивПоказателей.Добавить("ПТССерия");
	МассивПоказателей.Добавить("ПТСНомер");
	МассивПоказателей.Добавить("Пробег");
	МассивПоказателей.Добавить("ОсновноеТопливо");
	МассивПоказателей.Добавить("ОбъемБака");
	МассивПоказателей.Добавить("МассаПолная");
	МассивПоказателей.Добавить("МассаБезНагрузки");
	МассивПоказателей.Добавить("ТехническоеСостояние");
	
	
	// Формат показателей
	ФорматПоказателей = Новый Структура;
	
	Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
		Если ИмяПоказателя = "ГодВыпуска" Тогда
			ФорматПоказателей.Вставить(ИмяПоказателя ,"ЧДЦ=0; ЧГ=0; ДФ=dd.MM.yyyy");
		Иначе
			ФорматПоказателей.Вставить(ИмяПоказателя ,"ЧЦ=15; ЧДЦ=2; ДФ=dd.MM.yyyy");
		КонецЕсли;
	КонецЦикла;
	
	ПостроительОтчета.Параметры.Вставить("ДатаКон" 	  , КонецДня(ДатаОтчета));
	ПостроительОтчета.Параметры.Вставить("Организация", Организация);
	ПостроительОтчета.Параметры.Вставить("ПустаяДата" , Дата('00010101'));
	
	ПостроительОтчета.Выполнить();
	
	РезультатЗапроса = ПостроительОтчета.Результат;
	
	ЗаголовокОтчета = Макет.ПолучитьОбласть("ЗаголовокОтчета");
	
	ДокументРезультат.Вывести(ЗаголовокОтчета, 1);
	
	// Сдвиг уровня выводимой группировки отчета относительно группировки запроса
	СдвигУровня = 0;
	
	// Флаг сброса сдвига уровня при выводе группировки по счету
	СброситьСдвигУровня = Истина;
	
	ОбластьСтрока					= Макет.ПолучитьОбласть("Строка");
	ОбластьИтогиТипТС				= Макет.ПолучитьОбласть("ИтогиТипТС");
	ОбластьИтогиТипТСУкрупненный	= Макет.ПолучитьОбласть("ИтогиТипТСУкрупненный");
	ОбластьПустаяСтрока				= Макет.ПолучитьОбласть("ПустаяСтрока");
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ОбластьСтрока",					ОбластьСтрока);
	СтруктураПараметров.Вставить("ОбластьИтогиТипТС",				ОбластьИтогиТипТС);
	СтруктураПараметров.Вставить("ОбластьИтогиТипТСУкрупненный",	ОбластьИтогиТипТСУкрупненный);
	СтруктураПараметров.Вставить("ОбластьПустаяСтрока",				ОбластьПустаяСтрока);
	СтруктураПараметров.Вставить("ДокументРезультат",				ДокументРезультат);
	СтруктураПараметров.Вставить("ФорматПоказателей",				ФорматПоказателей);
	СтруктураПараметров.Вставить("МассивПоказателей",				МассивПоказателей);
	
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	
	Если МассивГруппировок.Количество() > 0 Тогда
		ВывестиГруппировку(РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, МассивГруппировок[0]), 
		0, МассивГруппировок, СдвигУровня, СброситьСдвигУровня, СтруктураПараметров);
	Иначе						
		ВывестиСтроки(РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ""),СтруктураПараметров);
	КонецЕсли;
	
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
		
	// Заполним общую расшифровку:
	СтруктураНастроекОтчета = Новый Структура;
	
	СтруктураНастроекОтчета.Вставить("ДатаОтчета", ДатаОтчета);
	СтруктураНастроекОтчета.Вставить("ПоказыватьЗаголовок", ПоказыватьЗаголовок);
	
	ДокументРезультат.Область(1,1).Расшифровка = СтруктураНастроекОтчета;
	
	// Зафиксируем заголовок отчета
	ДокументРезультат.ФиксацияСверху = ВысотаЗаголовка + 1;
	
	// Первую колонку не печатаем
	ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(1,2,ДокументРезультат.ВысотаТаблицы,ДокументРезультат.ШиринаТаблицы);
	
	// Ориентация страницы
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ДокументРезультат.ПолеСлева = 0;
	ДокументРезультат.ПолеСправа = 0;
	ДокументРезультат.Автомасштаб = Истина;
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "СписокТехникиВРазрезеМоделейИТипов_Вар1";
	ДокументРезультат.ТолькоПросмотр = уатПраваИНастройки.уатПраво("ЗащитаПечатныхФорм", глПраваУАТ);

	
КонецПроцедуры // СформироватьОтчет()

// Выводит заголовок отчета
//
// Параметры:
//	Нет.
//
Функция СформироватьЗаголовок() Экспорт
	
	// Вывод заголовка, описателя периода и фильтров и заголовка
	ОписаниеПериода = "данные на " + Строка(Формат(ДатаОтчета, "ДФ=dd.MM.yyyy"));
	
	Макет = ПолучитьМакет("Макет");
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");
	
	НазваниеОрганизации = Организация.НаименованиеПолное;
	Если ПустаяСтрока(НазваниеОрганизации) Тогда
		НазваниеОрганизации = Организация;
	КонецЕсли;
	
	Если Не ПустаяСтрока(НазваниеОрганизации) Тогда
		НазваниеОрганизации = " в " + НазваниеОрганизации;
	КонецЕсли;
	
	ЗаголовокОтчета.Параметры.ОписаниеПериода = ОписаниеПериода;
	
	ЗаголовокОтчета.Параметры.Заголовок = ЗаголовокОтчета() + НазваниеОрганизации;
	
	Возврат(ЗаголовокОтчета);
	
КонецФункции // СформироватьЗаголовок()

// Выводит показатели группировки
//
// Параметры:
//	Выборка - выборка
//	ЭтоПерваяСтрока - признак вывода отступов перед субконто
//
Процедура ВывестиПоказатели(Выборка, СтруктураПараметров)
	
	ДокументРезультат = СтруктураПараметров.ДокументРезультат;
	
	Если Выборка.Группировка() = "ТипТСУкрупненный" Тогда
		Область = СтруктураПараметров.ОбластьИтогиТипТСУкрупненный;
		Область.Параметры.ТипТСУкрупненный	= ВРег(Выборка.ТипТСУкрупненный);
		Область.Параметры.КоличествоТС		= Выборка.КоличествоТС;
		
	ИначеЕсли Выборка.Группировка() = "ТипТС" Тогда
		Область = СтруктураПараметров.ОбластьИтогиТипТС;
		Область.Параметры.ТипТС			= Выборка.ТипТС;
		Область.Параметры.КоличествоТС	= Выборка.КоличествоТС;
		
	Иначе
		Область = СтруктураПараметров.ОбластьСтрока;
		Область.Параметры.РасшифровкаТС = Выборка.ОсновноеСредство;

		Для Каждого ИмяПоказателя Из СтруктураПараметров.МассивПоказателей Цикл
			ФорматПоказателя = "";
			СтруктураПараметров.ФорматПоказателей.Свойство(ИмяПоказателя, ФорматПоказателя);
			Область.Параметры[ИмяПоказателя]  = СокрЛП(Формат(Выборка[ИмяПоказателя], ФорматПоказателя));
		КонецЦикла;

	КонецЕсли;
	
	Область.Область("R1C2").Отступ = Макс(Выборка.Уровень() - 1, 0);
	
	ДокументРезультат.Вывести(Область, Выборка.Уровень());
	
КонецПроцедуры // ВывестиПоказатели()

// Выводит строки
//
// Параметры:
//	Выборка - выборка
//
Процедура ВывестиСтроки(Выборка, СтруктураПараметров)
	
	ДокументРезультат = СтруктураПараметров.ДокументРезультат;
	Область = СтруктураПараметров.ОбластьСтрока;
	
	Пока Выборка.Следующий() Цикл
		ВывестиПоказатели(Выборка, СтруктураПараметров); 	
	КонецЦикла;
	
КонецПроцедуры // ВывестиПоказатели()

// Выводит группировку при развороте счета по субсчетам и/или субконто
//
// Параметры:
//	Выборка         - выборка из результата запроса по выводимой группировке,
//	ИндексТекущейГруппировки - индекс выводимой группировки в массиве группировок,
//	МассивГруппировок - массив, содержащий имена группировок, по которым строится разворот счета,
//	Уровень 		- уровень  группировки верхнего уровня
//	СдвигУровня     - сдвиг уровня группировки отчета относительно уровня группировки запроса,
//	СброситьСдвигУровня - признак сброса сдвига уровня,
//	ПоВалютам       - признак вывода валют и валютных сумм,
//	СтрокаРазвернутогоСальдо - строка таблицы значений с развернутым сальдо по текущему счету.
//	СтруктураОбщийИтог - структура, в которой накапливаются общие итоги
//	СтруктураПараметров - структура, содержащая неизменные для разворота счета параметры:
//	                      Области макета табличного документа, линии, уровень группировки, 
//	                      с которой начался вывод отчета.
//
Процедура ВывестиГруппировку(Выборка, Знач ИндексТекущейГруппировки, МассивГруппировок, СдвигУровня, 
	СброситьСдвигУровня, СтруктураПараметров)
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Группировка() = "ТипТСУкрупненный" Тогда
			ВывестиПоказатели(Выборка, СтруктураПараметров);
			ВывестиГруппировку(Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, МассивГруппировок[1]), 
				1, МассивГруппировок, СдвигУровня, СброситьСдвигУровня, СтруктураПараметров);
			
		ИначеЕсли Выборка.Группировка() = "ТипТС" Тогда
			ВывестиПоказатели(Выборка, СтруктураПараметров);
			ВывестиСтроки(Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ""), СтруктураПараметров); 

		Иначе
			ВывестиПоказатели(Выборка, СтруктураПараметров);
			ВывестиСтроки(Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ""),СтруктураПараметров); 
			
		КонецЕсли;
		
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Настраивает отчет по заданным параметрам (например, для расшифровки)
Процедура Настроить(СтруктураПараметров) Экспорт
	
	Параметры = Новый Соответствие;
	
	Для каждого Элемент Из СтруктураПараметров Цикл
		Параметры.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла; 
	
	//Организация = Параметры["Организация"];
	ДатаНач = Параметры["ДатаНач"];
	ДатаКон = Параметры["ДатаКон"];
	
	ЗаполнитьНачальныеНастройки();
	
	СтрокиОтбора = Параметры["Отбор"];
	
	Если ТипЗнч(СтрокиОтбора) = Тип("Соответствие")
		ИЛИ ТипЗнч(СтрокиОтбора) = Тип("Структура") Тогда
		
		Для каждого Строка Из СтрокиОтбора Цикл
			
			ЭлементОтбора = Неопределено;
			
			// Установим существующие элементы, добавим новые
			Для Инд = 0 По ПостроительОтчета.Отбор.Количество()-1 Цикл
				
				Если Строка.Ключ = ПостроительОтчета.Отбор[Инд].ПутьКДанным Тогда
					ЭлементОтбора = ПостроительОтчета.Отбор[Инд];
				КонецЕсли;
				
			КонецЦикла; 
			
			Если ЭлементОтбора = Неопределено Тогда
				
				ЭлементОтбора = ПостроительОтчета.Отбор.Добавить(Строка.Ключ);
				
			КонецЕсли; 
			ЭлементОтбора.Установить(Строка.Значение);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Функция возвращает текст заголовка отчета
//
Функция ЗаголовокОтчета() Экспорт
	Возврат "Свод о наличии техники для военкомата";
КонецФункции // ЗаголовокОтчета()


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// Параметры для выбора организации
Организация  = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");

#КонецЕсли
