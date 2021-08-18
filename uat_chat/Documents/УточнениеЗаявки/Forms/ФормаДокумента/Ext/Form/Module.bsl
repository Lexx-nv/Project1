﻿&НаКлиенте
Процедура УдалитьТекущуюСтроку(Команда)
	Если Элементы.Состав.ТекущиеДанные <> Неопределено Тогда
		мИдентификаторСтроки = Элементы.Состав.ТекущаяСтрока;
		Объект.Состав.Удалить(Объект.Состав.НайтиПоИдентификатору(мИдентификаторСтроки));
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ОчиститьСостав(Команда)
	Если Объект.Состав.Количество() > 0 Тогда
		Объект.Состав.Очистить();
		Модифицированность = Истина;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоТипуТС(Команда)
	Если Не ЗначениеЗаполнено(Объект.Дата) Тогда
		ПоказатьПредупреждение( , "Проверьте Дату - она должна быть заполнена!");
		Возврат;
	КонецЕсли;
	мМассивТиповТС = ПолучитьМассивТиповТСЗаДень(Объект.Дата, Объект.Контрагент);
	мСписокЗначений = Новый СписокЗначений();
	мСписокЗначений.ЗагрузитьЗначения(мМассивТиповТС);
	мСписокЗначений.Добавить(ПредопределенноеЗначение("Справочник.уатТипыТС.ПустаяСсылка"), "Все");
	мСписокЗначений.СортироватьПоЗначению(НаправлениеСортировки.Возр);
	//TODO: в тестовой базе при 1-2 заявках уже более 40 различных типов. Возможно это накладка соответствий, но подумать о переделывании на отдельную форму
	мОписаниеОповещенияВыборТипаТС = Новый ОписаниеОповещения("ОбработкаВыбораТипаТС", ЭтаФорма);
	ПоказатьВыборИзМеню(мОписаниеОповещенияВыборТипаТС, мСписокЗначений, Элементы.ЗаполнитьПоТипуТС);
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбораТипаТС(пРезультат, пДополнительныеПараметры) Экспорт
	Если пРезультат <> Неопределено Тогда
		мМассивДанных = ПолучитьСоставМассивом(Объект.Дата, Объект.Контрагент, пРезультат.Значение);
		ЗаполнитьТаблицуИзМассива(Объект.Состав, мМассивДанных, "ИдентификаторСтрокиЗаявки");
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуИзМассива(пТаблицаЗначенийФормы, пМассивСтруктур, пКлючевоеПоле = "")
	Для Каждого мЭлемент Из пМассивСтруктур Цикл
		Если пКлючевоеПоле = Неопределено Или пКлючевоеПоле = "" Тогда
			мНоваяСтрока = пТаблицаЗначенийФормы.Добавить();
		Иначе
			мОтбор = нОВЫЙ Структура(пКлючевоеПоле, мЭлемент[пКлючевоеПоле]);
			мНайденныеСтроки = пТаблицаЗначенийФормы.НайтиСтроки(мОтбор);
			Если мНайденныеСтроки.Количество() > 0 Тогда
				мНоваяСтрока = мНайденныеСтроки[0];
			Иначе
				мНоваяСтрока = пТаблицаЗначенийФормы.Добавить();
			КонецЕсли;
		КонецЕсли;
		ЗаполнитьЗначенияСвойств(мНоваяСтрока, мЭлемент);
	КонецЦикла;
КонецПроцедуры

