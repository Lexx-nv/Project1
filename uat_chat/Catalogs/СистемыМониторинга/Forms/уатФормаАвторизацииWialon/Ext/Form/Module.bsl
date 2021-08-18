﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	АдресСервиса      = "";
	Wialon_ВидСистемы = 0;
	
	Если Параметры.Свойство("АдресСервиса") Тогда 
		АдресСервиса = Параметры.АдресСервиса;
	КонецЕсли;
	
	Если Параметры.Свойство("АдресСервиса") Тогда 
		АдресСервиса = Параметры.АдресСервиса;
	КонецЕсли;
	
	Если Параметры.Свойство("ВидСистемы") Тогда 
		Wialon_ВидСистемы = Параметры.ВидСистемы;
	КонецЕсли;
	
	Если Wialon_ВидСистемы = 0 Тогда 
		АдресСервиса = "http://hosting.wialon.com";
	КонецЕсли;
	
	Если ПустаяСтрока(АдресСервиса) Тогда 
		Возврат;
	КонецЕсли;
	
	// адрес не должен оканчиваться символом "/"
	Если Прав(АдресСервиса, 1) = "/" Тогда
		АдресСервиса = Лев(АдресСервиса, СтрДлина(АдресСервиса)-1);
	КонецЕсли;
	
	// адрес должен начинаться на "http" или "https"
	Если Не НРег(Лев(АдресСервиса, 7)) = "http://" Тогда 
		Если Не НРег(Лев(АдресСервиса, 8)) = "https://" Тогда 
			АдресСервиса = "http://" + АдресСервиса;
		КонецЕсли;
	КонецЕсли;
	
	HTML = АдресСервиса + "/login.html?client_id=""1C:Enterprise""&access_type=-1&activation_time=0&duration=0&lang=ru&response_type=token";
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура УстановитьТокен(Команда)
	
	Токен = "";
	
	Попытка
		Поз = Найти(Элементы.HTML.Документ.URLUnencoded, "access_token=");
		Если Поз <> 0 Тогда 
			Токен = Прав(Элементы.HTML.Документ.URLUnencoded, СтрДлина(Элементы.HTML.Документ.URLUnencoded)-Поз-12);
			Поз = Найти(Токен, "&");
			Если Поз <> 0 Тогда 
				Токен = Лев(Токен, Поз-1);
			КонецЕсли;
		КонецЕсли;
	Исключение
	КонецПопытки;
	
	Если Токен = "" Тогда 
		ТекстОшибки = НСтр("en='Session token is not received and could not be installed.';ru='Токен сессии не получен и не может быть установлен.'");
		ПоказатьПредупреждение(, ТекстОшибки);
		Возврат;
	КонецЕсли;
	
	Закрыть(Токен);
	
КонецПроцедуры

#КонецОбласти
