﻿
&НаКлиенте
Процедура ВремяВПутиПриИзменении(Элемент)
	Если Объект.ВремяВПутиВод = Дата("00010101") Тогда
		Объект.ВремяВПутиВод = Объект.ВремяВПути;
	КонецЕсли;
КонецПроцедуры

&НаКлиенте
Процедура ВремяУсл3ПриИзменении(Элемент)
	Если Объект.ВремяУсл3Вод = Дата("00010101") Тогда
		Объект.ВремяУсл3Вод = Объект.ВремяУсл3;
	КонецЕсли;
КонецПроцедуры
