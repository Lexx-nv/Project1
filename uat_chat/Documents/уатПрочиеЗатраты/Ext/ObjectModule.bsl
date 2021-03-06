////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения.
Перем ТаблицаПоЗатратам;


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


// Процедура движений по регистру затрат
//
Процедура ФормированиеДвижений(Отказ, Заголовок, РежимПроведения)
	// Регистр затрат
	НаборЗаписейЗатраты							= Движения.уатЗатратыТС;
	НаборЗаписейЗатраты.ДокументОбъект			= ЭтотОбъект;
	Отказ										= НЕ НаборЗаписейЗатраты.ДобавитьДвижение() ИЛИ Отказ;
КонецПроцедуры // ФормированиеДвиженийУпр()


////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ПриКопировании(ОбъектКопирования)
	Дата = ТекущаяДата();
	БазовыйДокумент = Неопределено;
КонецПроцедуры

Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	ФормированиеДвижений(Отказ, Заголовок, РежимПроведения);
КонецПроцедуры

Процедура ПередЗаписью(Отказ,РежимЗаписи , РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВДокументах(ЭтотОбъект, Отказ, , Права);
КонецПроцедуры // ПередЗаписью

Процедура ОбработкаПроверкиЗаполнения(Отказ, ПроверяемыеРеквизиты)
	// Заголовок для сообщений об ошибках проведения.
	Заголовок = уатОбщегоНазначенияТиповые.уатПредставлениеДокументаПриПроведении(ЭтотОбъект);
	
	Если НЕ уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ВестиУчетЗатрат) Тогда
		ТекстСОобщения = "Для организации """ + Организация + """ учет затрат не ведется!";
		ОбщегоНазначения.СообщитьОбОшибке(ТекстСообщения,Отказ,Заголовок);	
		Возврат;
	КонецЕсли;
	
	СтруктураПолей = Новый Структура("Организация,Подразделение, ТС");
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеШапкиДокумента(ЭтотОбъект,СтруктураПолей, Отказ, Заголовок);
	
	СтруктураПолей = Новый Структура("СтатьяЗатрат, СчетЗатрат, Сумма");
	уатОбщегоНазначенияТиповые.уатПроверитьЗаполнениеТабличнойЧасти(ЭтотОбъект, "Затраты", СтруктураПолей, Отказ, Заголовок);
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли