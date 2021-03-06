/////////////////////////////////////////////////////////////////////////////////////
// НАЗНАЧЕНИЕ:
// МОДУЛЬ ПРЕДНАЗНАЧЕН ДЛЯ ОБРАБОТКИ ВВОДА ТС В ПОЛЯ ВВОДА И ТАБЛИЧНЫЕ ЧАСТИ, А ТАКЖЕ
// ОБРАБОТКИ МЕХАНИЗМОВ ОТОБРАЖЕНИЯ ГАРАЖНОГО ИЛИ ГОС. НОМЕРА ВМЕСТО ОСНОВНОГО
// ПРЕДСТАВЛЕНИЯ ТС (ПО НАИМЕНОВАНИЮ) В ЗАВИСИМОСТИ ОТ НАСТРОЕК ПРОГРАММЫ
// ИСПОЛЬЗОВАНИЕ:
// ВСЕ ПРОЦЕДУРЫ ВСТАВЛЯЮТСЯ В СООТВЕТСТВУЮЩИЕ ОБРАБОТЧИКИ В ФОРМАХ ОБЪЕКТОВ
// ПРИМЕР:
// Документ Заправка ГСМ. Табличная часть Заправки с полем ТС
// 1) колонку ТС делаем недоступной, добавляем в табличное поле колонку НомерТС
// типа Строка.
// 2) На нее навешиваем обработчики ПриИзменении, НачалоВыбора, АвтоПодборТекста, 
// ОкончаниеВводаТекста, ОбработкаВыбора. В этих обработчиках прописываем вызовы
// соответствующих процедур данного модуля.
// 3) Аналогично указываем обработчики ПриНачалеРедактирования, ПриВыводеСтроки
// в табличном поле с ТС


/////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ТАБЛИЧНОГО ПОЛЯ

//Процедура вызывается из обработчика ПриНачалеРедактирования табличного поля
//
//Параметры:
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	КолонкаНомерТС - колонка табл. поля - колонка НомерТС,
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура ТабличноеПолеПриНачалеРедактирования(ТС, КолонкаНомерТС, Организация) ЭКСПОРТ
	КолонкаНомерТС.ЭлементУправления.Значение = 
		уатОбщегоНазначения.уатПредставлениеТС(ТС, Организация);
КонецПроцедуры

//Процедура вызывается из обработчика ПриВыводеСтроки табличного поля
//
//Параметры:
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	ОформлениеСтрокиЯчейкаНомерТС - оформление строки табл. поля,
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура ТабличноеПолеПриВыводеСтроки(ТС, ОформлениеСтрокиЯчейкаНомерТС, Организация) ЭКСПОРТ
	ОформлениеСтрокиЯчейкаНомерТС.УстановитьТекст(уатОбщегоНазначения.уатПредставлениеТС(ТС, Организация));
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТА УПРАВЛЕНИЯ "НОМЕР ТС" ТАБЛИЧНОЙ ЧАСТИ

//Процедура вызывается из обработчика ПриИзменении поля ввода НомерТС табличного поля
//
//Параметры:
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	Значение - значение поля ввода (номер ТС),
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура ТабличноеПолеНомерТСПриИзменении(ТС, Значение, Организация) ЭКСПОРТ
	Если ПустаяСтрока(Значение) Тогда
		ТС = Неопределено;
		Возврат;
	КонецЕсли;
	
	мТС = уатОбщегоНазначения.уатНайтиТСПоНомеру(Организация, Значение);
	Если мТС <> Неопределено Тогда
		ТС = мТС;
	КонецЕсли;
КонецПроцедуры

//Процедура вызывается из обработчика НачалоВыбора поля ввода НомерТС табличного поля
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	СтруктураОтбора - Структура - будет использоваться для отбора списка выбора ТС
//(по умолчанию используется только по организации документа),
//	СтандартнаяОбработка - флаг стандартной обработки выбора (здесь сбрасывается)
//
Процедура ТабличноеПолеНомерТСНачалоВыбора(Элемент, ТС, СтруктураОтбора, СтандартнаяОбработка) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	
	Если СтруктураОтбора = Неопределено тогда
		СтруктураОтбора = Новый Структура;
	КонецЕсли;

	Если НЕ СтруктураОтбора.Свойство("ДатаВыбытия") Тогда
		СтруктураОтбора.Вставить("ДатаВыбытия", '00010101');
	КонецЕсли;
	Если НЕ СтруктураОтбора.Свойство("ПривлеченноеТС") тогда
		СтруктураОтбора.Вставить("ПривлеченноеТС",Ложь);
	КонецЕсли;
	
	уатЗащищенныеФункции.уатДиалогВыбораТС(Элемент, СтруктураОтбора, ТС);
КонецПроцедуры

//Процедура вызывается из обработчика АвтоПодборТекста поля ввода НомерТС табличного поля
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	Текст, ТекстАвтоПодбора - Строка - параметры, переданные из метода АвтоПодборТекста,
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	СтандартнаяОбработка - Булево - флаг стандартной обработки события,
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура ТабличноеПолеНомерТСАвтоПодборТекста(Элемент, Текст, ТекстАвтоПодбора, ТС, СтандартнаяОбработка, Организация) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	ТекстАвтоПодбора = уатОбщегоНазначения.уатПодобратьНомерТС(Организация, Текст);
	Если Не уатОбщегоНазначения.уатЗначениеНеЗаполнено(ТекстАвтоПодбора) Тогда
		Элемент.Значение = СокрЛП(ТекстАвтоПодбора);
		ТекстАвтоПодбора = "";
		ТабличноеПолеНомерТСПриИзменении(ТС, Элемент.Значение, Организация);
	КонецЕсли;
КонецПроцедуры

//Процедура вызывается из обработчика ОкончаниеВводаТекста поля ввода НомерТС табличного поля
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	Текст - Строка - параметр, переданный из метода ОкончаниеВводаТекста,
//	Значение - значение поля ввода (номер ТС),
//	СтандартнаяОбработка - флаг стандартной обработки (здесь сбрасывается),
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура ТабличноеПолеНомерТСОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка, Организация, Знач СтруктураДопПараметров = Неопределено) ЭКСПОРТ
	Если ПустаяСтрока(Текст) Тогда
		Значение = Неопределено;
		Возврат;
	КонецЕсли;
	
	Если СтруктураДопПараметров = Неопределено тогда
		СтруктураДопПараметров = Новый структура;
	КонецЕсли;
	Если СтруктураДопПараметров.Свойство("НастройкиОтбора") тогда
		мНастройкиОтбора = СтруктураДопПараметров.НастройкиОтбора;
	Иначе
		мНастройкиОтбора = Новый Структура();
	КонецЕсли;
	Если НЕ мНастройкиОтбора.Свойство("Организация") тогда
		мНастройкиОтбора.Вставить("Организация", Организация);
	КонецЕсли;
	Если НЕ мНастройкиОтбора.Свойство("ПривлеченноеТС") тогда
		мНастройкиОтбора.Вставить("ПривлеченноеТС", Ложь);
	КонецЕсли;
	
	Значение = уатЗащищенныеФункции.уатПодобратьСписокТС(Организация, Текст, Элемент.Значение, СтруктураДопПараметров);
	СтандартнаяОбработка = (Значение = Неопределено);
КонецПроцедуры

//Процедура вызывается из обработчика ОбработкаВыбора поля ввода НомерТС табличного поля
//
//Параметры:
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	КолонкаНомерТС - колонка табл. поля - колонка НомерТС,
//	ВыбранноеЗначение - значение, выбранное из списка ТС,
//	СтандартнаяОбработка - флаг стандартной обработки (здесь сбрасывается),
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура ТабличноеПолеНомерТСОбработкаВыбора(ТС, КолонкаНомерТС, ВыбранноеЗначение, СтандартнаяОбработка, Организация) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.уатТС") И НЕ ВыбранноеЗначение.ЭтоГруппа Тогда
		ТС = ВыбранноеЗначение;
	Иначе
		ТС = уатОбщегоНазначения.уатНайтиТСПоНомеру(Организация, СокрЛП(ВыбранноеЗначение));
	КонецЕсли;
	
//	КолонкаНомерТС.ЭлементУправления.Значение = уатОбщегоНазначения.уатПредставлениеТС(ТС, Организация);
КонецПроцедуры

//Процедура вызывается из обработчика Очистка поля ввода НомерТС табличного поля
//
//Параметры:
//	ТС - СправочникСсылка.уатТС - транспортное средство
//
Процедура ТабличноеПолеНомерТСОчистка(ТС) ЭКСПОРТ
	ТС = Неопределено;
КонецПроцедуры

//Процедура вызывается из обработчика Открытие поля ввода НомерТС табличного поля
//
//Параметры:
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	СтандартнаяОбработка - флаг стандартной обработки (здесь сбрасывается)
//
Процедура ТабличноеПолеНомерТСОткрытие(ТС, СтандартнаяОбработка) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	Попытка
		уатОбщегоНазначения.уатОткрытьКарточкуТС(ТС);
	Исключение
	КонецПопытки;
КонецПроцедуры


/////////////////////////////////////////////////////////////////////////////////////
// ОБРАБОТЧИКИ СОБЫТИЙ ЭЛЕМЕНТА УПРАВЛЕНИЯ "НОМЕР ТС" ШАПКИ

//Процедура вызывается из обработчика ПриИзменении поля ввода НомерТС
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура НомерТСПриИзменении(Элемент, ТС, Организация) ЭКСПОРТ
	
	Если ПустаяСтрока(Элемент.Значение) Тогда
		ТС = Неопределено;
		Возврат;
	КонецЕсли;
	
	мТС = уатОбщегоНазначения.уатНайтиТСПоНомеру(Организация, Элемент.Значение);
	Если мТС = Неопределено Тогда
		ТС = Неопределено;
		Элемент.Значение = "";
	Иначе
		ТС = мТС;
		Элемент.Значение = уатОбщегоНазначения.уатПредставлениеТС(ТС, Организация);
	КонецЕсли;
КонецПроцедуры

//Процедура вызывается из обработчика НачалоВыбора поля ввода НомерТС
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	СтруктураОтбора - Структура - будет использоваться для отбора списка выбора ТС
//(по умолчанию используется только по организации документа),
//	СтандартнаяОбработка - флаг стандартной обработки выбора (здесь сбрасывается)
//
Процедура НомерТСНачалоВыбора(Элемент, ТС, СтруктураОтбора, СтандартнаяОбработка) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	
	Если СтруктураОтбора = Неопределено тогда
		СтруктураОтбора = Новый Структура;
	КонецЕсли;
	
	Если НЕ СтруктураОтбора.Свойство("ДатаВыбытия") Тогда
		СтруктураОтбора.Вставить("ДатаВыбытия", '00010101');
	КонецЕсли;
	//Если НЕ СтруктураОтбора.Свойство("ПривлеченноеТС") тогда
	//	СтруктураОтбора.Вставить("ПривлеченноеТС", Ложь);
	//КонецЕсли;
	
 	уатЗащищенныеФункции.уатДиалогВыбораТС(Элемент, СтруктураОтбора, ТС);
КонецПроцедуры

//Процедура вызывается из обработчика ОбработкаВыбора поля ввода НомерТС
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	ВыбранноеЗначение - значение, выбранное из списка ТС,
//	СтандартнаяОбработка - флаг стандартной обработки (здесь сбрасывается),
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура НомерТСОбработкаВыбора(Элемент, ТС, ВыбранноеЗначение, СтандартнаяОбработка, Организация) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.уатТС") И НЕ ВыбранноеЗначение.ЭтоГруппа Тогда
		ТС = ВыбранноеЗначение;
	Иначе
		ТС = уатОбщегоНазначения.уатНайтиТСПоНомеру(Организация, СокрЛП(ВыбранноеЗначение));
	КонецЕсли;
	
КонецПроцедуры

//Процедура вызывается из обработчика АвтоПодборТекста поля ввода НомерТС
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	Текст, ТекстАвтоПодбора - Строка - параметры, переданные из метода АвтоПодборТекста,
//	СтандартнаяОбработка - Булево - флаг стандартной обработки события,
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура НомерТСАвтоПодборТекста(Элемент, ТС, Текст, ТекстАвтоПодбора, СтандартнаяОбработка, Организация) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	ТекстАвтоПодбора = уатОбщегоНазначения.уатПодобратьНомерТС(Организация, Текст);
	Если ЗначениеЗаполнено(ТекстАвтоПодбора) Тогда
		Элемент.Значение = СокрЛП(ТекстАвтоПодбора);
		ТекстАвтоПодбора = "";
		НомерТСПриИзменении(Элемент, ТС, Организация);
	КонецЕсли;
КонецПроцедуры

//Процедура вызывается из обработчика ОкончаниеВводаТекста поля ввода НомерТС
//
//Параметры:
//	Элемент - элемент управления (поле НомерТС),
//	Текст - Строка - параметр, переданный из метода ОкончаниеВводаТекста,
//	Значение - значение поля ввода (номер ТС),
//	СтандартнаяОбработка - флаг стандартной обработки (здесь сбрасывается),
//	Организация - СправочникСсылка.Организации - Организация
//
Процедура НомерТСОкончаниеВводаТекста(Элемент, Текст, Значение, СтандартнаяОбработка, Организация, Знач СтруктураДопПараметров = Неопределено,РекПоиска=неопределено) ЭКСПОРТ
	Если ПустаяСтрока(Текст) Тогда
		Значение = Неопределено;
		Возврат;
	КонецЕсли;
	
	Если СтруктураДопПараметров = Неопределено тогда
		СтруктураДопПараметров = Новый структура;
	КонецЕсли;
	Если СтруктураДопПараметров.Свойство("НастройкиОтбора") тогда
		мНастройкиОтбора = СтруктураДопПараметров.НастройкиОтбора;
	Иначе
		мНастройкиОтбора = Новый Структура();
	КонецЕсли;
	Если НЕ мНастройкиОтбора.Свойство("Организация") тогда
		мНастройкиОтбора.Вставить("Организация", Организация);
	КонецЕсли;
	Если НЕ мНастройкиОтбора.Свойство("ПривлеченноеТС") тогда
		мНастройкиОтбора.Вставить("ПривлеченноеТС", Ложь);
	КонецЕсли;
	
	Значение = уатЗащищенныеФункции.уатПодобратьСписокТС(Организация, Текст, Элемент.Значение, СтруктураДопПараметров,РекПоиска);
	СтандартнаяОбработка = (Значение = Неопределено);
КонецПроцедуры

//Процедура вызывается из обработчика Очистка поля ввода НомерТС
//
//Параметры:
//	ТС - СправочникСсылка.уатТС - транспортное средство
//
Процедура НомерТСОчистка(ТС) ЭКСПОРТ
	ТС = Неопределено;
КонецПроцедуры

//Процедура вызывается из обработчика Открытие поля ввода НомерТС
//
//Параметры:
//	ТС - СправочникСсылка.уатТС - транспортное средство,
//	СтандартнаяОбработка - флаг стандартной обработки (здесь сбрасывается)
//
Процедура НомерТСОткрытие(ТС, СтандартнаяОбработка) ЭКСПОРТ
	СтандартнаяОбработка = Ложь;
	Попытка
		уатОбщегоНазначения.уатОткрытьКарточкуТС(ТС);
	Исключение
	КонецПопытки;
КонецПроцедуры
