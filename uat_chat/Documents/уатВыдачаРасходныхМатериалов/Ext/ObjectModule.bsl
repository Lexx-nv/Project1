////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения.
Перем мВалютаРегламентированногоУчета Экспорт; // Переменная хранит значение валюты регламентированного учёта,
//полученное из константы.


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА

#Если Клиент Тогда
	
// Возвращает доступные варианты печати документа
//
// Возвращаемое значение:
//  Структура, каждая строка которой соответствует одному из вариантов печати
//  
//Функция ПолучитьСписокПечатныхФорм() Экспорт
Функция ПолучитьСтруктуруПечатныхФорм() Экспорт
	
	СтруктураМакетов = Новый Структура;
	
	СтруктураМакетов.Вставить("РаздаточнаяВедомостьНаТС", "Раздаточная ведомость на ТС");
	
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
//
Процедура Печать(НазваниеМакета = "", КоличествоЭкземпляров = 1, НаПринтер = Ложь) Экспорт
	
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
		
		Если НазваниеМакета = "РаздаточнаяВедомостьНаТС" Тогда
			
			ТабДокумент = ПечатьРаздаточнаяВедомостьНаТС();
			уатОбщегоНазначенияТиповые.уатНапечататьДокумент(ТабДокумент, КоличествоЭкземпляров, НаПринтер, уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ЭтотОбъект, ЭтотОбъект.Метаданные().Представление()), Права);
			
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры // Печать

// Процедура осуществляет печать формы "РаздаточнаяВедомостьНаТС"
//
Функция ПечатьРаздаточнаяВедомостьНаТС() Экспорт
	
	ТабДокумент = Новый ТабличныйДокумент;
	ТабДокумент.ИмяПараметровПечати = "ПАРАМЕТРЫ_ПЕЧАТИ_ВыдачаРасходныхМатериалов";
	Макет = ПолучитьМакет("РаздаточнаяВедомостьНаТС");
	
	ОбластьМакета = Макет.ПолучитьОбласть("Заголовок");
	ОбластьМакета.Параметры.ТекстЗаголовка = уатОбщегоНазначенияТиповые.уатСформироватьЗаголовокДокумента(ЭтотОбъект, "Выдача расходных материалов");
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Поставщик");
	ОбластьМакета.Параметры.Склад = Склад;
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("ШапкаТаблицы");
	ОбластьСтроки = Макет.ПолучитьОбласть("Строка");
	
	ТабДокумент.Вывести(ОбластьМакета);
	
	Движения.уатПартииТоваровНаСкладах.Прочитать();
	ТабДвижений = Движения.уатПартииТоваровНаСкладах.Выгрузить();
	
	НомерСтроки = 0;
	Для Каждого СтрокаТабличнойЧасти Из Материалы Цикл	
		
		НомерСтроки = НомерСтроки + 1;
		
		ОбластьСтроки.Параметры.Заполнить(СтрокаТабличнойЧасти);
		ОбластьСтроки.Параметры.ТСПредставление = уатОбщегоНазначения.уатПредставлениеТС(СтрокаТабличнойЧасти.ТС, Организация);
		
		ОбластьСтроки.Параметры.Сумма = СтрокаТабличнойЧасти.Сумма;
		
		ТабДокумент.Вывести(ОбластьСтроки);
		
	КонецЦикла;
	
	ОбластьМакета = Макет.ПолучитьОбласть("Итого");
	ОбластьМакета.Параметры.Всего = уатОбщегоНазначенияТиповые.уатФорматСумм(Материалы.Итог("Сумма"));
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("СуммаПрописью");
	ОбластьМакета.Параметры.ИтоговаяСтрока = "Всего выдано материалов " + НомерСтроки
		+ ", на сумму " + уатОбщегоНазначенияТиповые.уатФорматСумм(Материалы.Итог("Сумма"), мВалютаРегламентированногоУчета);
	ОбластьМакета.Параметры.СуммаПрописью  = уатОбщегоНазначенияТиповые.уатСформироватьСуммуПрописью(Материалы.Итог("Сумма"), мВалютаРегламентированногоУчета);
	ТабДокумент.Вывести(ОбластьМакета);
	
	ОбластьМакета = Макет.ПолучитьОбласть("Подписи");
	ОбластьМакета.Параметры.Заполнить(ЭтотОбъект);
	ТабДокумент.Вывести(ОбластьМакета);
	
	Возврат ТабДокумент;
	
КонецФункции //ПечатьРаздаточнаяВедомостьНаТС()

#КонецЕсли

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаЗаполнения(Основание)
	Если ТипЗнч(Основание) = Тип("ДокументСсылка.уатЗаявкаНаРемонт") Тогда
		Дата = ТекущаяДата();
		Организация       = Основание.Организация;
		ТС                = Основание.ТС;
		БазовыйДокумент   = Неопределено;
		ПричинаОбращения  = Основание.ПричинаОбращения;
		ВидОбслуживания	  = Основание.ВидОбслуживания;
		ДатаНачала		  = Основание.ДатаНачала;
		ДатаОкончания	  = Основание.ДатаОкончания;
		ДокументОснование = Основание;
		
		Для Каждого ТекСтрока из Основание.Материалы Цикл
			НоваяСтрока = Материалы.Добавить();
			НоваяСтрока.Номенклатура	 = ТекСтрока.Номенклатура;
			НоваяСтрока.Количество 		 = ТекСтрока.Количество;
			НоваяСтрока.ЕдиницаИзмерения = ТекСтрока.ЕдиницаИзмерения;
		КонецЦикла;
	КонецЕсли;	
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	Документы.уатВыдачаРасходныхМатериалов.ИнициализироватьДанныеДокумента(Ссылка, ДополнительныеСвойства);
	
	Для каждого ТекСтрока ИЗ ДополнительныеСвойства.ТаблицыДляДвижений.ТаблицаДокумента  Цикл
		Материалы[ТекСтрока.НомерСтроки - 1].Сумма = ТекСтрока.Стоимость;	
	КонецЦикла;
	Записать(РежимЗаписиДокумента.Запись);
	
	// Подготовка наборов записей.
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	уатПроведение.ОтразитьНоменклатуруТС(ДополнительныеСвойства, Движения, Отказ);
	уатПроведение.ОтразитьПартииТоваровНаСкладах(ДополнительныеСвойства, Движения, Отказ);
	
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);
	
	Документы.уатВыдачаРасходныхМатериалов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ);

КонецПроцедуры

// Процедура вызывается перед записью документа 
//
Процедура ПередЗаписью(Отказ,РежимЗаписи , РежимПроведения)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВДокументах(ЭтотОбъект, Отказ, , Права);
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаУдаленияПроведения(Отказ)
	
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.уатВыдачаРасходныхМатериалов.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);

КонецПроцедуры

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	уатОбщегоНазначенияТиповые.ПроверитьЧтоНетУслуг(ЭтотОбъект,"Материалы",,Отказ,Заголовок);	

КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли


мВалютаРегламентированногоУчета = Константы.ВалютаРегламентированногоУчета.Получить();