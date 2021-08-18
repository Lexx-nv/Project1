﻿

// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА

// Стандартный обработчик ПередЗаписью элемента справочника
//
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если Найти(ИмяПользователя(),"1с")=0
		и Найти(ИмяПользователя(),"1c")=0 Тогда 
		Отказ = Истина;
		Сообщить("Для изменения справочника состояний обратитесь в отдел сопровождения ЮРАЛС");
		Возврат; 
	КонецеСЛИ;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

