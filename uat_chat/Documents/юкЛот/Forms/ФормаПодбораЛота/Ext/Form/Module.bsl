﻿
&НаКлиенте
Процедура ПоискЛота(Команда)
	мМассивСтрок = НайтиСтрокиЛотов(фГруппаТипов, фКонтрагент, фМесяц, фДнейЗаМесяц, фЗапрещенныйЛот);
	фТаблицаЛотов.Очистить();
	Для Каждого мЭлемент Из мМассивСтрок Цикл
		мНоваяСтрока = фТаблицаЛотов.Добавить();
		ЗаполнитьЗначенияСвойств(мНоваяСтрока, мЭлемент);
	КонецЦикла;
КонецПроцедуры

&НаКлиенте
Процедура фТипТСПриИзменении(Элемент)
	фГруппаТипов = НайтиГруппуТипов(фТипТС);
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	фМесяц = ТекущаяДата();
	фДнейЗаМесяц = 31;	// by default
	Параметры.Свойство("ЗапрещенныйЛот", фЗапрещенныйЛот);
	Параметры.Свойство("РежимВыбораИдентификатора", фРежимВыбораИдентификатора);
	Если (Не Параметры.Свойство("СтруктураПереносаРазбивки")) И (Не фРежимВыбораИдентификатора) И Параметры.ТС.Пустая() Тогда
		Отказ = Истина;
		Возврат;
	ИначеЕсли фРежимВыбораИдентификатора Тогда
		фТипТС = ?(Параметры.Свойство("ТС"), Параметры.ТС.ТипТС, Параметры.ТипТС);
		фГруппаТипов = НайтиГруппуТипов(фТипТС);
		фКонтрагент = ?(Параметры.Свойство("ЦехМаршрут") И ЗначениеЗаполнено(Параметры.ЦехМаршрут), Параметры.ЦехМаршрут.Владелец, Параметры.Контрагент);
		фДнейЗаМесяц = ?(Параметры.Свойство("ДнейЗаМесяц"), Параметры.ДнейЗаМесяц, 31);
		Элементы.ТаблицаЛотовПривязатьКСтрокеЛота.Видимость = Ложь;
		Элементы.фТаблицаЛотовОтмена.Видимость = Истина;
	ИначеЕсли Параметры.Свойство("СтруктураПереносаРазбивки") Тогда
		//перенос между документами
		фСтруктураСтрокиРазбивки = Параметры.СтруктураПереносаРазбивки;
		фГруппаТипов = Параметры.ГрупповойТип;
		фМесяц = ДобавитьМесяц(НачалоГода(ТекущаяДата()), Параметры.НомерМесяца);
		фДнейЗаМесяц = Параметры.ДнейВМесяц;
		фКонтрагент = ?(ЗначениеЗаполнено(фСтруктураСтрокиРазбивки.ЦехМаршрут), фСтруктураСтрокиРазбивки.ЦехМаршрут.Владелец, ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
		фВремяНачала = фСтруктураСтрокиРазбивки.ВремяПодачи;
		фВремяОкончания = фСтруктураСтрокиРазбивки.ВремяВозврата;
		Элементы.ГруппаВремя.Видимость = (ТипЗнч(фСтруктураСтрокиРазбивки.ЦехМаршрут) = Тип("СправочникСсылка.ЦехаКонтрагента"));
	Иначе
		//привязка новой строки разнарядки к строке лота
		фТипТС = Параметры.ТС.ТипТС;
		фГруппаТипов = НайтиГруппуТипов(фТипТС);
		фКонтрагент = ?(ЗначениеЗаполнено(Параметры.ЦехМаршрут), Параметры.ЦехМаршрут.Владелец, ПредопределенноеЗначение("Справочник.Контрагенты.ПустаяСсылка"));
		фСтруктураСтрокиРазбивки = Новый Структура;
		фСтруктураСтрокиРазбивки.Вставить("ИдентификаторСтрокиЗаявки", Параметры.ИдентификаторСтрокиЗаявки);
		фСтруктураСтрокиРазбивки.Вставить("ЦехМаршрут", Параметры.ЦехМаршрут);
		фСтруктураСтрокиРазбивки.Вставить("ВремяПодачи", Параметры.ВремяПодачи);
		фСтруктураСтрокиРазбивки.Вставить("ВремяВозврата", Параметры.ВремяВозврата);
		фСтруктураСтрокиРазбивки.Вставить("ПозицияПП", Параметры.ПозицияПП);
		фВремяНачала = Параметры.ВремяПодачи;
		фВремяОкончания = Параметры.ВремяВозврата;
		Элементы.ГруппаВремя.Видимость = (ТипЗнч(фСтруктураСтрокиРазбивки.ЦехМаршрут) = Тип("СправочникСсылка.ЦехаКонтрагента"));
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция НайтиСтрокиЛотов(пГруппаТипов, пКонтрагент, пМесяцДатой, пДнейЗаМесяц, пЗапрещенныйЛот = Неопределено)
	вМассив = Новый Массив;
	мЗапрос = Новый Запрос("ВЫБРАТЬ
	|	юкЛотТаблицаЛотов.Ссылка,
	|	юкЛотТаблицаЛотов.Ссылка.Контрагент,
	|	юкЛотТаблицаЛотов.ГрупповойТип,
	|	юкЛотТаблицаЛотов.КоличествоТС,
	|	юкЛотТаблицаЛотов.ИдентификаторСтрокиЛота КАК ИдентификаторСтрокиЛота,
	|	юкЛотТаблицаЛотов.РежимРаботы КАК РежимРаботы,
	|	Количество(ТаблицаРазбивки.ИдентификаторСтрокиЗаявки) КАК Привязано
	|ИЗ
	|	Документ.юкЛот.ТаблицаЛотов КАК юкЛотТаблицаЛотов
	|	ЛЕВОЕ СОЕДИНЕНИЕ Документ.юкЛот.РазбивкаПоЦехамМаршрутам КАК ТаблицаРазбивки
	|	ПО юкЛотТаблицаЛотов.Ссылка = ТаблицаРазбивки.Ссылка
	|		И юкЛотТаблицаЛотов.ИдентификаторСтрокиЛота = ТаблицаРазбивки.ИдентификаторСтрокиЛота
	|ГДЕ
	|	юкЛотТаблицаЛотов.КоличествоТС > 0
	|	И (ВЫБОР КОГДА &ГруппаТипов <> ЗНАЧЕНИЕ(Справочник.юкГруппыТипов.ПустаяСсылка) ТОГДА юкЛотТаблицаЛотов.ГрупповойТип = &ГруппаТипов ИНАЧЕ ИСТИНА КОНЕЦ)
	|	И юкЛотТаблицаЛотов.Ссылка.Контрагент = &Контрагент
	|	И (ВЫБОР КОГДА &Дней > 0 ТОГДА юкЛотТаблицаЛотов.ДнейВРаботеЗаСмену1 = &Дней ИНАЧЕ ИСТИНА КОНЕЦ)
	|	И (НЕ юкЛотТаблицаЛотов.Ссылка.ПометкаУдаления)
	|	И (НЕ юкЛотТаблицаЛотов.Ссылка = &ЗапрещенныйЛот)
	|СГРУППИРОВАТЬ ПО юкЛотТаблицаЛотов.Ссылка, юкЛотТаблицаЛотов.ИдентификаторСтрокиЛота, юкЛотТаблицаЛотов.КоличествоТС, юкЛотТаблицаЛотов.ГрупповойТип, юкЛотТаблицаЛотов.РежимРаботы
	|УПОРЯДОЧИТЬ ПО юкЛотТаблицаЛотов.ГрупповойТип, юкЛотТаблицаЛотов.КоличествоТС, Привязано");
	мЗапрос.УстановитьПараметр("Контрагент", пКонтрагент);
	мЗапрос.УстановитьПараметр("ГруппаТипов", пГруппаТипов);
	мЗапрос.УстановитьПараметр("Дней", пДнейЗаМесяц);
	//	запрещаем вставку, если это перенос из открытого документа, ссылка на который передается
	//		параметром "ЗапрещенныйЛот" в реквизит "фЗапрещенныйЛот"
	мЗапрос.УстановитьПараметр("ЗапрещенныйЛот", пЗапрещенныйЛот);
	мСтрокаДнейЗаСменуПоМесяцу = "ДнейВРаботеЗаСмену" + Месяц(пМесяцДатой);
	мЗапрос.Текст = СтрЗаменить(мЗапрос.Текст, "ДнейВРаботеЗаСмену1", мСтрокаДнейЗаСменуПоМесяцу);
	мРезультат = мЗапрос.Выполнить().Выбрать();
	
	Пока мРезультат.Следующий() Цикл
		мСтруктура = Новый Структура("Ссылка, Контрагент, ГрупповойТип, ИдентификаторСтрокиЛота, РежимРаботы, КоличествоТС, Привязано");
		ЗаполнитьЗначенияСвойств(мСтруктура, мРезультат);
		вМассив.Добавить(мСтруктура);
	КонецЦикла;
	
	Возврат вМассив;
КонецФункции

&НаСервереБезКонтекста
Функция НайтиГруппуТипов(пТипТС)
	вГруппа = Справочники.юкГруппыТипов.ПустаяСсылка();
	мЗапрос = Новый Запрос("ВЫБРАТЬ
	|	юкГруппыТиповСписокТипов.Ссылка КАК Ссылка
	|ИЗ
	|	Справочник.юкГруппыТипов.СписокТипов КАК юкГруппыТиповСписокТипов
	|ГДЕ
	|	юкГруппыТиповСписокТипов.ТипТС = &ТипТС
	|	И НЕ юкГруппыТиповСписокТипов.Ссылка.ПометкаУдаления");
	мЗапрос.УстановитьПараметр("ТипТС", пТипТС);
	мРезультат = мЗапрос.Выполнить().Выбрать();
	Если мРезультат.Следующий() Тогда
		вГруппа = мРезультат.Ссылка;
	КонецЕсли;
	
	Возврат вГруппа;
КонецФункции

&НаКлиенте
Процедура ПривязатьКСтрокеЛота(Команда)
	Если фМестоРаботы.Пустая() Тогда
		ПоказатьПредупреждение( , "Не указано место работы!");
		Возврат;
	КонецЕсли;
	мСтрокаТекущихДанных = Элементы.фТаблицаЛотов.ТекущиеДанные;
	Если мСтрокаТекущихДанных <> Неопределено Тогда
		фСтруктураСтрокиРазбивки.Вставить("ВремяПодачи", фВремяНачала);
		фСтруктураСтрокиРазбивки.Вставить("ВремяВозврата", фВремяОкончания);
		мРезультатПривязки = ПривязатьКДокументу(мСтрокаТекущихДанных.Ссылка, мСтрокаТекущихДанных.ИдентификаторСтрокиЛота, фСтруктураСтрокиРазбивки, фМестоРаботы);
		фСтруктураСтрокиРазбивки = Неопределено;
		ПередЗакрытием(Ложь, Неопределено, "", Ложь);
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПривязатьКДокументу(пДокументЛота, пИдентификаторСтрокиЛота, пСтруктураСтрокиРазбивки, пМестоРаботы)
	мОбъектДокумента = пДокументЛота.ПолучитьОбъект();
	мСтруктураПоиска = Новый Структура("ИдентификаторСтрокиЗаявки", пСтруктураСтрокиРазбивки.ИдентификаторСтрокиЗаявки);
	мСтрокиРазбивки = мОбъектДокумента.РазбивкаПоЦехамМаршрутам.НайтиСтроки(мСтруктураПоиска);
	Если мСтрокиРазбивки.Количество() = 0 Тогда
		мНоваяСтрокаРазбивки = мОбъектДокумента.РазбивкаПоЦехамМаршрутам.Добавить();
	Иначе
		мНоваяСтрокаРазбивки = мСтрокиРазбивки[0];
	КонецЕсли;
	ЗаполнитьЗначенияСвойств(мНоваяСтрокаРазбивки, пСтруктураСтрокиРазбивки);
	мНоваяСтрокаРазбивки.ИдентификаторСтрокиЛота = пИдентификаторСтрокиЛота;
	мНоваяСтрокаРазбивки.МестоРаботы = пМестоРаботы;
	мОбъектДокумента.ЗаписыватьВРазнарядку = Истина;
	мОбъектДокумента.Записать(РежимЗаписиДокумента.Запись, РежимПроведенияДокумента.Неоперативный);
	Возврат Истина;
КонецФункции

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	Если ЗначениеЗаполнено(фКонтрагент) И ЗначениеЗаполнено(фГруппаТипов) И ЗначениеЗаполнено(фДнейЗаМесяц) И ЗначениеЗаполнено(фМесяц) Тогда
		ПоискЛота(Неопределено);
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	Если фРежимВыбораИдентификатора И СтандартнаяОбработка = Ложь Тогда
		ЭтаФорма.Закрыть(Неопределено);
	ИначеЕсли фЗапрещенныйЛот <> Неопределено И Не фЗапрещенныйЛот.Пустая() Тогда
		СтандартнаяОбработка = Ложь;
		ЭтаФорма.Закрыть(фСтруктураСтрокиРазбивки);
	ИначеЕсли фРежимВыбораИдентификатора Тогда
		мТекущаяСтрока = Элементы.фТаблицаЛотов.ТекущиеДанные;
		Если мТекущаяСтрока <> Неопределено Тогда
			СтандартнаяОбработка = Ложь;
			ЭтаФорма.Закрыть(мТекущаяСтрока.ИдентификаторСтрокиЛота);
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура фРежимРаботыПриИзменении(Элемент)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	ПередЗакрытием(Ложь, , , Ложь);
КонецПроцедуры
