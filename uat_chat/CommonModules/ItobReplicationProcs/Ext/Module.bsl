// Модуль предназначен для обращения из внешней компоненты
// Менять что либо не рекомендуется

// Получает таблицу актуальности терминалов
//
Функция GetTableOfActualTerminalData() Экспорт
	
	Запрос = Новый Запрос;	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ItobТерминалы.Код КАК КодТерминала,
	               |	ЕСТЬNULL(ItobКрайниеДанныеТерминалов.Счетчик, 0) КАК СчетчикАктуальности
	               |ИЗ
	               |	Справочник.ItobТерминалы КАК ItobТерминалы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobКрайниеДанныеТерминалов КАК ItobКрайниеДанныеТерминалов
	               |		ПО (ItobКрайниеДанныеТерминалов.Терминал = ItobТерминалы.Ссылка)
	               |ГДЕ
	               |	(НЕ ItobТерминалы.ПометкаУдаления)
	               |	И ItobТерминалы.Код <> 0";
				   
	Рез = "";			   
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл		
		Рез = ?(Рез = "", "", Рез + Символы.ПС) + Формат(Выборка.КодТерминала,"ЧН=0; ЧГ=0") + Символы.ПС 
			+ Формат(Выборка.СчетчикАктуальности, "ЧН=0; ЧГ=0");
	
	КонецЦикла;
				   
	Возврат Рез;

КонецФункции //

// Получает шаблон таблицы данных
//
Функция GetTemplateOfDataTable() Экспорт
	
	ТипДатаВремя = Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя));
	
	ТаблицаДанных = Новый ТаблицаЗначений;
	ТаблицаДанных.Колонки.Добавить("КодТерминала");
	ТаблицаДанных.Колонки.Добавить("Период", ТипДатаВремя);
	ТаблицаДанных.Колонки.Добавить("Широта");
	ТаблицаДанных.Колонки.Добавить("Долгота");
	ТаблицаДанных.Колонки.Добавить("Скорость");
	ТаблицаДанных.Колонки.Добавить("Направление");
	ТаблицаДанных.Колонки.Добавить("Счетчик");
	
	ТаблицаДанных.Индексы.Добавить("КодТерминала,Счетчик");
	
	Возврат ТаблицаДанных;

КонецФункции // 

// Записывает в базу данные от терминалов
//
Процедура WriteTerminalData(ТаблицаДанных, ИмяПотока="Основной") Экспорт
	
	ТаблицаБД = ТаблицаДанных.Скопировать();
	ТаблицаБД.Очистить();
	ТаблицаБД.Колонки.Добавить("ЗначенияДатчиков");
	
	ШаблонТаблицыДатчиков = Новый ТаблицаЗначений;
	ШаблонТаблицыДатчиков.Колонки.Добавить("Датчик");
	ШаблонТаблицыДатчиков.Колонки.Добавить("Значение");	
	
	ТЗПодписок = ПолучитьТаблицуАктивныхПодписок();
		
	НачатьТранзакцию();
	
	ТаблицаДанныхКопия = Новый ТаблицаЗначений;
	ТаблицаДанныхКопия.Колонки.Добавить("Период",Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	ТаблицаДанныхКопия.Колонки.Добавить("КодТерминала",Новый ОписаниеТипов("Число",Новый КвалификаторыЧисла(8,0)));
	    	
	ТаблицаДанных.Сортировать("КодТерминала Возр, Счетчик Возр");
	
	ДанныеМаксимальныйПериод = Новый Структура("Период,Терминал,Широта,Долгота,Скорость,Направление,Счетчик");
		
	Для п = 0 По ТаблицаДанных.Количество()-1 Цикл
		ТекущаяСтрока = ТаблицаДанных[п];
		
		строкаТДК = ТаблицаДанныхКопия.Добавить();
		строкаТДК.Период = ТекущаяСтрока.Период;
		строкаТДК.КодТерминала = ТекущаяСтрока.КодТерминала;
		
		ТекущийТерминал = Справочники.ItobТерминалы.НайтиПоКоду(ТекущаяСтрока.КодТерминала);
		Если ТекущийТерминал.Пустая() Тогда
			Продолжить;
		
		КонецЕсли;
		
		Если Год(ТекущаяСтрока.Период) > Год(ТекущаяДата())+1 Тогда
			Продолжить;		
		КонецЕсли;
		
		НовЗапись = РегистрыСведений.ItobДанныеТерминалов.СоздатьМенеджерЗаписи();
		НовЗапись.Терминал    = ТекущийТерминал;
		ЗаполнитьЗначенияСвойств(НовЗапись, ТекущаяСтрока);
		НовЗапись.Записать();
		
		НовСтрокаБД = ТаблицаБД.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрокаБД, ТекущаяСтрока);		
		НовСтрокаБД.ЗначенияДатчиков = ШаблонТаблицыДатчиков.Скопировать();
		
		// Датчики
		КоличествоДатчиков = Цел((ТаблицаДанных.Колонки.Количество() - 7)/2);
		Для НомДатчика = 0 По КоличествоДатчиков-1 Цикл
			КодДатчика = ТаблицаДанных[п][7+НомДатчика*2];
			ДанныеДатчика = ТаблицаДанных[п][8+НомДатчика*2];
			
			Если ЗначениеЗаполнено(КодДатчика) Тогда
				
				Датчик = Справочники.ItobДатчики.НайтиПоКоду(КодДатчика,Ложь,,ТекущийТерминал.Модель);
				Если Датчик.Пустая() Тогда
					НовДатчик = Справочники.ItobДатчики.СоздатьЭлемент();
					НовДатчик.Владелец = ТекущийТерминал.Модель;
					НовДатчик.Код = КодДатчика;
					НовДатчик.Наименование = "#"+КодДатчика;
					НовДатчик.Записать();
					Датчик = НовДатчик.Ссылка;
				КонецЕсли;					
				
				НовЗаписьДатчики = РегистрыСведений.ItobДанныеДатчиков.СоздатьМенеджерЗаписи();
				НовЗаписьДатчики.Период = НовЗапись.Период;
				НовЗаписьДатчики.Терминал = НовЗапись.Терминал;
				НовЗаписьДатчики.Датчик = Датчик;				
				НовЗаписьДатчики.Значение = ДанныеДатчика;
				НовЗаписьДатчики.Записать();
				
				ЗаписьДатчикиБД = НовСтрокаБД.ЗначенияДатчиков.Добавить();
				ЗаполнитьЗначенияСвойств(ЗаписьДатчикиБД, НовЗаписьДатчики);
				
			КонецЕсли;
		
		КонецЦикла;
		
		// Контролируем запись с максимальным периодом - для поддержания корректной актуальности
		Если (НЕ ЗначениеЗаполнено(ДанныеМаксимальныйПериод.Период))
			ИЛИ ДанныеМаксимальныйПериод.Терминал <> ТекущийТерминал
			ИЛИ НовЗапись.Период > ДанныеМаксимальныйПериод.Период Тогда
			
			ЗаполнитьЗначенияСвойств(ДанныеМаксимальныйПериод, НовЗапись);
			ДанныеМаксимальныйПериод.Счетчик = ТекущаяСтрока.Счетчик;
		
		КонецЕсли;
		
		Если п = ТаблицаДанных.Количество()-1 ИЛИ ТекущаяСтрока.КодТерминала <> ТаблицаДанных[п+1].КодТерминала Тогда
			// Обновим таблицу актуальности
			
			СтруктураОтбора = Новый Структура("Терминал", НовЗапись.Терминал);
			Выборка = РегистрыСведений.ItobКрайниеДанныеТерминалов.Выбрать(СтруктураОтбора);
			Если Выборка.Следующий() Тогда
				ЗаписьРегистра = Выборка.ПолучитьМенеджерЗаписи();
			Иначе
				ЗаписьРегистра = РегистрыСведений.ItobКрайниеДанныеТерминалов.СоздатьМенеджерЗаписи();
				ЗаписьРегистра.Терминал = НовЗапись.Терминал;
			КонецЕсли;
			ЗаписьРегистра.ДатаВремя = НовЗапись.Период;
			ЗаполнитьЗначенияСвойств(ЗаписьРегистра, НовЗапись);
			ЗаписьРегистра.Счетчик = ТекущаяСтрока.Счетчик;
			ЗаписьРегистра.Записать(Истина);
			
			
			// При необходимости обновим актуальность данных терминалов
			ВыборкаАктуальность = РегистрыСведений.ItobАктуальностьДанныхТерминалов.Выбрать(СтруктураОтбора);
			Если ВыборкаАктуальность.Следующий() Тогда
				ЗаписьРегистраАктуальность = ВыборкаАктуальность.ПолучитьМенеджерЗаписи();
			Иначе
				ЗаписьРегистраАктуальность = РегистрыСведений.ItobАктуальностьДанныхТерминалов.СоздатьМенеджерЗаписи();
				ЗаписьРегистраАктуальность.Терминал = НовЗапись.Терминал;
			КонецЕсли;
			
			Если ДанныеМаксимальныйПериод.Период > ЗаписьРегистраАктуальность.ДатаВремя Тогда
				
				ЗаполнитьЗначенияСвойств(ЗаписьРегистраАктуальность, ДанныеМаксимальныйПериод);
				ЗаписьРегистраАктуальность.ДатаВремя = ДанныеМаксимальныйПериод.Период;				
				ЗаписьРегистраАктуальность.Записать(Истина);
			
			КонецЕсли;
			
			// Обнулим данные макс. актуальности
			ДанныеМаксимальныйПериод.Период = Неопределено;
			
			// Проверим на события
			ПроверитьВыполнениеСобытий(ТекущийТерминал, ТаблицаБД, ТЗПодписок);
			ТаблицаБД.Очистить();			
		
		КонецЕсли;		
	
	КонецЦикла;
	
	Если Метаданные.НайтиПоПолномуИмени("Документ.ItobКалькуляцияВыработки") <> Неопределено Тогда
		
		ЗапросАктуальностьИтогов = Новый Запрос;
		ЗапросАктуальностьИтогов.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
		ЗапросАктуальностьИтогов.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ ТаблицаДанных ИЗ &ТаблицаДанных КАК ТаблицаДанных";
		ЗапросАктуальностьИтогов.УстановитьПараметр("ТаблицаДанных", ТаблицаДанныхКопия);
		ЗапросАктуальностьИтогов.Выполнить();
				
		ЗапросАктуальностьИтогов.Текст = "ВЫБРАТЬ
		                                 |	ТД.Период КАК Период,
		                                 |	ТД.КодТерминала КАК КодТерминала
		                                 |ИЗ
		                                 |	ТаблицаДанных КАК ТД
		                                 |ИТОГИ
		                                 |	МИНИМУМ(Период)
		                                 |ПО
		                                 |	КодТерминала";
		
		ВыборкаАктуальностьИтогов = ЗапросАктуальностьИтогов.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);	
		
		Пока ВыборкаАктуальностьИтогов.Следующий() Цикл
			
			СтруктураОтбора = Новый Структура("Терминал", Справочники.ItobТерминалы.НайтиПоКоду(ВыборкаАктуальностьИтогов.КодТерминала));
			Выборка = РегистрыСведений.ItobКрайниеДанныеТерминалов.Выбрать(СтруктураОтбора);
			Если Выборка.Следующий() Тогда
				
				Если Выборка.АктуальностьИтогов =  Дата('00010101') Тогда
					
					ЗаписьРегистра = Выборка.ПолучитьМенеджерЗаписи();
					ЗаписьРегистра.АктуальностьИтогов = НачалоДня(ВыборкаАктуальностьИтогов.Период);
					
					ЗаписьРегистра.Записать(Истина);		
					
				ИначеЕсли ВыборкаАктуальностьИтогов.Период <  УниверсальноеВремя(Выборка.АктуальностьИтогов) Тогда
					
					//сдвигаем калькуляцию
					//*************************
					ДокументыКалькуляции = Документы.ItobКалькуляцияВыработки.Выбрать(
						НачалоДня(ВыборкаАктуальностьИтогов.Период),КонецДня(ВыборкаАктуальностьИтогов.Период),СтруктураОтбора);
					Пока ДокументыКалькуляции.Следующий() Цикл
						
						ТекДокумент =  ДокументыКалькуляции.ПолучитьОбъект();
						ТекДокумент.Записать(РежимЗаписиДокумента.Проведение);
						
					КонецЦикла;
					
					//*************************				
					ЗаписьРегистра = Выборка.ПолучитьМенеджерЗаписи();
					ЗаписьРегистра.АктуальностьИтогов = НачалоДня(ВыборкаАктуальностьИтогов.Период);
					
					ЗаписьРегистра.Записать(Истина);
					
				ИначеЕсли ВыборкаАктуальностьИтогов.Период >=  УниверсальноеВремя(Выборка.АктуальностьИтогов + 24*3600) Тогда
					//ЗаписьВЛог(Строка(УниверсальноеВремя(Выборка.АктуальностьИтогов + 24*3600)));
					//формируем калькуляцию
					//****************************
					
					ВыборкаДокументов = Документы.ItobКалькуляцияВыработки.Выбрать(
						НачалоДня(Выборка.АктуальностьИтогов),КонецДня(Выборка.АктуальностьИтогов),СтруктураОтбора);
					Если ВыборкаДокументов.Следующий() Тогда
						ДокументКалькуляции = ВыборкаДокументов.Ссылка.ПолучитьОбъект();
						
					Иначе
						ДокументКалькуляции  = Документы.ItobКалькуляцияВыработки.СоздатьДокумент();
						ДокументКалькуляции.Дата = НачалоДня(Выборка.АктуальностьИтогов);
						ДокументКалькуляции.Терминал = СтруктураОтбора.Терминал;	
					
					КонецЕсли;				
					
					ДокументКалькуляции.Записать(РежимЗаписиДокумента.Проведение);    			
					
					//***************************
					ЗаписьРегистра = Выборка.ПолучитьМенеджерЗаписи();
					ЗаписьРегистра.АктуальностьИтогов = НачалоДня(ВыборкаАктуальностьИтогов.Период);
					
					ЗаписьРегистра.Записать(Истина);
					
					
				Иначе
					Продолжить;			 
				КонецЕсли;
				
			КонецЕсли;
			
		КонецЦикла;
	
	КонецЕсли;
	
	// Запись статистики
	
	СтруктураОтбора = Новый Структура("Поток", ИмяПотока);
	Выборка = РегистрыСведений.ItobСтатистикаРепликации.Выбрать(СтруктураОтбора);
	Если Выборка.Следующий() Тогда
		ЗаписьРегистра = Выборка.ПолучитьМенеджерЗаписи();
		
		Если НачалоМесяца(ЗаписьРегистра.ПериодКрайнейРепликации) < НачалоМесяца(ТекущаяДата()) Тогда
			ЗаписьРегистра.ЗаписейЗаМесяц = 0;
		КонецЕсли;
		
		Если НачалоДня(ЗаписьРегистра.ПериодКрайнейРепликации) < НачалоДня(ТекущаяДата()) Тогда
			ЗаписьРегистра.ЗаписейЗаСутки = 0;
		КонецЕсли;
		
		Если НачалоЧаса(ЗаписьРегистра.ПериодКрайнейРепликации) < НачалоЧаса(ТекущаяДата()) Тогда
			ЗаписьРегистра.ЗаписейЗаЧас = 0;
		КонецЕсли;
			
		
	Иначе
		ЗаписьРегистра = РегистрыСведений.ItobСтатистикаРепликации.СоздатьМенеджерЗаписи();
		ЗаписьРегистра.Поток = ИмяПотока;
	КонецЕсли;
	ЗаписьРегистра.ПериодКрайнейРепликации = ТекущаяДата();
	ЗаписьРегистра.ЗаписейВсего    = ЗаписьРегистра.ЗаписейВсего     + ТаблицаДанных.Количество();
	ЗаписьРегистра.ЗаписейЗаМесяц  = ЗаписьРегистра.ЗаписейЗаМесяц   + ТаблицаДанных.Количество();
	ЗаписьРегистра.ЗаписейЗаСутки  = ЗаписьРегистра.ЗаписейЗаСутки   + ТаблицаДанных.Количество();
	ЗаписьРегистра.ЗаписейЗаЧас    = ЗаписьРегистра.ЗаписейЗаЧас     + ТаблицаДанных.Количество();
	
	ЗаписьРегистра.Записать(Истина);
	
   	ЗафиксироватьТранзакцию();
		
КонецПроцедуры // WriteTerminalData()

// Возвращает таблицу активных подписок на события
//
Функция ПолучитьТаблицуАктивныхПодписок()

	Если Метаданные.НайтиПоПолномуИмени("Документ.ItobПодпискаНаСобытие") = Неопределено Тогда
		Возврат Неопределено;
	
	КонецЕсли;
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Период", ТекущаяДата());
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВложенныйЗапрос.Терминал,
	               |	ВложенныйЗапрос.Подписка,
	               |	ВложенныйЗапрос.Объект,
	               |	ВложенныйЗапрос.Подписка.Содержание КАК Содержание,
	               |	ВложенныйЗапрос.Подписка.ТипОповещения КАК ТипОповещения,
	               |	ВложенныйЗапрос.Подписка.Источник КАК Источник,
	               |	ВложенныйЗапрос.Подписка.Показатель КАК Показатель,
	               |	ВложенныйЗапрос.Подписка.ВидСравнения КАК ВидСравнения,
	               |	ВложенныйЗапрос.Подписка.Значение КАК Значение,
	               |	ItobТерминалыДатчики.Датчик,
	               |	ЕСТЬNULL(ItobАктуальностьДанныхТерминалов.ДатаВремя, ДАТАВРЕМЯ(1, 1, 1, 0, 0, 0)) КАК ДатаАктуальности,
	               |	ЕСТЬNULL(ItobАктуальностьДанныхТерминалов.Широта,0) КАК Широта,
	               |	ЕСТЬNULL(ItobАктуальностьДанныхТерминалов.Долгота,0) КАК Долгота,
	               |	ItobАктуальностьДанныхТерминалов.Скорость,
	               |	ItobАктуальностьДанныхТерминалов.Направление,
	               |	ItobДанныеДатчиков.Значение КАК ЗначениеДатчика
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ItobПривязкиТерминаловСрезПоследних.Терминал КАК Терминал,
	               |		ItobПодпискиНаСобытияОбъектов.Регистратор КАК Подписка,
	               |		ItobПодпискиНаСобытияОбъектов.Объект КАК Объект
	               |	ИЗ
	               |		РегистрСведений.ItobПодпискиНаСобытияОбъектов КАК ItobПодпискиНаСобытияОбъектов
	               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobПривязкиТерминалов.СрезПоследних(&Период, ТерминалУстановлен) КАК ItobПривязкиТерминаловСрезПоследних
	               |			ПО ItobПодпискиНаСобытияОбъектов.Объект = ItobПривязкиТерминаловСрезПоследних.Объект
	               |	ГДЕ
	               |		(НЕ ItobПодпискиНаСобытияОбъектов.Объект.Код ЕСТЬ NULL )
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ItobТерминалы.Ссылка,
	               |		ItobПодпискиНаСобытияОбъектов.Регистратор,
	               |		ItobПривязкиТерминаловСрезПоследних.Объект
	               |	ИЗ
	               |		РегистрСведений.ItobПодпискиНаСобытияОбъектов КАК ItobПодпискиНаСобытияОбъектов,
	               |		Справочник.ItobТерминалы КАК ItobТерминалы
	               |			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobПривязкиТерминалов.СрезПоследних(&Период, ТерминалУстановлен) КАК ItobПривязкиТерминаловСрезПоследних
	               |			ПО ItobТерминалы.Ссылка = ItobПривязкиТерминаловСрезПоследних.Терминал
	               |	ГДЕ
	               |		ItobПодпискиНаСобытияОбъектов.Объект.Код ЕСТЬ NULL ) КАК ВложенныйЗапрос
	               |		ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ItobТерминалы.Датчики КАК ItobТерминалыДатчики
	               |		ПО ВложенныйЗапрос.Терминал = ItobТерминалыДатчики.Ссылка
	               |			И ВложенныйЗапрос.Подписка.Показатель = ItobТерминалыДатчики.Назначение
	               |			И (ВложенныйЗапрос.Подписка.Источник = ЗНАЧЕНИЕ(Перечисление.ItobИсточникиСобытий.ДанныеДатчиков))
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobАктуальностьДанныхТерминалов КАК ItobАктуальностьДанныхТерминалов
	               |		ПО ВложенныйЗапрос.Терминал = ItobАктуальностьДанныхТерминалов.Терминал
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobДанныеДатчиков КАК ItobДанныеДатчиков
	               |		ПО ВложенныйЗапрос.Терминал = ItobДанныеДатчиков.Терминал
	               |			И (ItobАктуальностьДанныхТерминалов.ДатаВремя = ItobДанныеДатчиков.Период)
	               |			И (ItobТерминалыДатчики.Датчик = ItobДанныеДатчиков.Датчик)
	               |			И (ВложенныйЗапрос.Подписка.Источник = ЗНАЧЕНИЕ(Перечисление.ItobИсточникиСобытий.ДанныеДатчиков))
	               |ГДЕ
	               |	(НЕ(ВложенныйЗапрос.Подписка.Источник = ЗНАЧЕНИЕ(Перечисление.ItobИсточникиСобытий.ДанныеДатчиков)
	               |				И ItobТерминалыДатчики.Датчик ЕСТЬ NULL ))";
				   
	ТаблицаПодписок = Запрос.Выполнить().Выгрузить();			   
	ТаблицаПодписок.Индексы.Добавить("Терминал");
	
	ТаблицаПодписок.Колонки.Добавить("ПараметрыГеозоны");
		
	ТЗГеозон = ПолучитьТаблицуГеграфическихЗон();
	
	МассивУдаленияПодписки = Новый Массив;
		
	Для каждого СтрПодписки Из ТаблицаПодписок Цикл
		Если СтрПодписки.Источник = Перечисления.ItobИсточникиСобытий.ВходВГеозону
			ИЛИ СтрПодписки.Источник = Перечисления.ItobИсточникиСобытий.ВыходИзГеозоны Тогда
			
			НайдГеозона = ТЗГеозон.Найти(СтрПодписки.Показатель, "Геозона");
			Если НайдГеозона <> Неопределено Тогда
				
				СтрПодписки.ПараметрыГеозоны = 
					Новый Структура("МинШирота,МинДолгота,МаксШирота,МаксДолгота,Мх,Му");
				ЗаполнитьЗначенияСвойств(СтрПодписки.ПараметрыГеозоны, НайдГеозона);
				
				СтрПодписки.ПараметрыГеозоны.Мх = Новый Массив;
				Для каждого ЭлемМх Из НайдГеозона.Мх Цикл
					СтрПодписки.ПараметрыГеозоны.Мх.Добавить(ЭлемМх);				
				КонецЦикла;
				
				СтрПодписки.ПараметрыГеозоны.Му = Новый Массив;
				Для каждого ЭлемМу Из НайдГеозона.Му Цикл
					СтрПодписки.ПараметрыГеозоны.Му.Добавить(ЭлемМу);				
				КонецЦикла;
				
			Иначе
				МассивУдаленияПодписки.Добавить(СтрПодписки);
			
			КонецЕсли;			
		
		КонецЕсли;
	
	КонецЦикла;
	
	Для каждого СтрУдаления Из МассивУдаленияПодписки Цикл
		ТаблицаПодписок.Удалить(СтрУдаления);		
	
	КонецЦикла;
				   
	Возврат ТаблицаПодписок;			   

КонецФункции // ПолучитьТаблицуПодписок()

// Возвращает таблицу географических зон
//
Функция ПолучитьТаблицуГеграфическихЗон()

	ТаблицаГеозон = Новый ТаблицаЗначений;
	ТаблицаГеозон.Колонки.Добавить("Геозона");
	ТаблицаГеозон.Колонки.Добавить("МинШирота");
	ТаблицаГеозон.Колонки.Добавить("МинДолгота");	
	ТаблицаГеозон.Колонки.Добавить("МаксШирота");
	ТаблицаГеозон.Колонки.Добавить("МаксДолгота");	
	ТаблицаГеозон.Колонки.Добавить("Уровень");	
	ТаблицаГеозон.Колонки.Добавить("Мх");
	ТаблицаГеозон.Колонки.Добавить("Му");		
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ItobГеографическиеЗоныТочки.Ссылка КАК Ссылка,
	               |	ItobГеографическиеЗоныТочки.НомерСтроки КАК НомерСтроки,
	               |	ItobГеографическиеЗоныТочки.Широта КАК Широта,
	               |	ItobГеографическиеЗоныТочки.Долгота КАК Долгота,
	               |	ItobГеографическиеЗоныТочки.Широта КАК Широта1,
	               |	ItobГеографическиеЗоныТочки.Долгота КАК Долгота1,
	               |	ItobГеографическиеЗоныТочки.Ссылка.Код
	               |ИЗ
	               |	Справочник.ItobГеографическиеЗоны.Точки КАК ItobГеографическиеЗоныТочки
	               |ГДЕ
	               |	ItobГеографическиеЗоныТочки.Ссылка В
	               |			(ВЫБРАТЬ
	               |				ItobПодпискиНаСобытияОбъектов.Показатель
	               |			ИЗ
	               |				РегистрСведений.ItobПодпискиНаСобытияОбъектов КАК ItobПодпискиНаСобытияОбъектов
	               |			ГДЕ
	               |				(ItobПодпискиНаСобытияОбъектов.Источник = ЗНАЧЕНИЕ(перечисление.ItobИсточникиСобытий.ВходВГеозону)
	               |					ИЛИ ItobПодпискиНаСобытияОбъектов.Источник = ЗНАЧЕНИЕ(перечисление.ItobИсточникиСобытий.ВыходИзГеозоны)))
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	Ссылка,
	               |	НомерСтроки
	               |ИТОГИ
	               |	МИНИМУМ(Широта),
	               |	МИНИМУМ(Долгота),
	               |	МАКСИМУМ(Широта) КАК Широта1,
	               |	МАКСИМУМ(Долгота) КАК Долгота1
	               |ПО
	               |	Ссылка";	
				   
	ВыборкаПоЗонам = Запрос.Выполнить().Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам);
			
	Пока ВыборкаПоЗонам.Следующий() Цикл
		
		ВыборкаПоТочкам = ВыборкаПоЗонам.Выбрать();
		Если ВыборкаПоТочкам.Количество() = 0 Тогда
			Продолжить;
		
		КонецЕсли;
		
		НовСтрока = ТаблицаГеозон.Добавить();
		НовСтрока.Геозона = ВыборкаПоЗонам.Ссылка;
		НовСтрока.МинШирота = ВыборкаПоЗонам.Широта;
		НовСтрока.МинДолгота = ВыборкаПоЗонам.Долгота;
		НовСтрока.МаксШирота = ВыборкаПоЗонам.Широта1;
		НовСтрока.МаксДолгота = ВыборкаПоЗонам.Долгота1;
		НовСтрока.Уровень = СтрДлина(ВыборкаПоЗонам.Ссылка.ПолныйКод());
		НовСтрока.Мх = Новый Массив;
		НовСтрока.Му = Новый Массив;		
		
		Пока ВыборкаПоТочкам.Следующий() Цикл				
			НовСтрока.Мх.Добавить(ВыборкаПоТочкам.Долгота);
			НовСтрока.Му.Добавить(ВыборкаПоТочкам.Широта);
			
		КонецЦикла;
		
		НовСтрока.Мх.Добавить(НовСтрока.Мх[0]);
		НовСтрока.Му.Добавить(НовСтрока.Му[0]);		
		
	КонецЦикла;
	
	Возврат ТаблицаГеозон;

КонецФункции // ПолучитьТаблицуГеграфическихЗон()

// Проверка вхождения в геозону
//
Функция ОпределитьВхождениеВГеозону(Широта,Долгота, ПараметрыГеозоны)
	
	Если ПараметрыГеозоны.МинШирота <= Широта
		И ПараметрыГеозоны.МаксШирота >= Широта 
		И ПараметрыГеозоны.МинДолгота <= Долгота
		И ПараметрыГеозоны.МаксДолгота >= Долгота Тогда
		
		Возврат ItobОперативныйМониторинг.ТочкаВнутриГеозоны(Долгота, Широта, ПараметрыГеозоны.Мх, ПараметрыГеозоны.Му);
		
	Иначе
		
		Возврат Ложь;
	
	КонецЕсли;

КонецФункции // ОпределитьВхождениеВГеозону()

// Проверка выпаолнения условия срабатывания подписки
//
Функция УсловиеПодпискиВыполняется(ЗначениеПоказателя, ДанныеПодписки)
	
	Результат = Ложь;
	
	Если ДанныеПодписки.Источник = Перечисления.ItobИсточникиСобытий.ДанныеТерминалов
		ИЛИ ДанныеПодписки.Источник = Перечисления.ItobИсточникиСобытий.ДанныеДатчиков Тогда
		
		Результат = Вычислить("ЗначениеПоказателя "+ДанныеПодписки.ВидСравнения + " ДанныеПодписки.Значение");
		
	ИначеЕсли ДанныеПодписки.Источник = Перечисления.ItobИсточникиСобытий.ВходВГеозону Тогда
		Результат = ЗначениеПоказателя=Истина;
		
	ИначеЕсли ДанныеПодписки.Источник = Перечисления.ItobИсточникиСобытий.ВыходИзГеозоны Тогда
		Результат = ЗначениеПоказателя=Ложь;
	
	КонецЕсли;
	
	Возврат Результат;

КонецФункции // УсловиеПодпискиВыполняется()

// Считывание в БД данные предыдущей от переданный точки 
//
Функция ПолучитьПредыдущуюТочку(Терминал, Период, Датчик, ИсточникДанных)
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Терминал", Терминал);
	Запрос.УстановитьПараметр("Период", Период);
	Запрос.УстановитьПараметр("Датчик", Датчик);
	Запрос.УстановитьПараметр("ИсточникДанных", ИсточникДанных);
	
	Запрос.Текст = "ВЫБРАТЬ ПЕРВЫЕ 1
	               |	ItobДанныеТерминалов.Период КАК Период,
	               |	ItobДанныеТерминалов.Широта КАК Широта,
	               |	ItobДанныеТерминалов.Долгота КАК Долгота,
	               |	ItobДанныеТерминалов.Скорость КАК Скорость,
	               |	ItobДанныеТерминалов.Направление КАК Направление,
	               |	ItobДанныеДатчиков.Датчик,
	               |	ItobДанныеДатчиков.Значение КАК ЗначениеДатчика
	               |ИЗ
	               |	РегистрСведений.ItobДанныеТерминалов КАК ItobДанныеТерминалов
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobДанныеДатчиков КАК ItobДанныеДатчиков
	               |		ПО ItobДанныеТерминалов.Период = ItobДанныеДатчиков.Период
	               |			И (ItobДанныеДатчиков.Датчик = &Датчик)
	               |			И (ItobДанныеДатчиков.Терминал = &Терминал)
	               |ГДЕ
	               |	ItobДанныеТерминалов.Период < &Период
	               |	И ItobДанныеТерминалов.Терминал = &Терминал
	               |	И (НЕ ВЫБОР
	               |				КОГДА &ИсточникДанных = ЗНАЧЕНИЕ(Перечисление.ItobИсточникиСобытий.ДанныеДатчиков)
	               |					ТОГДА ItobДанныеДатчиков.Значение
	               |				ИНАЧЕ 1
	               |			КОНЕЦ ЕСТЬ NULL )
	               |
	               |УПОРЯДОЧИТЬ ПО
	               |	ItobДанныеТерминалов.Период УБЫВ";
				   
	Выборка = Запрос.Выполнить().Выбрать();
	Если Выборка.Следующий() Тогда
		Возврат Выборка;
		
	Иначе
		Возврат Неопределено;
	
	КонецЕсли;	

КонецФункции // ПолучитьПредыдущуюТочку()()

// Проверяет набор данных на исполнение подписок на события
//
Процедура ПроверитьВыполнениеСобытий(Терминал, ТаблицаДанных, ТЗПодписок)
	
	Если Метаданные.НайтиПоПолномуИмени("Документ.ItobПодпискаНаСобытие") = Неопределено Тогда
		Возврат;
	
	КонецЕсли;
	
	Если ТаблицаДанных.Количество()=0 Тогда
		Возврат;
	
	КонецЕсли;
	
	ТаблицаДанных.Сортировать("Период Возр");
		
	НайденныеПодписки = ТЗПодписок.НайтиСтроки(Новый Структура("Терминал", Терминал));
	Для каждого СтрокаПодписки Из НайденныеПодписки Цикл
		
		ПредыдущееЗначениеПоказателя = Неопределено;
				
		Если ЗначениеЗаполнено(СтрокаПодписки.ДатаАктуальности) Тогда
			
			Если ТаблицаДанных[0].Период > СтрокаПодписки.ДатаАктуальности Тогда
				// Все нормально, данные идут последовательно
				ДанныеПредыдущейТочки = СтрокаПодписки;
				
				Если СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ДанныеДатчиков
					И ДанныеПредыдущейТочки.ЗначениеДатчика = NULL Тогда
					
					ДанныеПредыдущейТочки = ПолучитьПредыдущуюТочку(Терминал, ТаблицаДанных[0].Период, СтрокаПодписки.Датчик, СтрокаПодписки.Источник);
				
				КонецЕсли;
				
			Иначе
				// Трекер скидывает данные задним числом
				// Смотрим предыдущие точки
				
				ДанныеПредыдущейТочки = ПолучитьПредыдущуюТочку(Терминал, ТаблицаДанных[0].Период, СтрокаПодписки.Датчик, СтрокаПодписки.Источник);				
			
			КонецЕсли;
			
			Если ДанныеПредыдущейТочки <> Неопределено Тогда
								
				Если СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ДанныеТерминалов Тогда
					ПредыдущееЗначениеПоказателя = ДанныеПредыдущейТочки[Строка(СтрокаПодписки.Показатель)];
					
				ИначеЕсли СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ДанныеДатчиков Тогда
					ПредыдущееЗначениеПоказателя = ДанныеПредыдущейТочки.ЗначениеДатчика;
					
				ИначеЕсли СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ВходВГеозону 
					ИЛИ СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ВыходИзГеозоны Тогда
					
					ПредыдущееЗначениеПоказателя = ОпределитьВхождениеВГеозону(
						ДанныеПредыдущейТочки.Широта, ДанныеПредыдущейТочки.Долгота, СтрокаПодписки.ПараметрыГеозоны);
					
				КонецЕсли;				
			
			КонецЕсли;
		
		КонецЕсли;
		
		Если ПредыдущееЗначениеПоказателя=Неопределено Тогда
			ПредыдущееУсловиеВыполняется = Ложь;
			
		Иначе
			ПредыдущееУсловиеВыполняется = УсловиеПодпискиВыполняется(ПредыдущееЗначениеПоказателя, СтрокаПодписки);
		
		КонецЕсли;
		
		Для каждого СтрДанные Из ТаблицаДанных Цикл
			
			ТекущееЗначениеПоказателя = Неопределено;
			
			Если СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ДанныеТерминалов Тогда
				ТекущееЗначениеПоказателя = СтрДанные[Строка(СтрокаПодписки.Показатель)];
					
			ИначеЕсли СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ДанныеДатчиков Тогда
				НайдСтрокаЗначенийДатчиков = СтрДанные.ЗначенияДатчиков.Найти(СтрокаПодписки.Датчик,"Датчик");
				Если НайдСтрокаЗначенийДатчиков <> Неопределено Тогда
					ТекущееЗначениеПоказателя = НайдСтрокаЗначенийДатчиков.Значение;
				Иначе
					
					// Точка невалидна - не учитываем ее в расчетах
					Продолжить;
					
				КонецЕсли;
					
			ИначеЕсли СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ВходВГеозону 
				ИЛИ СтрокаПодписки.Источник = Перечисления.ItobИсточникиСобытий.ВыходИзГеозоны Тогда
				ТекущееЗначениеПоказателя = ОпределитьВхождениеВГеозону(СтрДанные.Широта, СтрДанные.Долгота, СтрокаПодписки.ПараметрыГеозоны);
					
			КонецЕсли;
			
			ТекущееУсловиеВыполняется = УсловиеПодпискиВыполняется(ТекущееЗначениеПоказателя, СтрокаПодписки);
			
			Если ТекущееУсловиеВыполняется И (НЕ ПредыдущееУсловиеВыполняется) Тогда
				// Подписка сработала!
				ЗаписатьДанныеПодпискаСработала(СтрДанные.Период, Терминал, СтрокаПодписки.Подписка, ТекущееЗначениеПоказателя);				
			
			КонецЕсли;
			
			ПредыдущееЗначениеПоказателя = ТекущееЗначениеПоказателя;
			ПредыдущееУсловиеВыполняется = ТекущееУсловиеВыполняется;
			
		КонецЦикла;		
	
	КонецЦикла;
		

КонецПроцедуры

// Запись в журнал событий
//
Процедура ЗаписатьДанныеПодпискаСработала(Период, Терминал, Подписка, ЗначениеПоказателя)

	НовЗапись = РегистрыСведений.ItobЖурналСобытий.СоздатьМенеджерЗаписи();
	НовЗапись.Период      = Период;
	НовЗапись.Терминал    = Терминал;		
	НовЗапись.Подписка    = Подписка;
	НовЗапись.Значение    = ЗначениеПоказателя;
	НовЗапись.ДатаЗаписи  = ТекущаяУниверсальнаяДата();
	НовЗапись.Записать();

КонецПроцедуры


// Процедура вызова регламентного задания
//
Процедура РепликацияРегламентноеЗадание(ИмяПотока="Основной") Экспорт

	// Список объектов
	
	Логин = "";
	Пароль = "";
	
	Если ИмяПотока = "Резервный" Тогда
		СтруктураПараметрыРепликации = Константы.ItobПараметрыРепликацииРезервныйСервер.Получить().Получить();
		
		Если ТипЗнч(СтруктураПараметрыРепликации) = Тип("Структура") Тогда
			СтруктураПараметрыРепликации.Свойство("Логин" , Логин);
			СтруктураПараметрыРепликации.Свойство("Пароль", Пароль);	
		КонецЕсли;	
		
	Иначе
		СтруктураПараметрыРепликации = Константы.ItobПараметрыРепликации.Получить().Получить();	
		
		Логин = Константы.ItobЛогинРепликации.Получить();
		Пароль = Константы.ItobПарольРепликации.Получить();
	
	КонецЕсли;	
	
	Если ТипЗнч(СтруктураПараметрыРепликации) <> Тип("Структура") Тогда
		ЗаписьЖурналаРегистрации("Репликация",УровеньЖурналаРегистрации.Ошибка,,,"Ошибка репликации, поток "+ИмяПотока+": не указаны параметры");
		Возврат;		
			
	КонецЕсли;
	
	ИспользоватьРепликацию = Ложь;
	Сервер = "";
	Порт = 0;
		
	СтруктураПараметрыРепликации.Свойство("ИспользоватьРепликацию", ИспользоватьРепликацию);
	СтруктураПараметрыРепликации.Свойство("Сервер"                , Сервер);
	СтруктураПараметрыРепликации.Свойство("Порт"                  , Порт);
		
	Если (НЕ ИспользоватьРепликацию) ИЛИ Сервер="" ИЛИ Порт=0 ИЛИ Логин="" Тогда
		ЗаписьЖурналаРегистрации("Репликация",УровеньЖурналаРегистрации.Примечание,,,"Репликация не выполнена, поток "+ИмяПотока+", поскольку не все параметры указаны");
		Возврат;
	
	КонецЕсли;
	
	Запрос = Новый Запрос;	
	Запрос.Текст = "ВЫБРАТЬ
	               |	ItobТерминалы.Код КАК КодТерминала,
	               |	ЕСТЬNULL(ItobКрайниеДанныеТерминалов.Счетчик, 0) КАК СчетчикАктуальности
	               |ИЗ
	               |	Справочник.ItobТерминалы КАК ItobТерминалы
	               |		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobКрайниеДанныеТерминалов КАК ItobКрайниеДанныеТерминалов
	               |		ПО (ItobКрайниеДанныеТерминалов.Терминал = ItobТерминалы.Ссылка)
	               |ГДЕ
	               |	(НЕ ItobТерминалы.ПометкаУдаления)
	               |	И ItobТерминалы.Код <> 0";
				   
	СтрокаЗапроса = "";
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		СтрокаЗапроса = ?(СтрокаЗапроса="","",СтрокаЗапроса+",")+Формат(Выборка.КодТерминала,"ЧН=0; ЧГ=0") + "," 
			+ Формат(Выборка.СчетчикАктуальности, "ЧН=0; ЧГ=0");
	
	КонецЦикла;
		
	АдресСтраницы = "http://"+СокрЛП(Сервер)+":"+Формат(Порт, "ЧН=0; ЧГ=0")+"/GetTerminalData?login="+Логин+"&pwd="+Пароль+"&QueryMethod=1&Output=xml&Pack=2&Query="+СтрокаЗапроса;
	
	ИмяФайлаZIP = КаталогВременныхФайлов()+"replic-result-"+Строка(Новый УникальныйИдентификатор())+".zip";
	КаталогИзвлечения = Лев(ИмяФайлаZIP, СтрДлина(ИмяФайлаZIP)-4);
	
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ПутьДляСохранения", ИмяФайлаZIP);
	
	РезультатСкачивания = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(АдресСтраницы,ПараметрыПолучения);
	Если НЕ РезультатСкачивания.Статус Тогда
		ЗаписьЖурналаРегистрации("Репликация",УровеньЖурналаРегистрации.Ошибка,,,"Ошибка репликации, поток "+ИмяПотока+": Ошибка получения файла "+АдресСтраницы);
		Возврат;
	КонецЕсли;
	
	ЧтениеZIP = Новый ЧтениеZipФайла();
	
	Попытка
		
		ЧтениеZIP.Открыть(ИмяФайлаZIP);
		ЧтениеZIP.ИзвлечьВсе(КаталогИзвлечения);
		
		НайденныеФайлы = НайтиФайлы(КаталогИзвлечения,"*.*");
		Для каждого НайденныйФайл Из НайденныеФайлы Цикл
			ОбработатьДанныеРепликации(НайденныйФайл.ПолноеИмя, ИмяПотока);
					
		КонецЦикла;
		
		ЧтениеZIP.Закрыть();
				
		Для каждого НайденныйФайл Из НайденныеФайлы Цикл
			УдалитьФайлы(НайденныйФайл.ПолноеИмя);
								
		КонецЦикла;
		
	Исключение
		ЗаписьЖурналаРегистрации("Репликация",УровеньЖурналаРегистрации.Ошибка,,,"Ошибка обработки данных репликации, поток "+ИмяПотока+": "+ОписаниеОшибки());
		УдалитьФайлы(ИмяФайлаZIP);
		Возврат;
	
	КонецПопытки;	
	
	УдалитьФайлы(КаталогИзвлечения);
	УдалитьФайлы(ИмяФайлаZIP);	

КонецПроцедуры