// хотелось бы использовать контекстный вызов, т.к. на основании этих данных меняется УсловноеОформление, доступное только на сервере, но хранящееся на клиенте
//	чтобы не гонять несколько раз данные туда-сюда, условное оформление могло бы обновляться сразу здесь, тут же дополняться ТЧ Состав
//	НО!... Седая старуха, Злодейка-Судьба... В ХранилищеЗначений не поместить значение, так как это, видите ли, ДанныеФормы, а в них ХранилищеЗначений недоступно...
//	C'est la vie =D Итог - ХранилищаЗначений не используем - слишком много операций записи, много контекстных вызовов с одинаковыми данными, от которых хочу избавиться, ибо будет тормозить
&НаСервереБезКонтекста
Функция ПолучитьСоставМассивом(пДата, пКонтрагент, пТипТС)
	мЗапрос = Новый Запрос("ВЫБРАТЬ
	|//все данные за день
	|	СведенияРасширенные.ТипТС КАК ТипТС,
	|	ЕСТЬNULL(Уточнения.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) КАК ЦехМаршрут,
	|	ЕСТЬNULL(Уточнения.МестоОказанияУслуг, """") КАК МестоОказанияУслуг, 
	|	ЕСТЬNULL(Уточнения.Ответственный, СведенияРасширенные.Ответственный) КАК Ответственный,
	|	ЕСТЬNULL(Уточнения.ВремяПодачи, СведенияРасширенные.ВремяПодачи) КАК ВремяПодачи,
	|	ЕСТЬNULL(Уточнения.Комментарий, СведенияРасширенные.Комментарий) КАК Комментарий,
	|	ДополнительныеСведенияЗаявокОбороты.ИдентификаторСтрокиЗаявки КАК ИдентификаторСтрокиЗаявки,
	|	ЕСТЬNULL(Уточнения.ОтказВыезда, ЛОЖЬ) КАК ОтказВыезда
	|ИЗ
	|	РегистрНакопления.ДополнительныеСведенияЗаявок.Обороты(НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ), КОНЕЦПЕРИОДА(&ДатаОтчета, ДЕНЬ), День) КАК ДополнительныеСведенияЗаявокОбороты
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДополнительныеСведенияЗаявок КАК СведенияРасширенные
	|	ПО ДополнительныеСведенияЗаявокОбороты.ИдентификаторСтрокиЗаявки = СведенияРасширенные.ИдентификаторСтрокиЗаявки И ДополнительныеСведенияЗаявокОбороты.Период = СведенияРасширенные.Период
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.УточненияЗаявок КАК Уточнения
	|	ПО ДополнительныеСведенияЗаявокОбороты.ИдентификаторСтрокиЗаявки = Уточнения.ИдентификаторСтрокиЗаявки И ДополнительныеСведенияЗаявокОбороты.Период = Уточнения.Дата
	|ГДЕ
	|	ДополнительныеСведенияЗаявокОбороты.КоличествоТСОборот > 0
	|	И ВЫБОР КОГДА &ТипТС = ЗНАЧЕНИЕ(Справочник.уатТипыТС.ПустаяСсылка) ТОГДА ИСТИНА ИНАЧЕ СведенияРасширенные.ТипТС = &ТипТС КОНЕЦ
	|	И ВЫБОР КОГДА &Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ТОГДА ИСТИНА ИНАЧЕ СведенияРасширенные.Контрагент = &Контрагент КОНЕЦ");
	
	мЗапрос.УстановитьПараметр("ДатаОтчета", пДата);
	мЗапрос.УстановитьПараметр("ТипТС", пТипТС);
	мЗапрос.УстановитьПараметр("Контрагент", пКонтрагент);
	мРезультат = мЗапрос.Выполнить().Выгрузить();
	
	Возврат ПреобразоватьТаблицуВМассивСтруктур(мРезультат);
КонецФункции

&НаСервереБезКонтекста
Функция ПреобразоватьТаблицуВМассивСтруктур(пТаблица)
	вМассив = Новый Массив;
	мСтрокаИменКолонок = "";
	Для Каждого мКолонка Из пТаблица.Колонки Цикл
		мСтрокаИменКолонок = мСтрокаИменКолонок + ", " + мКолонка.Имя;
	КонецЦикла;
	мСтрокаИменКолонок = Сред(мСтрокаИменКолонок, 2);
	
	Для Каждого мСтрока Из пТаблица Цикл
		мСтруктура = Новый Структура(мСтрокаИменКолонок);
		ЗаполнитьЗначенияСвойств(мСтруктура, мСтрока);
		вМассив.Добавить(мСтруктура);
	КонецЦикла;
	
	Возврат вМассив;
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьМассивТиповТСЗаДень(пДата, пКонтрагент)
	мЗапрос = Новый Запрос("ВЫБРАТЬ РАЗЛИЧНЫЕ
	|	СведенияРасширенные.ТипТС
	|ИЗ
	|	РегистрНакопления.ДополнительныеСведенияЗаявок.Обороты(НАЧАЛОПЕРИОДА(&ДатаОтчета, ДЕНЬ), КОНЕЦПЕРИОДА(&ДатаОтчета, День), День) КАК ДополнительныеСведенияЗаявокОбороты
	|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДополнительныеСведенияЗаявок КАК СведенияРасширенные
	|	ПО ДополнительныеСведенияЗаявокОбороты.ИдентификаторСтрокиЗаявки = СведенияРасширенные.ИдентификаторСтрокиЗаявки И ДополнительныеСведенияЗаявокОбороты.Период = СведенияРасширенные.Период
	|ГДЕ (ДополнительныеСведенияЗаявокОбороты.КоличествоТСОборот) > 0
	|	И ВЫБОР КОГДА &Контрагент = ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка) ТОГДА ИСТИНА ИНАЧЕ СведенияРасширенные.Контрагент = &Контрагент КОНЕЦ");
	мЗапрос.УстановитьПараметр("ДатаОтчета", пДата);
	мЗапрос.УстановитьПараметр("Контрагент", пКонтрагент);
	
	мРезультат = мЗапрос.Выполнить().Выгрузить();
	Возврат мРезультат.ВыгрузитьКолонку("ТипТС");
КонецФункции