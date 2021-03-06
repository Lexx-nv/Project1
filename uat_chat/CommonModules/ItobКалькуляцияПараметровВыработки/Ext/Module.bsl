// Функция возвращает промежуточное географическое расположение
//
Функция ПолучитьТочкуНаДату(Точка1,Точка2,НаДату)
	
	Результат = Новый Структура("Период,Широта,Долгота",НаДату,0,0);
	
	Если НЕ (Точка1.Период < НаДату И НаДату < Точка2.Период) Тогда	
		Возврат Результат;
		
	КонецЕсли;
	
	x1 = Точка1.Долгота;
	y1 = Точка1.Широта;
	x2 = Точка2.Долгота;
	y2 = Точка2.Широта;
	
	t1 = Точка1.Период;
	t2 = Точка2.Период;
	
	dT = t2 - t1;
	dT3 = НаДату - t1;
		
	Результат.Широта = (y2-y1)*dT3/dT + y1;
	Результат.Долгота = (x2-x1)*dT3/dT + x1;
		
	Возврат Результат;	

КонецФункции // ПолучитьТочкуНаДату()

// Функция возвращает промежуточное значение параметра
//
Функция ПолучитьПромежуточноеЗначение(Знач1,Дата1,Знач2,Дата2, НаДату)
	
	t1 = Дата1;
	t2 = Дата2;
	
	dT = t2 - t1;
	dT3 = НаДату - t1;
	
	Возврат Знач1 + (Знач2-Знач1)*dT3/dT;	

КонецФункции // ПолучитьПромежуточноеЗначение()

// Функция преобразовывает переданное значение в соответствии с калибровочным графиком
//
Функция ПреобразоватьЗначениеПоКалибровочномуГрафику(Значение, КалибровочныйГрафик)
	
	Результат = 0;
	
	Для п = 0 По КалибровочныйГрафик.Показатели.Количество()-2 Цикл
		Если Значение >= КалибровочныйГрафик.Показатели[п].Вход
			И Значение <= КалибровочныйГрафик.Показатели[п+1].Вход Тогда
			
			СтрКалиб1 = КалибровочныйГрафик.Показатели[п];
			СтрКалиб2 = КалибровочныйГрафик.Показатели[п+1];
			
			Результат = (СтрКалиб1.Выход-СтрКалиб2.Выход)/(СтрКалиб1.Вход-СтрКалиб2.Вход)*Значение
				+ (СтрКалиб1.Вход*СтрКалиб2.Выход-СтрКалиб2.Вход*СтрКалиб1.Выход)/(СтрКалиб1.Вход-СтрКалиб2.Вход);
				
			Прервать;			
			
		КонецЕсли; 
		
	КонецЦикла;
	
	Возврат Результат;

КонецФункции // ПреобразоватьПоКалибровочномуГрафику()

// Проверка - соответствует ли строка выработки условию параметра 
//
Функция ПроверитьУсловие(строкаТЗ, УсловияОтбора)
	
	Для каждого условие Из УсловияОтбора Цикл
		
		//Для состояния в движении или стоянка
		Если ТипЗнч(условие.Показатель) = Тип("Строка") Тогда
			
			Если условие.ВидСравнения = Перечисления.ItobВидыСравнения.Равно Тогда
				Если НЕ (строкаТЗ.Состояние =  условие.значение) Тогда
					Возврат Ложь;
				КонецЕсли;
				
			КонецЕсли;	
			
		Иначе	
			
			
			Если условие.ВидСравнения = Перечисления.ItobВидыСравнения.Больше Тогда
				Если НЕ (строкаТЗ["ЗначениеДатчика"+условие.Показатель.Код] >  условие.значение) Тогда
					Возврат Ложь;
				КонецЕсли;
			ИначеЕсли условие.ВидСравнения = Перечисления.ItobВидыСравнения.БольшеЛибоРавно Тогда
				Если НЕ (строкаТЗ["ЗначениеДатчика"+условие.Показатель.Код] >=  условие.значение) Тогда
					Возврат Ложь;
				КонецЕсли;
			ИначеЕсли условие.ВидСравнения = Перечисления.ItobВидыСравнения.Меньше Тогда
				Если НЕ (строкаТЗ["ЗначениеДатчика"+условие.Показатель.Код] <  условие.значение) Тогда
					Возврат Ложь;
				КонецЕсли;
			ИначеЕсли условие.ВидСравнения = Перечисления.ItobВидыСравнения.МеньшеЛибоРавно Тогда
				Если НЕ (строкаТЗ["ЗначениеДатчика"+условие.Показатель.Код] <=  условие.значение) Тогда
					Возврат Ложь;
				КонецЕсли;
				
			ИначеЕсли условие.ВидСравнения = Перечисления.ItobВидыСравнения.Равно Тогда
				Если НЕ (строкаТЗ["ЗначениеДатчика"+условие.Показатель.Код] =  условие.значение) Тогда
					Возврат Ложь;
				КонецЕсли;
				
			КонецЕсли;	
		КонецЕсли;
		
	КонецЦикла;
	
	Возврат Истина;	
	
КонецФункции	

// Вычисление значение параметра по пробегу
//
Функция ПолучитьЗначениеПараметраПоПробегу(УсловияОтбора, ТЗ)
	
	Для  п=0 по УсловияОтбора.Количество()-1 Цикл
		Если ТипЗнч(УсловияОтбора[п].Показатель) <> Тип("Строка") Тогда
			
			Если ТЗ.Колонки.Найти("ЗначениеДатчика"+УсловияОтбора[п].Показатель.Код) = Неопределено Тогда
				УсловияОтбора.Удалить(п);	
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
	Пробег = 0;
	
	Для п = 0 По ТЗ.Количество() - 1 Цикл
		
		Проверка = ПроверитьУсловие(ТЗ[п], УсловияОтбора);
		Если Проверка Тогда
			
			Пробег = Пробег + ТЗ[п].Пробег;
			
		КонецЕсли;		
		
	КонецЦикла;	
	
	Возврат Пробег;
	
КонецФункции // ПолучитьЗначениеПараметраПоПробегу()

// Вычисление значение параметра по времени
//
Функция ПолучитьЗначениеПараметраПоВремени(УсловияОтбора, ТЗ)
		
	Для  п=0 по УсловияОтбора.Количество()-1 Цикл
		Если ТипЗнч(УсловияОтбора[п].Показатель) <> Тип("Строка") Тогда
			
			Если ТЗ.Колонки.Найти("ЗначениеДатчика"+УсловияОтбора[п].Показатель.Код) = Неопределено Тогда
				УсловияОтбора.Удалить(п);	
			КонецЕсли;	
		КонецЕсли;
	КонецЦикла;
	
	Время = 0;
	
	Для п = 0 По ТЗ.Количество() - 2 Цикл
		
		Проверка = ПроверитьУсловие(ТЗ[п], УсловияОтбора);
		Если Проверка Тогда
			
			Время = Время + (ТЗ[п+1].Период-ТЗ[п].Период);
			
		КонецЕсли;			
		
	КонецЦикла;	
	
	Возврат Время;
	
КонецФункции // ПолучитьЗначениеПараметраПоВремени()



