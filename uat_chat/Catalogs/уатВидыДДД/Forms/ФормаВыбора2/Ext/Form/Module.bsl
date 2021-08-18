﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	дляСотр = Неопределено;
	дляТС = Неопределено;
	
	Если Параметры.Свойство("дляСотр") ТОгда 
		дляСотр = Параметры.дляСотр;
		этаФорма.Заголовок = ""+ЭтаФорма.Заголовок+" (для сотрдуников)";
	КонецЕсли;
	Если Параметры.Свойство("дляТС")   ТОгда 
		дляТС = Параметры.дляТС; 
		этаФорма.Заголовок = ""+ЭтаФорма.Заголовок+" (для ТС)";
	КонецЕсли;
	
	СпкУатВидыДДД.ЗагрузитьЗначения(Справочники.уатВидыДДД.ПолучитьМассивДоступныхДокументов(дляСотр,дляТС));
  
  
КонецПроцедуры

&НаКлиенте
Процедура СпкУатВидыДДДВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	ОповеститьОВыборе(СпкУатВидыДДД[ВыбраннаяСтрока].Значение);
КонецПроцедуры

&НаКлиенте
Процедура ОтобразитьВсеЭлементы(Команда)
	Элементы.СпкУатВидыДДД.Видимость = Ложь;
	Элементы.ОтобразитьВсеЭлементы.Видимость = Ложь;
	Элементы.Список.Видимость = Истина;
КонецПроцедуры

&НаКлиенте
Процедура СписокВыбор(Элемент, ВыбраннаяСтрока, Поле, СтандартнаяОбработка)
	Если ВыбраннаяСтрока.ЭтоГруппа = Ложь ТОгда
		СтандартнаяОбработка = Ложь;
		ОповеститьОВыборе(ВыбраннаяСтрока);
	КонецЕСЛИ;
КонецПроцедуры
