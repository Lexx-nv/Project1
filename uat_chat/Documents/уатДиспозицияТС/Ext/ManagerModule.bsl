﻿
// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	уатДиспозицияТС.ТС,
	|	уатДиспозицияТС.Ссылка КАК Регистратор,
	|	уатДиспозицияТС.Местоположение,
	|	уатДиспозицияТС.Заказ,
	|	уатДиспозицияТС.Контрагент,
	|	уатДиспозицияТС.ДатаОкончания,
	|	уатДиспозицияТС.Состояние,
	|	уатДиспозицияТС.ДатаНачала КАК Период
	|ИЗ
	|	Документ.уатДиспозицияТС КАК уатДиспозицияТС
	|ГДЕ
	|	уатДиспозицияТС.Ссылка = &Ссылка";
	мЗапрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	
	ТаблицаДокумента = мЗапрос.Выполнить().Выгрузить();
	
	//управляемая блокировка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрСведений.уатСостояниеТС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ТаблицаДокумента;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ТС", "ТС");
	Блокировка.Заблокировать();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаСостоянийТС", ТаблицаДокумента);
КонецПроцедуры

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
	
КонецПроцедуры
