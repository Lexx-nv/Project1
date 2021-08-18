﻿	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ
//

// Выполняет преобразование таблицы данных по калибровочному графику
//
Функция ПреобразоватьДанныеДатчикаПоКалибровочномуГрафику(ТабДанных, КалибровочныйГрафик)
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ ТЗ ИЗ &ТЗ КАК ТЗ";
	Запрос.УстановитьПараметр("ТЗ", ТабДанных);
    Запрос.Выполнить();
	
	Запрос.УстановитьПараметр("КалибровочныйГрафик", КалибровочныйГрафик);
	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ТабДанных.Период КАК Период,
	               |	ТабДанных.Широта,
	               |	ТабДанных.Долгота,
	               |	ВЫРАЗИТЬ((ДанныеКалибровки.Выход1 - ДанныеКалибровки.Выход2) / (ДанныеКалибровки.Вход1 - ДанныеКалибровки.Вход2) * ТабДанных.Значение + (ДанныеКалибровки.Вход1 * ДанныеКалибровки.Выход2 - ДанныеКалибровки.Вход2 * ДанныеКалибровки.Выход1) / (ДанныеКалибровки.Вход1 - ДанныеКалибровки.Вход2) КАК ЧИСЛО(15, 1)) КАК Значение
	               |ИЗ
	               |	ТЗ КАК ТабДанных
	               |		ЛЕВОЕ СОЕДИНЕНИЕ (ВЫБРАТЬ
	               |			НаборДанныхГрафика.Вход1 КАК Вход1,
	               |			НаборДанныхГрафика.Выход1 КАК Выход1,
	               |			НаборДанныхГрафика.Вход2 КАК Вход2,
	               |			ItobКалибровочныеГрафикиПоказатели.Выход КАК Выход2
	               |		ИЗ
	               |			(ВЫБРАТЬ
	               |				ItobКалибровочныеГрафикиПоказатели.Вход КАК Вход1,
	               |				ItobКалибровочныеГрафикиПоказатели.Выход КАК Выход1,
	               |				МИНИМУМ(ItobКалибровочныеГрафикиПоказатели1.Вход) КАК Вход2
	               |			ИЗ
	               |				Справочник.ItobКалибровочныеГрафики.Показатели КАК ItobКалибровочныеГрафикиПоказатели,
	               |				Справочник.ItobКалибровочныеГрафики.Показатели КАК ItobКалибровочныеГрафикиПоказатели1
	               |			ГДЕ
	               |				ItobКалибровочныеГрафикиПоказатели.Ссылка = &КалибровочныйГрафик
	               |				И ItobКалибровочныеГрафикиПоказатели1.Ссылка = &КалибровочныйГрафик
	               |				И ItobКалибровочныеГрафикиПоказатели1.Вход > ItobКалибровочныеГрафикиПоказатели.Вход
	               |			
	               |			СГРУППИРОВАТЬ ПО
	               |				ItobКалибровочныеГрафикиПоказатели.Вход,
	               |				ItobКалибровочныеГрафикиПоказатели.Выход) КАК НаборДанныхГрафика
	               |				ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ItobКалибровочныеГрафики.Показатели КАК ItobКалибровочныеГрафикиПоказатели
	               |				ПО НаборДанныхГрафика.Вход2 = ItobКалибровочныеГрафикиПоказатели.Вход
	               |					И (ItobКалибровочныеГрафикиПоказатели.Ссылка = &КалибровочныйГрафик)) КАК ДанныеКалибровки
	               |		ПО (ТабДанных.Значение МЕЖДУ ДанныеКалибровки.Вход1 И ДанныеКалибровки.Вход2),
	               |	(ВЫБРАТЬ
	               |		ItobКалибровочныеГрафикиПоказатели.Ссылка КАК График,
	               |		МИНИМУМ(ItobКалибровочныеГрафикиПоказатели.Вход) КАК МинВход,
	               |		МАКСИМУМ(ItobКалибровочныеГрафикиПоказатели.Вход) КАК МаксВход
	               |	ИЗ
	               |		Справочник.ItobКалибровочныеГрафики.Показатели КАК ItobКалибровочныеГрафикиПоказатели
	               |	ГДЕ
	               |		ItobКалибровочныеГрафикиПоказатели.Ссылка = &КалибровочныйГрафик
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ItobКалибровочныеГрафикиПоказатели.Ссылка) КАК ДиапазонВходаКалибровки
	               |ГДЕ
	               |	ТабДанных.Широта <> 0
	               |	И ТабДанных.Долгота <> 0
	               |	И ВЫБОР
	               |			КОГДА ДиапазонВходаКалибровки.График.ДопускатьЗначенияВнеВходногоДиапазона
	               |				ТОГДА ИСТИНА
	               |			ИНАЧЕ ТабДанных.Значение МЕЖДУ ДиапазонВходаКалибровки.МинВход И ДиапазонВходаКалибровки.МаксВход
	               |		КОНЕЦ
	               |	И (НЕ ДанныеКалибровки.Вход1 ЕСТЬ NULL )
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Период";	
	
				   
	Возврат Запрос.Выполнить().Выгрузить();	

