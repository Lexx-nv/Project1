
&НаКлиенте
Процедура ОтобратьВыписанныеПутевыеЛистыЗаПериод(Элемент)
	мМассивПутевыхПоТсЗаПериод = ПолучитьПутевыеЛистыЗаПериод(фТС, фДатаНачала, фДатаОкончания);
	ЗаполнитьТаблицуИзМассива(фТаблицаПутевыхЛистовПериода, мМассивПутевыхПоТсЗаПериод);
КонецПроцедуры

&НаКлиенте
Процедура фТСПриИзменении(Элемент)
	ОтобратьВыписанныеПутевыеЛистыЗаПериод(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	ОтобратьВыписанныеПутевыеЛистыЗаПериод(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьТаблицуИзМассива(пТаблицаЗначенийФормы, пМассивСтруктур)
	фТаблицаПутевыхЛистовПериода.Очистить();
	
	Если пМассивСтруктур.Количество() > 0 Тогда
		Для Каждого мЭлемент Из пМассивСтруктур Цикл
			мСтрока = пТаблицаЗначенийФормы.Добавить();
			ЗаполнитьЗначенияСвойств(мСтрока, мЭлемент);
		КонецЦикла;
	КонецЕсли;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьПутевыеЛистыЗаПериод(пТС, пДатаНачала, пДатаОкончания)
	мЗапрос = Новый Запрос("ВЫБРАТЬ
	|	уатПутевойЛист.Ссылка КАК ПутевойЛист,
	|	уатПутевойЛист.ДатаВыезда КАК ДатаВыезда,
	|	уатПутевойЛист.ДатаВозвращения КАК ДатаВозвращения,
	|	уатПутевойЛист.Контрагент КАК Контрагент,
	|	уатПутевойЛист.ЦехКонтрагента КАК ЦехКонтрагента
	|ИЗ
	|	Документ.уатПутевойЛист КАК уатПутевойЛист
	|ГДЕ (НЕ уатПутевойЛист.ПометкаУдаления) И уатПутевойЛист.ТранспортноеСредство = &ТС И уатПутевойЛист.ДатаВыезда МЕЖДУ НАЧАЛОПЕРИОДА(&ДатаНачала, ДЕНЬ) И КОНЕЦПЕРИОДА(&ДатаОкончания, ДЕНЬ)");
	
	мЗапрос.УстановитьПараметр("ТС", пТС);
	мЗапрос.УстановитьПараметр("ДатаНачала", пДатаНачала);
	мЗапрос.УстановитьПараметр("ДатаОкончания", пДатаОкончания);
	
	мРезультат = мЗапрос.Выполнить().Выгрузить();
	Возврат ПреобразоватьТаблицуВМассивСтруктур(мРезультат);
КонецФункции

&НаСервереБезКонтекста
Функция ПреобразоватьТаблицуВМассивСтруктур(пТаблица, пЧистыйМассив = Ложь, пСтрокаИменКолонок = Неопределено)
	вМассив = Новый Массив;
	Если пСтрокаИменКолонок <> Неопределено Тогда
		мСтрокаИменКолонок = пСтрокаИменКолонок;
	Иначе
		мСтрокаИменКолонок = "";
		Для Каждого мКолонка Из пТаблица.Колонки Цикл
			мСтрокаИменКолонок = мСтрокаИменКолонок + "," + мКолонка.Имя;
		КонецЦикла;
		мСтрокаИменКолонок = Сред(мСтрокаИменКолонок, 2);
	КонецЕсли;
	мЧистыйМассив = пЧистыйМассив И Найти(мСтрокаИменКолонок, ",") = 0;
	
	Для Каждого мСтрока Из пТаблица Цикл
		Если Не мЧистыйМассив Тогда
			мСтруктура = Новый Структура(мСтрокаИменКолонок);
			ЗаполнитьЗначенияСвойств(мСтруктура, мСтрока);
			вМассив.Добавить(мСтруктура);
		Иначе
			вМассив.Добавить(мСтрока[мСтрокаИменКолонок]);
		КонецЕсли;
	КонецЦикла;
	
	Возврат вМассив;
КонецФункции

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	Если Параметры.Свойство("ДатаНачала") Тогда
		фДатаНачала = Параметры.ДатаНачала;
		фДатаОкончания = Параметры.ДатаНачала;
	КонецЕсли;
	Если Не Параметры.Свойство("МассивСтрокКПечати") Тогда
		Возврат;
	КонецЕсли;
	фОрганизация = ПолучитьОрганизацию();
	
	мПараметрыОбщие = Параметры.МассивСтрокКПечати[0].ОбщиеДанныеСтроки;
	мМассивПараметровЗадания = Параметры.МассивСтрокКПечати[0].МассивЗаданий;
	мПустаяСтруктураЗадания = Новый Структура("ТС, ИдентификаторСтрокиЗаявки, Смена, ВремяПодачи, ВремяВозврата, Водитель, МестоОказанияУслуг, ЦехМаршрут, Колонна, ТипТС, ВтораяСмена, Контрагент, Водитель2, ПутевойЛист, ДатаВозврата, Прицеп, ПутевойЛист, ПозицияПП");
	мПараметрыЗадания = ?(мМассивПараметровЗадания.Количество() > 0, мМассивПараметровЗадания[0], мПустаяСтруктураЗадания);
	
	фИдентификаторСтрокиЗаявки = мПараметрыЗадания.ИдентификаторСтрокиЗаявки;
	
	фВодитель = мПараметрыОбщие.Водитель;
	фВодитель2 = мПараметрыОбщие.Водитель2;
	
	фВремяВыезда = мПараметрыОбщие.ВремяПодачиОбщее;
	фВремяВозврата = мПараметрыОбщие.ВремяВозвратаОбщее;
	
	фДниНедели = 2;
	фЗаказчик = ?(ЗначениеЗаполнено(мПараметрыОбщие.КонтрагентПЛ), мПараметрыОбщие.КонтрагентПЛ, мПараметрыОбщие.Контрагент);
	
	фПечатьСразуНаПринтер = Истина;
	фПозицияПП = мПараметрыЗадания.ПозицияПП;
	фПрицеп = мПараметрыЗадания.Прицеп;
	фТС = мПараметрыОбщие.ТС;
	фЦех = мПараметрыЗадания.ЦехМаршрут;
	
	фВрач = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация"), ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойВрач);
	фДиспетчер = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация"), ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойДиспетчер);
	фМеханик = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация"), ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойМеханик);
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьОрганизацию()
	мТекущаяОрганизация = Справочники.Организации.ПустаяСсылка();
	мВыборкаОрганизаций = Справочники.Организации.Выбрать();
	Если Метаданные.Справочники.Организации.Реквизиты.Найти("ОсновнаяОрганизация") <> Неопределено ТОгда
		Пока мВыборкаОрганизаций.Следующий() Цикл
			мТекущаяОрганизация = мВыборкаОрганизаций.Ссылка;
			Если мВыборкаОрганизаций.ОсновнаяОрганизация = Истина ТОгда ПРервать; КонецеСЛИ;
		КонецЦикла;
	Иначе
		Если мВыборкаОрганизаций.Следующий() Тогда
			мТекущаяОрганизация = мВыборкаОрганизаций.Ссылка;
		КонецЕсли;
	КонецеСЛИ;
	
	Возврат мТекущаяОрганизация;
	
КонецФункции

&НаКлиенте
Процедура Напечатать(Команда)
	// Вставить содержимое обработчика.
КонецПроцедуры

&НаКлиенте
Процедура Выписать(Команда)
	
КонецПроцедуры

&НаКлиенте
Процедура ВыписатьИНапечатать(Команда)
	мРезультат = ВыписатьНапечататьПутевыеЛисты(Истина);
	мМассивТД = ?(мРезультат.Свойство("МассивПечатныхФорм"), мРезультат.МассивПечатныхФорм, Неопределено);
	Если мМассивТД <> Неопределено И мМассивТД.Количество() > 0 Тогда
		Для Каждого мПечатнаяФорма Из мМассивТД Цикл
			мПечатнаяФорма.АвтоМасштаб = Истина;
			Если фПечатьСразуНаПринтер Тогда
				мПечатнаяФорма.Напечатать();
			Иначе
				мПечатнаяФорма.Показать();
			КонецЕсли;
		КонецЦикла;
	КонецЕсли;
	ОтобратьВыписанныеПутевыеЛистыЗаПериод(Неопределено);
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПометкиТаблицыПЛ(Команда)
	ИзменитьПометкиТаблицыПЛ(Истина);
КонецПроцедуры

&НаКлиенте
Процедура СнятьПометкиТаблицыПЛ(Команда)
	ИзменитьПометкиТаблицыПЛ(Ложь);
КонецПроцедуры

&НаКлиенте
Процедура ИзменитьПометкиТаблицыПЛ(пЗначение)
	Для Каждого мСтрока Из фТаблицаПутевыхЛистовПериода Цикл
		мСтрока.Выбрано = пЗначение;
	КонецЦикла;
КонецПроцедуры

&НаСервереБезКонтекста
Функция ПолучитьМассивДнейПоФильтру(пДатаНачала, пДатаОкончания, пФильтр)
	//Фильтр дней
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря КАК День
	|ИЗ
	|	РегистрСведений.уатРегламентированныйПроизводственныйКалендарь КАК уатРегламентированныйПроизводственныйКалендарь
	|ГДЕ
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря >= &ДатаНачала
	|	И уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря <= &ДатаОкончания";
	
	Если пФильтр = 0 Тогда
		Запрос.Текст = Запрос.Текст + " И Пятидневка = 1";
	ИначеЕсли пФильтр = 1 Тогда
		Запрос.Текст = Запрос.Текст + " И Шестидневка = 1";
	ИначеЕсли пФильтр = 2 Тогда
		Запрос.Текст = Запрос.Текст + " И КалендарныеДни = 1";
	КонецЕсли;
	
	Запрос.Текст = Запрос.Текст + "
	|УПОРЯДОЧИТЬ ПО
	|	День";
	
	Запрос.УстановитьПараметр("ДатаНачала", НачалоДня(пДатаНачала));
	Запрос.УстановитьПараметр("ДатаОкончания", КонецДня(пДатаОкончания));
	Возврат Запрос.Выполнить().Выгрузить().ВыгрузитьКолонку("День");
КонецФункции

&НаСервереБезКонтекста
Функция СоздатьПЛ(пДатаВыезда, пДатаВозврата, пСтруктураОбщихРеквизитов);
	Если ЗначениеЗаполнено(пСтруктураОбщихРеквизитов.ПутевойЛист) Тогда
		мОбъектДокументаПЛ = пСтруктураОбщихРеквизитов.ПутевойЛист.ПолучитьОбъект();
	Иначе
		мОбъектДокументаПЛ = Документы.уатПутевойЛист.СоздатьДокумент();
	КонецЕсли;
	
	мОбъектДокументаПЛ.ТранспортноеСредство = пСтруктураОбщихРеквизитов.ТС;
	мОрганизация = пСтруктураОбщихРеквизитов.Организация;
	
	мОбъектДокументаПЛ.Дата = пДатаВыезда;
	мОбъектДокументаПЛ.ДатаВыписки = пДатаВыезда;
	Если Не ЗначениеЗаполнено(мОбъектДокументаПЛ.ДатаВыезда) Тогда
		мОбъектДокументаПЛ.ДатаВыезда = уатОбщегоНазначения.уатДатаБезСекунд(мОбъектДокументаПЛ.Дата);
	КонецЕсли;
	мОбъектДокументаПЛ.Организация = мОрганизация;
	
	мОбъектДокументаПЛ.Контрагент = пСтруктураОбщихРеквизитов.Контрагент;
	мОбъектДокументаПЛ.ИдентификаторРазнарядки = пСтруктураОбщихРеквизитов.ИдентификаторСтрокиЗаявки;
	
	мОбъектДокументаПЛ.ОсмотрелВрач = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(пСтруктураОбщихРеквизитов.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойВрач);
	мОбъектДокументаПЛ.ВыдалДиспетчер = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(пСтруктураОбщихРеквизитов.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойДиспетчер);
	мОбъектДокументаПЛ.ВыпустилМеханик = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(пСтруктураОбщихРеквизитов.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойМеханик);
	мОбъектДокументаПЛ.ПринялМеханик = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(пСтруктураОбщихРеквизитов.Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ОсновнойМеханик);
	
	уатОбщегоНазначенияТиповые.ЗаполнитьШапкуДокумента(мОбъектДокументаПЛ, глЗначениеПеременной("глТекущийПользователь"));
	
	мОбъектДокументаПЛ.Водитель1  = пСтруктураОбщихРеквизитов.Водитель;
	мОбъектДокументаПЛ.Водитель2  = пСтруктураОбщихРеквизитов.Водитель2;
	
	мОбъектДокументаПЛ.Температура = РегистрыСведений.Температуры.ПолучитьТемпературу(пДатаВыезда, мОрганизация);
	
	мОбъектДокументаПЛ.ДатаВыезда = пДатаВыезда;
	мОбъектДокументаПЛ.ДатаВозвращения = пДатаВозврата;
	
	мОбъектДокументаПЛ.ЦехКонтрагента = пСтруктураОбщихРеквизитов.ЦехКонтрагента;
	мОбъектДокументаПЛ.Комментарий = "";
	
	Если пСтруктураОбщихРеквизитов.Свойство("Прицеп") И ЗначениеЗаполнено(пСтруктураОбщихРеквизитов.Прицеп) Тогда
		Если мОбъектДокументаПЛ.Прицепы.Найти(пСтруктураОбщихРеквизитов.Прицеп, "ТС") = Неопределено Тогда
			НоваяСтрокаПрицеп = мОбъектДокументаПЛ.Прицепы.Добавить();
			НоваяСтрокаПрицеп.ТС = пСтруктураОбщихРеквизитов.Прицеп;
			НоваяСтрокаПрицеп.СчетчикМЧВыезда = уатОбщегоНазначения.уатТекущийСчетчикМЧ(пСтруктураОбщихРеквизитов.Прицеп, мОбъектДокументаПЛ.ДатаВыезда);
		КонецЕсли;
	КонецЕсли;
	
	// + Алексей: начало копия процедуры ИнициализацияДанныхАвтомобиля модуля объекта путевого листа
	//		пока доступна только на Клиенте (указана директива Препроцессора), а в режиме управляемого приложения
	//		обратиться к объекту с клиента невозможно... скопировано "нужное" из модуля объекта
	Если мОбъектДокументаПЛ.ЭтоНовый() Тогда
		Если мОбъектДокументаПЛ.ТранспортноеСредство.Модель.НаличиеСпидометра Тогда
			мОбъектДокументаПЛ.СпидометрВыезда = уатОбщегоНазначения.уатТекущийСпидометр(мОбъектДокументаПЛ.ТранспортноеСредство, мОбъектДокументаПЛ.ДатаВыезда);
		Иначе
			мОбъектДокументаПЛ.СпидометрВыезда = уатОбщегоНазначения.уатТекущийСчетчикМЧ(мОбъектДокументаПЛ.ТранспортноеСредство, мОбъектДокументаПЛ.ДатаВыезда);
		КонецЕсли;
	КонецЕсли;
	
	Если Не ЗначениеЗаполнено(мОбъектДокументаПЛ.УсловиеРаботы) Тогда
		мОбъектДокументаПЛ.УсловиеРаботы = мОбъектДокументаПЛ.ТранспортноеСредство.ОсновноеУсловиеРаботы;
	КонецЕсли;
	
	мОбъектДокументаПЛ.ВыдатьГорючее = мОбъектДокументаПЛ.ТранспортноеСредство.Модель.ОсновноеТопливо;
	// - Алексей: конец копия процедуры ИнициализацияДанныхАвтомобиля модуля объекта путевого листа
	
	Если пСтруктураОбщихРеквизитов.Свойство("ПозицияПП") И ЗначениеЗаполнено(пСтруктураОбщихРеквизитов.ПозицияПП) И Метаданные.Справочники.Найти("ПозицияПроизводсвеннойПрограммы") <> Неопределено Тогда
		мОбъектДокументаПЛ.ПозицияПП = Справочники.ПозицияПроизводсвеннойПрограммы.НайтиПоНаименованию(пСтруктураОбщихРеквизитов.ПозицияПП); // в НВДС этого нет
	КонецЕсли;
	
	мОбъектДокументаПЛ.ДействителенДо = КонецДня(мОбъектДокументаПЛ.ДатаВозвращения);
	
	Попытка
		мОбъектДокументаПЛ.Записать();
	Исключение
		Сообщить(ОписаниеОшибки());
	КонецПопытки;
	
	Возврат мОбъектДокументаПЛ;
КонецФункции

&НаКлиенте
Функция ПолучитьСтруктуруДанныхПЛ()
	вСтруктураВозврата = Новый Структура;
	вСтруктураВозврата.Вставить("ИдентификаторСтрокиЗаявки", фИдентификаторСтрокиЗаявки);
	вСтруктураВозврата.Вставить("Организация", фОрганизация);
	вСтруктураВозврата.Вставить("Водитель", фВодитель);
	вСтруктураВозврата.Вставить("Водитель2", фВодитель2);
	вСтруктураВозврата.Вставить("Контрагент", фЗаказчик);
	вСтруктураВозврата.Вставить("ЦехКонтрагента", фЦех);
	вСтруктураВозврата.Вставить("ТС", фТС);
	вСтруктураВозврата.Вставить("Прицеп", фПрицеп);
	вСтруктураВозврата.Вставить("Цех", фЦех);
	вСтруктураВозврата.Вставить("ПозицияПП", фПозицияПП);
	
	Возврат вСтруктураВозврата;
КонецФункции

&НаСервереБезКонтекста
Функция СуществуетСправочникПП()
	Возврат Метаданные.Справочники.Найти("ПозицияПроизводсвеннойПрограммы") <> Неопределено;
КонецФункции

&НаСервереБезКонтекста
Функция ОбновитьДанныеПЛ(пТекст, пСтруктураОбщихРеквизитов)
	Если ЗначениеЗаполнено(пСтруктураОбщихРеквизитов.ПутевойЛист) Тогда
		мОбъектПутевогоЛиста = пСтруктураОбщихРеквизитов.ПутевойЛист.ПолучитьОбъект();
	Иначе
		Возврат Неопределено;
	КонецЕсли;
	//обновление критических реквизитов:
	мОбъектПутевогоЛиста.Водитель1 = пСтруктураОбщихРеквизитов.Водитель;
	мОбъектПутевогоЛиста.Водитель2 = пСтруктураОбщихРеквизитов.Водитель2;
	
	мОбъектПутевогоЛиста.Контрагент = пСтруктураОбщихРеквизитов.Контрагент;
	мОбъектПутевогоЛиста.ЦехКонтрагента = пСтруктураОбщихРеквизитов.Цех;
	
	мОбъектПутевогоЛиста.ИдентификаторРазнарядки = пСтруктураОбщихРеквизитов.ИдентификаторСтрокиЗаявки;
	Если ЗначениеЗаполнено(пСтруктураОбщихРеквизитов.ПозицияПП) И СуществуетСправочникПП() Тогда
		мОбъектПутевогоЛиста.ПозицияПП = пСтруктураОбщихРеквизитов.ПозицияПП;
	КонецЕсли;
	
	Попытка
		мОбъектПутевогоЛиста.Записать();
		Сообщить("Путеовй лист уже существует! Его данные обновлены.");
		Возврат мОбъектПутевогоЛиста;
	Исключение
		Сообщить("Не удалось обновить данные ПЛ.");
	КонецПопытки;
	Возврат Неопределено;
КонецФункции

&НаКлиенте
Функция ВыписатьНапечататьПутевыеЛисты(пПечать = Ложь)
	вСтруктура = Новый Структура;
	Если НЕ ЗначениеЗаполнено(фТС) ТОгда
		Предупреждение("Не заполнен автомобиль");
		Возврат вСтруктура;
	КонецЕсли;
	
	ОтобратьВыписанныеПутевыеЛистыЗаПериод(Неопределено);
	
	мВремяПодачиЧислом = фВремяВыезда - НачалоДня(фВремяВыезда);
	мВремяВозвратаЧислом = фВремяВозврата - НачалоДня(фВремяВозврата);
	мАддитивВторойСмены = ?(мВремяПодачиЧислом < мВремяВозвратаЧислом, 0, 3600 * 24);
	
	мМассивДнейПоФильтру = ПолучитьМассивДнейПоФильтру(фДатаНачала, фДатаОкончания, фДниНедели);
	мСтруктураДанныхПЛ = ПолучитьСтруктуруДанныхПЛ();
	мСтруктураПЛПериода = ПолучитьПутевыеЛистыЗаПериод(фТС, фДатаНачала, фДатаОкончания);
	Возврат ВыписатьНапечататьПутевыеЛистыНаСервере(мМассивДнейПоФильтру, мСтруктураДанныхПЛ, мСтруктураПЛПериода, фРазрешитьСовпадениеВремени, мВремяПодачиЧислом, мВремяВозвратаЧислом, мАддитивВторойСмены, фИдентификаторСтрокиЗаявки, пПечать);
КонецФункции

&НаСервереБезКонтекста
Функция ВыписатьНапечататьПутевыеЛистыНаСервере(пМассивДнейПоФильтру, пСтруктураДанныхПЛ, пМассивСтруктурТаблицыПЛ, пРазрешитьСовпадениеВремени, пВремяПодачиЧислом, пВремяВозвратаЧислом, пАддитивВторойСмены, пИдентификаторСтрокиЗаявки, пПечать)
	
	мТаблицаПЛ = Новый ТаблицаЗначений;
	мТаблицаПЛ.Колонки.Добавить("ДатаВыезда");
	мТаблицаПЛ.Колонки.Добавить("ПутевойЛист");
	Если пМассивСтруктурТаблицыПЛ.Количество() > 0 Тогда
		Для Каждого мЭлемент из пМассивСтруктурТаблицыПЛ Цикл
			мНоваястрока = мТаблицаПЛ.Добавить();
			ЗаполнитьЗначенияСвойств(мНоваястрока, мЭлемент);
		КонецЦикла;
	КонецЕсли;
	
	вСтруктура = Новый Структура;
	мМассивСозданныхПЛ = Новый Массив;
	Для каждого мДень из пМассивДнейПоФильтру Цикл	
		мДатаВыезда = мДень + (пВремяПодачиЧислом);
		
		мСтруктураОтбора = Новый Структура("ДатаВыезда", мДатаВыезда);
		мСтрокиТаблицыПутевых = мТаблицаПЛ.НайтиСтроки(мСтруктураОтбора);
		Если мСтрокиТаблицыПутевых <> Неопределено И мСтрокиТаблицыПутевых.Количество() > 0 Тогда
			пСтруктураДанныхПЛ.Вставить("ПутевойЛист", мСтрокиТаблицыПутевых[0].ПутевойЛист);
		Иначе
			пСтруктураДанныхПЛ.Вставить("ПутевойЛист", ПредопределенноеЗначение("Документ.уатПутевойЛист.ПустаяСсылка"));
		КонецЕсли;
		
		Если мСтрокиТаблицыПутевых = Неопределено Или мСтрокиТаблицыПутевых.Количество() = 0 Или пРазрешитьСовпадениеВремени Тогда
			мОбъектПЛ = СоздатьПЛ(мДатаВыезда, НачалоДня(мДатаВыезда + пАддитивВторойСмены) + пВремяВозвратаЧислом, пСтруктураДанныхПЛ);
			ЗафиксироватьФактВыписки(мДатаВыезда, мОбъектПЛ.Ссылка, пСтруктураДанныхПЛ);
			мМассивСозданныхПЛ.Добавить(мОбъектПЛ);
		ИНаче
			мТекстСообщения = "";
			мОбъектПЛ = ОбновитьДанныеПЛ(мТекстСообщения, пСтруктураДанныхПЛ);
			Если мОбъектПЛ <> Неопределено Тогда
				мМассивСозданныхПЛ.Добавить(мОбъектПЛ);
			КонецЕсли;
			Если мТекстСообщения <> "" Тогда
				Сообщить("" + Формат(мДатаВыезда, "ДЛФ=Д") + " " + мТекстСообщения);
			КонецЕсли;
		КонецЕсли;
	КонецЦикла;
	
	вМассивТД = Новый Массив;
	Если пПечать И мМассивСозданныхПЛ.Количество() > 0 Тогда
		Для Каждого мОбъектПутевогоЛиста Из мМассивСозданныхПЛ Цикл
			мТабличныйДокумент = Новый ТабличныйДокумент;
			мОбъектПутевогоЛиста.Печать("ПечататьВесьПутевойЛист", , Истина, , , мТабличныйДокумент);
			Если ТипЗнч(мТабличныйДокумент) = Тип("Массив") Тогда
				Для Каждого мЭлементМассиваТД Из мТабличныйДокумент Цикл
					вМассивТД.Добавить(мЭлементМассиваТД);
				КонецЦикла;
			Иначе
				вМассивТД.Добавить(мТабличныйДокумент);
			КонецЕсли;
			ЗафиксироватьФактПечати(мОбъектПутевогоЛиста.Ссылка, ТекущаяДата());
		КонецЦикла;
		вСтруктура.Вставить("МассивПечатныхФорм", вМассивТД);
	КонецЕсли;
	
	Возврат вСтруктура;
КонецФункции

&НаСервереБезКонтекста
Процедура ЗафиксироватьФактПечати(пПутевойЛист, пДата)
	РегистрыСведений.ПечатьПЛ.ЗафиксироватьФактПечати(пПутевойЛист, пДата);
КонецПроцедуры

&НаСервереБезКонтекста
Процедура ЗафиксироватьФактВыписки(пДатаВыписки, пПутевойЛист, пСтруктураРеквизитов)
	РегистрыСведений.ВыпискаПЛПоИдентификаторам.ЗафиксироватьФактВыписки(пДатаВыписки, пПутевойЛист, пСтруктураРеквизитов);
КонецПроцедуры