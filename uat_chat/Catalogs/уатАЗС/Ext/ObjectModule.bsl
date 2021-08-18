﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения
Перем ИмяФайлаВнешнейОбработки Экспорт; // Имя файла внеш. обработки для загрузки данных по АЗС
//Перем ФлагЗаписатьОбработкуЗагрузки Экспорт;


//Функция проверяет наличие обработки загрузки данных 
// Параметры: 	ТС - ссылка на справочник ОС
// Возвращаемое значение: Список значений
Функция ЕстьОбработкаЗагрузки() ЭКСПОРТ
	
	Запрос = Новый Запрос;
	
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	КартинкиИФайлы.Данные
	|ИЗ
	|	РегистрСведений.уатКартинкиИФайлы КАК КартинкиИФайлы
	|ГДЕ
	|	КартинкиИФайлы.Объект = &Объект
	|	И КартинкиИФайлы.Идентификатор = &Идентификатор";
	
	Запрос.УстановитьПараметр("Объект", Ссылка);
	Запрос.УстановитьПараметр("Идентификатор", "Обработка загрузки данных");
	Результат = Не Запрос.Выполнить().Пустой();
	
	Возврат Результат;
	
КонецФункции // ПроверитьОбработкуЗагрузки

#Если Клиент Тогда
	
	//Функция возвращает обработку загрузки данных 
	// Параметры: 	ТС - ссылка на справочник ОС
	// Возвращаемое значение: Список значений
	Функция ПолучитьОбработкуЗагрузки() ЭКСПОРТ
		
		Запрос = Новый Запрос;
		
		Запрос.Текст = 
		"ВЫБРАТЬ
		|	КартинкиИФайлы.Данные
		|ИЗ
		|	РегистрСведений.уатКартинкиИФайлы КАК КартинкиИФайлы
		|ГДЕ
		|	КартинкиИФайлы.Объект = &Объект
		|	И КартинкиИФайлы.Идентификатор = &Идентификатор";
		
		Запрос.УстановитьПараметр("Объект", Ссылка);
		Запрос.УстановитьПараметр("Идентификатор", "Обработка загрузки данных");
		РезультатЗапроса = Запрос.Выполнить().Выбрать();
		Если РезультатЗапроса.Следующий() Тогда
			ИмяФайлаОбработки = КаталогВременныхФайлов() + ?(Прав(КаталогВременныхФайлов(), 1) = "\", "", "\") + "ОбработкаЗагрузкиПЦ" + СокрЛП(ЭтотОбъект.Наименование) + ".epf";
			
			Попытка
				РезультатЗапроса.Данные.Получить().Записать(ИмяФайлаОбработки);
				Возврат ВнешниеОбработки.Создать(ИмяФайлаОбработки);
			Исключение
				Предупреждение("Неправильное имя обработки для загрузки данных АЗС!
				|Для исправления внесите изменения в справочник ""АЗС""
				|для """ + СокрЛП(ЭтотОбъект.Наименование) + """");
				Возврат Неопределено;				
			КонецПопытки;	
		Иначе
			Возврат Неопределено;
		КонецЕсли;	
		
	КонецФункции // ПолучитьОбработкуЗагрузки
	
	//Функция записывает обработку загрузки данных в хранилище
	// 
	Функция ЗаписатьОбработкуЗагрузки() ЭКСПОРТ
		
		Если ЗначениеЗаполнено(ИмяФайлаВнешнейОбработки) Тогда
			ПроверкаФайл = Новый Файл(ИмяФайлаВнешнейОбработки);
			Если НЕ ПроверкаФайл.Существует() Тогда
				Сообщить("Файл <" + ИмяФайлаВнешнейОбработки + "> не обнаружен!", СтатусСообщения.Внимание);
				Возврат Ложь;
			КонецЕсли;
			
			Попытка
				Запись = РегистрыСведений.уатКартинкиИФайлы.СоздатьМенеджерЗаписи();
				Запись.Прочитать();
				Запись.Объект = Ссылка;
				Запись.Идентификатор = "Обработка загрузки данных";
				
				мОбработка = Новый ДвоичныеДанные(ИмяФайлаВнешнейОбработки);
				ХранилищеОбработки = Новый ХранилищеЗначения(мОбработка);
				Запись.Данные = ХранилищеОбработки;
				Запись.Записать(Истина);
				
				Результат = Истина;
			Исключение
				Сообщить(ОписаниеОшибки());
				
				Результат = Ложь;
			КонецПопытки;	
			
		КонецЕсли;
		
		Возврат Результат;
		
	КонецФункции // 
	
#КонецЕсли



// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА

// Стандартный обработчик ПередЗаписью элемента справочника
//
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВСправочниках(ЭтотОбъект, Отказ, , Права);
	
	Если ЭтоГруппа=Ложь Тогда
	ЭтоАЗССклад = (ТипЗнч(Контрагент_Склад) = Тип("СправочникСсылка.Склады"));
	//Наименование = Контрагент_Склад.Наименование;
	КонецеСЛИ;

КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли