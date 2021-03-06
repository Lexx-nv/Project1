
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	мНаборЗаписейЗаявки = Движения.Заявки;
	мНаборЗаписейЗаявки.Записывать = Истина;
	
	мНаборЗаписейДополнительныеСведенияЗаявок = Движения.ДополнительныеСведенияЗаявок;
	мНаборЗаписейДополнительныеСведенияЗаявок.Записывать = Истина;
	мТаблицаСоставаЗаявки = Состав.Выгрузить();
	Для мИтр = 1 По День(КонецМесяца(Дата)) Цикл	//контроль количества дней в месяце - на совести формы документа
		Если Состав.Итог("д" + мИтр) > 0 Тогда	//время выполнения минимальное, но иногда ускорит проведение. В отмене заявки - особенно
			мДата = НачалоМесяца(Дата) + (86400 * (мИтр - 1));
			мКопияТаблицаСоставаЗаявки = мТаблицаСоставаЗаявки.Скопировать();
			//мКопияТаблицаСоставаЗаявки.Свернуть("ТипТС, ЦехМаршрут, ВремяПодачи, ПричинаОтмены, д" + мИтр, "КоличествоОтмена");
			
			Для Каждого мСтрока Из Состав Цикл //TODO: тут тоже переделать на отбор строк
				Если мСтрока["д" + Число(мИтр)] И мСтрока.КоличествоОтмена > 0 Тогда
					мОтборПоНомеруСтроки = Новый Структура("НомерСтрокиСостава", мСтрока.НомерСтроки);
					мМассивСтрокИдентификаторов = ТаблицаИдентификаторов.НайтиСтроки(мОтборПоНомеруСтроки);
					//предотвращаем выход за границу массива мМассивСтрокИдентификаторов и вообще ошибочное поведение
					Если мМассивСтрокИдентификаторов.Количество() < мСтрока.КоличествоОтмена Тогда
						Сообщить("Количество единиц техники, которые отменяют, превысило количество из Заявок." + Символы.ПС + " ТипТС: " + мСтрока.ТипТС + " ; Цех/Маршрут: " + мСтрока.ЦехМаршрут + " ; ВремяПодачи: " + мСтрока.ВремяПодачи + " ; Количество к отмене: " + мСтрока.КоличествоОтмена);
						Отказ = Истина;
						Возврат;
					КонецЕсли;
					
					//разбиваем по идентификаторам: берем с конца массива столько, сколько нужно отменить
					Для мДжитр = 1 По мСтрока.КоличествоОтмена Цикл
						мНоваяЗапись = мНаборЗаписейДополнительныеСведенияЗаявок.Добавить();
						мНоваяЗапись.Регистратор = Ссылка;
						мНоваяЗапись.Период = мДата;
						мНоваяЗапись.Контрагент = Контрагент;
						ЗаполнитьЗначенияСвойств(мНоваяЗапись, мСтрока);
						мНоваяЗапись.ИдентификаторСтрокиЗаявки = мМассивСтрокИдентификаторов[мМассивСтрокИдентификаторов.Количество() - мДжитр].ИдентификаторСтрокиЗаявки;
						мНоваяЗапись.КоличествоТС = -1;
					КонецЦикла;
				КонецЕсли;
			КонецЦикла;
			////TODO: отказаться от рудиментарного регистра
			//мКопияТаблицаСоставаЗаявки.Свернуть("ТипТС, д" + мИтр, "КоличествоОтмена");
			//Для Каждого мСтрока Из мКопияТаблицаСоставаЗаявки Цикл
			//	Если мСтрока["д" + Число(мИтр)] Тогда
			//		мНоваяЗапись = мНаборЗаписейЗаявки.Добавить();
			//		мНоваяЗапись.Регистратор = Ссылка;
			//		мНоваяЗапись.Период = мДата;
			//		мНоваяЗапись.Контрагент = Контрагент;
			//		ЗаполнитьЗначенияСвойств(мНоваяЗапись, мСтрока);
			//	КонецЕсли;
			//КонецЦикла;
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры