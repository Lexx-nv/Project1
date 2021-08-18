﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения.


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

// Процедура перезаполняет таблицу Разнарядки
Процедура ЗаполнитьТаблицы() Экспорт
	Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(Организация) Тогда
		Сообщить("Не указана организация!");
		Возврат;
	КонецЕсли;
	
	#Если Клиент Тогда
		Если Разнарядка.Количество() > 0 Тогда
			Ответ = Вопрос("Перед заполнением табличная часть будет очищена! Продолжить?", РежимДиалогаВопрос.ДаНет);
			Если Ответ = КодВозвратаДиалога.Нет Тогда
				Возврат;
			КонецЕсли;
		КонецЕсли;
	#КонецЕсли
	
	Разнарядка.Очистить();
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	уатТС.Модель,
	|	уатТС.ГаражныйНомер КАК ГарНомер,
	|	уатТС.ГосударственныйНомер КАК ГосНомер,
	|	уатТС.Гараж,
	|	уатТС.Ссылка КАК ТС,
	|	уатМестонахождениеТССрезПоследних.Организация КАК Организация,
	|	уатМестонахождениеТССрезПоследних.Колонна КАК Колонна,
	|	уатТС.ОсновнойРежимРаботы КАК РежимРаботыТС
	|ИЗ
	|	Справочник.уатТС КАК уатТС
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаНач, ) КАК уатМестонахождениеТССрезПоследних
	|		ПО уатТС.Ссылка = уатМестонахождениеТССрезПоследних.ТС
	|ГДЕ
	|	уатМестонахождениеТССрезПоследних.Организация = &Организация
	|	И уатТС.Модель.ВидМоделиТС = ЗНАЧЕНИЕ(Перечисление.уатВидыМоделейТС.Автотранспорт)
	|	И (уатТС.ТипТС = &ПустойТипТС
	|			ИЛИ (НЕ уатТС.ТипТС.ВидТС В (&СписокПрицепов)))
	|	И (уатТС.ДатаВыбытия = &ПустаяДата
	|			ИЛИ уатТС.ДатаВыбытия > &ДатаДокумента)";
	
	Если Не Колонна.Пустая() Тогда
		Запрос.Текст = Запрос.Текст + "
		|	И уатМестонахождениеТССрезПоследних.Колонна В Иерархии (&Колонна)";
		Запрос.УстановитьПараметр("Колонна", Колонна);
	КонецЕсли;				   
	
	Запрос.УстановитьПараметр("ПустойТипТС", Справочники.уатТипыТС.ПустаяСсылка());
	Запрос.УстановитьПараметр("СписокПрицепов", уатОбщегоНазначения.уатСписокВидовТСПрицепов());
	Запрос.УстановитьПараметр("Организация", Организация);
	Запрос.УстановитьПараметр("ДатаНач", НачалоДня(Дата));
	Запрос.УстановитьПараметр("ДатаКон", КонецДня(Дата));
	Запрос.УстановитьПараметр("ДатаДокумента", Дата);
	Запрос.УстановитьПараметр("ПустаяДата", '00010101');
	
	тблРазнарядка = Разнарядка.Выгрузить();
	тблРазнарядка.Колонки.Добавить("ГарНомер");
	тблРазнарядка.Колонки.Добавить("ГосНомер");
	Для Каждого ТекСтрока Из Запрос.Выполнить().Выгрузить() Цикл
		НоваяСтрока = тблРазнарядка.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяСтрока, ТекСтрока);
	КонецЦикла;
	
	Для каждого ТекСтрока из тблРазнарядка Цикл
		// Заполняем прицепы по умолчанию
		тСч = 0;
		СоставТС = уатОбщегоНазначения.уатСоставТС(ТекСтрока.ТС);
		Для Каждого тСтрока из СоставТС Цикл
			тСч = тСч + 1;
			Если тСч = 1 Тогда 
				ТекСтрока.Прицеп1 = тСтрока.ТС;
			ИначеЕсли тСч = 2 Тогда
				ТекСтрока.Прицеп2 = тСтрока.ТС;
			Иначе	
				Прервать; 
			КонецЕсли;
		КонецЦикла;	
		
		Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(ТекСтрока.РежимРаботыТС) Тогда
			#Если Клиент Тогда
				ТекСтрока.ДатаВыезда = НачалоДня(Дата) + (уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВремяВыездаПЛ) - '00010101');
				ТекСтрока.ДатаВозвращения = НачалоДня(Дата) + (уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВремяВозращенияПЛ) - '00010101');
			#КонецЕсли
		Иначе	
			ТекСтрока.ДатаВыезда = НачалоДня(Дата) + (ТекСтрока.РежимРаботыТС.НачалоРаботы - НачалоДня(ТекСтрока.РежимРаботыТС.НачалоРаботы));
			ТекСтрока.ДатаВозвращения = НачалоДня(Дата) + (ТекСтрока.РежимРаботыТС.КонецРаботы - НачалоДня(ТекСтрока.РежимРаботыТС.КонецРаботы));
		КонецЕсли;	
		Если ТекСтрока.ДатаВозвращения <= ТекСтрока.ДатаВыезда Тогда
			ТекСтрока.ДатаВозвращения = НачалоДня(Дата) + 86400 + (ТекСтрока.ДатаВозвращения - НачалоДня(ТекСтрока.ДатаВозвращения));
		КонецЕсли;	
		
		//заполняем водителей
		#Если Клиент Тогда
			СтруктураЭкипаж = уатЗащищенныеФункции.уатЭкипажТСсУчетомГрафика(ТекСтрока.ТС, ТекСтрока.ДатаВыезда, Организация);
			ТекСтрока.Водитель = СтруктураЭкипаж.Водитель;
			ТекСтрока.Водитель2 = СтруктураЭкипаж.Водитель2;
			ТекСтрока.Кондуктор = СтруктураЭкипаж.Сотрудник;
			ТекСтрока.Кондуктор2 = СтруктураЭкипаж.Сотрудник2;
		#КонецЕсли
	КонецЦикла;
	
	Если уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ПредставлениеТСКакГосНомер) = Истина Тогда
		тблРазнарядка.Сортировать("ДатаВыезда, ГосНомер");
	Иначе
		тблРазнарядка.Сортировать("ДатаВыезда, ГарНомер");
	КонецЕсли;
	
	Разнарядка.Загрузить(тблРазнарядка);
