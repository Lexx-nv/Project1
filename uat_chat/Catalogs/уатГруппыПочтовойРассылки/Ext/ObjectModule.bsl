﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения
Перем мСсылкаОснование Экспорт; // Основание для объекта
Перем мКопирование Экспорт; // Флаг копирования объекта


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА

Процедура ПриКопировании(ОбъектКопирования)
	
	мКопирование = Истина;
	мСсылкаОснование = ОбъектКопирования.Ссылка;
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВСправочниках(ЭтотОбъект, Отказ, , Права);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

мКопирование = Ложь;

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли