Перем БД,ТекФорма;


Процедура ДобавитьВДерево(Вид,ОБк,ВидОпер) 
	
	Если ТекФорма=Неопределено ТОгда Возврат; КонецеСЛИ;
	
	Если ТБлОбк.Колонки.Количество()=0 ТОгда
		ТблОбк.Колонки.Добавить("Вид",Новый ОписаниеТипов("Строка"));
		ТблОбк.Колонки.Добавить("Обк");
		ТблОбк.Колонки.Добавить("ВидОпер",Новый ОписаниеТипов("Строка"));
	КонецесЛИ;
	
	Стр = ТблОбк.Добавить();
	Стр.Вид =Вид;
	Стр.Обк = Обк;
	Стр.ВидОпер = ВидОпер;
	ТекФорма.Обновить();
	
КонецПроцедуры

Функция ПолучитьСсылку(оОбк,ВидСпр)
	
	Попытка
	  оГУИД = БД.STRING(оОБк.ссылка.УникальныйИдентификатор());
  Исключение
	              Возврат Неопределено;
	  КонецПопытки;
	  Гуид = Новый УникальныйИдентификатор(оГУИД);
	  сс = Справочники[ВидСпр].ПолучитьСсылку(ГУИД);
	  
	  Возврат сс;
	
  КонецФункции

Функция ПолучитьСсылкуВР(оОбк)
	
	Если оОбк.уатВыгружать = ложь Тогда Возврат Неопределено; КонецЕслИ;
	
	  оГУИД = БД.STRING(оОБк.ссылка.УникальныйИдентификатор());
	  Гуид = Новый УникальныйИдентификатор(оГУИД);
	  сс = ПланыВидовРасчета.уатОсновныеНачисления.ПолучитьСсылку(ГУИД);
	  Если Найти(СокрлП(сс),"<Объект не найден")<>0 ТОгда
			Обк = ПланыВидовРасчета.уатОсновныеНачисления.СоздатьВидРасчета();
			Обк.Наименование = оОбк.Наименование;
			Обк.ОбменДанными.Загрузка = Истина;
			Обк.УстановитьСсылкуНового(сс);
			Обк.Записать();
			сс = Обк.Ссылка;
	  конецЕСЛИ;  
	  
	  Возврат сс;
	
  КонецФункции
  
Функция ПолучитьПер(оОбк,Вид)
	 
	 Зн = БД.XMLСтрока(оОбк);
	 Если Зн = "" ТОгда
		Возврат Перечисления[Вид].ПустаяСсылка();
	 ИНаче
		Возврат Перечисления[Вид][Зн];
	 КонецесЛИ;
	  
КонецФункции

Процедура ЗагрузитьСотр(оОБк,ВидСпр)
	
	ВидОперации = "Изменен";
	
	сс =  ПолучитьСсылку(оОбк,ВидСпр);
	Если Найти(СокрлП(сс),"<Объект не найден")<>0 ТОгда
		Если оОбк.IsFolder ТОгда
			Эл = Справочники[ВидСпр].СоздатьГруппу();
		ИНАче
			Эл = Справочники[ВидСпр].СоздатьЭлемент();
		Конецесли;
		Эл.УстановитьСсылкуНового(сс);
		ВидОперации = "Новый";
	ИНаче
		Эл = сс.ПолучитьОбъект();
	КонецеСЛИ;
	
	
	Эл.Код = оОБк.Код;
	Эл.Наименование = оОБк.Наименование;
	
	Если оОбк.Родитель.Пустая()=Ложь ТОгда
		Эл.РОдитель = ПолучитьСсылку(оОбк.Родитель,ВидСпр);
	КонецеСЛИ;
	
	Если оОбк.Владелец<>Неопределено ТОгда
		п=БД.XMLТипЗнч(оОбк.Владелец).TypeName; 
		пТипСпр = Сред(п,Найти(п,".")+1);
		Эл.Владелец = ПолучитьСсылку(оОбк.Владелец,пТипСпр);
	КонецеСЛИ;
	
	Если Эл.ЭтоГРуппа ТОгда
	ИНачеЕсли ВидСпр = "уатСотрудники" ТОгда
		Эл.Физлицо = ПолучитьСсылку(оОБк.Физлицо,"ФизическиеЛица");
		Эл.Организация = ПолучитьСсылку(оОбк.Организация,"Организации");
		Эл.ДатаПриема = оОбк.ДатаПриемаНаРаботу;
		Эл.ДатаУвольнения = оОбк.ДатаУвольнения;
	ИНачеЕсли ВидСпр = "ФизическиеЛица" ТОгда
		Эл.ДатаРождения = оОбк.ДатаРождения;
	ИНачеЕсли ВидСпр = "ПодразделенияОрганизаций" ТОгда
		Эл.Владелец = ПолучитьСсылку(оОбк.Владелец,"Организации");
		Эл.Расформировано = оОбк.Расформировано;
	КонецесЛИ;
	
	Эл.ОбменДанными.Загрузка = Истина;
	Эл.Записать();
	
	Если Эл.ПометкаУдаления <> оОбк.ПометкаУдаления ТОгда
		Эл.УстановитьПометкуУдаления(оОбк.ПометкаУдаления);
	КонеЦЕСЛИ;
	
	ДобавитьВДерево(ВидСпр,Эл.ССылка,ВидОперации);
	
КонецПроцедуры

Процедура ЗагрузитьРегСведФИО(оОбк)
	
	Наб = РегистрыСведений.ФИОФизЛиц.СоздатьНаборЗаписей();
	ТекФЛ = Неопределено;
	
	ДЛя каждого оЭЛ из оОбк.Filter Цикл
		Отб = Наб.Отбор[оЭл.Name];
		Если СокрлП(оЭл.Value) = "COMОбъект" ТОгда
			Отб.Значение = ПолучитьСсылку(оЭл.Value,"ФизическиеЛица");
			ТекФЛ = Отб.Значение;
		ИНАче
			Отб.Значение = оЭл.Value;
		КонецеСЛИ;
		Отб.Использование = Истина;
	КонецЦикла;
	
	ДЛя каждого оЗап из оОбк.ThisObject Цикл
		Зап = Наб.Добавить();
		Зап.Период = оЗап.Period;
		Зап.Имя = оЗап.Имя;
		Зап.Отчество = оЗап.Отчество;
		Зап.Фамилия = оЗап.Фамилия;
		Зап.ФизЛицо = ТекФЛ;
	КонецЦикла;
	
	Наб.Записать();
	
	ДобавитьВДерево("Регистр.ФИО",ТекФЛ,"Изменен");
	
	
КонецПроцедуры

Процедура ЗагрузитьРегСведПаспорт(оОбк)
	
	Наб = РегистрыСведений.ПаспортныеДанныеФизЛиц.СоздатьНаборЗаписей();
	ТекФЛ = Неопределено;
	
	ДЛя каждого оЭЛ из оОбк.Filter Цикл
		Отб = Наб.Отбор[оЭл.Name];
		Если СокрлП(оЭл.Value) = "COMОбъект" ТОгда
			Отб.Значение = ПолучитьСсылку(оЭл.Value,"ФизическиеЛица");
			ТекФЛ = Отб.Значение;
		ИНАче
			Отб.Значение = оЭл.Value;
		КонецеСЛИ;
		Отб.Использование = Истина;
	КонецЦикла;
	
	ДЛя каждого оЗап из оОбк.ThisObject Цикл
		Зап = Наб.Добавить();
		Зап.Период = оЗап.Period;
		Зап.ДокументВид = Справочники.ДокументыУдостоверяющиеЛичность.ИМНС21;
		Зап.ДокументСерия = оЗап.ДокументСерия;
		Зап.ДокументНомер = оЗап.ДокументНомер;
		Зап.ДокументДатаВыдачи = оЗап.ДокументДатаВыдачи;
		Зап.ДокументКемВыдан = оЗап.ДокументКемВыдан;
		Зап.ДокументКодПодразделения = оЗап.ДокументКодПодразделения;
		Зап.ДатаРегистрацииПоМестуЖительства = оЗап.ДатаРегистрацииПоМестуЖительства;
		Зап.ФизЛицо = ТекФЛ;
	КонецЦикла;
	
	Наб.Записать();
	
	ДобавитьВДерево("Регистр.ПаспортныеДанныеФизЛиц",ТекФЛ,"Изменен");
	
	
КонецПроцедуры

Процедура ЗагрузитьРегСведСевНадбавка(оОбк)
	
	Наб = РегистрыСведений.СведенияОГрафиках.СоздатьНаборЗаписей();
	ТекФЛ = Неопределено;
	
	ДЛя каждого оЭЛ из оОбк.Filter Цикл
		Отб = Наб.Отбор[оЭл.Name];
		Если СокрлП(оЭл.Value) = "COMОбъект" ТОгда
			Отб.Значение = ПолучитьСсылку(оЭл.Value,"ФизическиеЛица");
			ТекФЛ = Отб.Значение;
		ИНачеЕСли оЭл.Name = "Период" Тогда
			Отб.Значение = ?(оЭл.Value<Дата(1980,1,1),Дата(1980,1,1),оЭл.Value);;
		ИНАче
			Отб.Значение = оЭл.Value;
		КонецеСЛИ;
		Отб.Использование = Истина;
	КонецЦикла;
	
	ДЛя каждого оЗап из оОбк.ThisObject Цикл
		Зап = Наб.Добавить();
		Зап.Период = ?(оЗап.Period=Дата(1,1,1),Дата(1980,1,1),оЗап.Period);
		Зап.ФизЛицо = ТекФЛ;
		Если БД.XMLСтрока(оЗап.ПорядокНачисленияСеверныхНадбавок) = "Группа3Вахтовики" Тогда
			Зап.ГрафикРаботы = Справочники.уатГрафикиРаботы.Вахта;
		ИНачеЕсли БД.XMLСтрока(оЗап.ПорядокНачисленияСеверныхНадбавок) = "Группа3ВахтовикиМестные" Тогда
			Зап.ГрафикРаботы = Справочники.уатГрафикиРаботы.ВахтаМестные;
		ИНАче
			Зап.ГрафикРаботы = Справочники.уатГрафикиРаботы.Основной;
		КонецЕСЛИ;
	КонецЦикла;
	
	Наб.Записать();
	
	ДобавитьВДерево("Регистр.СведенияОГрафиках",ТекФЛ,"Изменен");
	
	
КонецПроцедуры

Процедура ЗагрузитьРегСведКонтакт(оОбк)
	
	Наб = РегистрыСведений.КонтактнаяИнформация.СоздатьНаборЗаписей();
	ТекФЛ = Неопределено;
	
	//Объект
	оЭл = оОбк.Filter["Объект"];
	Если оЭл.Value.Метаданные().Имя <> "ФизическиеЛица" ТОгда Возврат; КонецЕСЛИ;
	Отб = Наб.Отбор["Объект"];
	Отб.Значение = ПолучитьСсылку(оЭл.Value,"ФизическиеЛица");
	Отб.Использование = Истина;
	ТекОбк = Отб.Значение;
	
	//Вид
	оЭл = оОбк.Filter["Вид"];
	Отб = Наб.Отбор["Вид"];
	Отб.Значение = ПолучитьСсылку(оЭл.Value,"ВидыКонтактнойИнформации");
	Отб.Использование = Истина;
	ТекВид = Отб.Значение;
	
	//Тип
	оЭл = оОбк.Filter["Тип"];
	Отб = Наб.Отбор["Тип"];
	Отб.Значение = ПолучитьПер(оЭл.Value,"ТипыКонтактнойИнформации");//Перечисления.ТипыКонтактнойИнформации[БД.XMLСтрока(оЭл.Value)];
	Отб.Использование = Истина;
	ТекТип = Отб.Значение;
	
	ДЛя каждого оЗап из оОбк.ThisObject Цикл
		Зап = Наб.Добавить();
		Зап.Объект = ТекОбк;
		Зап.Тип = ТекТип;
		Зап.Вид = ТекВид;
		
		Зап.Представление = оЗап.Представление;
		ДЛя а=1 по 10 Цикл
			Зап["Поле"+а] = оЗап["Поле"+а];
		КонецЦикла;
		Зап.Комментарий = оЗап.Комментарий;
		Зап.ЗначениеПоУмолчанию = оЗап.ЗначениеПоУмолчанию;
		Зап.ТипДома = ПолучитьПер(оЗап.ТипДома,"ТипыДомов");//Перечисления.ТипыДомов[БД.XMLСтрока(оЗап.ТипДома)];
		Зап.ТипКорпуса  = ПолучитьПер(оЗап.ТипКорпуса,"ТипыКорпусов");//Перечисления.ТипыКорпусов[БД.XMLСтрока(оЗап.ТипКорпуса)];
		Зап.ТипКвартиры = ПолучитьПер(оЗап.ТипКвартиры,"ТипыКвартир");//Перечисления.ТипыКвартир[БД.XMLСтрока(оЗап.ТипКвартиры)];
		
	КонецЦикла;
	
	Наб.Записать();
	
	ДобавитьВДерево("Регистр.КонтактнаяИнформация",ТекОБк,"Изменен");

	
КонецПроцедуры

Процедура ЗагрузитьРегСведРабОрг(оМасСотр,МасУД)
	
	Запрос = БД.NewObject("Запрос");
	Запрос.Текст = "ВЫБРАТЬ
	               |	РаботникиОрганизаций.Период,
	               |	РаботникиОрганизаций.Регистратор,
	               |	РаботникиОрганизаций.Сотрудник,
	               |	РаботникиОрганизаций.Организация,
	               |	РаботникиОрганизаций.ПодразделениеОрганизации,
	               |	РаботникиОрганизаций.Должность,
	               |	РаботникиОрганизаций.ПодразделениеОрганизацииЗавершения,
	               |	РаботникиОрганизаций.ДолжностьЗавершения,
	               |	РаботникиОрганизаций.ГрафикРаботы,
	               |	РаботникиОрганизаций.ГрафикРаботыЗавершения,
	               |	РаботникиОрганизаций.Разряд,
	               |	РаботникиОрганизаций.РазрядЗавершения,
	               |	РаботникиОрганизаций.ПериодЗавершения
	               |ИЗ
	               |	РегистрСведений.РаботникиОрганизаций КАК РаботникиОрганизаций
	               |ГДЕ
	               |	РаботникиОрганизаций.Сотрудник В(&Мас)
				   |ORDER BY Сотрудник,Период";
				  Запрос.УстановитьПараметр("Мас",оМасСОтр);
				  оТбл = Запрос.Выполнить().Выгрузить();
	оСОтр= Неопределено;			  
	Наб = Неопределено;
	пСотр = Неопределено;
	пОрг = Неопределено;
	
	ВсегоКол = оТбл.Количество()+МасУд.КОличество();
	ДЛя а=1 по оТбл.Количество() Цикл
		
		ИндикаторКадры = а/ВсегоКол*100;
		
		оСТр = оТБл.Получить(а-1);
		
		Если оСТр.Сотрудник <> оСотр ТОгда
			Если Наб <> Неопределено ТОгда
				Наб.Записать();
				ДобавитьВДерево("Регистр.уатСведенияОСотрудниках",пСОтр,"Изменен");
			КонецеСЛИ;
			
			оСотр = оСтр.СОтрудник;
			
			пСотр = ПолучитьСсылку(оСТр.Сотрудник,"уатСОтрудники");
			пОрг  = ПолучитьСсылку(оСТр.Организация,"Организации");
			
			Наб = РегистрыСведений.уатСведенияОСотрудниках.СоздатьНаборЗаписей();
			Наб.Отбор.Сотрудник.Значение = пСОтр;
			Наб.Отбор.Сотрудник.Использование = Истина;
			Наб.Отбор.Организация.Значение = пОРг;
			Наб.Отбор.Организация.Использование = Истина;
			Наб.ОбменДанными.Загрузка = Истина;
			
		КонецесЛИ;
		
		Зап = Наб.Добавить();
		Зап.Сотрудник = пСОтр;
		Зап.Организация = пОРг;
		
		Зап.Период = оСТр.Период;
		Зап.идДОк = БД.STRING(оСТр.Регистратор.УникальныйИдентификатор());
		Зап.ПодразделениеОрганизации = ПолучитьСсылку(оСТр.ПодразделениеОрганизации,"ПодразделенияОрганизаций");
		Зап.Должность = ПолучитьСсылку(оСТр.Должность,"ДолжностиОрганизаций");
		Зап.ВидРасчета = ПолучитьСсылкуВР(оСТр.Разряд);
		
		Если а<>оТбл.Количество() ТОгда
			оСтр1 = оТбл.Получить(а);
		ИНаче
			оСТр1 = Неопределено;
		КонецЕсли;
		
		Если оСТр.ПериодЗавершения <> Дата(1,1,1) 
			и (   оСТр1 = Неопределено 
			      или
			     (оСТр.ПериодЗавершения < оСтр1.Период и оСотр = оСТр1.СОтрудник)
				  или
				  оСотр <> оСТр1.СОтрудник
			)ТОгда
			
		Зап = Наб.Добавить();
		Зап.Сотрудник = пСОтр;
		Зап.Организация = пОРг;
		
		Зап.Период = оСТр.ПериодЗавершения;
		Зап.ПодразделениеОрганизации = ПолучитьСсылку(оСТр.ПодразделениеОрганизацииЗавершения,"ПодразделенияОрганизаций");
		Зап.Должность = ПолучитьСсылку(оСТр.ДолжностьЗавершения,"ДолжностиОрганизаций");
		Зап.ВидРасчета = ПолучитьСсылкуВР(оСТр.РазрядЗавершения);
		
		КонецеСЛИ;
	КонецЦИкла;
	
	Если Наб <> Неопределено ТОгда
		Наб.Записать();
		ДобавитьВДерево("Регистр.уатСведенияОСотрудниках",пСОтр,"Изменен");
	КонецеСЛИ;
	
	
	
	//Удаление
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	уатСведенияОСотрудниках.Период,
	               |	уатСведенияОСотрудниках.Сотрудник,
	               |	уатСведенияОСотрудниках.Организация,
	               |	уатСведенияОСотрудниках.идДОк
	               |ИЗ
	               |	РегистрСведений.уатСведенияОСотрудниках КАК уатСведенияОСотрудниках
				   |WHERE идДОк в (&Мас)";
				   Запрос.УстановитьПараметр("Мас",МасУД);
				   тбл = Запрос.Выполнить().Выгрузить();
				   
				   
	ДЛя каждого стр из Тбл ЦИкл
					   
		а=а+1;
		ИндикаторКадры = а/ВсегоКол*100;
		
		Наб = РегистрыСведений.уатСведенияОСотрудниках.СоздатьНаборЗаписей();
		Наб.Отбор.Сотрудник.Значение = Стр.Сотрудник;
		Наб.Отбор.Сотрудник.Использование = Истина;
		Наб.Отбор.Организация.Значение = Стр.организация;
		Наб.Отбор.Организация.Использование = Истина;
		Наб.Отбор.Период.Значение = Стр.Период;
		Наб.Отбор.Период.Использование = Истина;
		Наб.Прочитать();
		Для аЗап=-Наб.Количество() по -1 ЦИкл
			Зап = Наб[-аЗап-1];
			Если Зап.идДОк = Стр.идДок ТОгда
				Наб.Удалить(-аЗап-1);	
			КонецЕСЛИ;
		КонецЦикла;
		
		ДобавитьВДерево("Регистр.уатСведенияОСотрудниках",Стр.Сотрудник,"Удален");
		Наб.ОбменДанными.Загрузка = Истина;
		Наб.Записать();
		
	КонецЦИкла;
	
	ИндикаторКадры=100;
	
КонецПроцедуры

Процедура УдалитьРегСведРабОрг(оМасСотр,МасУД)
	
	
	
КонецПроцедуры

Процедура Тарифы(БД)
	

	Запрос = БД.NewObject("Запрос");
	Запрос.Текст = "
|	//Соберем первоначальную таблицу плана
|
|ВЫБРАТЬ
|	РаботникиОрганизаций.Сотрудник,
|	РаботникиОрганизаций.ТарифныйРазряд1,
|	РаботникиОрганизаций.Показатель1,
|	РаботникиОрганизаций.Период Дт
|INTO ВРТбл	
|ИЗ
|	РегистрСведений.ПлановыеНачисленияРаботниковОрганизаций КАК РаботникиОрганизаций
|ГДЕ
//|	РаботникиОрганизаций.ТарифныйРазряд1 <> Значение(Справочник.ТарифныеРазряды.ПустаяСсылка) 
|	РаботникиОрганизаций.ВидРасчетаИзмерение.Код IS NULL 
|	и  (Сотрудник.ДатаУвольнения > ДатаВремя(2013,1,1) или Сотрудник.ДатаУвольнения = ДатаВремя(1,1,1))
|
|UNION ALL
|
|ВЫБРАТЬ
|	ПлановыеНачисленияРаботников.Сотрудник,
|	ПлановыеНачисленияРаботников.ТарифныйРазряд1Завершения,
|	ПлановыеНачисленияРаботников.Показатель1Завершения,
|	ПлановыеНачисленияРаботников.ПериодЗавершения
|ИЗ
|	РегистрСведений.ПлановыеНачисленияРаботниковОрганизаций КАК ПлановыеНачисленияРаботников
|ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.ПлановыеНачисленияРаботниковОрганизаций КАК ВременныеПлановыеНачисленияРаботников
|	ПО ПлановыеНачисленияРаботников.Организация = ВременныеПлановыеНачисленияРаботников.Организация
|	 И ПлановыеНачисленияРаботников.Сотрудник = ВременныеПлановыеНачисленияРаботников.Сотрудник
|	 И ПлановыеНачисленияРаботников.ВидРасчетаИзмерение = ВременныеПлановыеНачисленияРаботников.ВидРасчетаИзмерение
|	 И ПлановыеНачисленияРаботников.Период < ВременныеПлановыеНачисленияРаботников.Период
|	 И ПлановыеНачисленияРаботников.ПериодЗавершения >= ВременныеПлановыеНачисленияРаботников.Период
|ГДЕ
|	ПлановыеНачисленияРаботников.ВидРасчетаИзмерение.Код IS NULL И
|	ПлановыеНачисленияРаботников.ПериодЗавершения <> ДатаВремя(1,1,1) И
// ---=== Ограничение, т.к. уже работали ===---
|	ПлановыеНачисленияРаботников.ПериодЗавершения >= ДатаВремя(2013,1,1) И
// ---=== Ограничение, т.к. уже работали ===---
|	(ПлановыеНачисленияРаботников.Сотрудник.ДатаУвольнения > ДатаВремя(2013,1,1) или ПлановыеНачисленияРаботников.Сотрудник.ДатаУвольнения = ДатаВремя(1,1,1)) И
|	ВременныеПлановыеНачисленияРаботников.Сотрудник ЕСТЬ NULL
|;
|
|// Разобъем по периодам план
|
|Выбрать
|   Т1.Сотрудник,
|	Т1.ТарифныйРазряд1,
|	Т1.Показатель1,
|	т1.Дт,
|	т1.Дт изначДт,
|	MIN(ISNULL(ДОБАВИТЬКДАТЕ(Т2.Дт, ДЕНЬ, -1),ДатаВремя(2050,1,1))) КАК Дт1
|
|INTO ВРТбл1
|
|из ВРТбл Т1
|LEFT OUTER JOIN ВРТбл Т2 ON Т1.Сотрудник = Т2.Сотрудник и Т1.Дт < т2.Дт   
|	
|GROUP BY 
|    Т1.Сотрудник,
|	 Т1.ТарифныйРазряд1,
|	 Т1.Показатель1,
|	 т1.Дт
|	
|;
|	//Соберем первоначальную таблицу тарифов
|
|ВЫБРАТЬ
|	РаботникиОрганизаций.ТарифныйРазряд,
|	РаботникиОрганизаций.Размер,
|	РаботникиОрганизаций.Период Дт
|INTO ВРТрф	
|ИЗ
|	РегистрСведений.РазмерТарифныхСтавок КАК РаботникиОрганизаций
|	
|;
|
|// Разобъем по периодам тарифы
|
|Выбрать
|	Т1.ТарифныйРазряд,
|	Т1.Размер,
|	т1.Дт,
|	MIN(ISNULL(ДОБАВИТЬКДАТЕ(Т2.Дт, ДЕНЬ, -1),ДатаВремя(2050,1,1))) КАК Дт1
|
|INTO ВРТрф1
|
|из ВРТрф Т1
|LEFT OUTER JOIN ВРТрф Т2 ON Т1.ТарифныйРазряд = Т2.ТарифныйРазряд и Т1.Дт < т2.Дт   
|	
|GROUP BY 
|	 Т1.ТарифныйРазряд,
|	 Т1.Размер,
|	 т1.Дт
|	
|;

|//Сборка
|
|SELECT 
|     Тбл.Сотрудник,
|     Тбл.Сотрудник.Наименование,
|     CASE WHEN РазмерТарифныхСтавок.Дт IS NULL  THEN Тбл.Дт
|          WHEN Тбл.Дт > РазмерТарифныхСтавок.Дт THEN Тбл.Дт ELSE РазмерТарифныхСтавок.Дт END период,
|     CASE WHEN РазмерТарифныхСтавок.Размер IS NULL и Показатель1 < 500 и Показатель1 <> 0 THEN Показатель1
|          WHEN РазмерТарифныхСтавок.Размер IS NULL  THEN 0
|          WHEN РазмерТарифныхСтавок.Размер > 500    THEN 0
|          ELSE РазмерТарифныхСтавок.Размер END Размер,
|     CASE WHEN РазмерТарифныхСтавок.Размер IS NULL и Показатель1 > 500 THEN Истина
|          WHEN РазмерТарифныхСтавок.Размер > 500    THEN Истина
|          ELSE Ложь END ЭтоОклад
|FROM 
|ВРТбл1 Тбл
|       INNER JOIN (SELECT Сотрудник,Дт, MAX(изначДт) изначДТ FROM ВРТбл1 Т1 GROUP BY Сотрудник,ДТ) Т ON Т.Сотрудник = Тбл.Сотрудник и Т.Дт = Тбл.Дт и Т.ИзначДТ = Тбл.Дт 
|		LEFT OUTER JOIN ВрТрф1 КАК РазмерТарифныхСтавок
|		ПО Тбл.ТарифныйРазряд1 = РазмерТарифныхСтавок.ТарифныйРазряд
|        и РазмерТарифныхСтавок.Дт1>Тбл.Дт и РазмерТарифныхСтавок.Дт<Тбл.Дт1
| //Ограничения
//|        и РазмерТарифныхСтавок.Дт1 > ДатаВремя(2013,1,1)
| WHERE Тбл.Дт1 > ДатаВремя(2013,1,1)
|";

	оТБл = Запрос.Выполнить().Выгрузить();
	
	ИндикаторТарифы = 3;
	
	стрТбл = БД.ЗначениеВСтрокуВнутр(оТбл);
	п = БД.ЗначениеВСтрокуВнутр(БД.Справочники.СотрудникиОрганизаций.ПустаяСсылка());
	п = СтрЗаменить(п,",",Символы.ПС);
	оТип = СтрПолучитьСтроку(п,2);
	
	п = ЗначениеВСтрокуВнутр(Справочники.уатСотрудники.ПустаяСсылка());
	п = СтрЗаменить(п,",",Символы.ПС);
	уТип = СтрПолучитьСтроку(п,2);
	СтрТбл = СТрЗаменить(СтрТбл,оТип,уТип);
	
	ТБл = ЗначениеИзСтрокиВнутр(СтрТбл);
	
	Запрос = Новый Запрос;
	Запрос.Текст =" 
	| SELECT
	|	уатТарифыСотрудников.Период,
	|	уатТарифыСотрудников.Сотрудник,
	|	уатТарифыСотрудников.Размер Тариф,
	|	уатТарифыСотрудников.ЭтоОклад
	| INTO ВрТбл
	| FROm &Тбл уатТарифыСотрудников
	| ;
	|
	|ВЫБРАТЬ
	|	ISNULL(Тбл.Период,уатТбл.Период) Период,
	|	ISNULL(Тбл.Сотрудник,уатТбл.Сотрудник) Сотрудник,
	|	Тбл.Тариф,
	|	Тбл.ЭтоОклад
	|ИЗ
	|	РегистрСведений.уатТарифыСотрудников КАК уатТбл
	|
	|FULL JOIN ВРТбл Тбл ON Тбл.Период    = уатТбл.Период
	|                   and Тбл.Сотрудник = уатТбл.Сотрудник
	|                   and Тбл.Тариф     = уатТбл.Тариф
	|                   and Тбл.ЭтоОклад  = уатТбл.ЭтоОклад
	|
	|WHERE Тбл.Сотрудник IS NULL or уатТбл.Сотрудник IS NULL
	|
	| ";
	Запрос.УстановитьПараметр("тбл",Тбл);
	итТ = Запрос.Выполнить().Выгрузить();
	
	ИндикаторТарифы = 5;
	
	ВсегоколТбл = итТ.Количество();
	ном=0;
	
	НачатьТранзакцию();
	ДЛя каждого стр из итТ ЦИкл
		Ном=Ном+1;
		ИндикаторТарифы = ном/ВсегоколТбл*100;
		
		Наб = РегистрыСведений.уатТарифыСотрудников.СоздатьНаборЗаписей();
		Наб.Отбор.Период.ЗНачение = Стр.Период;
		Наб.ОТбор.Период.Использование = Истина;
		Наб.Отбор.Сотрудник.Значение = Стр.Сотрудник;
		Наб.ОТбор.Сотрудник.Использование = Истина;
		
		Если Стр.Тариф <> NULL ТОгда
			Зап = Наб.Добавить();
			ЗаполнитьЗначенияСвойств(Зап,Стр);	
			Сообщить("Записан тариф для "+Стр.СОтрудник+" = "+Стр.Тариф);
		ИНАче
			Сообщить("Удален тариф для "+Стр.СОтрудник+" на "+Стр.Период);
		КонецеСЛИ;
		
		Наб.Записать();
		
	КонецЦИкла;
	ЗафиксироватьТранзакцию();
	 ИндикаторТарифы = 100;
 КонецПроцедуры
 

Процедура Выгрузить(ТекФормаОбъекта=Неопределено) Экспорт 
	
	ТекФорма = ТекФормаОбъекта;
	
	Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");
	ПравоЗагружатьПаспорта = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ЗагружатьПаспорт);
	ПравоЗагружатьТарифы = уатПраваИНастройки.уатПолучитьПраваИНастройкиПользователя(Организация, ПланыВидовХарактеристик.уатПраваИНастройки.ЗагружатьТарифы);

	
	
	V8 = Новый COMObject(глОбщий.ИмяCOMСоединителя());
	БД = V8.Connect(Константы.СтрокаСоединенияСзуп.Получить());
	
	Если ТекФорма<>Неопределено Тогда
		ТекФорма.ЭлементыФормы.Надпись1.Картинка = БиблиотекаКартинок.уатОбъектНайден;
	КонецЕсли;
	
	МасРегСвед  = Новый Массив;
	МАсУдРабОрг = Новый Массив;
	оМас = БД.NewObject("Массив");
	
	оУзел = БД.ПланыОбмена.ЗУП.НайтиПоКоду("ПРЗ");
	
	МасОбк = Новый Массив;
	оВыб = БД.ПланыОбмена.ВыбратьИзменения(оУзел, оУзел.НомерОтправленного);
	Пока оВыб.Следующий() Цикл
		МасОбк.Добавить(оВыб.Получить());
	КонецЦикла;
	
	Если ТекФорма<>Неопределено Тогда
		ТекФорма.ЭлементыФормы.Надпись2.Картинка = БиблиотекаКартинок.уатОбъектНайден;
	КонецЕсли;
	
	ВсегоМасКол = масОбк.Количество();
	ном=0;
	ДЛя каждого оОбъект из МасОбк Цикл
		
		Ном=Ном+1;
		ИндикаторДаные = ном/ВсегоМасКол*100;
		
		
		
		ТекТип = БД.XMLТипЗнч(оОбъект).TypeName;
		
		Если ТекТип = "CatalogObject.СотрудникиОрганизаций" ТОгда
			ЗагрузитьСотр(оОбъект,"уатСотрудники");
		ИНачеЕсли Лев(ТекТип,7) = "Catalog" ТОгда
			п=БД.XMLТипЗнч(оОбъект).TypeName; 
			ТипСпр = Сред(п,Найти(п,".")+1);
			ЗагрузитьСотр(оОбъект,ТипСпр);
		ИНачеЕсли ТекТип = "InformationRegisterRecordSet.ФИОФизЛиц" ТОгда
			ЗагрузитьРегСведФИО(оОбъект);
		ИНачеЕсли ТекТип = "InformationRegisterRecordSet.КонтактнаяИнформация" ТОгда
			ЗагрузитьРегСведКонтакт(оОбъект);
		ИНачеЕсли ТекТип = "InformationRegisterRecordSet.СведенияОСтажеРаботыНаСевере" ТОгда
			ЗагрузитьРегСведСевНадбавка(оОбъект);
		ИНачеЕсли ТекТип = "InformationRegisterRecordSet.ПаспортныеДанныеФизЛиц" ТОгда
			Если ПравоЗагружатьПаспорта ТОгда
				ЗагрузитьРегСведПаспорт(оОбъект);
			КонецеСЛИ;
		ИНачеЕсли ТекТип = "InformationRegisterRecordSet.РаботникиОрганизаций" ТОгда
			Если оОбъект.ThisObject.Количество() = 0 ТОгда
				МАсУдРабОрг.ДОбавить(БД.STRING(оОбъект.Filter["Регистратор"].value.УникальныйИдентификатор()));
			ИНАче
				ДЛя каждого оЭЛ из оОбъект.ThisObject Цикл
					пСотр = ПолучитьСсылку(оЭл.Сотрудник,"уатСотрудники");
					Если МасРегСвед.Найти(пСотр)=Неопределено ТОгда
						МАсРегСвед.Добавить(пСотр);
						оМАс.ДОбавить(оЭл.Сотрудник);
					КонецеСЛИ;
				КонецЦикла;
			КонецеСлИ;
			
		ИНАче
			//Сообщить("Не определен тип "+ТекТИп);
		КонецеСЛИ;
		
	КонецЦикла;  
	
    ИндикаторДаные=100;
	
	
	ЗагрузитьРегСведРабОрг(оМас,МАсУдРабОрг);
	
	
	БД.ПланыОбмена.УдалитьРегистрациюИзменений(оУзел,оУзел.НомерОтправленного+1);
	
	Если ПравоЗагружатьТарифы Тогда
		Тарифы(БД);
	КонецеСЛИ;
	
КонецПроцедуры