КонецПроцедуры

#Если Клиент Тогда
	
	// Возвращает доступные варианты печати документа
	//
	// Возвращаемое значение:
	//  Структура, каждая строка которой соответствует одному из вариантов печати
	//  
	//Функция ПолучитьСписокПечатныхФорм() Экспорт
	Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
		
		СтруктураМакетов = Новый Структура;
		
		СтруктураМакетов.Вставить("Разнарядка", "Разнарядка");	
		
		Возврат СтруктураМакетов ;
		
	КонецФункции // ПолучитьСтруктуруПечатныхФорм()
	
	// Процедура осуществляет печать документа. Можно направить печать на 
	// экран или принтер, а также распечатать необходимое количество копий.
	//
	//  Название макета печати передается в качестве параметра,
	// по переданному названию находим имя макета в соответствии.
	//
	// Параметры:
	//  НазваниеМакета - строка, название макета.
	//  ФлагПечати: 0 - весь п/л, 1 - лиц. сторона, 2 - обр. сторона
	//
	Процедура Печать(НазваниеМакета = "", КоличествоЭкземпляров = 1, НаПринтер = Ложь, ФлагПечати = 0) ЭКСПОРТ
		
		Если ЭтоНовый() Тогда
			Предупреждение("Документ можно распечатать только после его записи");
			Возврат;
		ИначеЕсли Не ?(Права = Неопределено, Ложь, уатПраваИНастройки.уатПраво("ПечатьНепроведенных", Права)) Тогда
			Предупреждение("Недостаточно полномочий для печати непроведенного документа!");
			Возврат;
		КонецЕсли;
		
		Если Не уатОбщегоНазначенияТиповые.ПроверитьМодифицированность(ЭтотОбъект) Тогда
			Возврат;
		КонецЕсли;
		
		
		Если ТипЗнч(НазваниеМакета) = Тип("СправочникСсылка.ВнешниеОбработки") Тогда
			ИмяФайла = КаталогВременныхФайлов()+"PrnForm.tmp";
			ОбъектВнешнейФормы = НазваниеМакета.ПолучитьОбъект();
			Если ОбъектВнешнейФормы = Неопределено Тогда
				Сообщить("Ошибка получения внешней формы документа. Возможно форма была удалена", СтатусСообщения.Важное);
				Возврат;
			КонецЕсли;			
			ДвоичныеДанные = ОбъектВнешнейФормы.ХранилищеВнешнейОбработки.Получить();
			ДвоичныеДанные.Записать(ИмяФайла);
			Обработка = ВнешниеОбработки.Создать(ИмяФайла);
			Попытка
				Обработка.СсылкаНаОбъект = Ссылка;
				ТабДокумент = Обработка.Печать();
				уатОбщегоНазначенияТиповые.уатНапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Права);
			Исключение
				Сообщить("Ошибка формата внешней обработки. Возможно выбрана обработка не для печати.", СтатусСообщения.Важное);
			КонецПопытки;
		Иначе
			Если НазваниеМакета = "Разнарядка" Тогда
				ТабДокумент = ПечатьРазнарядка();	
				уатОбщегоНазначенияТиповые.уатНапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Права);
			КонецЕсли;
		КонецЕсли;    		
		
	КонецПроцедуры // Печать()
	
	Функция ПечатьРазнарядка()
		ТабДок = Новый ТабличныйДокумент;
		ТабДок.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_Разнарядка_Разнарядка";
		
		Макет = Документы.уатРазнарядка.ПолучитьМакет("Печать");
		
		ТабДок.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
		
		ТабДок.ПолеСверху 	= 0;
		ТабДок.ПолеСлева 	= 0;
		ТабДок.ПолеСнизу 	= 0;
		ТабДок.ПолеСправа 	= 0;
		
		// Заголовок
		Область = Макет.ПолучитьОбласть("Заголовок");
		Область.Параметры.Заголовок = "Разнарядка на выпуск ТС №" + Строка(Номер) + " от " + Формат(Дата, "ДЛФ=Д") + " г.";
		Область.Параметры.Организация = Организация;
		Область.Параметры.Колонна = Колонна;
		
		ТабДок.Вывести(Область);
		// Шапка
		Область = Макет.ПолучитьОбласть("Шапка");
		ТабДок.Вывести(Область);
		
		Запрос = Новый Запрос;
		Запрос.Текст = "ВЫБРАТЬ
		|	уатРазнарядкаРазнарядка.НомерСтроки,
		|	уатРазнарядкаРазнарядка.Водитель,
		|	уатРазнарядкаРазнарядка.Водитель2,
		|	уатРазнарядкаРазнарядка.ДатаВыезда,
		|	уатРазнарядкаРазнарядка.ДатаВозвращения,
		|	уатРазнарядкаРазнарядка.Контрагент,
		|	уатРазнарядкаРазнарядка.АдресПрибытия,
		|	уатРазнарядкаРазнарядка.ВремяПрибытия,
		|	уатРазнарядкаРазнарядка.Подразделение,
		|	уатРазнарядкаРазнарядка.ТС.ГаражныйНомер КАК ГаражныйНомер,
		|	уатРазнарядкаРазнарядка.ТС.ГосударственныйНомер КАК ГосударственныйНомер,
		|	уатРазнарядкаРазнарядка.ТС.Модель.Представление КАК Модель
		|ИЗ
		|	Документ.уатРазнарядка.Разнарядка КАК уатРазнарядкаРазнарядка
		|ГДЕ
		|	уатРазнарядкаРазнарядка.Ссылка = &ссылка";
		Запрос.УстановитьПараметр("ссылка", ЭтотОбъект.Ссылка);
		//Запрос.Выполнить().Выгрузить().ВыбратьСтроку();
		
		Выборка = Запрос.Выполнить().Выбрать();
		Пока Выборка.Следующий() Цикл
			// Разнарядка
			Область = Макет.ПолучитьОбласть("Строка");
			Область.Параметры.ГаражныйНомер = Выборка.ГаражныйНомер;
			Область.Параметры.ГосНомер = Выборка.ГосударственныйНомер;
			Область.Параметры.Модель = Выборка.Модель;
			Область.Параметры.Водитель = уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(Выборка.Водитель) + ?(уатОбщегоНазначения.уатЗначениеНеЗаполнено(Выборка.Водитель2),"", ", " + уатОбщегоНазначенияТиповые.уатФамилияИнициалыФизЛица(Выборка.Водитель2));
			Область.Параметры.ДатаВыезда = Формат(Выборка.ДатаВыезда, "ДФ=ЧЧ:мм");
			Область.Параметры.ДатаВозвращения = Формат(Выборка.ДатаВозвращения, "ДЛФ=Д");
			Область.Параметры.ВремяВозвращения = Формат(Выборка.ДатаВозвращения, "ДФ=ЧЧ:мм");
			Область.Параметры.Контрагент = Выборка.Контрагент;
			Область.Параметры.Подразделение = Выборка.Подразделение;
			Область.Параметры.АдресПрибытия = Выборка.АдресПрибытия;
			Область.Параметры.ВремяПрибытия = Формат(Выборка.ВремяПрибытия, "ДФ=ЧЧ:мм");
			ТабДок.Вывести(Область);
		КонецЦикла;
		ТабДок.ОтображатьСетку = Ложь;
		ТабДок.Защита = Ложь;
		ТабДок.ТолькоПросмотр = Ложь;
		ТабДок.ОтображатьЗаголовки = Ложь;
		Возврат ТабДок;
	КонецФункции
	
