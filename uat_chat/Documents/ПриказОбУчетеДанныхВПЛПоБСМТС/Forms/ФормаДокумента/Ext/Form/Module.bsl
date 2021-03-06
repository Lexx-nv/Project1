
&НаКлиенте
Процедура ПереченьТСТСОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ЗаполнитьЗначенияСвойств(Элементы.ПереченьТС.ТекущиеДанные,ВыбранноеЗначение);
КонецПроцедуры

&НаКлиенте
Процедура ПереченьТСПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	Элементы.ПереченьТС.ТекущиеДанные.ИспользоватьДанныеБСМТС = Истина;
КонецПроцедуры

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Ключ.Пустая() Тогда // Создается НОВЫЙ элемент
		Объект.Автор = ПараметрыСеанса.ТекущийПользователь; 
		Объект.МоментСоздания = ТекущаяДата();
	КонецЕсли;
КонецПроцедуры
