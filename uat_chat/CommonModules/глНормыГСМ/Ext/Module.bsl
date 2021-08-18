﻿
	//Запрос.Текст = "ВЫБРАТЬ DISTINCT
	//               |	тбНорм.ОборудованиеРабота ОБорудованиеРабота,
	//               |	тбНорм.ОборудованиеРабота.Родитель ОБорудованиеРаботаРодитель,
	//               |	CASE WHEN тбНорм.ОБорудованиеРабота.ОсновнаяРабота = Значение(Справочник.ОборудованиеРаботыГСМ.ПустаяСсылка) 
	//			   |         THEN тбНорм.ОБорудованиеРабота
	//			   |         ELSE тбНорм.ОборудованиеРабота.ОсновнаяРабота END ОсновнаяРабота,
	//               |	тбНорм.ОборудованиеРабота.ЕстьБак ЕстьБак,
	//               |	тбНорм.ОборудованиеРабота.ПараметрРасхода.ЕдиницаИзмерения ЕдИзм,
	//			   |    CASE WHEN тбНорм.ОборудованиеРабота.ПараметрРасхода = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ПробегОбщий) или  тбНорм.ОборудованиеРабота.ПараметрРасхода = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ТнКм) 
	//			   |         THEN 0.01 ELSE 1 END коэф100км,
	//			   |    CASE WHEN тбНорм.ОборудованиеРабота.ПараметрРасхода = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ПробегОбщий) или  тбНорм.ОборудованиеРабота.ПараметрРасхода = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ТнКм) 
	//			   |         THEN 0.01 ELSE 1 END *
	//               |	  ISNULL(ISNULL(ISNULL(ISNULL(тбНормТС.Норма,тбНормУпр.Норма),тбНормУпр0.Норма),тбНормМод.Норма),0) * (1+
	//			   |      ISNULL(ISNULL(ISNULL(ISNULL(тбНормТС.ТКоэф,тбНормУпр.ТКоэф),тбНормУпр0.ТКоэф),тбНормМод.ТКоэф),0) * ISNULL(СпрТемп.Процент,0)/100)  Норма,
	//			   |  
	//               |	  ISNULL(ISNULL(ISNULL(ISNULL(тбНормТС.ТКоэф,тбНормУпр.ТКоэф),тбНормУпр0.ТКоэф),тбНормМод.ТКоэф),0) * ISNULL(СпрТемп.Процент,0) ТКоэф,
	//			   |    0 РасходПоНорме,
	//			   |    0 пробег,
	//			   |    РегОгр.НормаВДень * РАЗНОСТЬДАТ(&Дт,&Дт1, День) Огр
	//			   |    
	//               |ИЗ
	//			   |  
	//			   |  РегистрСведений.НормыГсм.СрезПоследних(&Дт,  (Модель = &ТС OR Модель = &Мод OR Модель = &упр) 
	//			   |                                             и (ОборудованиеРабота в (&Обр) или &БезОбр = Истина)) тбНорм    
	//			   |    LEFT OUTER JOIN
	//			   |  РегистрСведений.НормыГсм.СрезПоследних(&Дт,Модель = &ТС)   тбНормТС   ON тбНормТС.ОборудованиеРабота = тбНорм.ОБорудованиеРабота    и  тбНормТС.Норма <> 0
	//			   |    LEFT OUTER JOIN
	//			   |  РегистрСведений.НормыГсм.СрезПоследних(&Дт,Модель = &Мод)  тбНормМод   ON тбНормМод.ОборудованиеРабота = тбНорм.ОБорудованиеРабота  и  тбНормМод.Норма <> 0
	//			   |    LEFT OUTER JOIN
	//			   |  РегистрСведений.НормыГсм.СрезПоследних(&Дт,Модель = &Упр и Вес = &Вес и ЛС =&ЛС )  тбНормУпр   ON тбНормУпр.ОборудованиеРабота = тбНорм.ОБорудованиеРабота  и  тбНормУпр.Норма <> 0
	//			   |    LEFT OUTER JOIN
	//			   |  РегистрСведений.НормыГсм.СрезПоследних(&Дт,Модель = &Упр и Вес = 0 и ЛС = 0)  тбНормУпр0   ON тбНормУпр0.ОборудованиеРабота = тбНорм.ОБорудованиеРабота и  тбНормУпр0.Норма <> 0
	//			   
	//			   |    LEFT OUTER JOIN  Справочник.уатТемпературныеКоэффициентыГСМ как СпрТемп ON   ТемператураМеньше >= &Темп и  ТемператураДо <= &Темп
	//			   |  
	//			   |    LEFT OUTER JOIN  РегистрСведений.ОграниченияРаходаГСМ.СрезПоследних(&Дт,Модель = &Мод) как РегОгр ON   тбНорм.ОборудованиеРабота = РегОгр.ОБорудованиеРабота
	//			   |  
	//			   |WHERE  ISNULL(ISNULL(ISNULL(ISNULL(тбНормТС.Норма,тбНормУпр.Норма),тбНормУпр0.Норма),тбНормМод.Норма),0) <> 0 
	//			   | ";

Функция ПолучитьТекстЗапросаНормы() Экспорт
	
	
	Возврат "
|SELECT 
|	Спр.Ссылка ссТС,
|	ВЫразить(Спр.СобственныйВес      как Число(5,0)) Вес,
|	ВЫразить(Спр.МощностьДвигателяЛС как Число(5,0)) ЛС,
|	Ложь ЕстьБак,
|	Спр.Ссылка ТС
|	
|INTO врТС
|FROM  Справочник.уатТС Спр 
|//здесь вставка отчет приказ на нормы
|WHERE (Спр.ссылка = &ТС или &БезФильтраПоТС = Истина)
|
|UNION ALL 

//Lexx от 11.05.2018 - убираем нормы расхода ГСМ по модели ТС
|SELECT 
|	Спр.Ссылка ссТС,
|	ВЫразить(Спр.СобственныйВес      как Число(5,0)) Вес,
|	ВЫразить(Спр.МощностьДвигателяЛС как Число(5,0)) ЛС,
|	Ложь ЕстьБак,
|	Спр.Модель
|FROM  Справочник.уатТС Спр 
|//здесь вставка отчет приказ на нормы
|WHERE (Спр.ссылка = &ТС или &БезФильтраПоТС = Истина)
|    и Спр.Модель<>Значение(Справочник.уатМоделиТС.ПустаяСсылка)
|
|UNION ALL 

|SELECT 
|	Спр.Ссылка ссТС,
|	ВЫразить(Спр.СобственныйВес      как Число(5,0)) Вес,
|	ВЫразить(Спр.МощностьДвигателяЛС как Число(5,0)) ЛС,
|	Ложь ЕстьБак,
|	Спр.упрМодель
|FROM  Справочник.уатТС Спр 
|//здесь вставка отчет приказ на нормы
|WHERE (Спр.ссылка = &ТС или &БезФильтраПоТС = Истина)
|    и Спр.упрМодель<>Значение(Справочник.упрМодели.ПустаяСсылка)
|

|UNION ALL 

|SELECT distinct
|	Спр.Ссылка ссТС,
|	ВЫразить(Спр.ссылка.СобственныйВес      как Число(5,0)) Вес,
|	ВЫразить(Спр.ссылка.МощностьДвигателяЛС как Число(5,0)) ЛС,
|	Спр.ЕстьБак,
|	Спр.Оборудование
|FROM  Справочник.уатТС.ОборудованиеГСМ Спр 
|//здесь вставка отчет приказ на нормы
|WHERE (Спр.ссылка = &ТС или &БезФильтраПоТС = Истина)
|    и Спр.Оборудование<>Значение(Справочник.ОборудованиеРаботыГСМ.ПустаяСсылка)
//Временно для старта потом убрать
|    и &Дт >= ДатаВремя(2017,10,14)
|;


|ВЫБРАТЬ
|   ISNULL(ТБлТС.ссТС,тблОбр.ссТС) ссТС,
|	НормыГСМСрезПоследних.Модель,
|   НормыГСМСрезПоследних.ОборудованиеРабота,
|   ISNULL(тблОбр.ЕстьБак,ЛОжь) ЕстьБак,
|
|	НормыГСМСрезПоследних.Вес,
|	НормыГСМСрезПоследних.ЛС,
|	НормыГСМСрезПоследних.Норма,
|	НормыГСМСрезПоследних.ТКоэф,
|	НормыГСМСрезПоследних.Период,

|	CASE WHEN СпрТС.ссылка  IS NOT NULL и  НормыГСМСрезПоследних.вес <> 0 и   НормыГСМСрезПоследних.ЛС <> 0 	THEN 12
|	     WHEN СпрТС.ссылка  IS NOT NULL и (НормыГСМСрезПоследних.вес <> 0 или НормыГСМСрезПоследних.ЛС <> 0) 	THEN 11
|	     WHEN СпрТС.ссылка  IS NOT NULL 																		THEN 10 
//Оборудование
|	     WHEN тблОбр.ТС     IS NOT NULL и  НормыГСМСрезПоследних.вес <> 0 и   НормыГСМСрезПоследних.ЛС <> 0 	THEN 9
|	     WHEN тблОбр.ТС     IS NOT NULL и (НормыГСМСрезПоследних.вес <> 0 или НормыГСМСрезПоследних.ЛС <> 0) 	THEN 8
|	     WHEN тблОбр.ТС     IS NOT NULL 																		THEN 7

|	     WHEN спрУпр.ссылка IS NOT NULL и  НормыГСМСрезПоследних.вес <> 0 и   НормыГСМСрезПоследних.ЛС <> 0 	THEN 6
|	     WHEN спрУпр.ссылка IS NOT NULL и (НормыГСМСрезПоследних.вес <> 0 или НормыГСМСрезПоследних.ЛС <> 0) 	THEN 5
|	     WHEN спрУпр.ссылка IS NOT NULL 																		THEN 4

//Lexx от 11.05.2018 - убираем нормы расхода ГСМ по модели ТС
|	     WHEN спрМод.ссылка IS NOT NULL и  НормыГСМСрезПоследних.вес <> 0 и   НормыГСМСрезПоследних.ЛС <> 0 	THEN 3
|	     WHEN спрМод.ссылка IS NOT NULL и (НормыГСМСрезПоследних.вес <> 0 или НормыГСМСрезПоследних.ЛС <> 0) 	THEN 2
|	     WHEN спрМод.ссылка IS NOT NULL 																		THEN 1

|	     ELSE 0 END +  CASE WHEN НормыГСМСрезПоследних.ИзЦентра THEN 0.3 ELSE 0 END инд 

|INTO врТбл
|ИЗ
|	РегистрСведений.НормыГСМ.СрезПоследних(&Дт
|			,
|			(    ( НормаНаОборудование=Ложь   и Модель IN (SELECT ТС FROM врТС Т) )    
|             or ( НормаНаОборудование=Истина и ОборудованиеРабота IN (SELECT ТС FROM врТС Т) и (Модель=Неопределено or Модель IN (SELECT ТС FROM врТС Т)) ) 
|            )
|			и  (Вес IN (SELECT Вес FROM врТС Т) OR Вес = 0) 
|			и  (ЛС  IN (SELECT ЛС  FROM врТС Т) OR ЛС  = 0) 
|				) КАК НормыГСМСрезПоследних
|	LEFT OUTER JOIN Справочник.уатТС       спрТС  ON СпрТС.ссылка  = НормыГСМСрезПоследних.Модель

//Lexx от 11.05.2018 - убираем нормы расхода ГСМ по модели ТС
|	LEFT OUTER JOIN Справочник.уатМоделиТС спрМод ON СпрМод.ссылка = НормыГСМСрезПоследних.Модель             

|	LEFT OUTER JOIN Справочник.упрМодели   спрУпр ON спрУпр.ссылка = НормыГСМСрезПоследних.Модель             
|	LEFT OUTER JOIN врТС                   тблОбр ON тблОбр.ТС     = НормыГСМСрезПоследних.ОборудованиеРабота             
|	LEFT OUTER JOIN врТС                   тблТС  ON тблТС.ТС      = НормыГСМСрезПоследних.Модель             
|
|				
|WHERE Норма <> 0	
|    и (тблТС.ссТС IS NULL or тблТС.Вес = НормыГСМСрезПоследних.Вес or НормыГСМСрезПоследних.Вес = 0)
|    и (тблТС.ссТС IS NULL or тблТС.ЛС  = НормыГСМСрезПоследних.ЛС  or НормыГСМСрезПоследних.ЛС  = 0)
|	  			
|;

|ВЫБРАТЬ
|	ТБл.ссТС ТС,
|	ТБл.Модель,
|	ТБл.ОборудованиеРабота,
|   ISNULL(СпрОбр.РОдитель,Значение(Справочник.ОборудованиеРаботыГСМ.ПустаяСсылка)) ОБорудованиеРаботаРодитель,
|	CASE WHEN  ISNULL(СпрОбр.ОсновнаяРабота,Значение(Справочник.ОборудованиеРаботыГСМ.ПустаяСсылка)) = Значение(Справочник.ОборудованиеРаботыГСМ.ПустаяСсылка) 
|         THEN ТБл.ОборудованиеРабота
|         ELSE СпрОбр.ОсновнаяРабота END ОсновнаяРабота,
// временно для перехода потом убрать
|   CASE WHEN СпрОбр.ЕстьБак или Тбл.ЕстьБак THEN ИСТИНА ELSE ЛОЖЬ END ЕстьБак,
//|   Тбл.ЕстьБак ЕстьБак, 
|   ISNULL(СпрОбр.ПараметрРасхода.ЕдиницаИзмерения,Неопределено) ЕдИзм, 
|	ТБл.Вес,
|	ТБл.ЛС,
|	
|    CASE WHEN СпрОбр.ПараметрРасхода = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ПробегОбщий) или  СпрОбр.ПараметрРасхода = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ТнКм) 
|         THEN 0.01 ELSE 1 END коэф100км,
|    CASE WHEN СпрОбр.ПараметрРасхода = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ПробегОбщий) или  СпрОбр.ПараметрРасхода = ЗНАЧЕНИЕ(Справочник.уатПараметрыВыработки.ТнКм) 
|         THEN 0.01 ELSE 1 END * ТБл.Норма * (1+ТБл.ТКоэф * ISNULL(СпрТемп.Процент,0)/100)   Норма,
|	ТБл.ТКоэф * ISNULL(СпрТемп.Процент,0) ТКоэф,
|   //здесь вставка отчет коэф
|	ТБл.Период,
|    0 РасходПоНорме,
|    0 пробег,
|    РегОгр.НормаВДень * РАЗНОСТЬДАТ(&Дт,&Дт1, День) Огр,
|	ТБл.инд
|
|ИЗ врТбл ТБл
|INNER JOIN (SELECT ссТС,ОборудованиеРабота, MAX(Инд) ИНд FROM врТБл Т GROUP BY ссТС,ОборудованиеРабота) тбМакс 
|                                                         ON  тбМакс.ОборудованиеРабота = ТБл.ОборудованиеРабота
|                                                          и  тбМакс.ссТС               = ТБл.ссТС
|                                                          и  тбМакс.ИНд                = ТБл.ИНд
|
|LEFT OUTER JOIN Справочник.ОборудованиеРаботыГСМ СпрОбр ON СпрОбр.ссылка = ТБл.ОборудованиеРабота
|
|    LEFT OUTER JOIN  Справочник.уатТемпературныеКоэффициентыГСМ как СпрТемп ON   СпрТемп.ТемператураМеньше >= &Темп и  СпрТемп.ТемператураДо <= &Темп и &БезФильтраПоТС=Ложь
|  
|    LEFT OUTER JOIN  РегистрСведений.ОграниченияРаходаГСМ.СрезПоследних(&Дт,Модель IN (SELECT ТС FROM врТС Т)) как РегОгр ON   тбл.ОборудованиеРабота = РегОгр.ОБорудованиеРабота  и &БезФильтраПоТС=Ложь
|//Здесь вставка отчет Справочник
| WHERE СпрОбр.ссылка в (&ОБр) OR  &БезОбр = Истина
|ORDER BY СпрОБр.Код
|";

	
	
КонецФункции
	
//Возвращает таблицу норм ГСМ
// Тип Эл : Справочник.ТранспортныеСредства, Справочник.МоделиТС
// Дт - дата запроса
Функция ТблНорм(Эл,Дт="",Дт1,ДокПЛ=Неопределено,Температура=99,ОБорудованиеРабота=Неопределено)  Экспорт
	
	Если Дт = "" тогда
		Дт=ТекущаяДата();
	КонецЕСЛИ;
	Запрос = Новый Запрос;   
	Запрос.Текст = ПолучитьТекстЗапросаНормы();	
	
	
	
	Запрос.УстановитьПараметр("Дт",НачалоДня(дт)); 
	Запрос.УстановитьПараметр("Дт1",НачалоДня(дт1+60*60*24)); 
	
	Запрос.УстановитьПараметр("ТС",Эл);
	Запрос.УстановитьПараметр("Темп",Температура);
	Запрос.УстановитьПараметр("БезФильтраПоТС",Ложь);
	
	Запрос.УстановитьПараметр("Обр",ОборудованиеРабота);
	Если ОБорудованиеРабота  = Неопределено ТОгда
		Запрос.УстановитьПараметр("БезОбр",Истина);
	Иначе
		Запрос.УстановитьПараметр("БезОбр",Ложь);
	КонецеСЛИ;
	
	Тбл = Запрос.Выполнить().Выгрузить();
	
	Возврат Тбл;
	
КонецФункции