#КонецЕсли


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПередЗаписью(Отказ,РежимЗаписи , РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВДокументах(ЭтотОбъект, Отказ, , Права);	
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроведения(Отказ, Режим)
	
	// Инициализация дополнительных свойств для проведения документа.
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Инициализация данных документа.
	Документы.уатРазнарядка.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Отражение в разделах учета.
	уатПроведение.ОтразитьСостояниеТС(ДополнительныеСвойства, Движения, Отказ);
	
	// Запись наборов записей.
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль возникновения отрицательного остатка.
	Документы.уатРазнарядка.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);
	
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	// Контроль
	Документы.уатРазнарядка.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
	
	
КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	//проверка ТС на признак автотранспорта
	Для Каждого ТекСтрока Из Разнарядка Цикл
		Если НЕ ТекСтрока.ТС.ВидМоделиТС = Перечисления.уатВидыМоделейТС.Автотранспорт Тогда
			ТекстСообщения = "В строке №" + ТекСтрока.НомерСтроки + " ТС не является автотранспортом (выбрано оборудование)!";
			ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);
		КонецЕсли;
	КонецЦикла;
	
	//проверка на пересечения занятости (состояния) ТС по времени
	Для Каждого ТекСтрока Из Разнарядка Цикл
		Для Каждого ТекСтрокаВлож Из Разнарядка Цикл
			Если Разнарядка.Индекс(ТекСтрокаВлож) <= Разнарядка.Индекс(ТекСтрока) ИЛИ ТекСтрока.ТС <> ТекСтрокаВлож.ТС Тогда
				Продолжить;
			КонецЕсли;
			
			Если ТекСтрока.ДатаВыезда <= ТекСтрокаВлож.ДатаВозвращения И ТекСтрока.ДатаВозвращения >= ТекСтрокаВлож.ДатаВыезда Тогда
				ТекстСообщения = "В строках №" + ТекСтрока.НомерСтроки + " и " + ТекСтрокаВлож.НомерСтроки + " обнаружено пересечение периодов занятости (состояние ТС) одного и того же ТС!";
				ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения, Отказ, Заголовок);
				Прервать;
			КонецЕсли;
		КонецЦикла;
	КонецЦикла;
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли