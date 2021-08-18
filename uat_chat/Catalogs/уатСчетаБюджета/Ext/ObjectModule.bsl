﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт;	// Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА


// Процедура генерирует код перемещаемого элемента (группы) справочника,
// а также код расположенного рядом элемента при интерактивном перемещении
// элемента в форме списка справочника.
// Записывает переставляемые элементы с измененными кодами.
// В случае сдвига группы элементов также изменяет коды вложенных в группу
// элементов.
//
// Параметры
//  Направление  – число – направление сдвига элемента,
//                 принимает значения:
//                      1 - при сдвиге вниз;
//                     -1 - при сдвиге вверх.
//
Процедура ИзменитьКод(Направление) Экспорт

	#Если Клиент Тогда
	
	ТекущийКод    = Код;

	СписокКодов   = Новый СписокЗначений;

	СчетаБюджета  = Справочники.уатСчетаБюджета;
	ВыборкаСтроки = СчетаБюджета.Выбрать(Родитель, Владелец, , "Код Убыв");

	Пока ВыборкаСтроки.Следующий() Цикл
		СписокКодов.Добавить(ВыборкаСтроки.Код);
	КонецЦикла;

	Если СписокКодов.Количество() < 2  Тогда
		// На данном уровне имеется только один элемент или группа справочника.
		// Игнорируем действие пользователя.

		Возврат;
	КонецЕсли; 

	ПорядковыйНомер = СписокКодов.Индекс(СписокКодов.НайтиПоЗначению(ТекущийКод));

	Если (ПорядковыйНомер = 0) И (Направление < 0) Тогда

		// Попытка перемещения первого по порядку элемента вверх.
		ИндексЭлементаЗамены = СписокКодов.Количество() - 1;
	
	ИначеЕсли (ПорядковыйНомер = СписокКодов.Количество() - 1) И (Направление > 0) Тогда

		// Попытка перемещения последнего по порядку элемента вниз.
		ИндексЭлементаЗамены = 0;

	Иначе

		// в иных случаях
		ИндексЭлементаЗамены = ПорядковыйНомер + Направление;

	КонецЕсли;

	КодЭлементаЗамены     = СписокКодов.Получить(ИндексЭлементаЗамены).Значение;
	
	ЭлементЗаменыСсылка   = СчетаБюджета.НайтиПоКоду(КодЭлементаЗамены,,Родитель, Владелец);
	Если ЭлементЗаменыСсылка <> СчетаБюджета.ПустаяСсылка() Тогда
		
		Попытка
			
			// Открываем транзакцию
			НачатьТранзакцию();
			
			// Промежуточная запись текущего элемента с уникальным кодом
			ЭтотОбъект.Код="&&$##";
			ЭтотОбъект.Записать();
						
			// записываем соседний элемент с кодом текущего
			ЭлементЗамены= ЭлементЗаменыСсылка.ПолучитьОбъект();
			ПредыдущийКод=ЭлементЗамены.Код;
			ЭлементЗамены.Код = ТекущийКод;
			ЭлементЗамены.Записать();
			
			// записываем текущий элемент с кодом соседнего
			ЭтотОбъект.Код = ПредыдущийКод;
			ЭтотОбъект.Записать();
			
			// Завершаем транзакцию
			ЗафиксироватьТранзакцию();
			
		Исключение
			Предупреждение("Не удалось записать элемент справочника:
			|" + ОписаниеОшибки());
			
			Возврат;
		КонецПопытки;
		
	КонецЕсли;
	
	#КонецЕсли
	
КонецПроцедуры // ИзменитьКод()

// Стандартный обработчик ПередЗаписью элемента справочника
//
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВСправочниках(ЭтотОбъект, Отказ, , Права);
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли





