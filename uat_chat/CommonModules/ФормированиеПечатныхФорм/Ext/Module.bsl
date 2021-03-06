
// Возвращает структуру данных со сводным описанием контрагента
//
// Параметры: 
//  СписокСведений - список значений со значениями параметров организации
//   СписокСведений формируется функцией СведенияОЮрФизЛице
//  Список         - список запрашиваемых параметров организации
//  СПрефиксом     - Признак выводить или нет префикс параметра организации
//
// Возвращаемое значение:
//  Строка - описатель организации / контрагента / физ.лица.
//
Функция ОписаниеОрганизации(СписокСведений, Список = "", СПрефиксом = Истина) Экспорт

	Если ПустаяСтрока(Список) Тогда
		Список = "ПолноеНаименование,ИНН,ЮридическийАдрес,Телефоны,НомерСчета,Банк,БИК,КоррСчет";
	КонецЕсли;

	Результат = "";

	СоответствиеПараметров = Новый Соответствие();
	СоответствиеПараметров.Вставить("ПолноеНаименование", " ");
	СоответствиеПараметров.Вставить("ИНН",                " ИНН ");
	СоответствиеПараметров.Вставить("КПП",                " КПП ");
	СоответствиеПараметров.Вставить("ЮридическийАдрес",   " ");
	СоответствиеПараметров.Вставить("Телефоны",           " тел.: ");
	СоответствиеПараметров.Вставить("НомерСчета",         " р/с ");
	СоответствиеПараметров.Вставить("Банк",               " в банке ");
	СоответствиеПараметров.Вставить("БИК",                " БИК ");
	СоответствиеПараметров.Вставить("КоррСчет",           " к/с ");
	СоответствиеПараметров.Вставить("КодПоОКПО",          " Код по ОКПО ");
	//+Lexx от 13.12.2017 по заявке 4328 - добавим ОГРН
	СоответствиеПараметров.Вставить("ОГРН",          " ОГРН ");
	//-Lexx от 13.12.2017 по заявке 4328 - добавим ОГРН

	Список          = Список + ?(Прав(Список, 1) = ",", "", ",");
	ЧислоПараметров = СтрЧислоВхождений(Список, ",");

	Для Счетчик = 1 по ЧислоПараметров Цикл

		ПозЗапятой = Найти(Список, ",");

		Если ПозЗапятой > 0  Тогда
			ИмяПараметра = Лев(Список, ПозЗапятой - 1);
			Список = Сред(Список, ПозЗапятой + 1, СтрДлина(Список));

			Попытка
				СтрокаДополнения = "";
				СписокСведений.Свойство(ИмяПараметра, СтрокаДополнения);

				Если ПустаяСтрока(СтрокаДополнения) Тогда
					Продолжить;
				КонецЕсли;

				Префикс = СоответствиеПараметров[ИмяПараметра];
				Если Не ПустаяСтрока(Результат)  Тогда
					Результат = Результат + ",";
				КонецЕсли; 

				Результат = Результат + ?(СПрефиксом = Истина, Префикс, "") + СтрокаДополнения;
			Исключение
				#Если Клиент Тогда
					Сообщить("Не удалось определить значение параметра организации: " + ИмяПараметра, СтатусСообщения.Внимание);
				#КонецЕсли
			КонецПопытки;

		КонецЕсли;

	КонецЦикла;

	Возврат СокрЛП(Результат);

КонецФункции // ОписаниеОрганизации()

// Функция собирает паспортные данные физ. лица на указанную дату
//
// Параметры: 
//  ФизЛицо.    - физ. лицо, для которого необходимо получить паспортные данные
//  ДатаПериода - дата получения сведений
//
// Возвращаемое значение:
//  Структура с паспортными данными.
//
Функция ПаспортныеДанные(ФизЛицо, ДатаПериода) Экспорт

	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("ПарФизЛицо",     ФизЛицо);
	Запрос.УстановитьПараметр("ПарДатаПериода", ДатаПериода);

	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДокументВид        КАК Вид,
	|	ДокументСерия      КАК Серия,
	|	ДокументНомер      КАК Номер,
	|	ДокументДатаВыдачи КАК ДатаВыдачи,
	|	ДокументКемВыдан   КАК Выдан
	|ИЗ
	|	РегистрСведений.ПаспортныеДанныеФизЛиц.СрезПоследних(&ПарДатаПериода, ФизЛицо = &ПарФизЛицо)
	|";

	Шапка = Запрос.Выполнить().Выбрать();
	Шапка.Следующий();

	Результат = Новый Структура("Вид, Серия, Номер, ДатаВыдачи, Выдан");

	Результат.Вид        = Шапка.Вид;
	Результат.Серия      = Шапка.Серия;
	Результат.Номер      = Шапка.Номер;
	Результат.ДатаВыдачи = Шапка.ДатаВыдачи;
	Результат.Выдан      = Шапка.Выдан;

	Возврат Результат;

КонецФункции // ПаспортныеДанные()



// Формирует описание серий и характеристик ТМЦ для печати
//
// Параметры
//  Выборка  – <ВыборкаИзРезультатаЗапроса > – Исходные данные
//
// Возвращаемое значение:
//   Строка - Описание серий и характеристик ТМЦ
//
Функция ПредставлениеСерий(Выборка) Экспорт

	Результат = "(";

	Если ЗначениеЗаполнено(Выборка.Характеристика) Тогда
		Результат = Результат + Выборка.Характеристика;
	КонецЕсли;

	Если ЗначениеЗаполнено(Выборка.Серия) Тогда
		Результат = ?(Результат = "(", Результат, Результат + "; ");
		Результат = Результат + Выборка.Серия;
	КонецЕсли;

	Результат = Результат + ")";

	Возврат ?(Результат = "()", "", " " + Результат)

КонецФункции // ПредставлениеСерий()

// Стандартная для данной конфигурации функция форматирования прописи количества
//
// Параметры: 
//  Количество - число, которое мы хотим форматировать
//
// Возвращаемое значение:
//  Отформатированная должным образом строковое представление количества.
//
Функция КоличествоПрописью(Количество) Экспорт

	ЦелаяЧасть   = Цел(Количество);
	ДробнаяЧасть = Окр(Количество - ЦелаяЧасть, 3);

	Если ДробнаяЧасть = Окр(ДробнаяЧасть,0) Тогда
		ПараметрыПрописи = ", , , , , , , , 0";
	ИначеЕсли ДробнаяЧасть = Окр(ДробнаяЧасть, 1) Тогда
		ПараметрыПрописи = "целая, целых, целых, ж, десятая, десятых, десятых, м, 1";
	ИначеЕсли ДробнаяЧасть = Окр(ДробнаяЧасть, 2) Тогда
		ПараметрыПрописи = "целая, целых, целых, ж, сотая, сотых, сотых, м, 2";
	Иначе
		ПараметрыПрописи = "целая, целых, целых, ж, тысячная, тысячных, тысячных, м, 3";
	КонецЕсли;

	Возврат ЧислоПрописью(Количество, ,ПараметрыПрописи);

КонецФункции // КоличествоПрописью()

// Проверяет, умещаются ли переданные табличные документы на страницу при печати.
//
// Параметры
//  ТабДокумент       – Табличный документ
//  ВыводимыеОбласти  – Массив из проверяемых таблиц или табличный документ
//  РезультатПриОшибке - Какой возвращать результат при возникновении ошибки
//
// Возвращаемое значение:
//   Булево   – умещаются или нет переданные документы
//
Функция ПроверитьВыводТабличногоДокумента(ТабДокумент, ВыводимыеОбласти, РезультатПриОшибке = Истина) Экспорт

	Попытка
		Возврат ТабДокумент.ПроверитьВывод(ВыводимыеОбласти);
	Исключение
		Возврат РезультатПриОшибке;
	КонецПопытки;

КонецФункции // ПроверитьВыводТабличногоДокумента()

