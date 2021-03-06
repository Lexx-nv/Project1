// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	СформироватьТаблицуТС(ДокументСсылка, СтруктураДополнительныеСвойства);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Формирует таблицу значений, содержащую данные для проведения по регистру.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура СформироватьТаблицуТС(ДокументСсылка, СтруктураДополнительныеСвойства)
	тблПрейскурантыТС = Новый ТаблицаЗначений;
	тблПрейскурантыТС.Колонки.Добавить("Регистратор");
	тблПрейскурантыТС.Колонки.Добавить("Период");
	тблПрейскурантыТС.Колонки.Добавить("Прейскурант");
	тблПрейскурантыТС.Колонки.Добавить("ДатаНачала");
	тблПрейскурантыТС.Колонки.Добавить("ДатаОкончания");
	
	Для Каждого ТекСтрокаПрейскурант Из ДокументСсылка.Прейскуранты Цикл
		НоваяСтрока = тблПрейскурантыТС.Добавить();
		НоваяСтрока.Период = ДокументСсылка.Дата;
		НоваяСтрока.Регистратор = ДокументСсылка;
		НоваяСтрока.Прейскурант = ТекСтрокаПрейскурант.Прейскурант;
		НоваяСтрока.ДатаНачала = ТекСтрокаПрейскурант.ДатаНачала;
		НоваяСтрока.ДатаОкончания = ТекСтрокаПрейскурант.ДатаОкончания;
	КонецЦикла;
	
	//управляемая блокировка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.уатПрейскурантыТС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = тблПрейскурантыТС;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Прейскурант", "Прейскурант");
	Блокировка.Заблокировать();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаПрейскурантыТС", тблПрейскурантыТС);
КонецПроцедуры // СформироватьТаблицуАгрегатыТС()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	//Зарезервировано
КонецПроцедуры