КонецФункции // ПреобразоватьДанныеДатчикаПоКалибровочномуГрафику()

// Функция выполняет формирование табличного документа отчета по аналоговым датчикам.
//
Функция СформироватьОтчетПоАналоговымДатчикам(НачПериода, КонПериода, ТекущийОбъект, ТекущийДатчик, ПреобразоватьПоКалибровке)
    	
	Терминал = Неопределено;
	КалибровочныйГрафик = Неопределено;
	
	СрезНаНачало = РегистрыСведений.ItobПривязкиТерминалов.ПолучитьПоследнее(НачалоДня(КонПериода)-1, Новый Структура("Объект", ТекущийОбъект));
	Если ЗначениеЗаполнено(СрезНаНачало.Терминал) Тогда
		Терминал = СрезНаНачало.Терминал;
		НайдСтрокаДатчиков = Терминал.Датчики.Найти(ТекущийДатчик,"Датчик");
		Если НайдСтрокаДатчиков <> Неопределено Тогда
			КалибровочныйГрафик = НайдСтрокаДатчиков.КалибровочныйГрафик;
		
		КонецЕсли;		
		
	КонецЕсли;	
		
	ТабДокумент = Новый ТабличныйДокумент;	
	Макет = ПолучитьМакет("Макет");
	
	ОбластьШапка = Макет.ПолучитьОбласть("Шапка");
	ОбластьГрафик = Макет.ПолучитьОбласть("График");
	
	ОбластьШапка.Параметры.ЗаголовокОтчета = "Отчет по аналоговым датчикам за "+ПредставлениеПериода(НачПериода,КонПериода);
	ОбластьШапка.Параметры.Объект = "Объект: "+Объект+", датчик: "+Датчик;	
	ТабДокумент.Вывести(ОбластьШапка);
	
	ТабДанныхДатчика = ItobОперативныйМониторинг.ПолучитьДанныеДатчикаОбъекта(ТекущийОбъект,
		НачПериода,КонПериода,ТекущийДатчик);
		
	Если ПреобразоватьПоКалибровке Тогда		
	
		Если ЗначениеЗаполнено(КалибровочныйГрафик) Тогда
			ТабДанныхДатчика = ПреобразоватьДанныеДатчикаПоКалибровочномуГрафику(ТабДанныхДатчика, КалибровочныйГрафик);				
			
		КонецЕсли;
	
	КонецЕсли;	
		
	ТекстовыйДок = Новый ТекстовыйДокумент;
	ТекстовыйДок.ДобавитьСтроку("#Series1");
	ТекстовыйДок.ДобавитьСтроку(""+Формат(ТабДанныхДатчика.Количество(),"ЧРД=.; ЧГ=0"));	
	Для каждого СтрДанных Из ТабДанныхДатчика Цикл
		ТекущаяСтрокаДанных = Формат(СтрДанных.Период,"ДФ='yyyyMMddHHmmss'")
			+";"+Формат(СтрДанных.Значение,"ЧРД=.; ЧН=0; ЧГ=0")+";"""+Формат(СтрДанных.Период,"ДФ='dd.MM.yy HH:mm'")+"""";
		ТекстовыйДок.ДобавитьСтроку(ТекущаяСтрокаДанных);					
	
	КонецЦикла;
	ИмяВременногоФайла = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор()) + ".txt";
	ТекстовыйДок.Записать(ИмяВременногоФайла, "windows-1251");
	//ТекстовыйДок.Показать();
	
	ИмяФайлаКартинки = КаталогВременныхФайлов() + Строка(Новый УникальныйИдентификатор()) + ".png";
	
	АдресСервераРендеринга = Константы.ItobАдресСервисаCsmSvc.Получить();
	ОшибкаЗапросаНаСервер = Ложь;
	
	Если ПустаяСтрока(АдресСервераРендеринга) Тогда
		ОшибкаЗапросаНаСервер = Истина;
		ОписаниеОшибки = "В настройках системы не указан адрес сервиса CsmSvc!
						 |Воспользуйтесь мастером настройки службы CsmSvc.";
		
	ИначеЕсли  НЕ ItobОперативныйМониторинг.ПроверитьДоступностьСервисаCsmSvc(АдресСервераРендеринга) Тогда
		ОшибкаЗапросаНаСервер = Истина;
		ОписаниеОшибки = "Cервис CsmSvc не доступен!
						 |Воспользуйтесь мастером настройки службы CsmSvc.";
		
	Иначе
		
		Если Прав(АдресСервераРендеринга,1) = "/" Тогда
			АдресСервераРендеринга = Сред(АдресСервераРендеринга,1,СтрДлина(АдресСервераРендеринга)-1);			
		КонецЕсли;
		
		Попытка
			ШиринаРисунка = Формат(Цел(ОбластьГрафик.Рисунки.ImageChart.Ширина*1.8),"ЧГ=0");
			ВысотаРисунка = Формат(Цел(ОбластьГрафик.Рисунки.ImageChart.Высота*1.8),"ЧГ=0");		
			
			Соединение = Новый HTTPСоединение(АдресСервераРендеринга);	
			Соединение.ОтправитьДляОбработки(ИмяВременногоФайла, "RenderChart?Width="+ШиринаРисунка+"&Height="+ВысотаРисунка, ИмяФайлаКартинки);	
			
			УдалитьФайлы(ИмяВременногоФайла);
			
			КартинкаГрафик = Новый Картинка(ИмяФайлаКартинки);
			
			ОбластьГрафик.Рисунки.ImageChart.Картинка = КартинкаГрафик;
			
			ТабДокумент.Вывести(ОбластьГрафик);
			
			УдалитьФайлы(ИмяФайлаКартинки);
			
		Исключение
			ОшибкаЗапросаНаСервер = Истина;
			ОписаниеОшибки = "Ошибка ренедеринга графика: "+ОписаниеОшибки();			
			
		КонецПопытки;
	
	КонецЕсли;
	
	Если ОшибкаЗапросаНаСервер Тогда
	
		ОбластьОшибка = Макет.ПолучитьОбласть("Ошибка");
		ОбластьОшибка.Параметры.ТекстОшибки = ОписаниеОшибки;
		ОбластьОшибка.Параметры.Расшифровка = Новый Структура("Действие","ОткрытьМастерНастройкиCsmSvc");
		ТабДокумент.Вывести(ОбластьОшибка);	
	
	КонецЕсли;
	
	Возврат ТабДокумент;	

КонецФункции // СформироватьОтчетПоАналоговымДатчикам()

// Процедура обработчик события "ПриКомпоновкеРезультата" объекта
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;	
	
	ДокументРезультат.Вывести(СформироватьОтчетПоАналоговымДатчикам(
		НачПериода,
		КонПериода,
		Объект,
		Датчик,
		ПреобразовыватьПоКалибровочномуГрафику));
	
КонецПроцедуры // ПриКомпоновкеРезультата()
 
// Процедура - обработчик события "ОбработкаПроверкиЗаполнения".
//
Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Если НачПериода > КонПериода Тогда
		ТекстОшибки = НСтр("ru='Начало периода не может быть больше даты конца периода'");
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
			ТекстОшибки,
			Неопределено, // ОбъектИлиСсылка
			"ItobОтчетПоАналоговымДатчикам",
			"Отчет", // ПутьКДанным
			Отказ
		);
	КонецЕсли;
		
КонецПроцедуры // ОбработкаПроверкиЗаполнения()
