﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	//todo kutv 2012.05.11
	//взять из общего модуля метод проверки объединения с БП
	ЭтоОбъединеннаяКонфигурация = Метаданные.Справочники.Найти("РегистрацияВИФНС") <> Неопределено;
	
	Список.ТекстЗапроса = "ВЫБРАТЬ
	|	РегистрСведенийуатМинимальныеОстаткиНоменклатуры.Номенклатура,
	|	РегистрСведенийуатМинимальныеОстаткиНоменклатуры.МинимальныйОстаток,
	|   //ЕдИзм
	|ИЗ
	|	РегистрСведений.уатМинимальныеОстаткиНоменклатуры КАК РегистрСведенийуатМинимальныеОстаткиНоменклатуры";
	Если ЭтоОбъединеннаяКонфигурация Тогда
		Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "//ЕдИзм", "РегистрСведенийуатМинимальныеОстаткиНоменклатуры.Номенклатура.БазоваяЕдиницаИзмерения КАК ЕдИзм");
	Иначе
		Список.ТекстЗапроса = СтрЗаменить(Список.ТекстЗапроса, "//ЕдИзм", "РегистрСведенийуатМинимальныеОстаткиНоменклатуры.Номенклатура.ЕдиницаХраненияОстатков КАК ЕдИзм");
	КонецЕсли;
КонецПроцедуры
