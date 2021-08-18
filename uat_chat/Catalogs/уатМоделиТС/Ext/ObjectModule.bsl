﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт;	// Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВСправочниках(ЭтотОбъект, Отказ, , Права);
	Если Не Отказ И НЕ ЗначениеЗаполнено(Наименование) тогда
		Сообщить("Должно быть указано наименование! Запись элемента <"+СокрЛП(ЭтотОбъект)+"> отменена!",СтатусСообщения.Важное);
		Отказ = Истина;
	КонецЕсли;
	
	//Если НЕ ЭтоНовый() И Ссылка.ВидМоделиТС <> ВидМоделиТС И Справочники.уатМоделиТС.СущестуютСсылкиНаПризнакАвтотранспорта(Ссылка) Тогда
	//	Если ВидМоделиТС = Перечисления.уатВидыМоделейТС.Автотранспорт тогда
	//		ТекстСообщения = "Модели оборудования " + СокрЛП(Ссылка) + " участвуют в документообороте. 
	//						 |Реквизит ""Вид модели ТС"" не может быть изменен";
	//	Иначе
	//		ТекстСообщения = "Модели автотранспорта " + СокрЛП(Ссылка) + " участвуют в документообороте. 
	//						 |Реквизит ""Вид модели ТС"" не может быть изменен";
	//	КонецЕсли;
	//	ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ);
	//КонецЕсли;
	
	//Если НЕ ЭтоНовый() И Ссылка.НаличиеСпидометра <> НаличиеСпидометра И Справочники.уатМоделиТС.СуществуютСсылкиНаНаличиеСпидометра(Ссылка) Тогда
	//	Если ВидМоделиТС = Перечисления.уатВидыМоделейТС тогда
	//		ТекстСообщения = "Для транспортных средств модели """ + СокрЛП(Ссылка) + """ есть изменения показаний счетчиков."
	//	Иначе
	//		ТекстСообщения = "Для оборудования модели """ + СокрЛП(Ссылка) + """ есть изменения показаний счетчиков."
	//	КонецЕсли;
	//	ТекстСообщения = ТекстСообщения + Символы.ПС + "Признак ""Наличие спидометра"" не может быть изменен";
	//	ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ);
	//КонецЕсли;	
	
	Если ТипТС = Справочники.уатТипыТС.ГрузовыеСамосвалы И НЕ ЗначениеЗаполнено(НормируемаяЗагрузкаСамосвала) Тогда
		ТекстСообщения = "Для модели ТС типа ""Грузовой самосвал"" необходимо указать коэффициент загрузки самосвала.";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ);
	КонецЕсли;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли