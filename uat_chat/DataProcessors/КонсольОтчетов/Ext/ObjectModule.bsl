﻿// Функция формирует путь строки из строки.
//
//Параметры:
// Строка - строка, на основе которой формируется путь строки
//
//Возвращаемое значение:
//	Путь строки дерева
//
Функция ПолучитьПутьСтроки(Строка) Экспорт
	ПутьСтроки = Неопределено;
	
	Если Строка <> Неопределено Тогда
		ТС = Строка;
		Пока ТС <> Неопределено Цикл
			Если ПутьСтроки = Неопределено Тогда
				ПутьСтроки = ТС.Запрос;
			Иначе
				ПутьСтроки = ТС.Запрос + Символы.ПС + ПутьСтроки;
			КонецЕсли;
			ТС = ТС.Родитель;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ПутьСтроки;
КонецФункции // ПолучитьПутьСтроки()

// Находит строку в дереве строк пути.
//
//Параметры:
//	Путь - дерево строк, в котором осуществляется поиск
//
//Возвращаемое значение:
//	Текущая строка дерева запросов
//
Функция НайтиСтрокуПоПути(Путь) Экспорт
	ТекущаяСтрокаДерева = Неопределено;

	Если Путь <> Неопределено Тогда
		
		Для тс = 1 По СтрЧислоСтрок(Путь) Цикл
			ТекущееИмяЗапроса = СтрПолучитьСтроку(Путь, тс);
			
			Если ТекущаяСтрокаДерева = Неопределено Тогда 
				Строки = ДеревоЗапросов.Строки;
			Иначе
				Строки = ТекущаяСтрокаДерева.Строки;
			КонецЕсли;
			
			Найдено = Ложь;
			Для Каждого СтрокаДерева Из Строки Цикл
				Если СтрокаДерева.Запрос = ТекущееИмяЗапроса Тогда
					// Нашли текущее имя
					Найдено = Истина;
					ТекущаяСтрокаДерева = СтрокаДерева;
					Прервать;
				КонецЕсли;
			КонецЦикла;
			
			Если Не Найдено Тогда
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	
	Возврат ТекущаяСтрокаДерева;
КонецФункции // НайтиСтрокуПоПути()


// Создадим структуру дерева запросов
ДеревоЗапросов.Колонки.Добавить("Запрос");
ДеревоЗапросов.Колонки.Добавить("ТекстЗапроса");
ДеревоЗапросов.Колонки.Добавить("ПараметрыЗапроса");
ДеревоЗапросов.Колонки.Добавить("АвтоЗаполнение");
ДеревоЗапросов.Колонки.Добавить("НастройкиПостроителя");
ДеревоЗапросов.Колонки.Добавить("ВыбТипДиаграммы");
ДеревоЗапросов.Колонки.Добавить("РазмещениеГруппировок");
ДеревоЗапросов.Колонки.Добавить("РазмещениеРеквизитов");
ДеревоЗапросов.Колонки.Добавить("ТипОформления");
ДеревоЗапросов.Колонки.Добавить("ПредставленияДляИмен");
ДеревоЗапросов.Колонки.Добавить("ИспользоватьМакет");
ДеревоЗапросов.Колонки.Добавить("Макет");
ДеревоЗапросов.Колонки.Добавить("ВыводВДиаграмму");
ДеревоЗапросов.Колонки.Добавить("ВыводВСводнуюТаблицу");
ДеревоЗапросов.Колонки.Добавить("ВыводВТаблицу");
ДеревоЗапросов.Колонки.Добавить("ПоУмолчаниюВыводитьВ");
ДеревоЗапросов.Колонки.Добавить("ОтчетРасшифровки");
ДеревоЗапросов.Колонки.Добавить("РазмещениеИтогов");
ДеревоЗапросов.Колонки.Добавить("НастройкаДляЗагрузки");
ДеревоЗапросов.Колонки.Добавить("СохранятьНастройкиАвтоматически");
ДеревоЗапросов.Колонки.Добавить("ФиксированныйЗаголовок");
ДеревоЗапросов.Колонки.Добавить("МакетСОформлением");
ДеревоЗапросов.Колонки.Добавить("ФорматыДляИмен");
ДеревоЗапросов.Колонки.Добавить("ВыбТипСводДиаграммы");
ДеревоЗапросов.Колонки.Добавить("ВыводВСводДиаграмму");

ПостроительОтчетов.ВыводитьДетальныеЗаписи = Истина;
ПостроительОтчетов.АвтоДетальныеЗаписи = Истина;