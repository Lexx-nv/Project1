﻿Перем ИмяФайла;


// Выделяет из переданной строки первое значение
 //  до символа "TAB"
 //
 // Параметры: 
 //  ИсходнаяСтрока - Строка - строка для разбора
 //
 // Возвращаемое значение:
 //  подстроку до символа "TAB"
 //
Функция ВыделитьПодСтроку(ИсходнаяСтрока)

	Перем ПодСтрока;
	
    Поз = Найти(ИсходнаяСтрока,Символы.Таб);
	Если Поз > 0 Тогда
		ПодСтрока = Лев(ИсходнаяСтрока,Поз-1);
		ИсходнаяСтрока = Сред(ИсходнаяСтрока,Поз+1);
	Иначе
		ПодСтрока = ИсходнаяСтрока;
		ИсходнаяСтрока = "";
	КонецЕсли;
	
	Возврат ПодСтрока;
 
 КонецФункции // ВыделитьПодСтроку()

 
////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТИРУЕМЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Производит загрузку курсов и кратностей валют с сайта РБК.
//
// Параметры:
//  ИндикаторФормы     - ЭлементыФормы типа Индикатор - для отработки индикатора формы
//  НадписьВалютыФормы - ЭлементыФормы типа Надпись  - Для отработки надписи 
//													   загружаемой валюты
//
Процедура ЗагрузитьКурсыСРБК(ИндикаторФормы = "",НадписьВалютыФормы = "") Экспорт
	
	Перем HTTP;
	#Если Клиент Тогда
	ОтрабатыватьИндикатор = Ложь;
	ОтрабатыватьНадпись   = Ложь;
	Если ТипЗнч(ИндикаторФормы) = Тип("Индикатор") Тогда
		ОтрабатыватьИндикатор = Истина;
	КонецЕсли;	
	Если ТипЗнч(НадписьВалютыФормы) = Тип("Надпись") Тогда
		ОтрабатыватьНадпись = Истина;
	КонецЕсли;	
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();

	Текст = Новый ТекстовыйДокумент();

	СерверИсточник = "cbrates.rbc.ru";
	ОбработкаПолученияФайлов = Обработки.ПолучениеФайловИзИнтернета.Создать();

	Адрес1 = "tsv/cb/";  // в интервале
	Адрес2 = "tsv/";     // по 1 дате
	Если НачДата = КонДата Тогда  // по 1 дате
		Адрес = Адрес2;
		ТМП   = "/"+Формат(Год(КонДата),"ЧРГ=; ЧГ=0")+"/"+Формат(Месяц(КонДата),"ЧЦ=2;ЧДЦ=0;ЧВН=")+"/"+Формат(День(КонДата),"ЧЦ=2;ЧДЦ=0;ЧВН=");
	Иначе    // в интервале
		Адрес = Адрес1;
		ТМП   = "";
	КонецЕсли;

	ВремКаталог = КаталогВременныхФайлов() + "tempKurs";
	СоздатьКаталог(ВремКаталог);
	УдалитьФайлы(ВремКаталог,"*.*");
	
	Для каждого СтрокаСпВалют из СписокВалют Цикл

		ТекВалюта = СтрокаСпВалют.Валюта;
		Стр = "";
		ИмяВходящегоФайла = "" + ВремКаталог + "\" + ИмяФайла;
		СтрокаПараметраПолучения = Адрес + Прав(ТекВалюта.Код,3) + ТМП + ".tsv";
		Если ОбработкаПолученияФайлов.ЗапроситьФайлыССервера(СерверИсточник, СтрокаПараметраПолучения, ИмяВходящегоФайла, HTTP) <> Истина Тогда
			Сообщить("Не удалось получить ресурс для валюты " + СокрЛП(ТекВалюта.Наименование) + " (код " + ТекВалюта.Код + "). Курс для валюты не загружен."); 
			Продолжить;
		КонецЕсли; 

		ВходящийФайл = Новый Файл(ИмяВходящегоФайла);
		Если НЕ ВходящийФайл.Существует() Тогда
			Сообщить("Не удалось получить ресурс для валюты " + СокрЛП(ТекВалюта.Наименование) + " (код " + ТекВалюта.Код + "). Курс для валюты не загружен."); 
			Продолжить;
		КонецЕсли;	

		Текст.Прочитать(ИмяВходящегоФайла,КодировкаТекста.ANSI);
		
		КолСтрок = Текст.КоличествоСтрок();
		Для Инд = 1 По КолСтрок Цикл
			Если ОтрабатыватьНадпись Тогда
				НадписьВалютыФормы.Заголовок = "" + СокрЛП(ТекВалюта.Наименование);
			КонецЕсли;	

			Если ОтрабатыватьИндикатор Тогда
				ИндикаторФормы.Значение = Инд/КолСтрок * 100;
			КонецЕсли;	
				
			Стр = Текст.ПолучитьСтроку(Инд);
			Если (Стр = "") ИЛИ (Найти(Стр,Символы.Таб) = 0) Тогда
			   Продолжить;
			КонецЕсли;
			Если НачДата = КонДата Тогда  
			   ДатаКурса = КонДата;
			Иначе 
			   ДатаКурсаСтр = ВыделитьПодСтроку(Стр);
			   ДатаКурса    = Дата(Лев(ДатаКурсаСтр,4),Сред(ДатаКурсаСтр,5,2),Сред(ДатаКурсаСтр,7,2));
			КонецЕсли;
			Кратность = Число(ВыделитьПодСтроку(Стр));
			Курс      = Число(ВыделитьПодСтроку(Стр));

			Если ДатаКурса > КонДата Тогда
			   Прервать;
			КонецЕсли;

			Если ДатаКурса < НачДата Тогда 
			   Продолжить;
			КонецЕсли;

            ЗаписьКурсовВалют.Валюта = ТекВалюта;
			ЗаписьКурсовВалют.Период = ДатаКурса;
			ЗаписьКурсовВалют.Прочитать();
			ЗаписьКурсовВалют.Валюта    = ТекВалюта;
			ЗаписьКурсовВалют.Период    = ДатаКурса;
			ЗаписьКурсовВалют.Курс      = Курс;
			ЗаписьКурсовВалют.Кратность = Кратность;
			ЗаписьКурсовВалют.Записать();
		КонецЦикла;	   
	КонецЦикла;	
	УдалитьФайлы(ВремКаталог,"*.*");
    #КонецЕсли
КонецПроцедуры // ЗагрузитьКурсыСРБК()

// Процедура выполняет заполнение списка валют из макета с перечнем валют.
//
// Параметры:
//  ЗаполнятьТолькоВалютамиБезАктуальныхКурсов - признак заполнения списка только валютами, для которых
//                 нет актуальных курсов
//
Процедура ЗаполнитьВалюты(ЗаполнятьТолькоВалютамиБезАктуальныхКурсов = Ложь) Экспорт
	
	СписокВалют.Очистить();
	СправочникВалюты = Справочники.Валюты;
	ВыборкаВалют = СправочникВалюты.Выбрать();
	МакетОКВ = Справочники.Валюты.ПолучитьМакет("КлассификаторВалют");
	ОбластьКоды = МакетОКВ.Область("КодЧисловой");
	
	РегистрКурсыВалют = РегистрыСведений.КурсыВалют;
	ЗаписьКурсовВалют = РегистрКурсыВалют.СоздатьМенеджерЗаписи();
	
	Пока ВыборкаВалют.Следующий() Цикл
		ТекущаяВалюта = ВыборкаВалют.Ссылка;
		КодТекущейВалюты = СокрЛП(ТекущаяВалюта.Код);
		НайденнаяОбласть = МакетОКВ.НайтиТекст(КодТекущейВалюты,,ОбластьКоды);
		Если НайденнаяОбласть = Неопределено ИЛИ НайденнаяОбласть.Верх=2 Тогда
			Продолжить;
		КонецЕсли;	
		
		Если ЗаполнятьТолькоВалютамиБезАктуальныхКурсов Тогда
			ЗаписьКурсовВалют.Валюта = ТекущаяВалюта;
			ЗаписьКурсовВалют.Период = ?(Не ЗначениеЗаполнено(КонДата), ТекущаяДата(), КонДата);
			ЗаписьКурсовВалют.Прочитать();
			Если ЗаписьКурсовВалют.Выбран() Тогда
				Продолжить;
			КонецЕсли;
		КонецЕсли;
		
		СтрокаСпискаВалют = СписокВалют.Добавить();
		СтрокаСпискаВалют.Валюта = ТекущаяВалюта;
	КонецЦикла;	
	
КонецПроцедуры // ЗаполнитьВалюты() 


////////////////////////////////////////////////////////////////////////////////
// ОПЕРАТОРЫ ОСНОВНОЙ ПРОГРАММЫ

ИмяФайла = "Curses.txt";  

