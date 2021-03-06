Функция идИзменения(имяОбк) Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ДатыОбновления.идИзменения
	               |ИЗ
	               |	РегистрСведений.ДатыОбновления КАК ДатыОбновления
	               |ГДЕ
	               |	ДатыОбновления.ВидСпр = &ВидСпр";
	Запрос.УстановитьПараметр("ВидСпр",имяОбк);
	
	Выб = Запрос.Выполнить().Выбрать();
	Если Выб.Следующий() ТОгда
		Возврат Выб.идИзменения;
	КонецеСЛИ;
	
	Возврат "none";
	
КонецФункции

Процедура ЗаписатьИдИзменения(имяОбъекта,идИзменения) Экспорт
	
	Зап = РегистрыСведений.ДатыОбновления.СоздатьМенеджерЗаписи();
	Зап.ВидСпр = имяОбъекта;
	Зап.Дт = ТекущаяДата();
	Зап.идИзменения = идИзменения;
	Зап.Записать();
	
КонецПроцедуры