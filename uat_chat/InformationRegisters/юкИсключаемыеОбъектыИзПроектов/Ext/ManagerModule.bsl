﻿Функция  ИсключаемыеОбъекты()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	юкИсключаемыеОбъектыИзПроектов.ИсключаемыйОбъект КАК ИсключаемыйОбъектСсылка,
		|	юкИсключаемыеОбъектыИзПроектов.ИсключаемыйОбъект.Наименование КАК ИсключаемыйОбъект,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(юкИсключаемыеОбъектыИзПроектов.ИсключаемыйОбъект) = ТИП(Справочник.уатТС)
		|			ТОГДА юкИсключаемыеОбъектыИзПроектов.ИсключаемыйОбъект.ГаражныйНомер
		|		ИНАЧЕ юкИсключаемыеОбъектыИзПроектов.ИсключаемыйОбъект.Код
		|	КОНЕЦ КАК КодОбъекта,
		|	ВЫБОР
		|		КОГДА ТИПЗНАЧЕНИЯ(юкИсключаемыеОбъектыИзПроектов.ИсключаемыйОбъект) = ТИП(Справочник.уатТС)
		|			ТОГДА ""ТС""
		|		ИНАЧЕ ""Подразделение""
		|	КОНЕЦ КАК ТипОбъекта
		|ИЗ
		|	РегистрСведений.юкИсключаемыеОбъектыИзПроектов КАК юкИсключаемыеОбъектыИзПроектов";
	
	Возврат Запрос.Выполнить().Выгрузить();;
КонецФункции

Функция  ЗаполнитьПереченьТСВРемонтеПолный()
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	уатРемонтныйЛист.ТС.Наименование КАК ТС,
		|	уатРемонтныйЛист.ТС.ГаражныйНомер КАК ГаражныйНомер,
		|	уатМестонахождениеТССрезПоследних.Подразделение.Наименование КАК Подразделение,
		|	уатРемонтныйЛист.ТС.ГосударственныйНомер КАК ГосударственныйНомер,
		|	уатРемонтныйЛист.ДатаНачала КАК ДатаНачалаРемонта,
		|	уатРемонтныйЛист.ДатаОкончанияПлан КАК ДатаОкончанияПлановая,
		|	уатРемонтныйЛист.Гараж.Наименование КАК Гараж
		|ИЗ
		|	Документ.уатРемонтныйЛист КАК уатРемонтныйЛист
		|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаЗапроса, ) КАК уатМестонахождениеТССрезПоследних
		|		ПО уатРемонтныйЛист.ТС = уатМестонахождениеТССрезПоследних.ТС
		|ГДЕ
		|	уатРемонтныйЛист.ПометкаУдаления = ЛОЖЬ
		|	И уатРемонтныйЛист.ДатаОкончания = ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)
		|	И уатРемонтныйЛист.Дата >= ДАТАВРЕМЯ(2020, 1, 1, 0, 0, 0)
		|
		|УПОРЯДОЧИТЬ ПО
		|	ДатаНачалаРемонта
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ДатаЗапроса", ТекущаяДата());
	
	Возврат  Запрос.Выполнить().Выгрузить();
	
КонецФункции

Функция  ЗаполнитьПереченьТСВЭксплуатации(МассивИсключаемыхОбъектов)
	
	
	Запрос = Новый Запрос;
	Запрос.Текст = 
		"ВЫБРАТЬ
		|	уатМестонахождениеТССрезПоследних.ТС.Наименование КАК ТС,
		|	уатМестонахождениеТССрезПоследних.ТС.ГаражныйНомер КАК ГаражныйНомер,
		|	уатМестонахождениеТССрезПоследних.Подразделение.Наименование КАК Подразделение,
		|	1 КАК Количество,
		|	уатМестонахождениеТССрезПоследних.ТС.ИДвСистемеНавигации КАК ИДвСистемеНавигации,
		|	уатМестонахождениеТССрезПоследних.ТС.СистемаМониторинга.Наименование КАК СистемаМониторинга,
		|	уатМестонахождениеТССрезПоследних.ТС.ГосударственныйНомер КАК ГосударственныйНомер
		|ИЗ
		|	РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаЗапроса, ) КАК уатМестонахождениеТССрезПоследних
		|ГДЕ
		|	уатМестонахождениеТССрезПоследних.Состояние.ЗапретитьВыпискуПЛ = ЛОЖЬ
		|	И уатМестонахождениеТССрезПоследних.Состояние <> ЗНАЧЕНИЕ(Справочник.уатСостояниеТС.Привлеченный)
		|	И НЕ уатМестонахождениеТССрезПоследних.Подразделение В (&МассивИскПодразделений)
		|	И НЕ уатМестонахождениеТССрезПоследних.ТС В (&МассивИскТС)
		|
		|УПОРЯДОЧИТЬ ПО
		|	уатМестонахождениеТССрезПоследних.ТС.ГаражныйНомер
		|АВТОУПОРЯДОЧИВАНИЕ";
	
	Запрос.УстановитьПараметр("ДатаЗапроса", ТекущаяДата());
	Запрос.УстановитьПараметр("МассивИскПодразделений", МассивИсключаемыхОбъектов);
	Запрос.УстановитьПараметр("МассивИскТС", МассивИсключаемыхОбъектов);
	
	
	Возврат Запрос.Выполнить().Выгрузить();
	
	
КонецФункции

Функция Гаражи()
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	уатГаражи.Наименование КАК Наименование,
	               |	уатГаражи.ЦветГаража КАК ЦветГаража,
	               |	уатГаражи.ИДГеозоны КАК ИДГеозоны,
	               |	уатГаражи.НаименованиеГеозоны КАК НаименованиеГеозоны
	               |ИЗ
	               |	Справочник.уатГаражи КАК уатГаражи";
	Тбл =  Запрос.Выполнить().Выгрузить();
	Возврат ТБл;
КонецФункции


Функция  ЗаполнитьОсновныеТаблицы() Экспорт
	
	//Организуем массив объектов, ислючаемых из мониторинга - здесь будут и ТС и подразделения
	тбИсклОб = ИсключаемыеОбъекты();
	ОтборПоИсключаемымОбъектам = тбИсклОб.ВыгрузитьКолонку("ИсключаемыйОбъектСсылка");
	ОтборПоИсключаемымОбъектам.Добавить(Справочники.ПодразделенияОрганизаций.ПустаяСсылка());
	
	тбРем = ЗаполнитьПереченьТСВРемонтеПолный();
	тбЭксп = ЗаполнитьПереченьТСВЭксплуатации(ОтборПоИсключаемымОбъектам);
	тбГар = Гаражи();
	
	Стк = Новый Структура();
	Стк.Вставить("тбРем",тбРем);
	Стк.Вставить("тбЭксп",тбЭксп);
	Стк.Вставить("тбГар",тбГар);
	Стк.Вставить("тбИсклОб",тбИсклОб);
	
	хр = Новый ХранилищеЗначения(стк,Новый СжатиеДанных(5));
	Возврат XMLСтрока(хр);
	
КонецФункции
