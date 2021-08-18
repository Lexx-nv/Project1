﻿#Если Клиент Тогда

Перем НП Экспорт; // Настройка периода


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура ЗаполнитьНачальныеНастройки() Экспорт
	
	Текст=
	"ВЫБРАТЬ
	|	уатВыработкаПоСтоимостиОбороты.ТС КАК ТС,
	|	ПРЕДСТАВЛЕНИЕ(уатВыработкаПоСтоимостиОбороты.ТС),
	|	уатВыработкаПоСтоимостиОбороты.ПутЛист КАК ПутевойЛист,
	|	уатВыработкаПоСтоимостиОбороты.ПараметрВыработки КАК ПараметрВыработки,
	|	ПРЕДСТАВЛЕНИЕ(уатВыработкаПоСтоимостиОбороты.ПараметрВыработки) Как ПараметрВыработкиПредставление,
	|	СУММА(ВЫБОР
	|			КОГДА уатВыработкаПоСтоимостиОбороты.ПараметрВыработки.Временный
	|				ТОГДА уатВыработкаПоСтоимостиОбороты.КоличествоПараметрВыработкиОборот / 3600
	|			ИНАЧЕ уатВыработкаПоСтоимостиОбороты.КоличествоПараметрВыработкиОборот 
	|		КОНЕЦ) КАК Количество,
	|	СУММА(уатВыработкаПоСтоимостиОбороты.СуммаВзаиморасчетовОборот) КАК СуммаВзаиморасчетов,
	|	СУММА(уатВыработкаПоСтоимостиОбороты.СуммаНДСОборот) КАК СуммаНДС,
	|	СУММА(уатВыработкаПоСтоимостиОбороты.СуммаВзаиморасчетовОборот - уатВыработкаПоСтоимостиОбороты.СуммаНДСОборот) КАК СуммаБезНДС";
	
	Если уатОбщегоНазначенияТиповые.уатЕстьИзмерениеРегистра("ОбъектСтроительства", РегистрыНакопления.уатВыработкаПоСтоимости.СоздатьНаборЗаписей()) Тогда
		Текст = Текст+",
		|	уатВыработкаПоСтоимостиОбороты.ОбъектСтроительства КАК ОбъектСтроительства,
		|	ПРЕДСТАВЛЕНИЕ(уатВыработкаПоСтоимостиОбороты.ОбъектСтроительства)";
	КонецЕсли;
	
	Текст = Текст+"
	|ИЗ
	|	РегистрНакопления.уатВыработкаПоСтоимости.Обороты(
	|		&ДатаНач,
	|		&ДатаКон,
	|		,
	|		Контрагент = Контрагент
	|			{Организация.* КАК Организация}) КАК уатВыработкаПоСтоимостиОбороты
	|{ГДЕ
	|	(ВЫБОР
	|			КОГДА уатВыработкаПоСтоимостиОбороты.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			КОГДА уатВыработкаПоСтоимостиОбороты.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЛОЖЬ
	|		КОНЕЦ) КАК ТСВыбыло}
	|СГРУППИРОВАТЬ ПО";
	
	Если уатОбщегоНазначенияТиповые.уатЕстьИзмерениеРегистра("ОбъектСтроительства", РегистрыНакопления.уатВыработкаПоСтоимости.СоздатьНаборЗаписей()) Тогда
		Текст = Текст+"
		|	уатВыработкаПоСтоимостиОбороты.ОбъектСтроительства,";
	КонецЕсли;
	
	Текст = Текст+"
	|	уатВыработкаПоСтоимостиОбороты.ТС,
	|	уатВыработкаПоСтоимостиОбороты.ПутЛист,
	|	уатВыработкаПоСтоимостиОбороты.ПараметрВыработки
	|ИТОГИ
	|	СУММА(Количество),
	|	СУММА(СуммаВзаиморасчетов),
	|	СУММА(СуммаНДС),
	|	СУММА(СуммаБезНДС)
	|ПО
	|	ОБЩИЕ,";
	
	Если уатОбщегоНазначенияТиповые.уатЕстьИзмерениеРегистра("ОбъектСтроительства", РегистрыНакопления.уатВыработкаПоСтоимости.СоздатьНаборЗаписей()) Тогда
		Текст = Текст+"
		|	ОбъектСтроительства,";
	КонецЕсли;
	
	Текст = Текст+"
	|	ТС";
	//|	ПутЛист";
	
	ПостроительОтчета.Текст = Текст;
	
	ПостроительОтчета.ЗаполнитьНастройки();
	
	//заполняем поля отбора
	ПостроительОтчета.Отбор.Добавить("ТС").Использование = Ложь;
	ПостроительОтчета.ДоступныеПоля.НоменклатураУслуги.Представление = "Номенклатура услуги";
	
	Если уатОбщегоНазначенияТиповые.уатЕстьИзмерениеРегистра("ОбъектСтроительства", РегистрыНакопления.уатВыработкаПоСтоимости.СоздатьНаборЗаписей()) Тогда
		ПостроительОтчета.Отбор.Добавить("ОбъектСтроительства").Использование = Ложь;
	КонецЕсли;
	
	//ПостроительОтчета.ИзмеренияСтроки.Очистить();
	
КонецПроцедуры

// Заполняет параметры расшифровки
//
// Параметры:
//	Нет.
//
Процедура ЗаполнитьПараметрыРасшифровки(Область, Выборка, ОтборСубконто = Неопределено)
	
	// Если итоги по счету не анализируются, берем общий
	//Если Выборка.Счет = NULL Тогда 
	//	РасшифровываемыйСчет = Счет;
	//	РасшифровываемыйСчетПредставление = Строка(Счет);
	//Иначе
	//	РасшифровываемыйСчет = Выборка.Счет;
	//	РасшифровываемыйСчетПредставление = Выборка.СчетПредставление;
	//КонецЕсли;
	
	//ПараметрыКарточкиСчета = Новый Соответствие;
	//
	//ПараметрыКарточкиСчета.Вставить("ИмяОбъекта", "КарточкаСчета"+ИмяРегистраБухгалтерии);
	
	//ПараметрыКарточкиСчета.Вставить("Счет", РасшифровываемыйСчет);
	
	//ПараметрыКарточкиСчета.Вставить("Счет", РасшифровываемыйСчет);
	
	//Если Лев(Выборка.Группировка(), СтрДлина(Выборка.Группировка()) - 1) = "Субконто" Тогда
	
	//	Если ОтборСубконто <> Неопределено Тогда
	//		
	//		ОтборСубконто.Вставить(Выборка.Группировка(), Выборка[Выборка.Группировка()]);
	//		
	//		// Область должна содержать свою копию отбора по субконто
	//		ОтборРасшифровка = Новый Соответствие;
	//		
	//		Для каждого ЭлементОтбора Из ОтборСубконто Цикл
	//		
	//			ОтборРасшифровка.Вставить(ЭлементОтбора.Ключ, ЭлементОтбора.Значение);
	//		
	//		КонецЦикла; 
	//		
	//		ПараметрыКарточкиСчета.Вставить("Отбор", ОтборРасшифровка);
	//		
	//	КонецЕсли;
	
	//	СписокРасшифровки = Новый СписокЗначений;
	
	//	СписокРасшифровки.Добавить(ПараметрыКарточкиСчета, "Карточка счета " + РасшифровываемыйСчетПредставление);
	//	
	//ИначеЕсли Выборка.Группировка() = "Счет" Тогда
	
	//	СписокРасшифровки = Новый СписокЗначений;
	
	//	СписокРасшифровки.Добавить(ПараметрыКарточкиСчета, "Карточка счета " + РасшифровываемыйСчетПредставление);
	//Иначе
	//	СписокРасшифровки = Неопределено;
	//КонецЕсли;
	
	//Область.Параметры.Расшифровка = СписокРасшифровки;
	
КонецПроцедуры // ЗаполнитьПараметрыРасшифровки()


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА

// Выполняет запрос и формирует табличный документ-результат отчета
// в соответствии с настройками, заданными значениями реквизитов отчета.
//
// Параметры:
//  ДокументРезультат - табличный документ, формируемый отчетом
//
Процедура СформироватьОтчет(ДокументРезультат,  ПоказыватьЗаголовок = Истина, ВысотаЗаголовка = 0) Экспорт
	
	Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(Организация) Тогда
		Предупреждение("Не выбрана организация!");
		Возврат;
	КонецЕсли;
	
	Если уатОбщегоНазначения.уатЗначениеНеЗаполнено(Контрагент) Тогда
		Предупреждение("Не выбран контрагент!");
		Возврат;
	КонецЕсли;
	
	Если ДатаНач > ДатаКон И ДатаКон <> '00010101000000' Тогда
		Предупреждение("Дата начала периода не может быть больше даты конца периода");
		Возврат;
	КонецЕсли;
	
	ДокументРезультат.Очистить();
	
	Макет       = ПолучитьМакет("Макет");
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");
	
	// Вывод заголовка отчета
	ОбластьЗаголовка = СформироватьЗаголовок();
	ВысотаЗаголовка  = ОбластьЗаголовка.ВысотаТаблицы;
	
	ДокументРезультат.Вывести(ОбластьЗаголовка, 1);
	
	МассивГруппировок = Новый Массив;
	
	Для Сч=0 По ПостроительОтчета.ИзмеренияСтроки.Количество()-1  Цикл
		МассивГруппировок.Добавить(ПостроительОтчета.ИзмеренияСтроки[Сч].Имя);
	КонецЦикла;
	
	МассивПоказателей = Новый Массив;
	
	МассивПоказателей.Добавить( "Количество");
	МассивПоказателей.Добавить( "СуммаБезНДС");
	МассивПоказателей.Добавить( "СуммаНДС");
	МассивПоказателей.Добавить( "СуммаВзаиморасчетов");
	
	// Формат показателей
	ФорматПоказателей = Новый Структура;
	
	Для Каждого ИмяПоказателя Из МассивПоказателей Цикл
		ФорматПоказателей.Вставить(ИмяПоказателя ,"ЧЦ = 15 ; ЧДЦ = 2");
	КонецЦикла;
	
	ПостроительОтчета.Параметры.Вставить("ДатаНач", ДатаНач);
	Если ДатаКон = '00010101' Тогда
		ПостроительОтчета.Параметры.Вставить("ДатаКон", ДатаКон);
	Иначе
		ПостроительОтчета.Параметры.Вставить("ДатаКон", КонецДня(ДатаКон));
	КонецЕсли;
	
	ПостроительОтчета.Параметры.Вставить("Контрагент", Контрагент);
	
	ПостроительОтчета.Выполнить();
	
	РезультатЗапроса = ПостроительОтчета.Результат;
	
	ЗаголовокОтчета = Макет.ПолучитьОбласть("ЗаголовокОтчета");
	
	ДокументРезультат.Вывести(ЗаголовокОтчета, 1);
	
	// Сдвиг уровня выводимой группировки отчета относительно группировки запроса
	СдвигУровня = 0;
	
	// Флаг сброса сдвига уровня при выводе группировки по счету
	СброситьСдвигУровня = Истина;
	
	ОбластьСтрока = Макет.ПолучитьОбласть("Строка");;
	ОбластьИтогиГруппировки = Макет.ПолучитьОбласть("ИтогиГруппировки");;
	ОбластьИтоги = Макет.ПолучитьОбласть("Итоги");
	ОбластьИтоги.Параметры.НазваниеОрганизации = ?(ПустаяСтрока(Организация.НаименованиеПолное), Организация, Организация.НаименованиеПолное);
	ОбластьИтоги.Параметры.Контрагент = Контрагент;

	ОбластьИтогиОбъектСтроительства = Макет.ПолучитьОбласть("ИтогиОбъектСтроительства");;
	ИтогиПодвал = Макет.ПолучитьОбласть("ИтогиПодвал");
	
	СтруктураПараметров = Новый Структура;
	СтруктураПараметров.Вставить("ДокументРезультат", ДокументРезультат);
	СтруктураПараметров.Вставить("ОбластьСтрока",ОбластьСтрока);
	СтруктураПараметров.Вставить("ОбластьИтогиГруппировки",ОбластьИтогиГруппировки);
	СтруктураПараметров.Вставить("ОбластьИтоги",ОбластьИтоги);
	СтруктураПараметров.Вставить("ОбластьИтогиОбъектСтроительства",ОбластьИтогиОбъектСтроительства);
	СтруктураПараметров.Вставить("ИтогиПодвал",ИтогиПодвал);
	СтруктураПараметров.Вставить("ФорматПоказателей", ФорматПоказателей);
	СтруктураПараметров.Вставить("МассивПоказателей", МассивПоказателей);
	
	ДокументРезультат.НачатьАвтогруппировкуСтрок();
	
	Если МассивГруппировок.Количество() > 0 Тогда
		
		ВывестиГруппировку(РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, МассивГруппировок[0]), 
		0, МассивГруппировок, 
		СдвигУровня, СброситьСдвигУровня, 
		СтруктураПараметров);
	Иначе						
		ВывестиСтроки(РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ""),СтруктураПараметров);
	КонецЕсли;
	
	ДокументРезультат.ЗакончитьАвтогруппировкуСтрок();
	
	// Выведем общие итоги
	Выборка = РезультатЗапроса.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, "ОБЩИЕ");
	Если Выборка.Следующий() Тогда
		ВывестиПоказатели(Выборка, СтруктураПараметров);
	КонецЕсли;
	
	// Зафиксируем заголовок отчета
	ДокументРезультат.ФиксацияСверху = ВысотаЗаголовка + 1;
	
	// Первую колонку не печатаем
	ДокументРезультат.ОбластьПечати = ДокументРезультат.Область(1,2,ДокументРезультат.ВысотаТаблицы,ДокументРезультат.ШиринаТаблицы);
	
	// Ориентация страницы
	ДокументРезультат.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	
	// Присвоим имя для сохранения параметров печати табличного документа
	ДокументРезультат.ИмяПараметровПечати = "РеестрНаВыпискуСчетов";
	ДокументРезультат.ТолькоПросмотр = уатПраваИНастройки.уатПраво("ЗащитаПечатныхФорм", глПраваУАТ);
 КонецПроцедуры // СформироватьОтчет()

// Выводит заголовок отчета
//
// Параметры:
//	Нет.
//
Функция СформироватьЗаголовок() Экспорт
	
	// Вывод заголовка, описателя периода и фильтров и заголовка
	Если ДатаНач = '00010101000000' И ДатаКон = '00010101000000' Тогда
		
		ОписаниеПериода     = "Период: без ограничения.";
		
	Иначе
		
		Если ДатаНач = '00010101000000' ИЛИ ДатаКон = '00010101000000' Тогда
			ОписаниеПериода = "Период: " + Формат(ДатаНач, "ДФ = ""дд.ММ.гггг""; ДП = ""без ограничения""") 
			+ " - "      + Формат(ДатаКон, "ДФ = ""дд.ММ.гггг""; ДП = ""без ограничения""");
		Иначе
			Если ДатаНач <= ДатаКон Тогда
				ОписаниеПериода = "Период: " + ПредставлениеПериода(НачалоДня(ДатаНач), КонецДня(ДатаКон), "ФП = Истина");
			Иначе
				ОписаниеПериода = "Неправильно задан период!"
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Макет = ПолучитьМакет("Макет");
	Итоги = Макет.ПолучитьОбласть("Итоги");
	ЗаголовокОтчета = Макет.ПолучитьОбласть("Заголовок");
	
	НазваниеОрганизации = Организация.НаименованиеПолное;
	Если ПустаяСтрока(НазваниеОрганизации) Тогда
		НазваниеОрганизации = Организация;
	КонецЕсли;
	
	ЗаголовокОтчета.Параметры.НазваниеОрганизации = НазваниеОрганизации;
	ЗаголовокОтчета.Параметры.Контрагент = Контрагент;
	ЗаголовокОтчета.Параметры.ОписаниеПериода = ОписаниеПериода;
	
	//ТекстПроИтоги = "";
	//
	//ТекстПроИтоги = ТекстПроИтоги + УправлениеОтчетами.СформироватьСтрокуИзмерений(ПостроительОтчета.ИзмеренияСтроки);
	//
	//Если Не ПустаяСтрока(ТекстПроИтоги) Тогда
	//	ЗаголовокОтчета.Параметры.ТекстПроИтоги = "Группировки по " + ТекстПроИтоги;
	//КонецЕсли;
	//
	ЗаголовокОтчета.Параметры.Заголовок = ЗаголовокОтчета();
	
	//Вывод списка фильтров:
	
	Если ПечататьСтрокуОтбора Тогда 
		СтрОтбор = УправлениеОтчетами.СформироватьСтрокуОтборов(ПостроительОтчета.Отбор);
		
		Если Не ПустаяСтрока(СтрОтбор) Тогда
			ОбластьОтбор = Макет.ПолучитьОбласть("СтрокаОтбор");
			ОбластьОтбор.Параметры.ТекстПроОтбор = "Отбор: " + СтрОтбор;
			ЗаголовокОтчета.Вывести(ОбластьОтбор);
		КонецЕсли;
	КонецЕсли;
	
	Возврат(ЗаголовокОтчета);
	
КонецФункции // СформироватьЗаголовок()

// Выводит показатели группировки
//
// Параметры:
//	Выборка - выборка
//	ЭтоПерваяСтрока - признак вывода отступов перед субконто
//
Процедура ВывестиПоказатели(Выборка, СтруктураПараметров)
	
	ДокументРезультат = СтруктураПараметров.ДокументРезультат;
	
	флОбластьСтрока = Ложь;
	
	Если Выборка.Группировка() = "ОбъектСтроительства" Тогда
		Область = СтруктураПараметров.ОбластьИтогиОбъектСтроительства;
		Область.Параметры.Группировка = Выборка.ОбъектСтроительства ;	
		//Область.Параметры.РасшифровкаГруппировка = Выборка.ОбъектСтроительства ;	
	ИначеЕсли Выборка.Группировка() = "ТС" Тогда
		Область = СтруктураПараметров.ОбластьИтогиГруппировки;
		Область.Параметры.Группировка = "Всего по ТС: " + уатОбщегоНазначения.уатПредставлениеТС(Выборка.ТС, УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация")) ;	
		//Область.Параметры.РасшифровкаГруппировка = Выборка.ТС ;	
	ИначеЕсли Выборка.Группировка() = "ОБЩИЕ" Тогда
		Область = СтруктураПараметров.ОбластьИтоги;
	Иначе	
		Область = СтруктураПараметров.ОбластьСтрока;
		Область.Параметры.ПредставлениеТС = уатОбщегоНазначения.уатПредставлениеТС(Выборка.ТС, УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация"));	
		Область.Параметры.ПараметрВыработкиПредставление = Выборка.ПараметрВыработкиПредставление ;
		Попытка
			Область.Параметры.ДатаПЛ = Выборка.ПутевойЛист.Дата ;	
			Область.Параметры.НомерПЛ = Выборка.ПутевойЛист.Номер ;	
		Исключение
		КонецПопытки;
		Область.Параметры.РасшифровкаТС = Выборка.ТС;	
		Область.Параметры.РасшифровкаПЛ = Выборка.ПутевойЛист;
		//Область.Параметры.РасшифровкаПараметров = Выборка.Ссылка;
		
		флОбластьСтрока = Истина;
	КонецЕсли;
	
	Для Каждого ИмяПоказателя Из СтруктураПараметров.МассивПоказателей Цикл
		
		ФорматПоказателя = "";
		СтруктураПараметров.ФорматПоказателей.Свойство(ИмяПоказателя, ФорматПоказателя);
		
		Если ИмяПоказателя = "Количество" И флОбластьСтрока И ЗначениеЗаполнено(Выборка.ПараметрВыработки) И Выборка.ПараметрВыработки.Временный Тогда
			Область.Параметры[ИмяПоказателя] = уатОбщегоНазначения.уатФорматироватьВремяВОтчетах(Выборка[ИмяПоказателя], ФорматПоказателя);
		Иначе	
		    Попытка Область.Параметры[ИмяПоказателя]  = Формат(Выборка[ИмяПоказателя], ФорматПоказателя);
			Исключение КонецПопытки;
		КонецЕсли;
		
	КонецЦикла;
	
	Область.Область("R1C2").Отступ = Макс(Выборка.Уровень() - 1, 0);
	
	Если Выборка.Группировка() = "ОБЩИЕ" Тогда
		ДокументРезультат.Вывести(СтруктураПараметров.ИтогиПодвал, Выборка.Уровень());
	КонецЕсли;	
	
	ДокументРезультат.Вывести(Область, Выборка.Уровень());
	
КонецПроцедуры // ВывестиПоказатели()

// Выводит строки
//
// Параметры:
//	Выборка - выборка
//
Процедура ВывестиСтроки(Выборка, СтруктураПараметров)
	
	ДокументРезультат = СтруктураПараметров.ДокументРезультат;
	Область = СтруктураПараметров.ОбластьСтрока;
	Пока Выборка.Следующий() Цикл
		
		ВывестиПоказатели(Выборка,СтруктураПараметров); 
		
	КонецЦикла;
	
КонецПроцедуры // ВывестиПоказатели()

// Выводит группировку при развороте счета по субсчетам и/или субконто
//
// Параметры:
//	Выборка         - выборка из результата запроса по выводимой группировке,
//	ИндексТекущейГруппировки - индекс выводимой группировки в массиве группировок,
//	МассивГруппировок - массив, содержащий имена группировок, по которым строится разворот счета,
//	Уровень 		- уровень  группировки верхнего уровня
//	СдвигУровня     - сдвиг уровня группировки отчета относительно уровня группировки запроса,
//	СброситьСдвигУровня - признак сброса сдвига уровня,
//	ПоВалютам       - признак вывода валют и валютных сумм,
//	СтрокаРазвернутогоСальдо - строка таблицы значений с развернутым сальдо по текущему счету.
//	СтруктураОбщийИтог - структура, в которой накапливаются общие итоги
//	СтруктураПараметров - структура, содержащая неизменные для разворота счета параметры:
//	                      Области макета табличного документа, линии, уровень группировки, 
//	                      с которой начался вывод отчета.
//
Процедура ВывестиГруппировку(Выборка, Знач ИндексТекущейГруппировки, МассивГруппировок, СдвигУровня, 
	СброситьСдвигУровня, СтруктураПараметров)
	
	Пока Выборка.Следующий() Цикл
		
		Если Выборка.Группировка() = "ГСМ" Тогда
			
			ВыводимаяОбласть = СтруктураПараметров.ОбластьИтогиГруппировки;
			
			ВыводимаяОбласть.Параметры.Заполнить(Выборка);
			
			ЗаполнитьПараметрыРасшифровки(ВыводимаяОбласть, Выборка, Неопределено);
			
		ИначеЕсли Выборка.Группировка() = "Модель" Тогда
			
			ВыводимаяОбласть = СтруктураПараметров.ОбластьИтогиГруппировки;
			
			ВыводимаяОбласть.Параметры.Заполнить(Выборка);
			
			ЗаполнитьПараметрыРасшифровки(ВыводимаяОбласть, Выборка, Неопределено)
			
		ИначеЕсли Выборка.Группировка() = "Колонна" Тогда
			
			ВыводимаяОбласть = СтруктураПараметров.ОбластьИтогиГруппировки;
			
			ВыводимаяОбласть.Параметры.Заполнить(Выборка);
			
			ЗаполнитьПараметрыРасшифровки(ВыводимаяОбласть, Выборка, Неопределено)
			
		ИначеЕсли Выборка.Группировка() = "АЗС" Тогда
			
			ВыводимаяОбласть = СтруктураПараметров.ОбластьИтогиГруппировки;
			
			ВыводимаяОбласть.Параметры.Заполнить(Выборка);
			
			ЗаполнитьПараметрыРасшифровки(ВыводимаяОбласть, Выборка, Неопределено)
			
		КонецЕсли;
		
		ВывестиПоказатели(Выборка, СтруктураПараметров);
		
		// Если есть следующая группировка, то выбираем ее
		~М1:	Если ИндексТекущейГруппировки + 1 < МассивГруппировок.Количество() Тогда
			
			ВывестиГруппировку(Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, МассивГруппировок[ИндексТекущейГруппировки + 1]), 
			ИндексТекущейГруппировки + 1, МассивГруппировок, СдвигУровня, 
			СброситьСдвигУровня, СтруктураПараметров);
		Иначе	//Для последней группировки выводим строку
			ВывестиСтроки(Выборка.Выбрать(ОбходРезультатаЗапроса.ПоГруппировкам, ""),СтруктураПараметров); 
		КонецЕсли;
	КонецЦикла;
	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Настраивает отчет по заданным параметрам (например, для расшифровки)
//
Процедура Настроить(СтруктураПараметров) Экспорт
	
	Параметры = Новый Соответствие;
	
	Для каждого Элемент Из СтруктураПараметров Цикл
		Параметры.Вставить(Элемент.Ключ, Элемент.Значение);
	КонецЦикла; 
	
	Организация = Параметры["Организация"];
	ДатаНач = Параметры["ДатаНач"];
	ДатаКон = Параметры["ДатаКон"];
	
	ЗаполнитьНачальныеНастройки();
	
	
	СтрокиОтбора = Параметры["Отбор"];
	
	Если ТипЗнч(СтрокиОтбора) = Тип("Соответствие")
		ИЛИ ТипЗнч(СтрокиОтбора) = Тип("Структура") Тогда
		
		Для каждого Строка Из СтрокиОтбора Цикл
			
			ЭлементОтбора = Неопределено;
			
			// Установим существующие элементы, добавим новые
			Для Инд = 0 По ПостроительОтчета.Отбор.Количество()-1 Цикл
				
				Если Строка.Ключ = ПостроительОтчета.Отбор[Инд].ПутьКДанным Тогда
					ЭлементОтбора = ПостроительОтчета.Отбор[Инд];
				КонецЕсли;
				
			КонецЦикла; 
			
			Если ЭлементОтбора = Неопределено Тогда
				
				ЭлементОтбора = ПостроительОтчета.Отбор.Добавить(Строка.Ключ);
				
			КонецЕсли; 
			ЭлементОтбора.Установить(Строка.Значение);
			
		КонецЦикла;
	КонецЕсли;
	
КонецПроцедуры

// Процедура установки начальных настроек отчета с использованием текста запроса
//
Функция ЗаголовокОтчета() Экспорт
	Возврат "Реестр оказанных транспортных услуг";	
КонецФункции // ЗаголовокОтчета()


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

НП = Новый НастройкаПериода;
Организация  = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");

#КонецЕсли