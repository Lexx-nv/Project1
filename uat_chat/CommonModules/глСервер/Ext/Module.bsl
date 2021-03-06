//===============================================
Процедура СинхроЗУП() Экспорт
	ОБр = ОБработки.СинхроЗУП.Создать();
	ОБр.Выгрузить();
КонецПроцедуры

Процедура СинхроЦентр() Экспорт
	
	ОБр = ОБработки.СинхроSQL.Создать();
	ОБр.Синхро();
	
КонецПроцедуры

Процедура СинхроБазы() Экспорт
	ОБр = ОБработки.ксОбменМеждуБазами.Создать();
	ОБр.Обмен();
КонецПроцедуры

Процедура СервисныеРаботы() Экспорт
	ОБр = ОБработки.СервисныеРаботы.Создать();
	ОБр.Алга();
КонецПроцедуры

Процедура СинхроРасходГСМ() Экспорт
	
	ОБр = ОБработки.СинхроSQL.Создать();
	ОБр.СинхроРазВДень();
	
	глСервер.АзурСправочник("КатегорииТехническогоРегламента","KATTS");
КонецПроцедуры

//==================================================
#Область РаботаСАЗУР

Функция СткПолучитьСоединение(НаАЗУР=Ложь) Экспорт
	
	Стк = Новый Структура();
	
	Если НаАЗУР = Истина Тогда
		Стк.Вставить("Сервер","azure1c.westeurope.cloudapp.azure.com");
		Стк.Вставить("Порт",80);
		Стк.Вставить("Логин","Serv");
		Стк.Вставить("Пароль","SERVgfhjkm");
	ИНаче
		Стк.Вставить("Сервер","192.168.40.9");
		Стк.Вставить("Порт",80);
		Стк.Вставить("Логин","1с_Максим");
		Стк.Вставить("Пароль","092222");
	КонецеСЛИ;
	

	
	Возврат Стк;
	
КонецФункции


Процедура АзурСправочник(ИмяСпр,Метод,СерверЮралс=Ложь,УдалятьЛишниеОбъекты=Ложь) Экспорт
	
	Если  СерверЮралс Тогда
		СткСоединение = глСервер.СткПолучитьСоединение();
		АдресРесурса = "/Urals_BUH/hs/invAPI/";
	ИНаче
		СткСоединение = глСервер.СткПолучитьСоединение(истина);
		АдресРесурса = "/portUC/hs/ksAPI/";
	КонецеСЛИ;
	
		Соединение = Новый HTTPСоединение(
        СткСоединение.Сервер, // сервер (хост)
        СткСоединение.Порт, // порт, по умолчанию для http используется 80, для https 443
        СткСоединение.Логин, // пользователь для доступа к серверу (если он есть)
        СткСоединение.Пароль, // пароль для доступа к серверу (если он есть)
        , // здесь указывается прокси, если он есть
        , // таймаут в секундах, 0 или пусто - не устанавливать
          // защищенное соединение, если используется https
    );
 
	Запрос = Новый HTTPЗапрос(АдресРесурса+Метод+"?idIzm="+РегистрыСведений.ДатыОбновления.идИзменения(ИмяСпр));
 
    Результат = Соединение.Получить(Запрос);
	
	Если Результат.КодСостояния <> 200 Тогда 
		Сообщить("Ошибка синхронизации: код "+Результат.КодСостояния);
		Сообщить(результат.ПолучитьТелоКакСтроку());
		Возврат ;
	КонецЕСЛИ;
	
	Рез = результат.ПолучитьТелоКакСтроку();
	Если Рез = "" ТОгда Возврат; КонецеСЛИ;
	
	Мас   = XMLзначение(Тип("ХранилищеЗначения"),рез).Получить();
	идИзм = Мас[0];
	Тбл = Мас[1];
	
	
	СинхроСправочникПоВерсииДанных(ИмяСпр,Тбл,УдалятьЛишниеОбъекты);
	
	РегистрыСведений.ДатыОбновления.ЗаписатьИдИзменения(ИмяСпр,идИзм);
	
КонецПроцедуры

Процедура СинхроСправочникПоВерсииДанных(имяСпр,Тбл,УдалятьЛишниеОбъекты=Ложь) экспорт
	
	
	
	Запрос = Новый Запрос;
	Запрос.УстановитьПараметр("Тбл",Тбл.скопировать(,"СсылкаGUID,ВерсияДанных"));
	Запрос.Текст = "
	| SELECT
	|   Т.СсылкаGUID,
	|   Т.ВерсияДанных
	| INTO врТбл
	| FROM &Тбл  Т
	|;
	|SELECT
	| 	Спр.ссылка
	|   ,Тбл.СсылкаGUID
	|
	|FROM  Справочник."+имяСпр+" Спр
	|LEFT OUTER JOIN РегистрСведений.ксСинхроИд РегИд ON РегИд.ссОбъекта = Спр.ссылка
	|FULL JOIN врТБл Тбл ON Тбл.СсылкаGUID = регИд.ид  
	|
	|WHERE  ТБл.ВерсияДанных <> регИд.верДанных 
	|   OR  Спр.ссылка IS NULL
	|   OR (Тбл.СсылкаGUID IS NULL и ISNULL(Спр.ПометкаУдаления,false) = Ложь) 
	|     
	|";
	
    запТбл = Запрос.Выполнить().Выгрузить();
	//Возврат;
	
	Для каждого запСтр из запТБл Цикл
		Если ЗначениеЗаполнено(запСтр.СсылкаGUID)=Ложь ТОгда
			Если УдалятьЛишниеОбъекты ТОгда
				запСтр.Ссылка.ПолучитьОбъект().Удалить();
			ИНаче
				Обк = запСтр.Ссылка.ПолучитьОбъект();
				Обк.Наименование = "удл"+Обк.Наименование;
				Обк.Записать();
				Обк.УстановитьПометкуУдаления(Истина);
			КонецЕсли;
			продолжить;
		КонецеСЛИ;
		
		текСтр = Тбл.Найти(запСтр.СсылкаGUID,"СсылкаGUID");
		
		сс = Справочники[имяСпр].ПолучитьСсылку(Новый УникальныйИдентификатор(текСтр.СсылкаGUID));
		Если Найти(СокрлП(сс),"бъект не найден")<>0 Тогда
			Обк = Справочники[имяСпр].СоздатьЭлемент();
			Обк.установитьСсылкуНового(сс);
		ИНаче
			Обк = сс.ПолучитьОбъект();
		КонецеслИ;
		
		ЗаполнитьЗначенияСвойств(Обк,текСтр);
		
		Обк.Записать();
		Сообщить("Записан "+Обк.Наименование+" "+Обк.Код);
		
		Если Обк.ПометкаУдаления <> текСтр.ПометкаУдаления ТОгда
			Обк.УстановитьПометкуУдаления(текСтр.ПометкаУдаления);
		КонецеСЛИ;
		
		
		Зап = РегистрыСведений.ксСинхроИД.СоздатьМенеджерЗаписи();
		Зап.ссОбъекта = Обк.ссылка;
		Зап.ид = Сокрлп(Обк.ссылка.УникальныйИдентификатор());
		Зап.верДанных = ТекСтр.ВерсияДанных;
		Зап.Записать();
		
	КонецЦикла;
	
	
КонецПроцедуры


#КонецОбласти


#Область ПрочиеДанные
Функция ПолучитьСоединение()
	
	  
	Соединение=Новый ComObject("ADODB.Connection");
	Соединение.CommandTimeout = 600;
	Соединение.ConnectionTimeout = 30;
	СтрСоединения = "Driver={SQL Server};Server=tcp:urals.database.windows.net,1433;Initial Catalog=SVOD;Persist Security Info=False;User ID=max;Password=1!qqqqqq;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;";//ПолучитьСтрокуСоединенияSQL();
	Попытка
		Соединение.Open(СтрСоединения);
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат Неопределено;
	КонецПопытки;
	
	
	Возврат Соединение;
	
КонецФункции

Функция ПолучитьОрг()
	
	Выб = Справочники.Организации.Выбрать();
	Если Метаданные.Справочники.Организации.Реквизиты.Найти("ОсновнаяОрганизация") <> Неопределено ТОгда
		Пока ВЫб.Следующий() Цикл
			ТекОрг = Выб.Наименование;
			Если Выб.ОсновнаяОрганизация = Истина ТОгда ПРервать; КонецеСЛИ;
		КонецЦикла;
	ИНАче
		Выб.Следующий();
		ТекОРг = Выб.Наименование;
	КонецеСЛИ;
	
	Возврат ТекОРг;
	
КонецФункции
#КонецОбласти
//==================================================
Процедура АлгаРазнарядка() Экспорт

	Если ПланыОбмена.ГлавныйУзел()<>Неопределено Тогда Возврат; КонецЕСлИ;
	ТекущаяДата = ТекущаяДата()+3600 * 10;
	
	Запрос = новый Запрос;
	Запрос.Текст = "
|SELECT
|Разнарядка.ТС, 
|Разнарядка.Колонна
|INTO врРазнарядка
|FROM  РегистрСведений.Разнарядка Разнарядка
|WHERE Разнарядка.Дата >= &Дт and Разнарядка.Дата < &Дт1 и Разнарядка.ТС <> Значение(Справочник.уатТС.ПустаяСсылка )
|
|;
|
|
|ВЫБРАТЬ DISTINCT
|		&Дт Дт,
|		СпрТС.ссылка ТС,
|		СпрТС.ГаражныйНомер ГарНом,
|		СпрТС.ГосударственныйНомер ГосНом,
|		СпрТС.ТипТС.Наименование ТипТС,
|		спрПодр.Наименование КАК Подр,
|	
|		CASE WHEN рег.ТС IS NULL THEN 0 ELSE 1 END колТС,
|		CASE WHEN Разнарядка.ТС IS NULL THEN 0 ELSE 1 END колРзн,
|		CASE WHEN рег.ТС IS NULL and Разнарядка.ТС IS NOT NULL THEN 1 ELSE 0 END колПрив
|	
|	ИЗ
|		РегистрСведений.уатМестонахождениеТС.СрезПоследних(&Дт, ) КАК Рег
|	FULL JOIN врРазнарядка Разнарядка  ON  Разнарядка.ТС = Рег.ТС 
|	
|	LEFT OUTER JOIN Справочник.уатТС спрТС ON спрТС.ссылка = ISNULL(Рег.ТС,Разнарядка.ТС)
|	LEFT OUTER JOIN Справочник.ПодразделенияОрганизаций спрПодр ON спрПодр.ссылка = ISNULL(Рег.Подразделение,Разнарядка.Колонна)
|	
|	WHERE 	                               
|	   ((Рег.Состояние.ЗапретитьВыпискуПЛ = Ложь и Рег.Состояние<>Значение(Справочник.уатСостояниеТС.Привлеченный) и Рег.ТС.ТипТС.НеВыводитьВТабельТС <> Истина) или Рег.ТС IS NULL)
|
|";
	
	Запрос.УстановитьПараметр("Дт",НачалоДня(ТекущаяДата));
	Запрос.УстановитьПараметр("Дт1",КонецДня(ТекущаяДата)+1);
	Тбл = Запрос.Выполнить().Выгрузить();
	  
	
	  
Соединение = ПолучитьСоединение();	
ИмяБазы = "disorderTS";
ТекстЗапроса  = "INSERT INTO [dbo].["+ИмяБазы+"] VALUES ";
ном = 1;

ТекДт = "CONVERT(DateTime,'"+Формат(ТекущаяДата,"ДФ=yyyyMMdd")+"',104)";

Орг = ПолучитьОрг();

Т = Тбл.Скопировать();
Т.свернуть("Дт","");

Для каждого С из Т Цикл
	
	Дт = "CONVERT(DateTime,'"+Формат(С.Дт,"ДФ=yyyyMMdd")+"',104)";
	дтМес = "CONVERT(DateTime,'"+Формат(НачалоМесяца(С.Дт),"ДФ=yyyyMMdd")+"',104)";
	Попытка
		Соединение.Execute("DELETE "+ИмяБазы+" WHERE org = N'"+Орг+"'");
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
		
	мас = Тбл.НайтиСтроки(Новый Структура("Дт",С.Дт));
	
	Для а=1 по мас.Количество() Цикл
		Стр = мас[а-1];
		
		ТекстЗапроса = ТекстЗапроса + "
		|(N'"+Орг+"', 
		|N'',
		|N'"+Стр.Подр+"',
		|N'"+Стр.ГарНом+"',
		|N'"+Стр.ТС+"',
		|N'"+Стр.ГосНом+"',
		|N'"+Стр.ТипТС+"',
		|"+Формат(Стр.КолТС,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.КолРзн,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.КолРзн-Стр.КолПрив,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.колТС - (Стр.КолРзн-Стр.КолПрив),"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.КолПрив,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Дт+",
		|"+дтМес+",
		|GETDATE()
		|) ";
		
		Если а=мас.Количество() или ном = 500 ТОгда
			ТекстЗапроса = ТекстЗапроса+"; ";
			ном = 1;
			Попытка
				Соединение.Execute(ТекстЗапроса);
			Исключение
				Сообщить(ОписаниеОшибки());
				Возврат;
			КонецПопытки;
			ТекстЗапроса  = "INSERT INTO [dbo].["+ИмяБазы+"] VALUES ";
		ИНАче
			ТекстЗапроса = ТекстЗапроса+", ";
		КонецЕСЛИ;
		
		ном=ном+1;
		
	КонецЦиклА;
	
	Сообщить("Синхро [dbo].["+ИмяБазы+"] выпонена за "+Дт);
КонецЦиклА;

АлгаРазнарядкаПер();
	
КонецПроцедуры
//==================================================
Процедура АлгаРазнарядкаПер() Экспорт

	Если ПланыОбмена.ГлавныйУзел()<>Неопределено Тогда Возврат; КонецЕСлИ;
	
	ТекущаяДата = ТекущаяДата() + 3600*10;
	
	Запрос = новый Запрос;
	Запрос.Текст = "
|ВЫБРАТЬ
|		уатМестонахождениеТССрезПоследних.ТС,
|		уатМестонахождениеТССрезПоследних.Подразделение пПодразделение,
|		уатМестонахождениеТССрезПоследних.Владелец КаВладелец,
|		уатМестонахождениеТССрезПоследних.Состояние пСос,
|		НачалоПериода(уатМестонахождениеТССрезПоследних.Период,День) Период
|		INTO ВРТбл
|	ИЗ
|		РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДтДляПодр) КАК уатМестонахождениеТССрезПоследних
|	Where Состояние.ЗапретитьВыпискуПЛ = Ложь	
|	    и Состояние<>Значение(Справочник.уатСостояниеТС.Привлеченный)	
|	    и ТС.ТипТС.НеВыводитьВТабельТС <> Истина
|		
|	UNION ALL
|		
|	
|	ВЫБРАТЬ
|		уатМестонахождениеТС.ТС,
|		уатМестонахождениеТС.Подразделение,
|		уатМестонахождениеТС.Владелец,
|		уатМестонахождениеТС.Состояние,
|		НачалоПериода(уатМестонахождениеТС.Период,День)
|	ИЗ
|		РегистрСведений.уатМестонахождениеТС КАК уатМестонахождениеТС
|	WHERE Период > &ДтДляПодр и Период < &Дт1
|	    и Состояние.ЗапретитьВыпискуПЛ = Ложь	
|	    и Состояние<>Значение(Справочник.уатСостояниеТС.Привлеченный)	
|	    и ТС.ТипТС.НеВыводитьВТабельТС <> Истина
|	;
|		
|	SELECT  DISTINCT
|		Тбл.ТС,
|		Тбл.пПодразделение,
|		Тбл.КаВладелец,
|		Тбл.пСос,
|		Тбл.Период,
|		MIN(ISNULL(Т.Период,&Дт1)) ПериодКон,
|		Тбл.Период изначДт
|	INTO ВРТбл1	
|	FROM ВРТбл Тбл 
|	LEFT OUTER JOIN ВРТбл Т ON Т.ТС = Тбл.ТС и Т.Период > Тбл.Период
|	GROUP BY		
|		Тбл.ТС,
|		Тбл.пПодразделение,
|		Тбл.КаВладелец,
|		Тбл.пСос,
|		Тбл.Период
|	;	
|	SELECT DISTINCT
|		Тбл.ТС,
|		Тбл.пПодразделение,
|		Тбл.КаВладелец,
|		Тбл.пСос пСостояние,
|		Тбл.Период,
|		Тбл.ПериодКон
|	INTo ВРПодр
|	FROM ВРТбл1 Тбл
|	INNER JOIN (SELECT ТС,Период,MAX(изначДт) изНачДт FROM ВРТбл1 Т1 GROUP BY ТС,Период) Т ON Т.ТС = Тбл.ТС и Т.Период = ТБл.Период и Т.ИзначДт = Тбл.ИзначДт
|	
|	;

|ВЫБРАТЬ 
|    ДатаКалендаря Дт,
|	1  колТС,
|	0  колРзн,	
|	0  колЗвк,	
|	0  колВыпПоЗвк,	
|	0  колПеч,	
|	0  колКППвзд,
|	0  колКППвоз
|INTO врИтог	
|ИЗ
|	РегистрСведений.уатРегламентированныйПроизводственныйКалендарь КАК уатРегламентированныйПроизводственныйКалендарь
|INNER JOIN ВРПодр тблПодр ON тблПодр.Период    <= ДатаКалендаря 
|                           и тблПодр.ПериодКон >  ДатаКалендаря
|                           
|WHERE
|   ДатаКалендаря >= &ДтДляПодр and ДатаКалендаря < &Дт1
|	
|UNION ALL
|	
|SELECT
|	РегРзн.Дата,
|	0  колТС,	
|	1  колРзн,	
|	0  колЗвк,	
|	0  колВыпПоЗвк,	
|	0  колПеч,	
|	0  колКППвзд,
|	0  колКППвоз

|FROM РегистрСведений.Разнарядка РегРзн
|WHERE РегРзн.Дата >= &ДтДляПодр and РегРзн.Дата < &Дт1 и РегРзн.ТС <> Значение(Справочник.уатТС.ПустаяСсылка)
|	
|UNION ALL
|	
|SELECT
|	РегВыпПоРзн.ДатаВыписки Дата,
|	0  колТС,	
|	0  колРзн,	
|	0  колЗвк,	
|	1  колВыпПоЗвк,	
|	0  колПеч,	
|	0  колКППвзд,
|	0  колКППвоз
|	
|FROM РегистрСведений.ВыпискаПЛПоИдентификаторам РегВыпПоРзн
|WHERE РегВыпПоРзн.ДатаВыписки >= &ДтДляПодр and РегВыпПоРзн.ДатаВыписки < &Дт1
|	
|UNION ALL
|	
|SELECT
|	Док.Дата Дата,
|	0  колТС,	
|	0  колРзн,	
|	0  колЗвк,	
|	0  колВыпПоЗвк,	
|	1  колПеч,	
|	0  колКППвзд,
|	0  колКППвоз

|FROM РегистрСведений.ПечатьПЛ РегПеч
|INNER JOIN Документ.уатПутевойЛист Док ON Док.ссылка = РегПеч.ПутевойЛист	
|и Док.Дата >= &ДтДляПодр and Док.Дата < &Дт1
|	
|UNION ALL
|	
|SELECT
|	Период,
|	0  колТС,	
|	0  колРзн,	
|	КоличествоТСОборот  колЗвк,	
|	0  колВыпПоЗвк,	
|	0  колПеч,	
|	0  колКППвзд,
|	0  колКППвоз

|FROM РегистрНакопления.ДополнительныеСведенияЗаявок.Обороты(НАЧАЛОПЕРИОДА(&ДтДляПодр, ДЕНЬ), &ТекДт, День) КАК ДополнительныеСведенияЗаявокОбороты

|;

|SELECT
|   НачалоПериода(Дт,ДЕНЬ) Дт,
|	SUM(колТС) колТС,
|	SUM(колРзн)  колРзн,	
|	SUM(колЗвк)  колЗвк,	
|	SUM(колВыпПоЗвк)  колВыпПоЗвк,	
|	SUM(колПеч)  колПеч,	
|	SUM(колКППвзд)  колКППвзд,
|	SUM(колКППвоз)  колКППвоз


|FROM врИтог Тбл	
|GROUP BY НачалоПериода(Дт,ДЕНЬ)
|";
	
	Запрос.УстановитьПараметр("ДтДляПодр",НачалоДня(ТекущаяДата - 3600*24*5 ));
	Запрос.УстановитьПараметр("Дт1",КонецДня(ТекущаяДата)+1);
	Запрос.УстановитьПараметр("ТекДт",КонецДня(ТекущаяДата));
	Тбл = Запрос.Выполнить().Выгрузить();
	  
	
	  
Соединение = ПолучитьСоединение();	
ИмяБазы = "disorderTSper";
ТекстЗапроса  = "INSERT INTO [dbo].["+ИмяБазы+"] VALUES ";
ном = 1;

ТекДт = "CONVERT(DateTime,'"+Формат(ТекущаяДата,"ДФ=yyyyMMdd")+"',104)";

Орг = ПолучитьОрг();

Т = Тбл.Скопировать();
Т.свернуть("Дт","");

Для каждого С из Т Цикл
	
	Дт = "CONVERT(DateTime,'"+Формат(С.Дт,"ДФ=yyyyMMdd")+"',104)";
	дтМес = "CONVERT(DateTime,'"+Формат(НачалоМесяца(С.Дт),"ДФ=yyyyMMdd")+"',104)";
	Попытка
		Соединение.Execute("DELETE "+ИмяБазы+" WHERE org = N'"+Орг+"' and dt = "+Дт );
	Исключение
		Сообщить(ОписаниеОшибки());
		Возврат;
	КонецПопытки;
		
	мас = Тбл.НайтиСтроки(Новый Структура("Дт",С.Дт));
	
	Для а=1 по мас.Количество() Цикл
		Стр = мас[а-1];
		
		ТекстЗапроса = ТекстЗапроса + "
		|(N'"+Орг+"', 
		|"+Формат(Стр.КолТС,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.КолРзн,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.КолЗвк,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.колВыпПоЗвк,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.колПеч,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.колКППвзд,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Формат(Стр.колКППвоз,"ЧРД=.; ЧН=0; ЧГ=0")+",
		|"+Дт+",
		|"+дтМес+",
		|GETDATE()
		|) ";
		
		Если а=мас.Количество() или ном = 500 ТОгда
			ТекстЗапроса = ТекстЗапроса+"; ";
			ном = 1;
			Попытка
				Соединение.Execute(ТекстЗапроса);
			Исключение
				Сообщить(ОписаниеОшибки());
				Возврат;
			КонецПопытки;
			ТекстЗапроса  = "INSERT INTO [dbo].["+ИмяБазы+"] VALUES ";
		ИНАче
			ТекстЗапроса = ТекстЗапроса+", ";
		КонецЕСЛИ;
		
		ном=ном+1;
		
	КонецЦиклА;
	
	Сообщить("Синхро [dbo].["+ИмяБазы+"] выпонена за "+Дт);
КонецЦиклА;


	
КонецПроцедуры
//==================================================
Процедура ЗагрузкаТемпературы() Экспорт
	 РегистрыСведений.Температуры.ЗагрузитьТемпературу();
КонецПроцедуры
//==================================================
Процедура Синхро3разаВДень() Экспорт
	АлгаРазнарядка();
КонецПроцедуры
//==================================================
Процедура ЗагрузитьДанныеБСМТС() Экспорт
	Обработки.ПолучениеДанныхИзБСМТС.ПолучитьДанныеБСМТС();
	//ОБр = ОБработки.ПолучениеДанныхИзБСМТС.Создать();
	//ОБр.ВыполнитьЗагрузку();
КонецПроцедуры
