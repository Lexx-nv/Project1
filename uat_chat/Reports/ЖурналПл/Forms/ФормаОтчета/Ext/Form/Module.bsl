
&НаКлиенте
Процедура Сформировать(Команда)
	СформироватьНаСервере();
	Элементы.Результат.ОтображениеСостояния.Видимость = Ложь;
	Элементы.Результат.ОтображениеСостояния.ДополнительныйРежимОтображения = ДополнительныйРежимОтображения.НеИспользовать;
КонецПроцедуры

&НаСервере
Процедура СформироватьНаСервере()
	мМакетСхемы = Отчеты.ЖурналПл.ПолучитьМакет("СКДЖурналПЛ");
	
	КомпоновщикМакетаОСКД = Новый КомпоновщикМакетаКомпоновкиДанных;
	мСкомпонованныйМакет = КомпоновщикМакетаОСКД.Выполнить(мМакетСхемы, Отчет.КомпоновщикНастроек.ПолучитьНастройки());
	
	ПроцессорКомпоновкиОСКД = Новый ПроцессорКомпоновкиДанных;
	ПроцессорКомпоновкиОСКД.Инициализировать(мСкомпонованныйМакет);
	Результат.Очистить();
	ПроцессорВыводаОСКД = Новый ПроцессорВыводаРезультатаКомпоновкиДанныхВТабличныйДокумент;
	ПроцессорВыводаОСКД.УстановитьДокумент(Результат);
	ПроцессорВыводаОСКД.Вывести(ПроцессорКомпоновкиОСКД);
	Результат.НижнийКолонтитул.Выводить = Истина;
	Результат.НижнийКолонтитул.НачальнаяСтраница = 1;
	Результат.НижнийКолонтитул.ТекстСправа = "Подпись диспетчера:________________________________";
КонецПроцедуры