// Разбор XML файла данных от трекеров
//
Процедура ОбработатьДанныеРепликации(ИмяФайла, ИмяПотока)
	
	ЧтениеXML = Новый ЧтениеXML;
			
	ТабДанных = Новый ТаблицаЗначений;
	ТабДанных.Колонки.Добавить("КодТерминала");
	ТабДанных.Колонки.Добавить("Период");
	ТабДанных.Колонки.Добавить("Широта");
	ТабДанных.Колонки.Добавить("Долгота");
	ТабДанных.Колонки.Добавить("Высота");
	ТабДанных.Колонки.Добавить("Направление");
	ТабДанных.Колонки.Добавить("Скорость");
	ТабДанных.Колонки.Добавить("ЧислоСпутников");
	ТабДанных.Колонки.Добавить("Счетчик");
	ТабДанных.Колонки.Добавить("ДанныеДатчиков");

	
	ТабДанных.Индексы.Добавить("КодТерминала,Счетчик");
	
	ТабДатчиков = Новый ТаблицаЗначений;
	ТабДатчиков.Колонки.Добавить("Код");
	ТабДатчиков.Колонки.Добавить("Данные");
	
	ВерсияСервера = "";
	ВерсияФормата = "";
	
	Попытка		
		
		ЧтениеXML.ОткрытьФайл(ИмяФайла);	
		
		Пока ЧтениеXML.Прочитать() Цикл
			
			Если ЧтениеXML.Имя="imcs" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				ВерсияСервера = ЧтениеXML.ПолучитьАтрибут("version");
				ВерсияФормата = ЧтениеXML.ПолучитьАтрибут("format_version");	
				
			КонецЕсли;
			
			Если ЧтениеXML.Имя="p" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
				
				СтрДанных = ТабДанных.Добавить();
				
				Попытка
				
					СтрДанных.КодТерминала   = Число(ЧтениеXML.ПолучитьАтрибут("code"));
					СтрДанных.Период         = Дата(ЧтениеXML.ПолучитьАтрибут("period"));
					СтрДанных.Широта         = Число(ЧтениеXML.ПолучитьАтрибут("lat"));
					СтрДанных.Долгота        = Число(ЧтениеXML.ПолучитьАтрибут("lon"));
					СтрДанных.Высота         = Число(ЧтениеXML.ПолучитьАтрибут("altitude"));
					СтрДанных.Направление    = Число(ЧтениеXML.ПолучитьАтрибут("angle"));
					СтрДанных.Скорость       = Число(ЧтениеXML.ПолучитьАтрибут("speed"));
					СтрДанных.ЧислоСпутников = Число(ЧтениеXML.ПолучитьАтрибут("vsat"));
					СтрДанных.Счетчик        = Число(ЧтениеXML.ПолучитьАтрибут("counter"));	
				
				Исключение
					ЗаписьЖурналаРегистрации("Репликация",УровеньЖурналаРегистрации.Ошибка,,,"Разбор XML, ошибка преобразования: "+ОписаниеОшибки());
					ТабДанных.Удалить(СтрДанных);
					Продолжить;
					
				КонецПопытки;				
				
				СтрДанных.ДанныеДатчиков = ТабДатчиков.Скопировать();
				
				РезультатЧтения = Истина;
				Пока РезультатЧтения И НЕ (ЧтениеXML.Имя = "p" И ЧтениеXML.ТипУзла = ТипУзлаXML.КонецЭлемента) Цикл
					
					Если ЧтениеXML.Имя="sensor" И ЧтениеXML.ТипУзла = ТипУзлаXML.НачалоЭлемента Тогда
						НовСтрокаДатчиков = СтрДанных.ДанныеДатчиков.Добавить();
						
						Попытка						
							НовСтрокаДатчиков.Код = Число(ЧтениеXML.ПолучитьАтрибут("code"));
							НовСтрокаДатчиков.Данные = Число(ЧтениеXML.ПолучитьАтрибут("data"));
							
						Исключение
							ЗаписьЖурналаРегистрации("Репликация",УровеньЖурналаРегистрации.Ошибка,,,"Разбор XML, ошибка преобразования данных датчиков: "+ОписаниеОшибки());
							СтрДанных.ДанныеДатчиков.Удалить(НовСтрокаДатчиков);
														
						КонецПопытки;
						
					КонецЕсли;	
					
					РезультатЧтения = ЧтениеXML.Прочитать();	
				КонецЦикла;
				
			КонецЕсли;
						
		КонецЦикла;	
		
		ЧтениеXML.Закрыть();
		
	Исключение
		ЗаписьЖурналаРегистрации("Репликация",УровеньЖурналаРегистрации.Ошибка,,,"Ошибка разбора XML файла : "+ОписаниеОшибки());
		КопироватьФайл(ИмяФайла, ИмяФайла+".error");
		
	КонецПопытки;
	
	ТабДанных.Сортировать("КодТерминала Возр, Счетчик Возр");
	
	// Получаем таблицу "старого" формата
	
	ТабДанныхСтарыйФормат = GetTemplateOfDataTable();
	Для каждого СтрДанных Из ТабДанных Цикл
		
		НовСтрокаСтарыйФормат = ТабДанныхСтарыйФормат.Добавить();
		ЗаполнитьЗначенияСвойств(НовСтрокаСтарыйФормат, СтрДанных);
		
		Для j = 0 По СтрДанных.ДанныеДатчиков.Количество()-1 Цикл
		
			Если ТабДанныхСтарыйФормат.Колонки.Количество() < 9+2*j  Тогда
				ТабДанныхСтарыйФормат.Колонки.Добавить();
				ТабДанныхСтарыйФормат.Колонки.Добавить();			
			КонецЕсли;
			
			НовСтрокаСтарыйФормат.Установить(7+2*j, СтрДанных.ДанныеДатчиков[j].Код);
			НовСтрокаСтарыйФормат.Установить(8+2*j, СтрДанных.ДанныеДатчиков[j].Данные);	
		
		КонецЦикла;
		
		Если ТабДанныхСтарыйФормат.Количество() >= 200 Тогда
			WriteTerminalData(ТабДанныхСтарыйФормат, ИмяПотока);			
			ТабДанныхСтарыйФормат.Очистить();
		
		КонецЕсли;
	
	КонецЦикла;
	
	WriteTerminalData(ТабДанныхСтарыйФормат, ИмяПотока);
	
КонецПроцедуры

// Тестирование соединения с сервером
//
Функция ТестСоединенияССервером(Сервер, Порт, Логин, Пароль, ТекстОшибки) Экспорт
	
	АдресСтраницы = "http://"+СокрЛП(Сервер)+":"+Формат(Порт, "ЧН=0; ЧГ=0")+"/TestConnection?login="+Логин+"&pwd="+Пароль;
	
	ИмяФайла = КаталогВременныхФайлов()+"replic-result-"+Строка(Новый УникальныйИдентификатор())+".html";
		
	ПараметрыПолучения = Новый Структура;
	ПараметрыПолучения.Вставить("ПутьДляСохранения", ИмяФайла);
	
	РезультатСкачивания = ПолучениеФайловИзИнтернета.СкачатьФайлНаСервере(АдресСтраницы,ПараметрыПолучения);
	Если НЕ РезультатСкачивания.Статус Тогда
		ТекстОшибки = "Ошибка соединения с сервером репликации: "+РезультатСкачивания.СообщениеОбОшибке;
		Возврат Ложь;
	КонецЕсли;
	
	ТекстовыйДок = Новый ТекстовыйДокумент;
	ТекстовыйДок.Прочитать(ИмяФайла);
	
	Если ТекстовыйДок.КоличествоСтрок()=1 И ТекстовыйДок.ПолучитьСтроку(1) = "OK" Тогда
		Возврат Истина;
		
	Иначе
		ТекстОшибки = "Ответ сервера: "+ТекстовыйДок.ПолучитьТекст();
		Возврат Ложь;		
	
	КонецЕсли;	

КонецФункции // ТестСоединенияССервером()