Функция ПолучитьТаблицуВыработки(НачДата, КонДата, ОбъектМониторинга) Экспорт
	
	ТаблицаВыработки = Новый ТаблицаЗначений;
	ТаблицаВыработки.Колонки.Добавить("ПараметрВыработки");
	ТаблицаВыработки.Колонки.Добавить("Значение");
	
	Терминал = ItobОперативныйМониторинг.ПолучитьПривязанныйТерминал(ОбъектМониторинга,НачДата);
	Если НЕ ЗначениеЗаполнено(Терминал) Тогда
		Возврат ТаблицаВыработки;
	
	КонецЕсли;
	
	ПоправочныйКоэффициентПробега = 1;
	
	// Получим таблицу с интервалами движения
	ТаблицаСостояния = ItobОперативныйМониторинг.СформироватьМаршрутОбъектаМониторинга(ОбъектМониторинга, НачДата, КонДата);
	ТаблицаСостояния.Колонки.Добавить("ПериодКонUTC0", Новый ОписаниеТипов("Дата",,,Новый КвалификаторыДаты(ЧастиДаты.ДатаВремя)));
	Для каждого СтрСостояния Из ТаблицаСостояния Цикл
		СтрСостояния.ПериодКонUTC0 = УниверсальноеВремя(СтрСостояния.ПериодКон);	
	КонецЦикла;
		
	// Определим набор датчиков, данные по которым необхоимо определить
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Терминал", Терминал);
	Запрос.Текст = "ВЫБРАТЬ РАЗЛИЧНЫЕ
	               |	ВложенныйЗапрос.Назначение,
	               |	ВложенныйЗапрос.НазначениеКод,
	               |	ВложенныйЗапрос.Датчик
	               |ИЗ
	               |	(ВЫБРАТЬ
	               |		ItobПараметрыВыработкиУсловияОтобора.Показатель КАК Назначение,
	               |		ItobПараметрыВыработкиУсловияОтобора.Показатель.Код КАК НазначениеКод,
	               |		ItobТерминалыДатчики.Датчик КАК Датчик
	               |	ИЗ
	               |		Справочник.уатПараметрыВыработки.УсловияОтбора КАК ItobПараметрыВыработкиУсловияОтобора
	               |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ItobТерминалы.Датчики КАК ItobТерминалыДатчики
	               |			ПО ItobПараметрыВыработкиУсловияОтобора.Показатель = ItobТерминалыДатчики.Назначение
	               |				И (ItobТерминалыДатчики.Ссылка = &Терминал)
	               |	ГДЕ
	               |		(НЕ ItobПараметрыВыработкиУсловияОтобора.Ссылка.ПометкаУдаления)
	               |		И ItobПараметрыВыработкиУсловияОтобора.Показатель ССЫЛКА Справочник.ItobНазначенияДатчиков
	               |		И (НЕ ItobТерминалыДатчики.Датчик ЕСТЬ NULL )
	               |		И ItobПараметрыВыработкиУсловияОтобора.Ссылка.ЗаполнятьПоДаннымДатчиковТелеметрии
	               |	
	               |	ОБЪЕДИНИТЬ ВСЕ
	               |	
	               |	ВЫБРАТЬ
	               |		ItobПараметрыВыработки.НазначениеДатчика,
	               |		ItobПараметрыВыработки.НазначениеДатчика.Код,
	               |		ItobТерминалыДатчики.Датчик
	               |	ИЗ
	               |		Справочник.уатПараметрыВыработки КАК ItobПараметрыВыработки
	               |			ЛЕВОЕ СОЕДИНЕНИЕ Справочник.ItobТерминалы.Датчики КАК ItobТерминалыДатчики
	               |			ПО ItobПараметрыВыработки.НазначениеДатчика = ItobТерминалыДатчики.Назначение
	               |				И (ItobТерминалыДатчики.Ссылка = &Терминал)
	               |	ГДЕ
	               |		(НЕ ItobПараметрыВыработки.ПометкаУдаления)
	               |		И ItobПараметрыВыработки.ВидПараметра = ЗНАЧЕНИЕ(Перечисление.ItobВидыПараметровВыработки.ИзменениеЗначенияДатчика)
	               |		И (НЕ ItobТерминалыДатчики.Датчик ЕСТЬ NULL )
	               |		И ItobПараметрыВыработки.ЗаполнятьПоДаннымДатчиковТелеметрии) КАК ВложенныйЗапрос";
			
	ТекстЗапросаСекцияВыбрать = "";
	ТекстЗапросаСекцияСоединения = "";
	
	Индекс = 0;
	Выборка = Запрос.Выполнить().Выбрать();
	
	Запрос = Новый Запрос;
	Запрос.МенеджерВременныхТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.Текст = "ВЫБРАТЬ * ПОМЕСТИТЬ ТаблицаСостояния ИЗ &ТаблицаСостояния КАК ТаблицаСостояния";
	Запрос.УстановитьПараметр("ТаблицаСостояния", ТаблицаСостояния);
	Запрос.Выполнить();
	
	Пока Выборка.Следующий() Цикл
		
		ИндексСтр = Формат(Индекс,"ЧН=0; ЧГ=0");
		
		ТекстЗапросаСекцияВыбрать = ТекстЗапросаСекцияВыбрать + "
			|ТабДанныеДатчиков"+ИндексСтр+".Значение КАК ЗначениеДатчика"+Выборка.НазначениеКод+",";
		
		ТекстЗапросаСекцияСоединения = ТекстЗапросаСекцияСоединения + "
			|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ItobДанныеДатчиков КАК ТабДанныеДатчиков"+ИндексСтр+"
			|ПО ТабДанныеДатчиков"+ИндексСтр+".Терминал = &Терминал
			|   И ТабДанныеДатчиков"+ИндексСтр+".Датчик = &Датчик"+ИндексСтр+"
			|	И ТабДанныеДатчиков"+ИндексСтр+".Период = ВложенныйЗапрос.Период";
		
		Запрос.УстановитьПараметр("Датчик"+ИндексСтр, Выборка.Датчик);
		
		Индекс = Индекс + 1;
		
	КонецЦикла;
	
	ПараметрыСдвигаВремени = ItobОперативныйМониторинг.ПолучитьПараметрыСдвигаВремени();
	
	Запрос.УстановитьПараметр("Терминал", Терминал);
	Запрос.УстановитьПараметр("НачДата",  УниверсальноеВремя(НачДата));
	Запрос.УстановитьПараметр("КонДата",  УниверсальноеВремя(КонДата));
	
	Запрос.УстановитьПараметр("СдвигВремени", ПараметрыСдвигаВремени.СдвигВремени);
	Запрос.УстановитьПараметр("ВариантПереводаНаЛетнееВремя", ПараметрыСдвигаВремени.ВариантПереводаВремени);
	Запрос.УстановитьПараметр("СдвигЛетнееВремя", ПараметрыСдвигаВремени.СдвигЛетнееВремя);
		
	Запрос.Текст  = "ВЫБРАТЬ РАЗЛИЧНЫЕ
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
					|	ВложенныйЗапрос.Период КАК Период1,
					|	ВЫБОР КОГДА ТаблицаСостояния.Состояние=ЗНАЧЕНИЕ(Перечисление.ItobСостоянияТерминалов.Стоянка) ТОГДА ТаблицаСостояния.Широта
					|		ИНАЧЕ ВложенныйЗапрос.Широта КОНЕЦ КАК Широта,
					|	ВЫБОР КОГДА ТаблицаСостояния.Состояние=ЗНАЧЕНИЕ(Перечисление.ItobСостоянияТерминалов.Стоянка) ТОГДА ТаблицаСостояния.Долгота
					|		ИНАЧЕ ВложенныйЗапрос.Долгота КОНЕЦ КАК Долгота,
					|	ВложенныйЗапрос.Скорость,
					|	ТаблицаСостояния.Состояние,
					|	"+ТекстЗапросаСекцияВыбрать+"
					|	&Терминал КАК Терминал
					|ИЗ
					|	(ВЫБРАТЬ
					|		ПодзапросПерваяТочка.Период КАК Период,
					|		ПодзапросПерваяТочка.Широта КАК Широта,
					|		ПодзапросПерваяТочка.Долгота КАК Долгота,
					|		ПодзапросПерваяТочка.Скорость КАК Скорость
					|	ИЗ
					|		(ВЫБРАТЬ ПЕРВЫЕ 1
					|			ItobДанныеТерминалов.Период КАК Период,
					|			ItobДанныеТерминалов.Широта КАК Широта,
					|			ItobДанныеТерминалов.Долгота КАК Долгота,
					|			ItobДанныеТерминалов.Скорость КАК Скорость
					|		ИЗ
					|			РегистрСведений.ItobДанныеТерминалов КАК ItobДанныеТерминалов
					|		ГДЕ
					|			ItobДанныеТерминалов.Терминал = &Терминал
					|			И ItobДанныеТерминалов.Период <= &НачДата
					|		
					|		УПОРЯДОЧИТЬ ПО
					|			Период УБЫВ) КАК ПодзапросПерваяТочка
					|	
					|	ОБЪЕДИНИТЬ ВСЕ
					|	
					|	ВЫБРАТЬ
					|		ItobДанныеТерминалов.Период,
					|		ItobДанныеТерминалов.Широта,
					|		ItobДанныеТерминалов.Долгота,
					|		ItobДанныеТерминалов.Скорость
					|	ИЗ
					|		РегистрСведений.ItobДанныеТерминалов КАК ItobДанныеТерминалов
					|	ГДЕ
					|		ItobДанныеТерминалов.Терминал = &Терминал
					|		И ItobДанныеТерминалов.Период МЕЖДУ &НачДата И &КонДата
					|	
					|	ОБЪЕДИНИТЬ ВСЕ
					|	
					|	ВЫБРАТЬ
					|		ПодзапросКрайняяТочка.Период,
					|		ПодзапросКрайняяТочка.Широта,
					|		ПодзапросКрайняяТочка.Долгота,
					|		ПодзапросКрайняяТочка.Скорость
					|	ИЗ
					|		(ВЫБРАТЬ ПЕРВЫЕ 1
					|			ItobДанныеТерминалов.Период КАК Период,
					|			ItobДанныеТерминалов.Широта КАК Широта,
					|			ItobДанныеТерминалов.Долгота КАК Долгота,
					|			ItobДанныеТерминалов.Скорость КАК Скорость
					|		ИЗ
					|			РегистрСведений.ItobДанныеТерминалов КАК ItobДанныеТерминалов
					|		ГДЕ
					|			ItobДанныеТерминалов.Терминал = &Терминал
					|			И ItobДанныеТерминалов.Период >= &КонДата
					|		
					|		УПОРЯДОЧИТЬ ПО
					|			Период) КАК ПодзапросКрайняяТочка) КАК ВложенныйЗапрос
					|	ЛЕВОЕ СОЕДИНЕНИЕ ТаблицаСостояния КАК ТаблицаСостояния 
					|		ПО ВЫБОР КОГДА ТаблицаСостояния.Состояние=ЗНАЧЕНИЕ(Перечисление.ItobСостоянияТерминалов.Движение)
					|			ТОГДА ТаблицаСостояния.ПериодUTC0 = ВложенныйЗапрос.Период
					|			ИНАЧЕ ВложенныйЗапрос.Период МЕЖДУ ТаблицаСостояния.ПериодUTC0 И ТаблицаСостояния.ПериодКонUTC0
					|		КОНЕЦ
					|
					|	"+ТекстЗапросаСекцияСоединения+"
					|
					|УПОРЯДОЧИТЬ ПО
					|	ВложенныйЗапрос.Период";
	
	ТЗ = Запрос.Выполнить().Выгрузить();
	Если ТЗ.Количество() > 1 Тогда
		ТЗ[ТЗ.Количество()-1].Состояние = ТЗ[ТЗ.Количество()-2].Состояние;	
	КонецЕсли;
	
	// Обработаем крайние точки
	Если ТЗ.Количество() >= 2 И ТЗ[0].Период < НачДата Тогда
		ПараметрыТочки = ПолучитьТочкуНаДату(ТЗ[0],ТЗ[1],НачДата);
		ЗаполнитьЗначенияСвойств(ТЗ[0],ПараметрыТочки);
		
	КонецЕсли;
	
	Если ТЗ.Количество() >= 2 И ТЗ[ТЗ.Количество()-1].Период > КонДата Тогда
		ПараметрыТочки = ПолучитьТочкуНаДату(ТЗ[ТЗ.Количество()-2],ТЗ[ТЗ.Количество()-1],КонДата);
		ЗаполнитьЗначенияСвойств(ТЗ[ТЗ.Количество()-1],ПараметрыТочки);
		
	КонецЕсли;
	
	ТЗ.Колонки.Добавить("Пробег");
	//ТЗ.Колонки.Добавить("Состояние");
				
	Для п = 0 По ТЗ.Количество()-1 Цикл
		Если п = 0 Тогда
			ТЗ[0].Пробег = 0;
		ИначеЕсли ТЗ[п-1].Состояние = Перечисления.ItobСостоянияТерминалов.Движение
			ИЛИ (ТЗ[п-1].Состояние = Перечисления.ItobСостоянияТерминалов.Стоянка И ТЗ[п].Состояние = Перечисления.ItobСостоянияТерминалов.Движение) Тогда
			
			ТЗ[п].Пробег = ПоправочныйКоэффициентПробега*ItobОперативныйМониторинг.ПолучитьРасстояниеМеждуТочками(ТЗ[п-1].Широта,ТЗ[п-1].Долгота,ТЗ[п].Широта,ТЗ[п].Долгота);
		Иначе
			ТЗ[п].Пробег = 0;
		КонецЕсли;
						
	КонецЦикла;
		
	ПараметрыВыработкиВыборка = Справочники.уатПараметрыВыработки.Выбрать();
	
	Пока ПараметрыВыработкиВыборка.Следующий() Цикл 
						
		Параметр = ПараметрыВыработкиВыборка.Ссылка;
		
		Если Параметр.ПометкаУдаления Тогда
			Продолжить;
		
		КонецЕсли;
		
		Если НЕ Параметр.ЗаполнятьПоДаннымДатчиковТелеметрии Тогда
			Продолжить;
		
		КонецЕсли;
				
		Если Параметр.ВидПараметра = Перечисления.ItobВидыПараметровВыработки.ИзменениеЗначенияДатчика Тогда
			// Обработка изменения значения датчиков
			
			Если Параметр.НазначениеДатчика.Пустая() Тогда
				Продолжить;
			
			КонецЕсли;
			
			НайдСтрока = Терминал.Датчики.Найти(Параметр.НазначениеДатчика,"Назначение");
			Если НайдСтрока = Неопределено Тогда
				Продолжить;			
			КонецЕсли;
			
			Если НайдСтрока.Датчик.Пустая() Тогда
				Продолжить;
			
			КонецЕсли;
			
			КалибровочныйГрафик = НайдСтрока.КалибровочныйГрафик;
			
			ЗапросИзменения = Новый Запрос;
			ЗапросИзменения.УстановитьПараметр("Терминал", Терминал);
			ЗапросИзменения.УстановитьПараметр("Датчик", НайдСтрока.Датчик);
			ЗапросИзменения.УстановитьПараметр("ПредДеньНачало", ItobОперативныйМониторинг.ПривестиКДатеВремениПоГринвичу(НачДата-24*3600));
			ЗапросИзменения.УстановитьПараметр("ПредДеньКонец", ItobОперативныйМониторинг.ПривестиКДатеВремениПоГринвичу(НачДата-1));
			ЗапросИзменения.УстановитьПараметр("ТекДеньНачало", ItobОперативныйМониторинг.ПривестиКДатеВремениПоГринвичу(НачДата));
			ЗапросИзменения.УстановитьПараметр("ТекДеньКонец", ItobОперативныйМониторинг.ПривестиКДатеВремениПоГринвичу(КонДата));
			ЗапросИзменения.УстановитьПараметр("СледДеньНачало", ItobОперативныйМониторинг.ПривестиКДатеВремениПоГринвичу(КонДата+24*3600));
			ЗапросИзменения.УстановитьПараметр("СледДеньКонец", ItobОперативныйМониторинг.ПривестиКДатеВремениПоГринвичу(КонДата+1));			
			ЗапросИзменения.Текст = "ВЫБРАТЬ
			                        |	ЕСТЬNULL(ВложенныйЗапрос.МаксЗначениеПредыдущегоДня,0) КАК МаксЗначениеПредыдущегоДня,
			                        |	ЕСТЬNULL(ВложенныйЗапрос.МинЗначениеТекущегоДня,0) КАК МинЗначениеТекущегоДня,
			                        |	ЕСТЬNULL(ВложенныйЗапрос.МаксЗначениеТекущегоДня,0) КАК МаксЗначениеТекущегоДня,
			                        |	ЕСТЬNULL(ВложенныйЗапрос.МинЗначениеСледующегоДня,0) КАК МинЗначениеСледующегоДня,
			                        |	ЕСТЬNULL(МАКСИМУМ(ВЫБОР
			                        |			КОГДА ItobДанныеДатчиков.Значение = ВложенныйЗапрос.МаксЗначениеПредыдущегоДня
			                        |					И (ItobДанныеДатчиков.Период МЕЖДУ &ПредДеньНачало И &ПредДеньКонец)
			                        |				ТОГДА ItobДанныеДатчиков.Период
			                        |			ИНАЧЕ NULL
			                        |		КОНЕЦ),0) КАК МаксПериодПредыдущегоДня,
			                        |	ЕСТЬNULL(МИНИМУМ(ВЫБОР
			                        |			КОГДА ItobДанныеДатчиков.Значение = ВложенныйЗапрос.МинЗначениеТекущегоДня
			                        |					И (ItobДанныеДатчиков.Период МЕЖДУ &ТекДеньНачало И &ТекДеньКонец)
			                        |				ТОГДА ItobДанныеДатчиков.Период
			                        |			ИНАЧЕ NULL
			                        |		КОНЕЦ),0) КАК МинПериодТекущегоДня,
			                        |	ЕСТЬNULL(МАКСИМУМ(ВЫБОР
			                        |			КОГДА ItobДанныеДатчиков.Значение = ВложенныйЗапрос.МаксЗначениеТекущегоДня
			                        |					И (ItobДанныеДатчиков.Период МЕЖДУ &ТекДеньНачало И &ТекДеньКонец)
			                        |				ТОГДА ItobДанныеДатчиков.Период
			                        |			ИНАЧЕ NULL
			                        |		КОНЕЦ),0) КАК МаксПериодТекущегоДня,
			                        |	ЕСТЬNULL(МИНИМУМ(ВЫБОР
			                        |			КОГДА ItobДанныеДатчиков.Значение = ВложенныйЗапрос.МинЗначениеСледующегоДня
			                        |					И (ItobДанныеДатчиков.Период МЕЖДУ &СледДеньНачало И &СледДеньКонец)
			                        |				ТОГДА ItobДанныеДатчиков.Период
			                        |			ИНАЧЕ NULL
			                        |		КОНЕЦ),0) КАК МинПериодСледующегоДня
			                        |ИЗ
			                        |	РегистрСведений.ItobДанныеДатчиков КАК ItobДанныеДатчиков,
			                        |	(ВЫБРАТЬ
			                        |		МАКСИМУМ(ВЫБОР
			                        |				КОГДА ItobДанныеДатчиков.Период МЕЖДУ &ПредДеньНачало И &ПредДеньКонец
			                        |					ТОГДА ItobДанныеДатчиков.Значение
			                        |				ИНАЧЕ NULL
			                        |			КОНЕЦ) КАК МаксЗначениеПредыдущегоДня,
			                        |		МИНИМУМ(ВЫБОР
			                        |				КОГДА ItobДанныеДатчиков.Период МЕЖДУ &ТекДеньНачало И &ТекДеньКонец
			                        |					ТОГДА ItobДанныеДатчиков.Значение
			                        |				ИНАЧЕ NULL
			                        |			КОНЕЦ) КАК МинЗначениеТекущегоДня,
			                        |		МАКСИМУМ(ВЫБОР
			                        |				КОГДА ItobДанныеДатчиков.Период МЕЖДУ &ТекДеньНачало И &ТекДеньКонец
			                        |					ТОГДА ItobДанныеДатчиков.Значение
			                        |				ИНАЧЕ NULL
			                        |			КОНЕЦ) КАК МаксЗначениеТекущегоДня,
			                        |		МИНИМУМ(ВЫБОР
			                        |				КОГДА ItobДанныеДатчиков.Период МЕЖДУ &СледДеньНачало И &СледДеньКонец
			                        |					ТОГДА ItobДанныеДатчиков.Значение
			                        |				ИНАЧЕ NULL
			                        |			КОНЕЦ) КАК МинЗначениеСледующегоДня
			                        |	ИЗ
			                        |		РегистрСведений.ItobДанныеДатчиков КАК ItobДанныеДатчиков
			                        |	ГДЕ
			                        |		ItobДанныеДатчиков.Период МЕЖДУ &ПредДеньНачало И &СледДеньКонец
			                        |		И ItobДанныеДатчиков.Терминал = &Терминал
			                        |		И ItobДанныеДатчиков.Датчик = &Датчик
			                        |		И ItobДанныеДатчиков.Значение > 100) КАК ВложенныйЗапрос
			                        |ГДЕ
			                        |	ItobДанныеДатчиков.Период МЕЖДУ &ПредДеньНачало И &СледДеньКонец
			                        |	И ItobДанныеДатчиков.Терминал = &Терминал
			                        |	И ItobДанныеДатчиков.Датчик = &Датчик
			                        |	И (ItobДанныеДатчиков.Значение = ВложенныйЗапрос.МаксЗначениеПредыдущегоДня
			                        |			ИЛИ ItobДанныеДатчиков.Значение = ВложенныйЗапрос.МинЗначениеТекущегоДня
			                        |			ИЛИ ItobДанныеДатчиков.Значение = ВложенныйЗапрос.МаксЗначениеТекущегоДня
			                        |			ИЛИ ItobДанныеДатчиков.Значение = ВложенныйЗапрос.МинЗначениеСледующегоДня)
			                        |
			                        |СГРУППИРОВАТЬ ПО
			                        |	ВложенныйЗапрос.МаксЗначениеПредыдущегоДня,
			                        |	ВложенныйЗапрос.МинЗначениеТекущегоДня,
			                        |	ВложенныйЗапрос.МаксЗначениеТекущегоДня,
			                        |	ВложенныйЗапрос.МинЗначениеСледующегоДня";
									
			ВыборкаИзменения = ЗапросИзменения.Выполнить().Выбрать();
			
			Если НЕ ВыборкаИзменения.Следующий() Тогда
				Продолжить;
			КонецЕсли;
			
			ВыборкаИзменения.Следующий();
			
			Если ВыборкаИзменения.МинЗначениеТекущегоДня=0 И ВыборкаИзменения.МаксЗначениеТекущегоДня=0 Тогда
				Продолжить;
			
			КонецЕсли;
			
			Если ВыборкаИзменения.МаксЗначениеПредыдущегоДня = 0 Тогда
				НачальноеЗначение = ВыборкаИзменения.МинЗначениеТекущегоДня;
				
			Иначе
				
				НачальноеЗначение = Окр(?(ВыборкаИзменения.МинЗначениеТекущегоДня=ВыборкаИзменения.МаксЗначениеПредыдущегоДня,
					ВыборкаИзменения.МинЗначениеТекущегоДня, 
					ПолучитьПромежуточноеЗначение(ВыборкаИзменения.МаксЗначениеПредыдущегоДня,ВыборкаИзменения.МаксПериодПредыдущегоДня,
						ВыборкаИзменения.МинЗначениеТекущегоДня,ВыборкаИзменения.МинПериодТекущегоДня,
						УниверсальноеВремя(НачДата))));
			
			КонецЕсли;
			
			Если ВыборкаИзменения.МаксЗначениеТекущегоДня = 0 Тогда
				Продолжить;
				
			ИначеЕсли ВыборкаИзменения.МинЗначениеСледующегоДня = 0 Тогда
				
				КонечноеЗначение = ВыборкаИзменения.МаксЗначениеТекущегоДня;
				
			Иначе
				КонечноеЗначение = Окр(?(ВыборкаИзменения.МаксЗначениеТекущегоДня=ВыборкаИзменения.МинЗначениеСледующегоДня,
					ВыборкаИзменения.МаксЗначениеТекущегоДня, 
					ПолучитьПромежуточноеЗначение(ВыборкаИзменения.МаксЗначениеТекущегоДня,ВыборкаИзменения.МаксПериодТекущегоДня,
						ВыборкаИзменения.МинЗначениеСледующегоДня,ВыборкаИзменения.МинПериодСледующегоДня,
						УниверсальноеВремя(КонДата))));
			
			КонецЕсли;
			
			
					
			Если НЕ КалибровочныйГрафик.Пустая() Тогда
						
				НачальноеЗначение = ПреобразоватьЗначениеПоКалибровочномуГрафику(НачальноеЗначение, КалибровочныйГрафик);
				КонечноеЗначение = ПреобразоватьЗначениеПоКалибровочномуГрафику(КонечноеЗначение, КалибровочныйГрафик);				
			
			КонецЕсли;
			
			СтрокаТаблицыВыработки = ТаблицаВыработки.Добавить();
			СтрокаТаблицыВыработки.Значение = КонечноеЗначение-НачальноеЗначение;
			СтрокаТаблицыВыработки.ПараметрВыработки = Параметр.Ссылка;			
			
		Иначе
			
			Значение = 0;
			
			Если ТЗ.Количество() > 1 Тогда
				
				Если Параметр.ВидПараметра = Перечисления.ItobВидыПараметровВыработки.Пробег Тогда
					
					Значение = Окр(ПолучитьЗначениеПараметраПоПробегу(Параметр.УсловияОтбора.Выгрузить(), ТЗ)/1000,0);
					
				ИначеЕсли Параметр.ВидПараметра =  Перечисления.ItobВидыПараметровВыработки.Время Тогда
					
					Значение = ПолучитьЗначениеПараметраПоВремени(Параметр.УсловияОтбора.Выгрузить(), ТЗ);
					
				КонецЕсли;
			КонецЕсли;
			
			
			СтрокаТаблицыВыработки = ТаблицаВыработки.Добавить();
			СтрокаТаблицыВыработки.Значение = Значение;
			СтрокаТаблицыВыработки.ПараметрВыработки = Параметр.Ссылка;
			
		КонецЕсли;				
		
	КонецЦикла;
		
	Возврат ТаблицаВыработки;

КонецФункции // ПолучитьТаблицуВыработкиПоТерминалу()