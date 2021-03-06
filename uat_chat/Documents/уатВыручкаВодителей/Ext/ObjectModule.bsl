////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения.


////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

Процедура ПроверитьЗаполнениеДокумента(СтруктураШапкиДокумента,Отказ, Заголовок)
	
	СтруктураПолей = Новый Структура("Сотрудник, Сумма");
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект,СтруктураПолей, Отказ, Заголовок);
	Если Отказ Тогда Возврат КонецЕсли;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ДЛЯ ОБЕСПЕЧЕНИЯ ПРОВЕДЕНИЯ ДОКУМЕНТА

// Функция списания материалов с регистра ТоварыНаСкладе
//
Функция ФормированиеДвижений(Отказ, Заголовок, РежимПроведения)
	
	НаборДвижений   = Движения.уатВыручка;
	ТаблицаДвижений = НаборДвижений.Выгрузить();
	
	НоваяСтрока 			= ТаблицаДвижений.Добавить();
	НоваяСтрока.Период 		= Дата;
	НоваяСтрока.Сотрудник 	= Сотрудник;
	НоваяСтрока.Организация = Организация;
	НоваяСтрока.ПутевойЛист	= ПутевойЛист;
	НоваяСтрока.ТС		 	= ПутевойЛист.ТранспортноеСредство;
	НоваяСтрока.Маршрут 	= Маршрут;
	НоваяСтрока.Количество	= Количество; 
	НоваяСтрока.Сумма 		= Сумма; 
	
	НаборДвижений.Загрузить(ТаблицаДвижений);
	НаборДвижений.УстановитьАктивность(Истина);
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(Ссылка);
	СтруктураШапкиДокумента = ОбщегоНазначения.СформироватьСтруктуруШапкиДокумента(ЭтотОбъект);
	ПроверитьЗаполнениеДокумента(СтруктураШапкиДокумента,Отказ, Заголовок);
	
	Если Отказ Тогда
		Возврат;
	КонецЕсли;
	
	ФормированиеДвижений(Отказ, "", РежимПроведения);
	
КонецПроцедуры

Процедура ОбработкаЗаполнения(Основание)
	Если ТипЗнч(Основание) = Тип("Форма") ИЛИ ТипЗнч(Основание) = Тип("ДокументСсылка.уатПутевойЛист") Тогда
		Организация = Основание.Организация;
		Ответственный = Основание.Ответственный;
		Сотрудник = Основание.Водитель1;
		ПутевойЛист = Основание.Ссылка;
		Дата = Основание.Дата;
		
		Для Каждого ТекСтрока Из Основание.Задание Цикл
			Если ЗначениеЗаполнено(ТекСтрока.Маршрут) Тогда
				Маршрут = ТекСтрока.Маршрут;
				Прервать;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры


// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;	
#КонецЕсли