////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

// Обработчик события ПриСозданииНаСервере.
// Выполняет установки параметров функциональных опций формы - требуется
// для формирования командного интерфейса формы.
//
Процедура ПриСозданииНаСервере(Форма) Экспорт
	
	Если ПустаяСтрока(ПользователиИнформационнойБазы.ТекущийПользователь().Имя)
		ИЛИ РольДоступна(Метаданные.Роли.ПолныеПрава)
		ИЛИ РольДоступна(Метаданные.Роли.ИспользованиеДополнительныхОтчетовИОбработок)
		ИЛИ РольДоступна(Метаданные.Роли.ДобавлениеИзменениеДополнительныхОтчетовИОбработок) Тогда
		
		ИмяФормыМассив = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(Форма.ИмяФормы, ".");
		ПолноеИмяОбъектаМетаданных = ИмяФормыМассив[0] + "." + ИмяФормыМассив[1];
		
		Если	ЭтоФормаОбъекта(ПолноеИмяОбъектаМетаданных, Форма.ИмяФормы) Тогда
			Форма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("ТипФормыСДополнительнымиОтчетамиИОбработками", "ФормаОбъекта"));
		Иначе
			Форма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("ТипФормыСДополнительнымиОтчетамиИОбработками", "ФормаСписка"));
		КонецЕсли;
		
		Форма.УстановитьПараметрыФункциональныхОпцийФормы(Новый Структура("ТипОбъектаКонфигурации", ПолноеИмяОбъектаМетаданных));
		
	КонецЕсли;
	
КонецПроцедуры

// Функция формирования печатной формы по внешнему источнику.
// ИсточникДанных - СправочникСсылка.ДополнительныеОтчетыИОбработки - ссылка на внешнюю обработку
// ПараметрыИсточника - Структура с ключами:
//		БезопасныйРежим - булево - используется ли безопасный режим
//		ИдентификаторКоманды - строка- список макетов, перечисленных через запятую
//		ОбъектыНазначения - массив - массив ссылок на объекты назначения
//
// параметры, заполняемые в функции (описание см. в модуле УправлениеПечатьюПереопределяемый)
// КоллекцияПечатныхФорм
// ОбъектыПечати
// ПараметрыВывода
//
Процедура ПечатьПоВнешнемуИсточнику(ИсточникДанных,
								ПараметрыИсточника,
								КоллекцияПечатныхФорм,
								ОбъектыПечати,
								ПараметрыВывода) Экспорт
	
	КоллекцияПечатныхФорм = УправлениеПечатью.ПодготовитьКоллекциюПечатныхФорм(ПараметрыИсточника.ИдентификаторКоманды);
	
	ПараметрыВывода = УправлениеПечатью.ПодготовитьСтруктуруПараметровВывода();
	
	ОбъектыПечати = Новый СписокЗначений;
	
	ВнешняяОбработкаОбъект = ПолучитьОбъектВнешнейОбработки(ИсточникДанных, ПараметрыИсточника.БезопасныйРежим);
	
	ВнешняяОбработкаОбъект.Печать(
					ПараметрыИсточника.ОбъектыНазначения,
					КоллекцияПечатныхФорм, ОбъектыПечати, ПараметрыВывода);
	
	// Проверим, все ли макеты были сформированы
	Для Каждого Стр Из КоллекцияПечатныхФорм Цикл
		Если Стр.ТабличныйДокумент = Неопределено Тогда
			ТекстСообщенияОбОшибке = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
										НСтр("ru = 'В обработчике печати не был сформирован табличный документ для: %1'"),
										Стр.ИмяМакета);
			ВызватьИсключение(ТекстСообщенияОбОшибке);
		КонецЕсли;
		
		Стр.ТабличныйДокумент.КоличествоЭкземпляров = Стр.Экземпляров;
	КонецЦикла;

КонецПроцедуры

// Проверяет, является ли переданное имя формы основной формой объекта метаданных,
// полное имя которого передается в параметре ПолноеИмяОбъектаМетаданных
// Параметры
//  ПолноеИмяОбъектаМетаданных - строка - полное имя объекта метаданных
//  ИмяФормы - полное имя формы
// Возвращаемое значение
//  Истина, если форма является основной формой объекта метаданных, иначе Ложь
//
Функция ЭтоФормаОбъекта(ПолноеИмяОбъектаМетаданных, ИмяФормы) Экспорт
	
	ОбъектМетаданных = Метаданные.НайтиПоПолномуИмени(ПолноеИмяОбъектаМетаданных);
	
	Если ОбъектМетаданных.ОсновнаяФормаОбъекта.ПолноеИмя() = ИмяФормы Тогда
		Возврат Истина;
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Обработчик экземпляра регламентного задания ЗапускОбработок.
// Запускает обработчик глобальной обработки по регламентному заданию,
// с указанным идентификатором команды.
//
// Параметры
// ВнешняяОбработка		- СправочникСсылка.ДополнительныеОтчетыИОбработки
// ИдентификаторКоманды - Строка - идентификатор выполняемой команды
//
Процедура ВыполнитьОбработкуПоРегламентномуЗаданию(ВнешняяОбработка, ИдентификаторКоманды) Экспорт
	
	НачалоВыполненияОбработки(ВнешняяОбработка, ИдентификаторКоманды);
	
	ВыполнитьОбработкуНепосредственно(ВнешняяОбработка, ИдентификаторКоманды, ВнешняяОбработка.БезопасныйРежим);
	
	ОкончаниеРаботыОбработки(ВнешняяОбработка, ИдентификаторКоманды);
	
КонецПроцедуры

// Функция возвращает таблицу значений со списком объектов метаданных,
// к которым может быть применена обработка переданного вида.
// Список объектов метаданных берется из общий команд, соответствующих
// виду обработки. Для глобальных обработок возвращается пустой набор.
// Параметры
// Вид - Перечисление.ВидыДополнительныхОтчетовИОбработок - вид внешней обработки
// Возвращаемое значение
// ТаблицаЗначений с колонками
//		ПолноеИмяОбъектаМетаданных - строка - полное имя объекта метаданных, например "Справочник.Валюты"
//		Класс	  - строка - класс метаданных, например "Справочник"
//		Объект	  - строка - имя объекта метаданных, например "Валюты"
//
Функция ПолучитьПолноеНазначениеПоВидуДополнительнойВнешнейОбработки(Вид) Экспорт
	
	Назначение = Новый ТаблицаЗначений;
	Назначение.Колонки.Добавить("ПолноеИмяОбъектаМетаданных");
	Назначение.Колонки.Добавить("Класс");
	Назначение.Колонки.Добавить("Объект");
	
	Команда = Неопределено;
	
	Если		Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта Тогда
		Команда = Метаданные.ОбщиеКоманды.ДополнительныеОтчетыИОбработкиЗаполнениеОбъекта;
	ИначеЕсли	Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Тогда
		Команда = Метаданные.ОбщиеКоманды.ДополнительныеОтчетыИОбработкиОтчеты;
	ИначеЕсли	Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма Тогда
		Команда = Метаданные.ОбщиеКоманды.ДополнительныеОтчетыИОбработкиПечатныеФормы;
	ИначеЕсли	Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов Тогда
		Команда = Метаданные.ОбщиеКоманды.ДополнительныеОтчетыИОбработкиСозданиеСвязанныхОбъектов;
	КонецЕсли;
	
	Если Команда <> Неопределено Тогда
		
		Для Каждого Тип Из Команда.ТипПараметраКоманды.Типы() Цикл
			ПолноеИмяОбъектаМетаданных = Метаданные.НайтиПоТипу(Тип).ПолноеИмя();
			РазделеннаяСтрока = СтроковыеФункцииКлиентСервер.РазложитьСтрокуВМассивПодстрок(ПолноеИмяОбъектаМетаданных, ".");
			НовоеНазначение = Назначение.Добавить();
			НовоеНазначение.ПолноеИмяОбъектаМетаданных	= ПолноеИмяОбъектаМетаданных;
			НовоеНазначение.Класс		= РазделеннаяСтрока[0];
			НовоеНазначение.Объект		= РазделеннаяСтрока[1];
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Назначение;
	
КонецФункции

// Проверяет, что обработка относится к категории глобальных.
// Параметры
// Вид - ПеречислениеСсылка.ВидыДополнительныхОтчетовИОбработок - вид обработки
// Возвращаемое значение
//	Истина - обработка относится к категории глобальных
//	Ложь   - обработка относится к категории назначаемых
//
Функция ПроверитьГлобальнаяОбработка(Вид) Экспорт
	
	Возврат (Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка)
		ИЛИ (Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет);
	
КонецФункции

// Проверяет, что обработка относится к категории назначаемых для объектов
// Параметры
// Вид - ПеречислениеСсылка.ВидыДополнительныхОтчетовИОбработок - вид обработки
// Возвращаемое значение
//	Истина - обработка относится к категории назначаемых
//	Ложь   - обработка относится к категории глобальных
//
Функция ПроверитьНазначаемаяОбработка(Вид) Экспорт
	
	Возврат Не ПроверитьГлобальнаяОбработка(Вид);
	
КонецФункции

// Выполняет подключение внешней обработки. После подключения обработка
// становится известной в системе под определенным именем. После этого
// можно открывать форму обработки.
//
// Параметры
// ВнешняяОбработка - СправочникСсылка.ДополнительныеОтчетыИОбработки
// БезопасныйРежим - Булево - требуется ли запускать обработку в безопасном режиме
//
// Возвращаемое значение
// Имя обработки - строка - имя обработки известное системе
//
Функция ПодключитьВнешнююОбработку(ВнешняяОбработка, БезопасныйРежим) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ДвоичныеДанныеОбработки = ВнешняяОбработка.ПолучитьОбъект().ХранилищеОбработки.Получить();
	АдресВоВременномХранилище = ПоместитьВоВременноеХранилище(ДвоичныеДанныеОбработки);
	
	Если ВнешняяОбработка.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
	 ИЛИ ВнешняяОбработка.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		Возврат ВнешниеОтчеты.Подключить(АдресВоВременномХранилище,, БезопасныйРежим);
	Иначе
		Возврат ВнешниеОбработки.Подключить(АдресВоВременномХранилище,, БезопасныйРежим);
	КонецЕсли;
	
КонецФункции

// Создает объект обработки и передает ему управление через известный интерфейс.
// Для назначаемых обработок так же указываются объекты назначения. Из некоторых обработок
// происходит получение результата выполнения.
// Параметры
// ВнешняяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки
// ИдентификаторКоманды - Строка - идентификатор одной из команд обработки
// БезопасныйРежим - Булево - требуется ли запускать обработку в безопасном режиме
// ОбъектыНазначения - Массив - объекты назначения обработки
// РезультатВыполнения - Массив - используется для передачи результата выполнения обработки
//
Процедура ВыполнитьОбработкуНепосредственно(
	ВнешняяОбработкаСсылка,
	ИдентификаторКоманды,
	БезопасныйРежим,
	ОбъектыНазначения = Неопределено,
	РезультатВыполнения = Неопределено
	) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	ВнешняяОбработка = ПолучитьОбъектВнешнейОбработки(ВнешняяОбработкаСсылка, БезопасныйРежим);
	
	ТипОбработки = ВнешняяОбработкаСсылка.Вид;
	
	Если ТипОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка
	 ИЛИ ТипОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		
		ВнешняяОбработка.ВыполнитьКоманду(ИдентификаторКоманды);
		
	ИначеЕсли ТипОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов Тогда
		
		СозданныеОбъекты = Новый Массив;
		
		ВнешняяОбработка.ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения, СозданныеОбъекты);
		
		РезультатВыполнения = Новый Массив;
		
		Для Каждого СозданныйОбъект Из СозданныеОбъекты Цикл
			Тип = ТипЗнч(СозданныйОбъект);
			Если РезультатВыполнения.Найти(Тип) = Неопределено Тогда
				РезультатВыполнения.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта Тогда
		
		ВнешняяОбработка.ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения);
		
		РезультатВыполнения = Новый Массив;
		
		Для Каждого ИзмененныйОбъект Из ОбъектыНазначения Цикл
			Тип = ТипЗнч(ИзмененныйОбъект);
			Если РезультатВыполнения.Найти(Тип) = Неопределено Тогда
				РезультатВыполнения.Добавить(Тип);
			КонецЕсли;
		КонецЦикла;
		
	ИначеЕсли ТипОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет Тогда
		
		ВнешняяОбработка.ВыполнитьКоманду(ИдентификаторКоманды, ОбъектыНазначения);
		
	ИначеЕсли ТипОбработки = Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма Тогда
		
		ВнешняяОбработка.Печать(ИдентификаторКоманды, ОбъектыНазначения);
		
	КонецЕсли;
	
КонецПроцедуры

// Возвращает вид обработки по строковому представлению
// Параметры
// СтроковоеПредставление - Строка - строковое представление вида обработки
// Возвращаемое значение
// ПеречислениеСсылка.ВидыДополнительныхОтчетовИОбработок - вид обработки
//
Функция ПолучитьВидОбработкиПоСтроковомуПредставлениюВида(СтроковоеПредставление) Экспорт
	
	Если	  СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиЗаполнениеОбъекта() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ЗаполнениеОбъекта;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиОтчет() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиПечатнаяФорма() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ПечатнаяФорма;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиСозданиеСвязанныхОбъектов() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.СозданиеСвязанныхОбъектов;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительнаяОбработка() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительнаяОбработка;
	ИначеЕсли СтроковоеПредставление = ДополнительныеОтчетыИОбработкиКлиентСервер.ВидОбработкиДополнительныйОтчет() Тогда
		Возврат Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет;
	КонецЕсли;
	
КонецФункции

// Выполняет создание экземпляра внешней обработки (отчета)
// Параметры
//  ВнешняяОбработкаСсылка - СправочникСсылка.ДополнительныеОтчетыИОбработки
//  БезопасныйРежим - Булево - требуется ли запускать обработку в безопасном режиме
// Возвращаемое значение
//  строка - имя обработки известное системе
//
Функция ПолучитьОбъектВнешнейОбработки(ВнешняяОбработкаСсылка, БезопасныйРежим) Экспорт
	
	ВнешняяОбработкаОбъект = ВнешняяОбработкаСсылка.ПолучитьОбъект();
	
	ДвоичныеДанныеОбработки = ВнешняяОбработкаОбъект.ХранилищеОбработки.Получить();
	
	ИмяВременногоФайла = ПолучитьИмяВременногоФайла("epf");
	
	ДвоичныеДанныеОбработки.Записать(ИмяВременногоФайла);
	
	Если ВнешняяОбработкаОбъект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.Отчет
	 ИЛИ ВнешняяОбработкаОбъект.Вид = Перечисления.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет Тогда
		Возврат ВнешниеОтчеты.Создать(ИмяВременногоФайла, БезопасныйРежим);
	Иначе
		Возврат ВнешниеОбработки.Создать(ИмяВременногоФайла, БезопасныйРежим);
	КонецЕсли;
	
КонецФункции

// Возвращает имя рабочего места команды
//
Функция ПолучитьИмяРабочегоМеста(ИмяКоманды) Экспорт
	
	ТаблицаКоманд = ДополнительныеОтчетыИОбработкиПереопределяемый.ПолучитьОбщиеКомандыДополнительныхОбработок();
	
	Найденные = ТаблицаКоманд.НайтиСтроки(Новый Структура("ИмяКоманды", ИмяКоманды));
	
	Если Найденные.Количество() = 0 Тогда
		ТаблицаКоманд = ДополнительныеОтчетыИОбработкиПереопределяемый.ПолучитьОбщиеКомандыДополнительныхОтчетов();
		Найденные = ТаблицаКоманд.НайтиСтроки(Новый Структура("ИмяКоманды", ИмяКоманды));
	КонецЕсли;
	
	Возврат Найденные[0].ИмяРабочегоМеста;
	
КонецФункции

// Получает список доступных команд
// Параметры
//  ЭтоНазначаемыеОбработки - Булево - фильтр по назначаемым обработкам
//  ПолноеИмяОбъектаМетаданных - строка - полное имя объекта метаданных
//  ЭтоФормаОбъекта - булево - получать настройку для формы объекта
//  ИмяРаздела - имя раздела для глобальных обработок
//  ВидОбработок - ПеречислениеСсылка.ВидыДополнительныхОтчетовИОбработок - вид обработок
//
Функция ПолучитьДоступныеКоманды(ЭтоНазначаемыеОбработки, ПолноеИмяОбъектаМетаданных, ЭтоФормаОбъекта, ИмяРаздела, ВидОбработок) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "
			|ВЫБРАТЬ
			|	ВЫРАЗИТЬ(ДополнительныеОтчетыИОбработкиКоманды.Представление КАК Строка(200)) КАК Представление,
			|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор КАК Идентификатор,
			|	ДополнительныеОтчетыИОбработкиКоманды.ПоказыватьОповещение КАК ПоказыватьОповещение,
			|	ДополнительныеОтчетыИОбработкиКоманды.Модификатор КАК Модификатор,
			|	ВЫБОР
			|		КОГДА ДополнительныеОтчетыИОбработкиКоманды.ВариантЗапуска = ЗНАЧЕНИЕ(Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода)
			|			ТОГДА ""ВызовКлиентскогоМетода""
			|		КОГДА ДополнительныеОтчетыИОбработкиКоманды.ВариантЗапуска = ЗНАЧЕНИЕ(Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода)
			|			ТОГДА ""ВызовСерверногоМетода""
			|		КОГДА ДополнительныеОтчетыИОбработкиКоманды.ВариантЗапуска = ЗНАЧЕНИЕ(Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы)
			|			ТОГДА ""ОткрытиеФормы""
			|	КОНЕЦ КАК ВариантЗапуска,
			|	ДополнительныеОтчетыИОбработки.Ссылка			КАК Ссылка,
			|	ДополнительныеОтчетыИОбработки.БезопасныйРежим	КАК БезопасныйРежим
			|ИЗ
			|	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
			|	СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
			|			ПО ДополнительныеОтчетыИОбработкиКоманды.Ссылка = ДополнительныеОтчетыИОбработки.Ссылка";
	
	Если ЭтоНазначаемыеОбработки Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Назначение КАК ДополнительныеОтчетыИОбработкиНазначение
			|			ПО ДополнительныеОтчетыИОбработкиНазначение.Ссылка = ДополнительныеОтчетыИОбработки.Ссылка";
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
			|	СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ДополнительныеОтчетыИОбработкиРазделы
			|			ПО ДополнительныеОтчетыИОбработкиРазделы.Ссылка = ДополнительныеОтчетыИОбработки.Ссылка
			|	ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользовательскиеНастройкиДоступаКОбработкам КАК ПользовательскиеНастройкиДоступаКОбработкам
			|			ПО ПользовательскиеНастройкиДоступаКОбработкам.ДополнительныйОтчетИлиОбработка = ДополнительныеОтчетыИОбработки.Ссылка
			|			 И ПользовательскиеНастройкиДоступаКОбработкам.ИдентификаторКоманды = ДополнительныеОтчетыИОбработкиКоманды.Идентификатор
			|			 И ПользовательскиеНастройкиДоступаКОбработкам.Пользователь = &Пользователь";
		Запрос.Параметры.Вставить("Пользователь", ОбщегоНазначения.ТекущийПользователь());
	КонецЕсли;
	
	//////////////////////////
	// блок наложения фильтров
	
	ТекстЗапроса = ТекстЗапроса + "
			|ГДЕ
			|	ДополнительныеОтчетыИОбработки.Вид = &ВидОбработок
			|	И НЕ ДополнительныеОтчетыИОбработки.ПометкаУдаления
			|	И (
			|		ДополнительныеОтчетыИОбработки.Публикация = ЗНАЧЕНИЕ(Перечисление.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется)";
			
	Если РольДоступна(Метаданные.Роли.ДобавлениеИзменениеДополнительныхОтчетовИОбработок)
		ИЛИ РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	ИЛИ ДополнительныеОтчетыИОбработки.Публикация = ЗНАЧЕНИЕ(Перечисление.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки)";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
									| )";
	
	Если ЭтоНазначаемыеОбработки Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	И ДополнительныеОтчетыИОбработкиНазначение.ПолноеИмяОбъектаМетаданных ПОДОБНО &ПолноеИмяОбъектаМетаданных";
			
		Запрос.Параметры.Вставить("ПолноеИмяОбъектаМетаданных", ПолноеИмяОбъектаМетаданных);
		
		Если ЭтоФормаОбъекта Тогда
			ТекстЗапроса = ТекстЗапроса + "
			|	И ДополнительныеОтчетыИОбработки.ИспользоватьДляФормыОбъекта";
		Иначе
			ТекстЗапроса = ТекстЗапроса + "
			|	И ДополнительныеОтчетыИОбработки.ИспользоватьДляФормыСписка";
		КонецЕсли;
		
	Иначе
		ТекстЗапроса = ТекстЗапроса + "
			|	И ДополнительныеОтчетыИОбработкиРазделы.ИмяРаздела = &ИмяРаздела
			|	И ПользовательскиеНастройкиДоступаКОбработкам.Доступно";
		Запрос.Параметры.Вставить("ИмяРаздела", ИмяРаздела);
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
			|УПОРЯДОЧИТЬ ПО
			|	Представление Возр";
			
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.Параметры.Вставить("ВидОбработок", ВидОбработок);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции

// Функция для добавления команд дополнительных обработок в список "своих"
//
Процедура ДобавитьКомандыВСписокСвоих(МассивКоманд) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ЭлементСтрока Из МассивКоманд Цикл
		
		Запись = РегистрыСведений.ПользовательскиеНастройкиДоступаКОбработкам.СоздатьМенеджерЗаписи();
		Запись.ДополнительныйОтчетИлиОбработка	= ЭлементСтрока.Обработка;
		Запись.ИдентификаторКоманды 			= ЭлементСтрока.Идентификатор;
		Запись.Пользователь						= ОбщегоНазначения.ТекущийПользователь();
		Запись.Доступно = Истина;
		
		Запись.Записать(Истина);
	КонецЦикла;
	
КонецПроцедуры

// Функция для исключения команд дополнительных обработок из списока "своих"
//
Процедура УдалитьКомандыИзСпискаСвоих(МассивКоманд) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ЭлементСтрока Из МассивКоманд Цикл
		
		Запись = РегистрыСведений.ПользовательскиеНастройкиДоступаКОбработкам.СоздатьМенеджерЗаписи();
		Запись.ДополнительныйОтчетИлиОбработка	= ЭлементСтрока.Обработка;
		Запись.ИдентификаторКоманды 			= ЭлементСтрока.Идентификатор;
		Запись.Пользователь						= ОбщегоНазначения.ТекущийПользователь();
		Запись.Прочитать();
		Запись.Удалить();
		
	КонецЦикла;
	
КонецПроцедуры

// Устанавливает доступность команды для указанных типа объекта метаданных и типа формы
//
Процедура УстановитьДоступностьКоманды(ПолноеИмяОбъектаМетаданных, ТипФормы, ИмяРесурса, Значение) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	МенеджерЗаписи = РегистрыСведений.НазначениеДополнительныхОбработок.СоздатьМенеджерЗаписи();
	МенеджерЗаписи.ТипОбъекта = ПолноеИмяОбъектаМетаданных;
	МенеджерЗаписи.ТипФормы = ТипФормы;
	МенеджерЗаписи.Прочитать();
	МенеджерЗаписи.ТипОбъекта = ПолноеИмяОбъектаМетаданных;
	МенеджерЗаписи.ТипФормы = ТипФормы;
	МенеджерЗаписи[ИмяРесурса] = Значение;
	МенеджерЗаписи.Записать(Истина);
	
КонецПроцедуры

// Записывает настройки быстрого доступа к обработкам "по пользователям"
//
Процедура ЗаписатьНастройкиБыстрогоДоступа(Ссылка, ТаблицаКоманд) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Для Каждого ЭлементКоманда Из ТаблицаКоманд Цикл
		
		НаборЗаписей = РегистрыСведений.ПользовательскиеНастройкиДоступаКОбработкам.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.ДополнительныйОтчетИлиОбработка.Установить(Ссылка);
		НаборЗаписей.Отбор.ИдентификаторКоманды.Установить(ЭлементКоманда.Идентификатор);
		
		Для Каждого ЭлементПользователь Из ЭлементКоманда.БыстрыйСписокДоступа Цикл
			Запись = НаборЗаписей.Добавить();
			Запись.ДополнительныйОтчетИлиОбработка = Ссылка;
			Запись.ИдентификаторКоманды = ЭлементКоманда.Идентификатор;
			Запись.Пользователь = ЭлементПользователь.Значение;
			Запись.Доступно = Истина;
		КонецЦикла;
		
		НаборЗаписей.Записать(Истина);
		
	КонецЦикла;
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// Блок экспортных функций работы с регламентными заданиями

Процедура ОбновитьСведенияПоРасписанию(ДополнительнаяОбработка, Команда, Расписание, Использование, Отказ) Экспорт
	
	// получаем регламентное задание по идентификатору, если объект не находим, то создаем новый
	РегламентноеЗаданиеОбъект = ПолучитьРегламентноеЗадание(Команда.РегламентноеЗаданиеGUID);
	
	// обновляем свойства РЗ
	УстановитьПараметрыРегламентногоЗадания(РегламентноеЗаданиеОбъект, Расписание, Использование, ДополнительнаяОбработка.Ссылка, Команда);
	
	// записываем измененное задание
	ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект);
	
	//запоминаем GUID регл. задания в реквизите объекта
	Команда.РегламентноеЗаданиеGUID = РегламентноеЗаданиеОбъект.УникальныйИдентификатор;
	
КонецПроцедуры

// Выполняет удаление регламентного задания по GUID
// Параметры
//  РегламентноеЗаданиеGUID - УникальныйИдентификатор - уникальный идентификатор регламентного задания
//
Процедура УдалитьРегламентноеЗадание(РегламентноеЗаданиеGUID) Экспорт
	
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗадание(РегламентноеЗаданиеGUID);
	
	Если РегламентноеЗаданиеОбъект <> Неопределено Тогда
		УстановитьПривилегированныйРежим(Истина);
		РегламентноеЗаданиеОбъект.Удалить();
	КонецЕсли;
	
КонецПроцедуры

// Выполняет поиск регламентного задания по GUID
// Параметры
//  РегламентноеЗаданиеGUID - УникальныйИдентификатор - уникальный идентификатор регламентного задания
// Возвращаемое значение
//  РегламентноеЗадание - если найдено
//  Неопределено - если не найдено
//
Функция НайтиРегламентноеЗадание(РегламентноеЗаданиеGUID) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		ТекущееРегламентноеЗадание = РегламентныеЗадания.НайтиПоУникальномуИдентификатору(РегламентноеЗаданиеGUID);
	Исключение
		ТекущееРегламентноеЗадание = Неопределено;
	КонецПопытки;
	
	Возврат ТекущееРегламентноеЗадание;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Блок служебных функций работы с регламентными заданиями

Процедура УстановитьПараметрыРегламентногоЗадания(РегламентноеЗаданиеОбъект, Расписание, Использование, Ссылка, Команда)
	
	ПараметрыРЗ = Новый Массив;
	ПараметрыРЗ.Добавить(Ссылка);
	ПараметрыРЗ.Добавить(Команда.Идентификатор);
	
	НаименованиеРегламентногоЗадания = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
				НСтр("ru = 'Запуск обработок: %1'"),
				СокрЛП(Команда.Представление) );
	
	РегламентноеЗаданиеОбъект.Наименование  = Лев(НаименованиеРегламентногоЗадания, 120);
	РегламентноеЗаданиеОбъект.Использование = Использование;
	РегламентноеЗаданиеОбъект.Параметры     = ПараметрыРЗ;
	
	РегламентноеЗаданиеОбъект.Расписание = Расписание;
	
КонецПроцедуры

// Выполняет запись регламентного задания
//
// Параметры:
//  Отказ                     - Булево - флаг отказа. Если в процессе выполнения процедуры были обнаружены ошибки,
//                                       то флаг отказа устанавливается в значение Истина
//  РегламентноеЗаданиеОбъект - объект регламентного задания, которое необходимо записать
// 
Процедура ЗаписатьРегламентноеЗадание(Отказ, РегламентноеЗаданиеОбъект)
	
	УстановитьПривилегированныйРежим(Истина);
	
	Попытка
		
		// записываем задание
		РегламентноеЗаданиеОбъект.Записать();
		
	Исключение
		НСтрока = НСтр("ru = 'Произошла ошибка при сохранении регламентного задания
							|Подробное описание ошибки: %1'");
		
		СтрокаСообщения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(НСтрока,
								КраткоеПредставлениеОшибки(ИнформацияОбОшибке()));
		
		ОбщегоНазначенияКлиентСервер.СообщитьПользователю(СтрокаСообщения, , , , Отказ);
	КонецПопытки;
	
КонецПроцедуры

Функция ПолучитьРегламентноеЗадание(РегламентноеЗаданиеGUID)
	
	УстановитьПривилегированныйРежим(Истина);
	
	РегламентноеЗаданиеОбъект = НайтиРегламентноеЗадание(РегламентноеЗаданиеGUID);
	
	// при необходимости создаем регл. задание
	Если РегламентноеЗаданиеОбъект = Неопределено Тогда
		
		РегламентноеЗаданиеОбъект = РегламентныеЗадания.СоздатьРегламентноеЗадание("ЗапускДополнительныхОбработок");
		
	КонецЕсли;
	
	Возврат РегламентноеЗаданиеОбъект;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// ВСПОМОГАТЕЛЬНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ

Процедура НачалоВыполненияОбработки(ДополнительнаяОбработкаСсылка, ИдентификаторКоманды)
	
	ТекстСообщения = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Запуск обработчика. Команда: %1.'"),
			ИдентификаторКоманды);
	
	ЗаписатьСобытиеВЖурналРегистрации(ДополнительнаяОбработкаСсылка, ТекстСообщения);
	
КонецПроцедуры

Процедура ОкончаниеРаботыОбработки(ДополнительнаяОбработкаСсылка, ИдентификаторКоманды)
	
	ТекстСообщения = 
		СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Возврат из обработчика. Команда: %1.'"),
			ИдентификаторКоманды);
	
	ЗаписатьСобытиеВЖурналРегистрации(ДополнительнаяОбработкаСсылка, ТекстСообщения);
	
КонецПроцедуры

Процедура ЗаписатьСобытиеВЖурналРегистрации(ДополнительнаяОбработкаСсылка, ТекстСообщения)
	
	ЗаписьЖурналаРегистрации(НСтр("ru = 'Дополнительные отчеты и обработки'"),
				УровеньЖурналаРегистрации.Информация,
				ДополнительнаяОбработкаСсылка.Метаданные(),
				ДополнительнаяОбработкаСсылка,
				ТекстСообщения);
	
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ ОБНОВЛЕНИЯ ИНФОРМАЦИОННОЙ БАЗЫ

// Добавляет в список Обработчики процедуры-обработчики обновления,
// необходимые данной подсистеме.
//
// Параметры:
//   Обработчики - ТаблицаЗначений - см. описание функции НоваяТаблицаОбработчиковОбновления
//                                   общего модуля ОбновлениеИнформационнойБазы.
// 
Процедура ЗарегистрироватьОбработчикиОбновления(Обработчики) Экспорт
	
	Обработчик = Обработчики.Добавить();
	Обработчик.Версия = "1.0.7.1";
	Обработчик.Процедура = "ДополнительныеОтчетыИОбработки.ОбновитьПользовательскиеНастройкиДоступаКОбработкам";
	
КонецПроцедуры

// Процедура обновления записей о доступности дополнительных обработок
//
Процедура ОбновитьПользовательскиеНастройкиДоступаКОбработкам() Экспорт
	
	ПользователиСДопОбработками = ПолучитьМассивПользователейСДоступомКДополнительнымОбработкам();
	
	ТаблицаЗаписей = ПолучитьТаблицуЗаписей(ПользователиСДопОбработками);
	
	Для Каждого Пользователь Из ПользователиСДопОбработками Цикл
		НаборЗаписей = РегистрыСведений.ПользовательскиеНастройкиДоступаКОбработкам.СоздатьНаборЗаписей();
		НаборЗаписей.Отбор.Пользователь.Установить(Пользователь);
		ЗаписиПоБыстромуДоступу = ТаблицаЗаписей.НайтиСтроки(Новый Структура("Пользователь,Доступно", Пользователь, Истина));
		Для Каждого ЗаписьБыстрогоДоступа Из ЗаписиПоБыстромуДоступу Цикл
			НоваяЗапись = НаборЗаписей.Добавить();
			НоваяЗапись.ДополнительныйОтчетИлиОбработка = ЗаписьБыстрогоДоступа.Обработка;
			НоваяЗапись.ИдентификаторКоманды			= ЗаписьБыстрогоДоступа.Идентификатор;
			НоваяЗапись.Пользователь					= Пользователь;
			НоваяЗапись.Доступно						= Истина;
		КонецЦикла;
		НаборЗаписей.Записать(Истина);
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТаблицуЗаписей(ПользователиСДопОбработками)
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ДополнительныеОтчетыИОбработки.Ссылка КАК Обработка,
	               |	КомандыДополнительныхОтчетовИОбработок.Идентификатор КАК Идентификатор
	               |ИЗ
	               |	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК КомандыДополнительныхОтчетовИОбработок
	               |		ПО (КомандыДополнительныхОтчетовИОбработок.Ссылка = ДополнительныеОтчетыИОбработки.Ссылка)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	ОбработкиСКомандами = Запрос.Выполнить().Выгрузить();
	
	ТаблицаЗаписей = Новый ТаблицаЗначений;
	ТаблицаЗаписей.Колонки.Добавить("Обработка",     Новый ОписаниеТипов("СправочникСсылка.ДополнительныеОтчетыИОбработки"));
	ТаблицаЗаписей.Колонки.Добавить("Идентификатор", Новый ОписаниеТипов("Строка"));
	ТаблицаЗаписей.Колонки.Добавить("Пользователь",  Новый ОписаниеТипов("СправочникСсылка.Пользователи"));
	ТаблицаЗаписей.Колонки.Добавить("Доступно",      Новый ОписаниеТипов("Булево"));
	
	Для Каждого ОбработкаКоманда Из ОбработкиСКомандами Цикл
		Для Каждого Пользователь Из ПользователиСДопОбработками Цикл
			НоваяСтрока = ТаблицаЗаписей.Добавить();
			НоваяСтрока.Обработка     = ОбработкаКоманда.Обработка;
			НоваяСтрока.Идентификатор = ОбработкаКоманда.Идентификатор;
			НоваяСтрока.Пользователь  = Пользователь;
			НоваяСтрока.Доступно   = Истина;
		КонецЦикла;
	КонецЦикла;
	
	ТекстЗапроса = "ВЫБРАТЬ
	               |	ДополнительныеОтчетыИОбработки.Ссылка КАК Обработка,
	               |	КомандыДополнительныхОтчетовИОбработок.Идентификатор КАК Идентификатор,
	               |	Пользователи.Ссылка КАК Пользователь,
	               |	ПользовательскиеНастройкиДоступаКОбработкам.Доступно КАК Доступно
	               |ИЗ
	               |	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК КомандыДополнительныхОтчетовИОбработок
	               |		ПО (КомандыДополнительныхОтчетовИОбработок.Ссылка = ДополнительныеОтчетыИОбработки.Ссылка)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ РегистрСведений.ПользовательскиеНастройкиДоступаКОбработкам КАК ПользовательскиеНастройкиДоступаКОбработкам
	               |		ПО (ПользовательскиеНастройкиДоступаКОбработкам.ДополнительныйОтчетИлиОбработка = ДополнительныеОтчетыИОбработки.Ссылка)
	               |			И (ПользовательскиеНастройкиДоступаКОбработкам.ИдентификаторКоманды = КомандыДополнительныхОтчетовИОбработок.Идентификатор)
	               |		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.Пользователи КАК Пользователи
	               |		ПО (Пользователи.Ссылка = ПользовательскиеНастройкиДоступаКОбработкам.Пользователь)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	ИсключенияПерсональногоДоступа = Запрос.Выполнить().Выгрузить();
	
	Для Каждого ИсключениеПерсональногоДоступа Из ИсключенияПерсональногоДоступа Цикл
		
		Строка = ТаблицаЗаписей.НайтиСтроки(Новый Структура("Обработка,Идентификатор,Пользователь",
												ИсключениеПерсональногоДоступа.Обработка,
												ИсключениеПерсональногоДоступа.Идентификатор,
												ИсключениеПерсональногоДоступа.Пользователь))[0];
		
		Строка.Доступно = НЕ ИсключениеПерсональногоДоступа.Доступно; // ранее это значение было исключением доступа, инвертируем его
		
	КонецЦикла;
	
	Возврат ТаблицаЗаписей;
	
КонецФункции

Функция ПолучитьМассивПользователейСДоступомКДополнительнымОбработкам()
	
	Результат = Новый Массив;
	
	ТекстЗапроса = "ВЫБРАТЬ Ссылка
					|ИЗ
					|	Справочник.Пользователи";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	
	ВсеПользователи = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Ссылка");
	
	Для Каждого Пользователь Из ВсеПользователи Цикл
		
		ПользовательИБ = ПользователиИнформационнойБазы.НайтиПоУникальномуИдентификатору(Пользователь.ИдентификаторПользователяИБ);
		
		Если ПользовательИБ <> Неопределено Тогда
			Если ПользовательИБ.Роли.Содержит(Метаданные.Роли.ИспользованиеДополнительныхОтчетовИОбработок)
			 ИЛИ ПользовательИБ.Роли.Содержит(Метаданные.Роли.ДобавлениеИзменениеДополнительныхОтчетовИОбработок)
			 ИЛИ ПользовательИБ.Роли.Содержит(Метаданные.Роли.ПолныеПрава) Тогда
				Результат.Добавить(Пользователь);
			КонецЕсли;
		КонецЕсли;
		
	КонецЦикла;
	
	ТекстЗапроса = "ВЫБРАТЬ РАЗЛИЧНЫЕ
					|	Пользователь
					|ИЗ
					|	РегистрСведений.ПользовательскиеНастройкиДоступаКОбработкам
					|ГДЕ
					|	Пользователь НЕ В (&МассивПользователей)";
	
	Запрос = Новый Запрос;
	Запрос.Текст = ТекстЗапроса;
	Запрос.Параметры.Вставить("МассивПользователей", Результат);
	
	ПользователиВРегистре = Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("Пользователь");
	
	Для Каждого Пользователь Из ПользователиВРегистре Цикл
		Результат.Добавить(Пользователь);
	КонецЦикла;
	
	Возврат Результат;
	
КонецФункции

////////////////////////////////////////////////////////////////////////////////
// Служебные функции, используются в общем модуле ДополнительныеОтчетыИОбработкиПереопределяемый
//

// Служебная функция используется при определении таблицы рабочих мест для
// глобальных дополнительных отчетов и обработок
// Возвращаемое значение
//  Таблица значений, две колонки:
//        ИмяКоманды - строка
//        ИмяРабочегоМеста - строка
//
Функция ПолучитьТаблицуКоманд() Экспорт
	
	Таблица = Новый ТаблицаЗначений;
	
	Таблица.Колонки.Добавить("ИмяКоманды", Новый ОписаниеТипов("Строка"));
	Таблица.Колонки.Добавить("ИмяРабочегоМеста", Новый ОписаниеТипов("Строка"));
	
	Возврат Таблица;
	
КонецФункции

// Служебная процедура, используется при добавлении описания нового рабочего места
// для глобальных дополнительных отчетов и обработок
// Параметры
//  ТаблицаКоманд - таблица значений - таблица, получаемая с помощью ПолучитьТаблицуКоманд()
//  ИмяКоманды - строка - имя связанной общей команды
//  ИмяРабочегоМеста - строка - пользовательское представление рабочего места
//
Процедура ДобавитьКоманду(ТаблицаКоманд, ИмяКоманды, ИмяРабочегоМеста) Экспорт
	
	НоваяСтрока = ТаблицаКоманд.Добавить();
	НоваяСтрока.ИмяКоманды = ИмяКоманды;
	НоваяСтрока.ИмяРабочегоМеста = ИмяРабочегоМеста;
	
КонецПроцедуры

// Служебная процедура для получения команд по переданным разделам
// Параметры:
//  МассивИменРазделов - массив строк - каждая строка - имя раздела
//
Функция ПолучитьДоступныеДополнительныеОтчеты(МассивИменРазделов) Экспорт
	
	УстановитьПривилегированныйРежим(Истина);
	
	Запрос = Новый Запрос;
	
	ТекстЗапроса = "ВЫБРАТЬ
	|	ДополнительныеОтчетыИОбработкиКоманды.Представление КАК Представление,
	|	ДополнительныеОтчетыИОбработкиКоманды.Идентификатор КАК Идентификатор,
	|	ДополнительныеОтчетыИОбработкиКоманды.ПоказыватьОповещение КАК ПоказыватьОповещение,
	|	ДополнительныеОтчетыИОбработкиКоманды.Модификатор КАК Модификатор,
	|	ВЫБОР
	|		КОГДА ДополнительныеОтчетыИОбработкиКоманды.ВариантЗапуска = ЗНАЧЕНИЕ(Перечисление.СпособыВызоваДополнительныхОбработок.ВызовКлиентскогоМетода)
	|			ТОГДА ""ВызовКлиентскогоМетода""
	|		КОГДА ДополнительныеОтчетыИОбработкиКоманды.ВариантЗапуска = ЗНАЧЕНИЕ(Перечисление.СпособыВызоваДополнительныхОбработок.ВызовСерверногоМетода)
	|			ТОГДА ""ВызовСерверногоМетода""
	|		КОГДА ДополнительныеОтчетыИОбработкиКоманды.ВариантЗапуска = ЗНАЧЕНИЕ(Перечисление.СпособыВызоваДополнительныхОбработок.ОткрытиеФормы)
	|			ТОГДА ""ОткрытиеФормы""
	|	КОНЕЦ КАК ВариантЗапуска,
	|	ДополнительныеОтчетыИОбработки.Ссылка КАК Ссылка,
	|	ДополнительныеОтчетыИОбработки.БезопасныйРежим КАК БезопасныйРежим,
	|	ЕСТЬNULL(ПользовательскиеНастройкиДоступаКОбработкам.Доступно, ЛОЖЬ) КАК Доступно
	|ИЗ
	|	Справочник.ДополнительныеОтчетыИОбработки КАК ДополнительныеОтчетыИОбработки
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Команды КАК ДополнительныеОтчетыИОбработкиКоманды
	|		ПО (ДополнительныеОтчетыИОбработкиКоманды.Ссылка = ДополнительныеОтчетыИОбработки.Ссылка)
	|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Справочник.ДополнительныеОтчетыИОбработки.Разделы КАК ДополнительныеОтчетыИОбработкиРазделы
	|		ПО (ДополнительныеОтчетыИОбработкиРазделы.Ссылка = ДополнительныеОтчетыИОбработки.Ссылка)
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПользовательскиеНастройкиДоступаКОбработкам КАК ПользовательскиеНастройкиДоступаКОбработкам
	|		ПО (ПользовательскиеНастройкиДоступаКОбработкам.ДополнительныйОтчетИлиОбработка = ДополнительныеОтчетыИОбработки.Ссылка)
	|			И (ПользовательскиеНастройкиДоступаКОбработкам.ИдентификаторКоманды = ДополнительныеОтчетыИОбработкиКоманды.Идентификатор)
	|			И (ПользовательскиеНастройкиДоступаКОбработкам.Пользователь = &Пользователь)
	|ГДЕ
	|	ДополнительныеОтчетыИОбработки.Вид = ЗНАЧЕНИЕ(Перечисление.ВидыДополнительныхОтчетовИОбработок.ДополнительныйОтчет)
	|	И НЕ ДополнительныеОтчетыИОбработки.ПометкаУдаления
	|	И (
	|		ДополнительныеОтчетыИОбработки.Публикация = ЗНАЧЕНИЕ(Перечисление.ВариантыПубликацииДополнительныхОтчетовИОбработок.Используется)";
			
	Если РольДоступна(Метаданные.Роли.ДобавлениеИзменениеДополнительныхОтчетовИОбработок)
		ИЛИ РольДоступна(Метаданные.Роли.ПолныеПрава) Тогда
		ТекстЗапроса = ТекстЗапроса + "
			|	ИЛИ ДополнительныеОтчетыИОбработки.Публикация = ЗНАЧЕНИЕ(Перечисление.ВариантыПубликацииДополнительныхОтчетовИОбработок.РежимОтладки)";
	КонецЕсли;
	
	ТекстЗапроса = ТекстЗапроса + "
			| )
			|	И ДополнительныеОтчетыИОбработкиРазделы.ИмяРаздела В (&МассивИменРазделов)";
	
	Запрос.Текст = ТекстЗапроса;
	
	Запрос.Параметры.Вставить("Пользователь", ОбщегоНазначения.ТекущийПользователь());
	Запрос.Параметры.Вставить("МассивИменРазделов", МассивИменРазделов);
	
	Возврат Запрос.Выполнить().Выгрузить();
	
КонецФункции
