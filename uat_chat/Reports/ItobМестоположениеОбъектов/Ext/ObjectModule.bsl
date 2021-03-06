	
////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ
//

// Функция выполняет формирование табличного документа отчета по движениям и стоянкам.
//
Функция СформироватьОтчетМестоположениеОбъектов(НаДату)
	
	ТабДокумент = Новый ТабличныйДокумент;
	
	Макет = ПолучитьМакет("Макет");
	
	ТабДокумент.Очистить();
		
	ОбластьШапка         = Макет.ПолучитьОбласть("Шапка");
	ОбластьДетали        = Макет.ПолучитьОбласть("Детали");
	
	ОбластьШапка.Параметры.ЗаголовокОтчета = "Местоположение объектов на "+Формат(Период,"ДЛФ=DD");
	ТабДокумент.Вывести(ОбластьШапка);
	
	ПараметрыСдвигаВремени = ItobОперативныйМониторинг.ПолучитьПараметрыСдвигаВремени();
	
	НаДатуUTC0 = ItobОперативныйМониторинг.ПривестиКДатеВремениПоГринвичу(КонецДня(НаДату));
			
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("СдвигВремени", ПараметрыСдвигаВремени.СдвигВремени);
	Запрос.УстановитьПараметр("ВариантПереводаНаЛетнееВремя", ПараметрыСдвигаВремени.ВариантПереводаВремени);
	Запрос.УстановитьПараметр("СдвигЛетнееВремя", ПараметрыСдвигаВремени.СдвигЛетнееВремя);	
	Запрос.УстановитьПараметр("НаДату", НаДатуUTC0);
	Запрос.Текст = "ВЫБРАТЬ РАЗРЕШЕННЫЕ
	               |	ItobПривязкиТерминаловСрезПоследних.Объект КАК Объект,
	               |	ДОБАВИТЬКДАТЕ(ДОБАВИТЬКДАТЕ(ВложенныйЗапрос.Период, СЕКУНДА, &СдвигВремени), СЕКУНДА, ВЫБОР
	               |			КОГДА &ВариантПереводаНаЛетнееВремя = ЗНАЧЕНИЕ(Перечисление.ItobВариантыПереводаВремени.Европейский)
	               |				ТОГДА ВЫБОР
	               |						КОГДА ВложенныйЗапрос.Период МЕЖДУ ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ГОД), МЕСЯЦ, 3), НЕДЕЛЯ), НЕДЕЛЯ, -1), ДЕНЬ), ЧАС, 2) И ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ГОД), МЕСЯЦ, 10), НЕДЕЛЯ), НЕДЕЛЯ, -1), ДЕНЬ), ЧАС, 2)
	               |							ТОГДА &СдвигЛетнееВремя
	               |						ИНАЧЕ 0
	               |					КОНЕЦ
	               |			КОГДА &ВариантПереводаНаЛетнееВремя = ЗНАЧЕНИЕ(Перечисление.ItobВариантыПереводаВремени.Американский)
	               |				ТОГДА ВЫБОР
	               |						КОГДА ВложенныйЗапрос.Период МЕЖДУ ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ГОД), МЕСЯЦ, 2), НЕДЕЛЯ), НЕДЕЛЯ, 1), ДЕНЬ), ЧАС, 2) И ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ДОБАВИТЬКДАТЕ(КОНЕЦПЕРИОДА(ДОБАВИТЬКДАТЕ(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ГОД), МЕСЯЦ, 10), НЕДЕЛЯ), НЕДЕЛЯ, 0), ДЕНЬ), ЧАС, 2)
	               |							ТОГДА &СдвигЛетнееВремя
	               |						ИНАЧЕ 0
	               |					КОНЕЦ
	               |			ИНАЧЕ 0
	               |		КОНЕЦ) КАК Период,
	               |	ItobДанныеТерминалов.Широта,
	               |	ItobДанныеТерминалов.Долгота,
	               |	ItobДанныеТерминалов.Скорость
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		МАКСИМУМ(ItobДанныеТерминалов.Период) КАК Период,
	               |		ItobДанныеТерминалов.Терминал КАК Терминал
	               |	ИЗ
	               |		РегистрСведений.ItobДанныеТерминалов КАК ItobДанныеТерминалов
	               |	ГДЕ
	               |		ItobДанныеТерминалов.Период МЕЖДУ ДОБАВИТЬКДАТЕ(&НаДату, ДЕНЬ, -10) И &НаДату
	               |	
	               |	СГРУППИРОВАТЬ ПО
	               |		ItobДанныеТерминалов.Терминал) КАК ВложенныйЗапрос
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobПривязкиТерминалов.СрезПоследних(&НаДату, ) КАК ItobПривязкиТерминаловСрезПоследних
	               |		ПО ВложенныйЗапрос.Терминал = ItobПривязкиТерминаловСрезПоследних.Терминал
	               |			И (ItobПривязкиТерминаловСрезПоследних.ТерминалУстановлен)
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobДанныеТерминалов КАК ItobДанныеТерминалов
	               |		ПО ВложенныйЗапрос.Период = ItobДанныеТерминалов.Период
	               |			И ВложенныйЗапрос.Терминал = ItobДанныеТерминалов.Терминал
	               |ГДЕ
	               |	(НЕ ItobПривязкиТерминаловСрезПоследних.Объект ЕСТЬ NULL )
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Объект
	               |АВТОУПОРЯДОЧИВАНИЕ";
				   
	НомПП = 1;			   
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		ОбластьДетали.Параметры.Заполнить(Выборка);
		ОбластьДетали.Параметры.НомПП = НомПП;
		ОбластьДетали.Параметры.Состояние = ?(Выборка.Скорость>=10, "Движение", "Стоянка");
		ОбластьДетали.Параметры.Местоположение = ItobОперативныйМониторинг.НайтиБлижайшийАдрес(Выборка.Широта, Выборка.Долгота); 
		ТабДокумент.Вывести(ОбластьДетали);
		
		НомПП = НомПП + 1;
		
	КонецЦикла;	

	Возврат ТабДокумент;
	
КонецФункции

// Процедура обработчик события "ПриКомпоновкеРезультата" объекта
//
Процедура ПриКомпоновкеРезультата(ДокументРезультат, ДанныеРасшифровки, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;
	
	
	ДокументРезультат.Вывести(СформироватьОтчетМестоположениеОбъектов(
		Период));
				
КонецПроцедуры // ПриКомпоновкеРезультата()



