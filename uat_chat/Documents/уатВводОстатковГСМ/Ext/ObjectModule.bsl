﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения.


#Если Клиент Тогда
	
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
		
	КонецЕсли;		
КонецПроцедуры

#КонецЕсли


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)
	Тбл = Топливо.Выгрузить();
	Тбл.Колонки.Добавить("Период");
	Тбл.Колонки.Добавить("ВидДвижения");
	Тбл.ЗаполнитьЗначения(ВидДвиженияНакопления.Приход,"ВидДвижения");
	Тбл.ЗаполнитьЗначения(Дата,"Период");
	
	Рег = Движения.уатОстаткиГСМнаТС;
	Рег.Загрузить(Тбл);
	Рег.Записать();
	
КонецПроцедуры

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	уатОбщегоНазначения.уатДокументПередЗаписью(ЭтотОбъект, Отказ, Права, РежимЗаписи, РежимПроведения);
	
	Если глОбщий.ЕстьРасходГСМзаМесяц(Дата) ТОгда
		Отказ = Истина;
		ВозвраТ;
	КонецЕСЛИ;
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если (НЕ Отказ) Тогда
		// Заголовок для сообщений об ошибках проведения.
		Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
		СтруктураПолей = Новый Структура("Организация");
		уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект, СтруктураПолей, Отказ, Заголовок);
		
		СтруктураПолей = Новый Структура("ТС, ГСМ, Количество");
		уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Топливо", СтруктураПолей, Отказ, Заголовок);
		
		//проверка по наличию бака в ТС
		Если Не Отказ Тогда
			Для Каждого СтрокаТаблицы Из Топливо Цикл
				ТекМодельТС = уатОбщегоНазначения.уатПрочитатьРеквизитыТС(СтрокаТаблицы.ТС, "Модель").Модель;
				//Если НЕ ТекМодельТС.НаличиеТопливногоБака Тогда
				//	ОбщегоНазначения.СообщитьОбОшибке("В строке номер """ + СтрокаТаблицы.НомерСтроки + """ табличной части ""Топливо"": указано ТС / Оборудование, у которого отсутствует топливный бак!", Отказ, Заголовок);
				//КонецЕсли;
			КонецЦикла;
		КонецЕсли;
	КонецЕсли;
КонецПроцедуры

Процедура ОбработкаУдаленияПроведения(Отказ)
	// Инициализация дополнительных свойств для проведения документа
	уатПроведение.ИнициализироватьДополнительныеСвойстваДляПроведения(Ссылка, ДополнительныеСвойства);
	
	// Подготовка наборов записей
	уатПроведение.ПодготовитьНаборыЗаписейКРегистрацииДвижений(ЭтотОбъект);
	
	// Запись наборов записей
	уатПроведение.ЗаписатьНаборыЗаписей(ЭтотОбъект);

	// Контроль
	Документы.уатВводОстатковГСМ.ВыполнитьКонтроль(Ссылка, ДополнительныеСвойства, Отказ, Истина);
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли

