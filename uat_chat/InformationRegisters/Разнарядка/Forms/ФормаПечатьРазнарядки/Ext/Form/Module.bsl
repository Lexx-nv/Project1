#Область Вспомогательные_Методы

&НаСервереБезКонтекста
Функция ПреобразоватьТаблицуВМассивСтруктур(пТаблица, пЧистыйМассив = Ложь)
	вМассив = Новый Массив;
	мСтрокаИменКолонок = "";
	Для Каждого мКолонка Из пТаблица.Колонки Цикл
		мСтрокаИменКолонок = мСтрокаИменКолонок + "," + мКолонка.Имя;
	КонецЦикла;
	мСтрокаИменКолонок = Сред(мСтрокаИменКолонок, 2);
	мЧистыйМассив = пЧистыйМассив И Найти(мСтрокаИменКолонок, ",") = 0;
	
	Для Каждого мСтрока Из пТаблица Цикл
		Если Не мЧистыйМассив Тогда
			мСтруктура = Новый Структура(мСтрокаИменКолонок);
			ЗаполнитьЗначенияСвойств(мСтруктура, мСтрока);
			вМассив.Добавить(мСтруктура);
		Иначе
			вМассив.Добавить(мСтрока[мСтрокаИменКолонок]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат вМассив;
КонецФункции   

&НаКлиенте
Процедура ИзменитьВидимостьФильтров()
	
	Если ВариантОтчета = "ТиповаяРазнорядка" Тогда
		Элементы.ГруппаФильтров3.Видимость = Истина;
		Элементы.Контрагент.Видимость = Истина;
		Элементы.Колонна.Видимость = Истина;
		Элементы.Платформа.Видимость = Ложь;
		Элементы.Интервал.Видимость = Ложь;
		Элементы.фРежимНачальникАвтоколонны.Видимость = Истина;
		Элементы.ГруппаФильтров4.Видимость = Истина;
	ИначеЕсли ВариантОтчета = "СменныйСуточныйПлан" Тогда
		Элементы.Колонна.Видимость = Истина;
		Элементы.Платформа.Видимость = Ложь;
		Элементы.ГруппаФильтров3.Видимость = Ложь;
		Элементы.ГруппаФильтров4.Видимость = Ложь;
	ИначеЕсли ВариантОтчета = "РазнярядкаПоЗаказчикам" Тогда
		Элементы.ГруппаФильтров3.Видимость = Истина;
		Элементы.Контрагент.Видимость = Истина;
		Элементы.Колонна.Видимость = Ложь;
		Элементы.Платформа.Видимость = Истина;
		Элементы.Интервал.Видимость = Истина;
		Элементы.фРежимНачальникАвтоколонны.Видимость = Ложь;
		Элементы.ГруппаФильтров4.Видимость = Ложь;
		Интервал = Элементы.Интервал.СписокВыбора[0].Значение;
	ИначеЕсли ВариантОтчета = "ПоВсемКонтрагентам" Тогда
		Элементы.ГруппаФильтров3.Видимость = Истина;
		Элементы.Контрагент.Видимость = Истина;
		Элементы.Колонна.Видимость = Ложь;
		Элементы.Платформа.Видимость = Истина;
		Элементы.Интервал.Видимость = Ложь;
		Элементы.фРежимНачальникАвтоколонны.Видимость = Ложь;
		Элементы.ГруппаФильтров4.Видимость = Ложь;
	КонецЕсли;      	
		
КонецПроцедуры

#КонецОбласти

#Область Печать

&НаКлиенте
Процедура Печать(ПечатьИзРазнарядки = Истина)
	
	Если Не ЗначениеЗаполнено(фДата) Тогда
		ПоказатьПредупреждение( , "Укажите дату", 10, "Предупреждение");
		Возврат;
	КонецЕсли;	
		
	МасКолонн = Новый Массив();
	Для каждого мКолонна Из Элементы.фКолонна.СписокВыбора Цикл
		Если мКолонна.Пометка Тогда
			МасКолонн.Добавить(мКолонна.Значение);	
		КонецЕсли;	
	КонецЦикла;
	
	МасКонтрагент = Новый Массив();
	Для каждого мКонтрагент Из Элементы.фКонтрагент.СписокВыбора Цикл
		Если мКонтрагент.Пометка Тогда
			МасКонтрагент.Добавить(мКонтрагент.Значение);	
		КонецЕсли;	
	КонецЦикла;
	
	Если ПечатьИзРазнарядки и ЗначениеЗаполнено(фКолонна) Тогда
		 МасКолонн.Добавить(фКолонна); 
	КонецЕсли;
	
	Если Интервал = "1" Тогда
		ВремяС = '00010101060000';
		ВремяПО = '00010101080000';
	ИначеЕсли Интервал = "2" Тогда
		ВремяС = '00010101150000';
		ВремяПО = '00010101200000';
	ИначеЕсли Интервал = "3" Тогда
		ВремяС = '00010101060000';
		ВремяПО = '00010101200000';
	Иначе
		ВремяС = '00010101041000';
		ВремяПО = '00010101155000';
	КонецЕсли;	
	
	СтрРезультат = ПечатьРазнарядки(ВариантОтчета, фДата, фМестоРаботы, МасКонтрагент, МасКолонн, фТипТС, фЦех, фРежимНачальникАвтоколонны, ВремяС, ВремяПО, Платформа);
	
	ЗаполнитьСписокВыбораКолонн(СтрРезультат.МассивКолонн, ПечатьИзРазнарядки);
	ЗаполнитьСписокВыбораКонтрагент(СтрРезультат.МассивКонтрагент);
	
	Результат = СтрРезультат.ТабДокумент;
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ИзменитьВидимостьФильтров();
	Если ЗапускИзРазнарядки Тогда
		Печать();
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПечатьРазнарядки(ВариантОтчета, фДата, фМестоРаботы, МасКонтрагент, МасКолонн, фТипТС, фЦех, фРежимНачальникАвтоколонны, ВремяС, ВремяПо, Платформа) Экспорт	

	Запрос = Новый Запрос;
	
	// ВТРазнарядкаИзРегистров - взят из запроса заполения формы разнарядки по дате
	//Запрос.Текст = РегистрыСведений.Разнарядка.ПолучитьТекстЗапросаРазнарядка(Истина, "ПОМЕСТИТЬ ВТРазнарядкаИзРегистров") + "
	
	Запрос.Текст = ПолучитьТекстЗапроса();
	
	Запрос.УстановитьПараметр("ДатаРазнарядки", фДата);
	Запрос.УстановитьПараметр("МестоРаботы", фМестоРаботы);		
	Запрос.УстановитьПараметр("Контрагент", МасКонтрагент);
	Если МасКонтрагент.Количество() = 0 Тогда
		Запрос.УстановитьПараметр("ВсеКонтрагенты", Истина);
	Иначе
		Запрос.УстановитьПараметр("ВсеКонтрагенты", Ложь);
	КонецЕсли;
	Запрос.УстановитьПараметр("Колонна", МасКолонн);
	Если МасКолонн.Количество() = 0 Тогда
		Запрос.УстановитьПараметр("ВсеЗаписи", Истина);
	Иначе
		Запрос.УстановитьПараметр("ВсеЗаписи", Ложь);
	КонецЕсли;		
	Запрос.УстановитьПараметр("ТипТС", фТипТС);
	Запрос.УстановитьПараметр("Цех", фЦех);
	Запрос.УстановитьПараметр("РежимНачальникАвтоколонны", фРежимНачальникАвтоколонны);
	
	// Переопределяем, если др.отчет
	Если ВариантОтчета = "СменныйСуточныйПлан" Тогда
		Запрос.УстановитьПараметр("Контрагент", Справочники.Контрагенты.ПустаяСсылка());
		Запрос.УстановитьПараметр("ТипТС", Справочники.уатТипыТС.ПустаяСсылка());
		Запрос.УстановитьПараметр("Цех", Справочники.ЦехаКонтрагента.ПустаяСсылка());
		Запрос.УстановитьПараметр("РежимНачальникАвтоколонны", Истина);
	ИначеЕсли ВариантОтчета = "РазнярядкаПоЗаказчикам" Тогда
		Запрос.УстановитьПараметр("Колонна", Новый Массив);
		Запрос.УстановитьПараметр("ВсеЗаписи", Истина);
		Запрос.УстановитьПараметр("ТипТС", Справочники.уатТипыТС.ПустаяСсылка());
		Запрос.УстановитьПараметр("Цех", Справочники.ЦехаКонтрагента.ПустаяСсылка());
		Запрос.УстановитьПараметр("РежимНачальникАвтоколонны", Истина);
	ИначеЕсли ВариантОтчета = "ПоВсемКонтрагентам" Тогда
		Запрос.УстановитьПараметр("Колонна", Новый Массив);
		Запрос.УстановитьПараметр("ВсеЗаписи", Истина);
		Запрос.УстановитьПараметр("ТипТС", Справочники.уатТипыТС.ПустаяСсылка());
		Запрос.УстановитьПараметр("Цех", Справочники.ЦехаКонтрагента.ПустаяСсылка());
		Запрос.УстановитьПараметр("РежимНачальникАвтоколонны", Истина);
	КонецЕсли;
	
	РезультатЗапроса = Запрос.ВыполнитьПакет();
	
	ТЗРезультат = РезультатЗапроса[6].Выгрузить();
	
	ТЗКонтрагенты = Новый ТаблицаЗначений;
	ТЗКонтрагенты.Колонки.Добавить("Контрагент", Новый ОписаниеТипов("СправочникСсылка.Контрагенты"));
	
	//Корректировка полей
	Сч = 0;
	Пока Сч <= ТЗРезультат.Количество()-1 Цикл
		ТЗРезультат[Сч].ГарНомерТС = СтрЗаменить(ТЗРезультат[Сч].ГарНомерТС, " ", "");
		ТЗРезультат[Сч].ГосНомерТС = СтрЗаменить(ТЗРезультат[Сч].ГосНомерТС, " ", "");
		ТЗРезультат[Сч].ТабНомерВодителя = СтрЗаменить(ТЗРезультат[Сч].ТабНомерВодителя, " ", "");
		
		Если ЗначениеЗаполнено(ТЗРезультат[Сч].Контрагент) Тогда
			НоваяСтрока = ТЗКонтрагенты.Добавить();
			НоваяСтрока.Контрагент = ТЗРезультат[Сч].Контрагент;
		КонецЕсли;	
		
		Сч = Сч + 1;
	КонецЦикла;
	
	ТЗКонтрагенты.Свернуть("Контрагент");
	ТЗКонтрагенты.Сортировать("Контрагент Возр");
	МассивКонтрагент = ПреобразоватьТаблицуВМассивСтруктур(ТЗКонтрагенты, Истина);
	
	МассивКолонн = Новый Массив();
	МассивКолонн = ПреобразоватьТаблицуВМассивСтруктур(РезультатЗапроса[2].Выгрузить(), Истина);
	
	Если ТЗРезультат.Количество() = 0 Тогда
		Возврат Новый Структура("ТабДокумент, МассивКолонн, МассивКонтрагент", Новый ТабличныйДокумент, МассивКолонн, МассивКонтрагент);
	КонецЕсли;
	
	ТЗРезультат.Сортировать("ТипТСПредставление Возр, ЦехМаршрут, МестоОказанияУслуг, СтатусыОтказаНаименование ВОЗР, ТСПредставление, ВремяПодачи ВОЗР");
	
	ТабДокумент = РегистрыСведений.Разнарядка.Печать(ВариантОтчета, фДата, фМестоРаботы, ТЗРезультат, МасКолонн, фРежимНачальникАвтоколонны, ВремяС, ВремяПо, Платформа);
	
	Возврат Новый Структура("ТабДокумент, МассивКолонн, МассивКонтрагент", ТабДокумент, МассивКолонн, МассивКонтрагент);
	
КонецФункции

&НаСервереБезКонтекста
Функция ПолучитьТекстЗапроса()
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	уатМестонахождениеТС.ТС КАК ТС,
	               |	уатМестонахождениеТС.Подразделение КАК Колонна
	               |ПОМЕСТИТЬ ТипыТСИКолонны
	               |ИЗ
	               |	РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаРазнарядки, ) КАК уатМестонахождениеТС
	               |ГДЕ
	               |	уатМестонахождениеТС.Подразделение <> ЗНАЧЕНИЕ(Справочник.ПодразделенияОрганизаций.ПустаяСсылка)
	               |	И уатМестонахождениеТС.ТС <> ЗНАЧЕНИЕ(Справочник.уатТС.ПустаяСсылка)
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ТипыТСИКолонны.ТС КАК ТС,
	               |	ТипыТСИКолонны.Колонна КАК Колонна
	               |ИЗ
	               |	ТипыТСИКолонны КАК ТипыТСИКолонны
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ТипыТСИКолонны.Колонна КАК Колонна
	               |ИЗ
	               |	ТипыТСИКолонны КАК ТипыТСИКолонны
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Колонна
	               |АВТОУПОРЯДОЧИВАНИЕ
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ РАЗЛИЧНЫЕ
				   |	ДополнительныеСведенияЗаявокОбороты.ИдентификаторСтрокиЗаявки КАК ИдентификаторСтрокиЗаявки,
	               |	СведенияРасширенные.Контрагент КАК Контрагент,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) ССЫЛКА Справочник.уатМаршруты
	               |			ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) КАК Справочник.уатМаршруты)
	               |		КОГДА ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) ССЫЛКА Справочник.ЦехаКонтрагента
	               |			ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) КАК Справочник.ЦехаКонтрагента)
	               |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ЦехаКонтрагента.ПустаяСсылка)
	               |	КОНЕЦ КАК ЦехМаршрут,
	               |	ЕСТЬNULL(РазнарядкаТекущая.Ответственный, """") КАК Ответственный,
	               |	ЕСТЬNULL(РазнарядкаТекущая.ТС, ЗНАЧЕНИЕ(Справочник.уатТС.ПустаяСсылка)) КАК ТС,
	               |	СведенияРасширенные.ТипТС КАК ТипТС,
	               |	ВЫБОР КОГДА РазнарядкаТекущая.ЦехМаршрут ССЫЛКА Справочник.уатМаршруты ТОГДА ВЫРАЗИТЬ(РазнарядкаТекущая.ЦехМаршрут КАК Справочник.уатМаршруты).Начало ИНАЧЕ ЕСТЬNULL(РазнарядкаТекущая.ВремяПодачи, ДАТАВРЕМЯ(1, 1, 1)) КОНЕЦ КАК ВремяПодачи,
	               |	ВЫБОР
	               |		КОГДА ВЫБОР
	               |				КОГДА ЕСТЬNULL(РазнарядкаТекущая.СтатусыОтказа, ЗНАЧЕНИЕ(Справочник.юкСтатусыОтказаЗаявки.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.юкСтатусыОтказаЗаявки.ПустаяСсылка)
	               |					ТОГДА ЕСТЬNULL(РазнарядкаТекущая.СтатусыОтказа.ПризнакНевыходаВодителя, ЛОЖЬ)
	               |				ИНАЧЕ ЛОЖЬ
	               |			КОНЕЦ
	               |			ТОГДА ЗНАЧЕНИЕ(Справочник.уатСотрудники.ПустаяСсылка)
	               |		ИНАЧЕ ЕСТЬNULL(РазнарядкаТекущая.Водитель, ЗНАЧЕНИЕ(Справочник.уатСотрудники.ПустаяСсылка))
	               |	КОНЕЦ КАК Водитель,
	               |	ВЫБОР
	               |		КОГДА ВЫБОР
	               |				КОГДА ЕСТЬNULL(РазнарядкаТекущая.СтатусыОтказа, ЗНАЧЕНИЕ(Справочник.юкСтатусыОтказаЗаявки.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.юкСтатусыОтказаЗаявки.ПустаяСсылка)
	               |					ТОГДА ЕСТЬNULL(РазнарядкаТекущая.СтатусыОтказа.ПризнакНевыходаВодителя2, ЛОЖЬ)
	               |				ИНАЧЕ ЛОЖЬ
	               |			КОНЕЦ
	               |			ТОГДА ЗНАЧЕНИЕ(Справочник.уатСотрудники.ПустаяСсылка)
	               |		ИНАЧЕ ЕСТЬNULL(РазнарядкаТекущая.Водитель2, ЗНАЧЕНИЕ(Справочник.уатСотрудники.ПустаяСсылка))
	               |	КОНЕЦ КАК Водитель2,
	               |	ЕСТЬNULL(РазнарядкаТекущая.СтатусыОтказа, ЗНАЧЕНИЕ(Справочник.юкСтатусыОтказаЗаявки.ПустаяСсылка)) КАК СтатусыОтказа,
	               |	ВЫБОР
	               |		КОГДА РазнарядкаТекущая.СтатусыОтказа ЕСТЬ NULL
	               |			ТОГДА """"
	               |		ИНАЧЕ РазнарядкаТекущая.СтатусыОтказа.Наименование
	               |	КОНЕЦ КАК СтатусыОтказаНаименование,
	               |	ЕСТЬNULL(РазнарядкаТекущая.Колонна, ЗНАЧЕНИЕ(Справочник.уатКолонны.ПустаяСсылка)) КАК Колонна,
	               |	ЕСТЬNULL(РазнарядкаТекущая.МестоОказанияУслуг, """") КАК МестоОказанияУслуг,
	               |	ПОДСТРОКА(ЕСТЬNULL(РазнарядкаТекущая.Комментарий, СведенияРасширенные.Комментарий), 1, 255) КАК Комментарий,
	               |	ВЫБОР
	               |		КОГДА ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) ССЫЛКА Справочник.уатМаршруты
	               |			ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) КАК Справочник.уатМаршруты).ЦехКонтрагента
	               |		КОГДА ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) ССЫЛКА Справочник.ЦехаКонтрагента
	               |			ТОГДА ВЫРАЗИТЬ(ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, СведенияРасширенные.ЦехМаршрут) КАК Справочник.ЦехаКонтрагента)
	               |		ИНАЧЕ ЗНАЧЕНИЕ(Справочник.ЦехаКонтрагента.ПустаяСсылка)
	               |	КОНЕЦ КАК Цех,
				   |	ЕСТЬNULL(РазнарядкаТекущая.ЦехМаршрут, ЗНАЧЕНИЕ(Справочник.уатМаршруты.ПустаяСсылка)) <> ЗНАЧЕНИЕ(Справочник.уатМаршруты.ПустаяСсылка) КАК ЦехМаршрутЗаполнен
	               |ПОМЕСТИТЬ ВТРазнарядкаИзРегистров
	               |ИЗ
	               |	РегистрНакопления.ДополнительныеСведенияЗаявок.Обороты(НАЧАЛОПЕРИОДА(&ДатаРазнарядки, ДЕНЬ), КОНЕЦПЕРИОДА(&ДатаРазнарядки, ДЕНЬ), День, ) КАК ДополнительныеСведенияЗаявокОбороты
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрНакопления.ДополнительныеСведенияЗаявок КАК СведенияРасширенные
	               |		ПО ДополнительныеСведенияЗаявокОбороты.ИдентификаторСтрокиЗаявки = СведенияРасширенные.ИдентификаторСтрокиЗаявки
	               |			И ДополнительныеСведенияЗаявокОбороты.Период = СведенияРасширенные.Период
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.Разнарядка КАК РазнарядкаТекущая
	               |		ПО ДополнительныеСведенияЗаявокОбороты.ИдентификаторСтрокиЗаявки = РазнарядкаТекущая.ИдентификаторСтрокиЗаявки
	               |			И ДополнительныеСведенияЗаявокОбороты.Период = РазнарядкаТекущая.Дата
	               |ГДЕ
	               |	ДополнительныеСведенияЗаявокОбороты.КоличествоТСОборот > 0
	               |	И (СведенияРасширенные.МестоРаботы = &МестоРаботы
	               |			ИЛИ &МестоРаботы = ЗНАЧЕНИЕ(Справочник.юкМестаРаботы.ПустаяСсылка))
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	Разнарядка.Контрагент КАК Контрагент,
	               |	Разнарядка.ЦехМаршрут КАК ЦехМаршрут,
	               |	ВЫБОР КОГДА НЕ Разнарядка.ЦехМаршрут ЕСТЬ NULL И Разнарядка.ЦехМаршрут Ссылка Справочник.уатМаршруты и Разнарядка.ЦехМаршрут.Ответсвенный <> """" ТОГДА Разнарядка.ЦехМаршрут.Ответсвенный ИНАЧЕ Разнарядка.Ответственный КОНЕЦ КАК Ответственный,
	               |	ЧАС(ЕСТЬNULL(Разнарядка.ВремяПодачи, ДАТАВРЕМЯ(1, 1, 1))) <= 3
	               |		ИЛИ ЧАС(ЕСТЬNULL(Разнарядка.ВремяПодачи, ДАТАВРЕМЯ(1, 1, 1))) >= 15 КАК ВтораяСмена,
	               |	ВЫБОР КОГДА НЕ ВыпискаПЛПоИдентификаторам.ПутевойЛист ЕСТЬ NULL ТОГДА ВыпискаПЛПоИдентификаторам.ПутевойЛист.ТранспортноеСредство ИНАЧЕ Разнарядка.ТС КОНЕЦ КАК ТС,
	               |	Разнарядка.ТипТС КАК ТипТС,
	               |	Разнарядка.ВремяПодачи КАК ВремяПодачи,
	               |	ВЫБОР КОГДА НЕ ВыпискаПЛПоИдентификаторам.ПутевойЛист ЕСТЬ NULL ТОГДА ВыпискаПЛПоИдентификаторам.ПутевойЛист.Водитель1 ИНАЧЕ Разнарядка.Водитель КОНЕЦ КАК Водитель,
	               |	ВЫБОР КОГДА НЕ ВыпискаПЛПоИдентификаторам.ПутевойЛист ЕСТЬ NULL ТОГДА ВыпискаПЛПоИдентификаторам.ПутевойЛист.Водитель2 ИНАЧЕ Разнарядка.Водитель2 КОНЕЦ КАК Водитель2,
	               |	Разнарядка.СтатусыОтказа КАК СтатусыОтказа,
	               |	Разнарядка.СтатусыОтказаНаименование КАК СтатусыОтказаНаименование,
	               |	ТипыТСИКолонны.Колонна КАК Колонна,
	               |	Разнарядка.МестоОказанияУслуг КАК МестоОказанияУслуг,
	               |	Разнарядка.Комментарий КАК Комментарий,
				   |	Разнарядка.ЦехМаршрутЗаполнен КАК ЦехМаршрутЗаполнен,	// + Алексей, 31.03.2020 - признак для сортировки в Сменно-суточном
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).ВремяВПути КАК ЧасыЛ,
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).ВремяУсл3 КАК ЧасыР,
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).ВремяУсл2 КАК ЧасыО,
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).ВремяВПутиВод КАК ЧасыЛВод,
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).ВремяУсл3Вод КАК ЧасыРВод,
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).ВремяУсл2Вод КАК ЧасыОВод,
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).Владелец.Код КАК КодКА,
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).Платформа КАК Платформа,
	               |	ВЫРАЗИТЬ(Разнарядка.ЦехМаршрут КАК Справочник.уатМаршруты).Стоянка КАК Стоянка
	               |ПОМЕСТИТЬ ВТРазнарядка
	               |ИЗ
	               |	ВТРазнарядкаИзРегистров КАК Разнарядка
				   |	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ВыпискаПЛПоИдентификаторам КАК ВыпискаПЛПоИдентификаторам
				   |		ПО Разнарядка.ИдентификаторСтрокиЗаявки = ВыпискаПЛПоИдентификаторам.ИдентификаторСтрокиЗаявки И НАЧАЛОПЕРИОДА(ВыпискаПЛПоИдентификаторам.ДатаВыписки, ДЕНЬ) = НАЧАЛОПЕРИОДА(&ДатаРазнарядки, ДЕНЬ)  И (НЕ ВыпискаПЛПоИдентификаторам.ПутевойЛист.ПометкаУдаления) И ВыпискаПЛПоИдентификаторам.ПутевойЛист <> ЗНАЧЕНИЕ(Документ.уатПутевойЛист.ПустаяСсылка)
				   |	ЛЕВОЕ СОЕДИНЕНИЕ ТипыТСИКолонны КАК ТипыТСИКолонны
				   |		ПО ВЫБОР КОГДА НЕ ВыпискаПЛПоИдентификаторам.ПутевойЛист ЕСТЬ NULL ТОГДА ВыпискаПЛПоИдентификаторам.ПутевойЛист.ТранспортноеСредство = ТипыТСИКолонны.ТС ИНАЧЕ Разнарядка.ТС = ТипыТСИКолонны.ТС КОНЕЦ
	               |ГДЕ
	               |	(ТипыТСИКолонны.Колонна В (&Колонна)
	               |			ИЛИ &ВсеЗаписи)
	               |	И (Разнарядка.Контрагент В (&Контрагент)
	               |			ИЛИ &ВсеКонтрагенты)
	               |	И (Разнарядка.ТипТС = &ТипТС
	               |			ИЛИ &ТипТС = ЗНАЧЕНИЕ(Справочник.уатТипыТС.ПустаяСсылка))
	               |	И (Разнарядка.ЦехМаршрут = &Цех
	               |			ИЛИ &Цех = ЗНАЧЕНИЕ(Справочник.ЦехаКонтрагента.ПустаяСсылка))
				   |	И (ВЫБОР КОГДА НЕ ВыпискаПЛПоИдентификаторам.ПутевойЛист ЕСТЬ NULL ТОГДА ВыпискаПЛПоИдентификаторам.ПутевойЛист.ТранспортноеСредство ИНАЧЕ Разнарядка.ТС КОНЕЦ) <> ЗНАЧЕНИЕ(Справочник.уатТС.ПустаяСсылка)	// + Алексей, 31.03.2020 без пустых ТС
				   |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	уатТС.Ссылка КАК ТС,
	               |	уатМестонахождениеТССрезПоследних.Подразделение КАК Колонна,
	               |	МАКСИМУМ(ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) КАК Контрагент,
	               |	МАКСИМУМ(ЗНАЧЕНИЕ(Справочник.ЦехаКонтрагента.ПустаяСсылка)) КАК ЦехМаршрут
	               |ПОМЕСТИТЬ ВТНеВРаботе
	               |ИЗ
	               |	Справочник.уатТС КАК уатТС
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаРазнарядки, ) КАК уатМестонахождениеТССрезПоследних
	               |		ПО (уатМестонахождениеТССрезПоследних.ТС = уатТС.Ссылка)
	               |ГДЕ
	               |	уатТС.ДатаВводаВЭксплуатацию > ДАТАВРЕМЯ(1, 1, 1)
	               |	И уатТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	               |	И &РежимНачальникАвтоколонны
	               |	И (уатМестонахождениеТССрезПоследних.Подразделение В (&Колонна)
	               |			ИЛИ &ВсеЗаписи)
	               |	И (уатТС.Ссылка.ТипТС = &ТипТС
	               |			ИЛИ &ТипТС = ЗНАЧЕНИЕ(Справочник.уатТипыТС.ПустаяСсылка))
	               |	И НЕ уатМестонахождениеТССрезПоследних.Состояние.ЗапретитьВыпискуПЛ
	               |
	               |СГРУППИРОВАТЬ ПО
	               |	уатТС.Ссылка,
	               |	уатМестонахождениеТССрезПоследних.Подразделение
	               |
	               |ИМЕЮЩИЕ
	               |	(МАКСИМУМ(ЗНАЧЕНИЕ(Справочник.Контрагенты.ПустаяСсылка)) В (&Контрагент)
	               |		ИЛИ &ВсеКонтрагенты) И
	               |	(МАКСИМУМ(ЗНАЧЕНИЕ(Справочник.ЦехаКонтрагента.ПустаяСсылка)) = &Цех
	               |		ИЛИ &Цех = ЗНАЧЕНИЕ(Справочник.ЦехаКонтрагента.ПустаяСсылка))
	               |;
	               |
	               |////////////////////////////////////////////////////////////////////////////////
	               |ВЫБРАТЬ
	               |	ВТРазнарядка.Контрагент КАК Контрагент,
	               |	ВТРазнарядка.ЦехМаршрут КАК ЦехМаршрут,
	               |	ВЫБОР КОГДА ВТРазнарядка.ЦехМаршрут ССЫЛКА Справочник.уатМаршруты ТОГДА ВТРазнарядка.ЦехМаршрут.Родитель.Наименование ИНАЧЕ ""ЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯЯ"" КОНЕЦ КАК ЦехМаршрутРодитель,
				   |	ВЫБОР КОГДА ВТРазнарядка.ЦехМаршрут ССЫЛКА Справочник.уатМаршруты ТОГДА ВТРазнарядка.ЦехМаршрут.Наименование ИНАЧЕ ""ЯЯЯЯЯЯ"" КОНЕЦ КАК ЦехМаршрутНаименование,
	               |	ВТРазнарядка.Ответственный КАК Ответственный,
	               |	ЕСТЬNULL(ВТРазнарядка.ВтораяСмена, ЛОЖЬ) КАК ВтораяСмена,
	               |	ЕСТЬNULL(ВТРазнарядка.ТС, ВТНеВРаботе.ТС) КАК ТС,
	               |	ЕСТЬNULL(ВТРазнарядка.ТипТС, ВТНеВРаботе.ТС.ТипТС) КАК ТипТС,
	               |	ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ДАТАВРЕМЯ(1, 1, 1), ЧАС, ЧАС(ВТРазнарядка.ВремяПодачи)), МИНУТА, МИНУТА(ВТРазнарядка.ВремяПодачи)) КАК ВремяПодачи,
	               |	ЕСТЬNULL(ВТРазнарядка.Водитель, ЗНАЧЕНИЕ(Справочник.уатСотрудники.ПустаяСсылка)) КАК Водитель,
	               |	ВТРазнарядка.Водитель2 КАК Водитель2,
	               |	ВТРазнарядка.СтатусыОтказа КАК СтатусыОтказа,
	               |	ВТРазнарядка.СтатусыОтказаНаименование КАК СтатусыОтказаНаименование,
	               |	ЕСТЬNULL(ВТРазнарядка.Колонна, ВТНеВРаботе.Колонна) КАК Колонна,
	               |	ВТРазнарядка.МестоОказанияУслуг КАК МестоОказанияУслуг,
	               |	ВТРазнарядка.Комментарий КАК Комментарий,
				   |	ВТРазнарядка.ЦехМаршрутЗаполнен КАК ЦехМаршрутЗаполнен,	// + Алексей, 31.03.2020 - признак для сортировки в Сменно-суточном
	               |	ВЫРАЗИТЬ(ЕСТЬNULL(ВТРазнарядка.ТС, ВТНеВРаботе.ТС) КАК Справочник.уатТС).ГаражныйНомер КАК ГарНомерТС,
	               |	ВЫРАЗИТЬ(ЕСТЬNULL(ВТРазнарядка.ТС, ВТНеВРаботе.ТС) КАК Справочник.уатТС).ГосударственныйНомер КАК ГосНомерТС,
	               |	ВЫРАЗИТЬ(ВТРазнарядка.Водитель КАК Справочник.уатСотрудники).Код КАК ТабНомерВодителя,
	               |	ВЫРАЗИТЬ(ВТРазнарядка.Водитель2 КАК Справочник.уатСотрудники).Код КАК ТабНомерВодителя2,
	               |	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЕСТЬNULL(ВТРазнарядка.ТС, ВТНеВРаботе.ТС)) КАК ТСПредставление,
	               |	ПРЕДСТАВЛЕНИЕССЫЛКИ(ЕСТЬNULL(ВТРазнарядка.ТипТС, ВТНеВРаботе.ТС.ТипТС)) КАК ТипТСПредставление,
	               |	ПРЕДСТАВЛЕНИЕССЫЛКИ(ВТРазнарядка.Водитель) КАК ВодительПредставление,
	               |	ПРЕДСТАВЛЕНИЕССЫЛКИ(ВТРазнарядка.Водитель2) КАК Водитель2Представление,
	               |	ЕСТЬNULL(ВТРазнарядка.ЧасыЛ, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ЧасыЛ,
	               |	ЕСТЬNULL(ВТРазнарядка.ЧасыР, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ЧасыР,
	               |	ЕСТЬNULL(ВТРазнарядка.ЧасыО, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ЧасыО,
	               |	ЕСТЬNULL(ВТРазнарядка.ЧасыЛВод, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ЧасыЛВод,
	               |	ЕСТЬNULL(ВТРазнарядка.ЧасыРВод, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ЧасыРВод,
	               |	ЕСТЬNULL(ВТРазнарядка.ЧасыОВод, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ЧасыОВод,
	               |	ВТРазнарядка.КодКА КАК КодКА,
	               |	ВТРазнарядка.Платформа КАК Платформа,
	               |	ВТРазнарядка.Стоянка КАК Стоянка
	               |ИЗ
	               |	ВТРазнарядка КАК ВТРазнарядка
	               |		ПОЛНОЕ СОЕДИНЕНИЕ ВТНеВРаботе КАК ВТНеВРаботе
	               |		ПО ВТРазнарядка.ТС = ВТНеВРаботе.ТС
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ТипТС,
	               |	МестоОказанияУслуг,
	               |	ТС";
	Возврат ТекстЗапроса;
	
КонецФункции

&НаСервере
Процедура ЗаполнитьСписокВыбораКолонн(МассивКолонн, ПечатьИзРазнарядки)
	
	СтарыйСВ = Элементы.фКолонна.СписокВыбора.Скопировать();
	Элементы.фКолонна.СписокВыбора.Очистить();
	
	Для каждого нКолонна Из МассивКолонн Цикл
		Пометка = Ложь;
		Поиск = СтарыйСВ.НайтиПоЗначению(нКолонна);
		Если Поиск <> Неопределено Тогда
			Пометка = ?(Поиск.Пометка, Истина, Ложь);
		КонецЕсли;	
		Если нКолонна.Ссылка = фКолонна И ПечатьИзРазнарядки Тогда
			Колонна = фКолонна;
			Пометка = Истина;
		КонецЕсли;
		Элементы.фКолонна.СписокВыбора.Добавить(нКолонна.Ссылка, нКолонна.Наименование, Пометка);			
	КонецЦикла; 	

КонецПроцедуры 

&НаСервере
Процедура ЗаполнитьСписокВыбораКонтрагент(МассивКонтрагент)
	
	СтарыйСВ = Элементы.фКонтрагент.СписокВыбора.Скопировать();
	Элементы.фКонтрагент.СписокВыбора.Очистить();
	
	Для каждого нКонтрагент Из МассивКонтрагент Цикл
		Пометка = Ложь;
		Поиск = СтарыйСВ.НайтиПоЗначению(нКонтрагент);
		Если Поиск <> Неопределено Тогда
			Пометка = ?(Поиск.Пометка, Истина, Ложь);
		КонецЕсли;
		Элементы.фКонтрагент.СписокВыбора.Добавить(нКонтрагент.Ссылка, нКонтрагент.Наименование, Пометка);
	КонецЦикла;

КонецПроцедуры 

#КонецОбласти

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("СтрДанные") Тогда
		Для каждого Данные Из Параметры.СтрДанные Цикл			
			ЭтаФорма[Данные.Ключ] = Данные.Значение;
		КонецЦикла;
		ЗапускИзРазнарядки = Истина;
	КонецЕсли;
	
	Для каждого МетДанные Из Метаданные.РегистрыСведений.Разнарядка.Макеты Цикл
		Элементы.ВариантОтчета.СписокВыбора.Добавить(МетДанные.Имя, МетДанные.Синоним);		
	КонецЦикла;
	
	ВариантОтчета = Элементы.ВариантОтчета.СписокВыбора[0].Значение;
		 
КонецПроцедуры

&НаКлиенте
Процедура Сформировать(Команда)
	Печать(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура КолоннаНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Сч = 0;
	НовыйВыбор = Новый СписокЗначений;
	Если Элементы.фКолонна.СписокВыбора.ОтметитьЭлементы("Выберите колонны:") Тогда
		Для Каждого ЭлементК Из Элементы.фКолонна.СписокВыбора Цикл
			Сч = Сч + 1;
			Если ЭлементК.Пометка Тогда
		        НовыйВыбор.Добавить(ЭлементК.Значение, ЭлементК.Представление, ЭлементК.Пометка);
		    КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Колонна = НовыйВыбор;
	
КонецПроцедуры

&НаКлиенте
Процедура КолоннаПриИзменении(Элемент)
	
	Сч = 0;
	НовыйВыбор = Новый СписокЗначений;
	Для Каждого ЭлементК Из Элементы.фКолонна.СписокВыбора Цикл
		Сч = Сч + 1;
		Если ЭлементК.Пометка Тогда
			НовыйВыбор.Добавить(ЭлементК.Значение, ЭлементК.Представление, ЭлементК.Пометка);
		КонецЕсли;
	КонецЦикла;
	
	Колонна = НовыйВыбор;
	Результат = Новый ТабличныйДокумент;
КонецПроцедуры

&НаКлиенте
Процедура ВариантОтчетаПриИзменении(Элемент)	
	ИзменитьВидимостьФильтров();
	Результат = Новый ТабличныйДокумент;
	//Печать();	// + Алексей, убрал, т.к. время тратится а ПФ нужна другая
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	Сч = 0;
	НовыйВыбор = Новый СписокЗначений;
	Если Элементы.фКонтрагент.СписокВыбора.ОтметитьЭлементы("Выберите контрагентов:") Тогда
		Для Каждого ЭлементК Из Элементы.фКонтрагент.СписокВыбора Цикл
			Сч = Сч + 1;
			Если ЭлементК.Пометка Тогда
		        НовыйВыбор.Добавить(ЭлементК.Значение, ЭлементК.Представление, ЭлементК.Пометка);
		    КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Контрагент = НовыйВыбор;
	
КонецПроцедуры

&НаКлиенте
Процедура КонтрагентПриИзменении(Элемент)

	Сч = 0;
	НовыйВыбор = Новый СписокЗначений;
	Для Каждого ЭлементК Из Элементы.фКонтрагент.СписокВыбора Цикл
		Сч = Сч + 1;
		Если ЭлементК.Пометка Тогда
			НовыйВыбор.Добавить(ЭлементК.Значение, ЭлементК.Представление, ЭлементК.Пометка);
		КонецЕсли;
	КонецЦикла;
	
	Контрагент = НовыйВыбор;
	Результат = Новый ТабличныйДокумент;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьСсылкуМаршрута(Текст)
	Возврат Справочники.уатМаршруты.НайтиПоНаименованию(Текст);	
КонецФункции

&НаКлиенте
Процедура РезультатВыбор(Элемент, Область, СтандартнаяОбработка)
	Если ВариантОтчета = "РазнярядкаПоЗаказчикам" И Область.Лево = 2 И ЗначениеЗаполнено(Область.Текст) Тогда
		//мСсылка = ПолучитьСсылкуМаршрута(Область.Текст); 
		//Если мСсылка <> Неопределено Тогда
		//	ПоказатьЗначение(,мСсылка);
		//КонецЕсли;	
	КонецЕсли;	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалПриИзменении(Элемент)
	Результат = Новый ТабличныйДокумент;
КонецПроцедуры

&НаКлиенте
Процедура фМестоРаботыПриИзменении(Элемент)
	Результат = Новый ТабличныйДокумент;
КонецПроцедуры