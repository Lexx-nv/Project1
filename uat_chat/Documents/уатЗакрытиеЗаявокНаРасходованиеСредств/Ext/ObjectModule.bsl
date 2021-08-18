﻿////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; //Переменная хранит список прав и настроек , полученный из глобальной переменной
Перем ТабЗаявки Экспорт; // Хранит результаты отбора по заявкам
Перем НП Экспорт; // Настройка периода

////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОКУМЕНТА


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


// Создает запрос для получения остатков по регистрам "ЗаявкиНаРасходованиеСредств"
// и "ДенежныеСредстваВРезерве"
//
Функция СформироватьЗапрос(Заявка="") Экспорт
	
	Запрос = Новый Запрос;
	СтруктураПараметров = Новый Структура;
	
	ТекстОтбора = "";
	
	Если Заявка = "" Тогда // Формируем запрос для заполнения ТЧ
		
		Если ОтборЦФО Тогда
			
			Если ЦФО.Пустая() Тогда
				ТекстОтбора=ТекстОтбора+"
				|И (##.ЦФО = &ЦФО)";
			Иначе
				ТекстОтбора=ТекстОтбора+"
				|И (##.ЦФО В ИЕРАРХИИ (&ЦФО))";
			КонецЕсли;
			
			СтруктураПараметров.Вставить("ЦФО",ЦФО);
			
		КонецЕсли;
				
		Если ОтборКонтрагент Тогда
			
			Если Контрагент.Пустая() Тогда
				ТекстОтбора=ТекстОтбора+"
				|И (##.Контрагент = &Контрагент)";
			Иначе
				ТекстОтбора=ТекстОтбора+"
				|И (##.Контрагент В ИЕРАРХИИ (&Контрагент))";
			КонецЕсли;
			
			СтруктураПараметров.Вставить("Контрагент",Контрагент);
			
		КонецЕсли;
				
		Если ОтборОтветственный Тогда
			
			Если Ответственный.Пустая() Тогда
				ТекстОтбора=ТекстОтбора+"
				|И (##.Ответственный = &Ответственный)";
			Иначе
				ТекстОтбора=ТекстОтбора+"
				|И (##.Ответственный В ИЕРАРХИИ (&Ответственный))";
			КонецЕсли;
			
			СтруктураПараметров.Вставить("Ответственный",ОтветственныйЗаявка);
			
		КонецЕсли;
		
		Если НЕ (ОтборДатаНач='00010101' ИЛИ ОтборДатаКон='00010101') Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаРасхода МЕЖДУ &ДатаНач И &ДатаКон)";
			
			СтруктураПараметров.Вставить("ДатаНач",НачалоДня(ОтборДатаНач));
			СтруктураПараметров.Вставить("ДатаКон",КонецДня(ОтборДатаКон));
			
		ИначеЕсли НЕ ОтборДатаНач='00010101' Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаРасхода >= &ДатаНач)";
			
			СтруктураПараметров.Вставить("ДатаНач",НачалоДня(ОтборДатаНач));
			
		ИначеЕсли НЕ ОтборДатаКон='00010101' Тогда
			
			ТекстОтбора=ТекстОтбора+"
			|И (##.ДатаРасхода <= &ДатаКон)";
			
			СтруктураПараметров.Вставить("ДатаКон",КонецДня(ОтборДатаКон));
			
		КонецЕсли;

		ТекстОтбора=Сред(ТекстОтбора,4);
		
	Иначе // Формируем запрос по конкретной заявке
		
		ТекстОтбора="##=&Заявка";
		СтруктураПараметров.Вставить("Заявка",Заявка);
		
	КонецЕсли;
	
	ТекстОтбораЗаявок = ?(ПустаяСтрока(ТекстОтбора), "", "ЗаявкаНаРасходование В (ВЫБРАТЬ Ссылка ИЗ Документ.уатЗаявкаНаРасходованиеДС ГДЕ "+ТекстОтбора+")");
	
	Запрос.Текст="ВЫБРАТЬ
	|	ЗаявкиОстаток.Заявка КАК Заявка,
	|	СУММА(ЗаявкиОстаток.СуммаЗаявкиОстаток) КАК ОстатокЗаявка,
	|	СУММА(ЗаявкиОстаток.СуммаРезерваОстаток) КАК ОстатокРезерв,
	|	СУММА(ЗаявкиОстаток.СуммаРазмещенияОстаток) КАК ОстатокРазмещение,
	|	ЗаявкиОстаток.Заявка.Ответственный КАК Ответственный,
	|	ЗаявкиОстаток.Заявка.ВалютаДокумента КАК ВалютаЗаявка,
	|	ЗаявкиОстаток.Заявка.Контрагент КАК Контрагент
	|ИЗ
	|	(ВЫБРАТЬ
	|		ЗаявкиНаРасходованиеСредствОстатки.ЗаявкаНаРасходование КАК Заявка,
	|		ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток КАК СуммаЗаявкиОстаток,
	|		ЗаявкиНаРасходованиеСредствОстатки.СуммаУпрОстаток КАК СуммаУпрЗаявкиОстаток,
	|		ЗаявкиНаРасходованиеСредствОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетовЗаявкиОстаток,
	|		0 КАК СуммаРезерваОстаток,
	|       0 КАК СуммаРазмещенияОстаток
	|	ИЗ
	|		РегистрНакопления.уатЗаявкиНаРасходованиеДС.Остатки(&МоментДокумента,"+СтрЗаменить(ТекстОтбораЗаявок,"##","Ссылка")+" ) КАК ЗаявкиНаРасходованиеСредствОстатки
	|	
	|) КАК ЗаявкиОстаток
	|
	|СГРУППИРОВАТЬ ПО
	|	ЗаявкиОстаток.Заявка";
	
	Для Каждого Параметр Из СтруктураПараметров Цикл
		
		Запрос.УстановитьПараметр(Параметр.Ключ,Параметр.Значение);
		
	КонецЦикла;
	
	Запрос.УстановитьПараметр("МоментДокумента",МоментВремени());
	
	Возврат Запрос;
	
КонецФункции // СформироватьЗапрос()

// Добавляет в табличную часть заявки, по которым есть остатки в регистрах
// "ЗаявкиНаРасходованиеСредств" и (или) в регистре "ДенежныеСредстваВРезерве"
//
Процедура ЗаполнитьЗаявкиПоОстаткам() Экспорт
	
	Запрос = СформироватьЗапрос();
	
	Выборка = Запрос.Выполнить().Выбрать();
	Пока Выборка.Следующий() Цикл
		НоваяСтрока = ЗаявкиНаРасходованиеСредств.Добавить();
		НоваяСтрока.Заявка            = Выборка.Заявка;
		НоваяСтрока.ВалютаЗаявка      = Выборка.ВалютаЗаявка;
		НоваяСтрока.ОстатокЗаявка     = Выборка.ОстатокЗаявка;
		НоваяСтрока.ОстатокРезерв     = Выборка.ОстатокРезерв;
		НоваяСтрока.ОстатокРазмещение = Выборка.ОстатокРазмещение;
		НоваяСтрока.Контрагент        = Выборка.Контрагент;
		НоваяСтрока.Ответственный     = Выборка.Ответственный;
	КонецЦикла; 
		
КонецПроцедуры // ЗаполнитьЗаявкиПоОстаткам()

// Формирует движения по регистрам
//  Отказ                     - флаг отказа в проведении,
//  Заголовок                 - строка, заголовок сообщения об ошибке проведения.
//
Процедура ДвиженияПоРегистрам(Отказ, Заголовок)
	
	Запрос = Новый Запрос;
	МенеджерВремТаблиц = Новый МенеджерВременныхТаблиц;
	Запрос.МенеджерВременныхТаблиц = МенеджерВремТаблиц;
	
	Запрос.Текст =
	"ВЫБРАТЬ 
	|	ЗаявкиКЗакрытию.Заявка КАК Заявка,
	|	ЗаявкиКЗакрытию.Заявка.ВидОперации КАК ВидОперации
	|ПОМЕСТИТЬ
	|	ЗаявкиКЗакрытию
	|ИЗ
	|	Документ.уатЗакрытиеЗаявокНаРасходованиеСредств.ЗаявкиНаРасходованиеСредств КАК ЗаявкиКЗакрытию
	|ГДЕ
	|	ЗаявкиКЗакрытию.Ссылка = &Ссылка";
	
	Запрос.УстановитьПараметр("Ссылка", Ссылка);
	Запрос.Выполнить();
	
	
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатЗаявкиНаРасходованиеДС");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	Блокировка.Заблокировать();

	Запрос.Текст =
	"ВЫБРАТЬ РАЗРЕШЕННЫЕ
	|	&Период КАК Период,
	|	&Регистратор КАК Регистратор,
	|	Значение(ВидДвиженияНакопления.Расход) КАК ВидДвижения,
	|	ЗаявкиКЗакрытию.Заявка КАК ЗаявкаНаРасходование,
	|	ЗаявкиКЗакрытию.ВидОперации КАК ВидОперации,
	|	ЗаявкиНаРасходованиеСредствОстатки.ДоговорКонтрагента КАК ДоговорКонтрагента,
	|	ЗаявкиНаРасходованиеСредствОстатки.Контрагент КАК Контрагент,
	|	ЗаявкиНаРасходованиеСредствОстатки.Организация КАК Организация,
	|	ЗаявкиНаРасходованиеСредствОстатки.Сделка КАК Сделка,
	|	ЗаявкиНаРасходованиеСредствОстатки.СтатьяДвиженияДенежныхСредств КАК СтатьяДвиженияДенежныхСредств,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаВзаиморасчетовОстаток КАК СуммаВзаиморасчетов,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаУпрОстаток КАК СуммаУпр,
	|	ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток КАК Сумма
	|ИЗ
	|	РегистрНакопления.уатЗаявкиНаРасходованиеДС.Остатки(,
	|		ЗаявкаНаРасходование В (ВЫБРАТЬ РАЗЛИЧНЫЕ Заявка ИЗ ЗаявкиКЗакрытию)) КАК ЗаявкиНаРасходованиеСредствОстатки
	|		ЛЕВОЕ СОЕДИНЕНИЕ 
	|			ЗаявкиКЗакрытию
	|		ПО ЗаявкиКЗакрытию.Заявка = ЗаявкиНаРасходованиеСредствОстатки.ЗаявкаНаРасходование
	|ГДЕ
	|	НЕ (ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток ЕСТЬ NULL
	|			ИЛИ (ЗаявкиНаРасходованиеСредствОстатки.СуммаОстаток = 0
	|				И ЗаявкиНаРасходованиеСредствОстатки.СуммаВзаиморасчетовОстаток = 0
	|				И ЗаявкиНаРасходованиеСредствОстатки.СуммаУпрОстаток = 0)) ";
	Запрос.УстановитьПараметр("Период",Дата);
	Запрос.УстановитьПараметр("Регистратор",Ссылка);
		
	ТаблицаДвижений = Запрос.Выполнить().Выгрузить();
	Движения.уатЗаявкиНаРасходованиеДС.Загрузить(ТаблицаДвижений);
	Движения.уатЗаявкиНаРасходованиеДС.Записывать = Истина;
		
КонецПроцедуры // ДвиженияПоРегистрам()

//////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ

Процедура ОбработкаПроведения(Отказ, Режим)

	// Заголовок для сообщений об ошибках проведения.
	Заголовок = ОбщегоНазначения.ПредставлениеДокументаПриПроведении(Ссылка);
	ДвиженияПоРегистрам(Отказ, Заголовок);
	
КонецПроцедуры // ОбработкаПроведения()

Процедура ПередЗаписью(Отказ, РежимЗаписи, РежимПроведения)
	Если ОбменДанными.Загрузка  Тогда
		Возврат;
	КонецЕсли;
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВДокументах(ЭтотОбъект, Отказ, , Права);
	
КонецПроцедуры // ПередЗаписью

#Если Клиент Тогда
НП = Новый НастройкаПериода;
#КонецЕсли

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли

