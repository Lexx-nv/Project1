
// Функция возвращает массив вышестоящих групп указанного элемента.
// 
// Переметры:
//  Элемент      - Элемент справочника, для которого ищется родитель
//
// Возвращаемое значение
//  Массив вышестояших групп
//
Функция ПолучитьСписокВышеСтоящихГрупп(ЭлементСправочника) Экспорт
	
	Результат = Новый Массив;		
	
	Если НЕ ЗначениеЗаполнено(ЭлементСправочника) Тогда
		Возврат Результат;
	КонецЕсли;
	
	МетаданныеСправочника = ЭлементСправочника.Метаданные();
	Если НЕ МетаданныеСправочника.Иерархический Тогда
		Возврат Результат;
	КонецЕсли;
	ИмяСправочника = МетаданныеСправочника.Имя;	
	Запрос = Новый Запрос;
	Запрос.Текст = "
	|ВЫБРАТЬ
	|	Справочник1.Родитель КАК Родитель1,
	|	Справочник2.Родитель КАК Родитель2,
	|	Справочник3.Родитель КАК Родитель3,
	|	Справочник4.Родитель КАК Родитель4,
	|	Справочник5.Родитель КАК Родитель5
	|ИЗ
	|	Справочник." + ИмяСправочника + " КАК Справочник1
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник." + ИмяСправочника + " КАК Справочник2
	|		ПО (Справочник2.Ссылка = Справочник1.Родитель)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник." + ИмяСправочника + " КАК Справочник3
	|		ПО (Справочник3.Ссылка = Справочник2.Родитель)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник." + ИмяСправочника + " КАК Справочник4
	|		ПО (Справочник4.Ссылка = Справочник3.Родитель)
	|		ЛЕВОЕ СОЕДИНЕНИЕ Справочник." + ИмяСправочника + " КАК Справочник5
	|		ПО (Справочник5.Ссылка = Справочник4.Родитель)
	|ГДЕ
	|	Справочник1.Ссылка = &Ссылка";
	
	ТекущийЭлемент = ЭлементСправочника;
	
	Пока ЗначениеЗаполнено(ТекущийЭлемент) Цикл		
		Запрос.УстановитьПараметр("Ссылка", ТекущийЭлемент);
		Выборка = Запрос.Выполнить().Выбрать();
		Если Выборка.Следующий() Тогда
			Для Индекс = 1 по 5 Цикл
				ТекущийЭлемент = Выборка["Родитель" + Индекс];
				Если ЗначениеЗаполнено(ТекущийЭлемент) Тогда
					Результат.Добавить(ТекущийЭлемент);
				Иначе
					Прервать;
				КонецЕсли;				
			КонецЦикла;
		Иначе
			ТекущийЭлемент = Неопределено;
		КонецЕсли;
	КонецЦикла;	
	
	Возврат Результат;
	
КонецФункции

// Функция ИнформационнаяБазаФайловая определяет режим эксплуатации
// информационной базы файловый (Истина) или Серверный (Ложь).
//  При проверке используется СтрокаСоединенияИнформационнойБазы, которую
// можно указать явно.
//
// Параметры:
//  СтрокаСоединенияИнформационнойБазы - Строка - параметр используется, если
//                 нужно проверить строку соединения не текущей информационной базы.
//
// Возвращаемое значение:
//  Булево.
//
Функция ИнформационнаяБазаФайловая(Знач СтрокаСоединенияИнформационнойБазы = "") Экспорт
			
	Если ПустаяСтрока(СтрокаСоединенияИнформационнойБазы) Тогда
		СтрокаСоединенияИнформационнойБазы =  СтрокаСоединенияИнформационнойБазы();
	КонецЕсли;
	Возврат Найти(Врег(СтрокаСоединенияИнформационнойБазы), "FILE=") = 1;
	
КонецФункции // ИнформационнаяБазаФайловая()