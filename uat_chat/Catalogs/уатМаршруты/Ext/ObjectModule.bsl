////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОПОЛНИТЕЛЬНЫХ МЕТОДОВ ОБЪЕКТА

// Функция возвращает новый УИД для таблицы этапов.
//Новый УИД = Количество этапов + 1.
//
//Возвращаемое значение:
//	Число - номер нового этапа маршрута.
//
Функция СформироватьУИД() Экспорт
	
	мТаблица = Этапы.Выгрузить();
	мТаблица.Сортировать("УИД Возр");
	мКоличество = мТаблица.Количество();
	Если мКоличество > 0 Тогда
		мУИД = мТаблица[мКоличество-1].УИД + 1;
	Иначе	
		мУИД = 1;
	КонецЕсли;
	
	Возврат мУИД;
	
КонецФункции //СформироватьУИД

#Если Клиент Тогда
	
// Процедура удаляет пункт маршрута по регистру уатРасписаниеРейсов. Только для решения УАТ ПП.
//
Процедура УдалитьПункт(УИДПункта, Отказ)  Экспорт
	
	Если уатРаботаСМетаданными.уатЕстьРегистрСведений("уатРасписаниеРейсов") Тогда
		
		Отказ = Ложь;
		НаборЗаписей = РегистрыСведений.уатРасписаниеРейсов.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Маршрут.Значение = Ссылка;
		НаборЗаписей.Отбор.Маршрут.Использование = Истина;
		НаборЗаписей.Отбор.УИДПункта.Значение = УИДПункта;
		НаборЗаписей.Отбор.УИДПункта.Использование = Истина;
		НаборЗаписей.Прочитать();
		
		Если НаборЗаписей.Количество() > 0 Тогда
			
			мОтвет = Вопрос("Для данного пункта заполнено расписание движения.
			|Удалять пункт, Вы уверены?", РежимДиалогаВопрос.ДаНет, , КодВозвратаДиалога.Нет);
			
			Если мОтвет = КодВозвратаДиалога.Да Тогда
				
				НаборЗаписей.Очистить();
				НаборЗаписей.Записать();
			Иначе	
				
				Отказ = Истина;
				
			КонецЕсли;	
		КонецЕсли;	
		
	КонецЕсли;	
	
КонецПроцедуры
	
#КонецЕсли


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА

Процедура ПередЗаписью(Отказ)
	Если НЕ ЭтоГруппа Тогда
	     Наименование = НаименованиеПолное;
	КонецЕсли;
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