//Получение цены работы в нормочасах из элемента справочники или справочника нормочасов работ
Функция ПолучитьКоличествоНЧРаботы(МодельТС,РаботаСсылка) Экспорт
	КоличествоНЧ = 0;
	//Сформируем запрос на выборку цены работы
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	НормочасыРабот.КоличествоНЧ КАК КоличествоНЧ
	|ИЗ
	|	РегистрСведений.уатНормочасыРаботПоРемонту КАК НормочасыРабот
	|ГДЕ
	|	НормочасыРабот.Работа = &ВидРаботы И
	|	НормочасыРабот.МодельТС = &МодельТС";
	Запрос.УстановитьПараметр("ВидРаботы",РаботаСсылка);
	Запрос.УстановитьПараметр("МодельТС",МодельТС);
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		КоличествоНЧ = Выборка.КоличествоНЧ;
	КонецЕсли;
	Возврат КоличествоНЧ;
КонецФункции
