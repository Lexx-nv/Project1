Функция РаботаПоРеестрам()
	
	Запрос = новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
				   |  CASE WHEN SUM(рее) > SUM(Раб) THEN 1 ELSE 0 END  Инд
				   |
				   |
				   |FROM (
				   |ВЫБРАТЬ
	               |	РеестрыУслуг.Количество рее, 0 раб
	               |ИЗ
	               |	РегистрНакопления.РеестрыУслуг КАК РеестрыУслуг
				   |
				   |UNION ALL
				   |
	               |ВЫБРАТЬ
	               |	0,
	               |	РаботаТС.КоличествоЧасов 
	               |ИЗ
				   |
	               |	РегистрНакопления.РаботаТС КАК РаботаТС
				   |
				   | ) WWW
				   |";
	
	ТБл = Запрос.Выполнить().Выгрузить();
	Если Тбл.Количество() = 0 Тогда Возврат Истина; 
	ИНачеЕсли ТБл[0].Инд = 1 ТОгда Возврат Истина;
	Иначе Возврат Ложь;
	КонецЕСЛИ;
	
КонецФункции


Функция Данные(НадоВыборку=ЛОжь) Экспорт
	
	Запрос = Новый Запрос;
	
	Запрос.УстановитьПараметр("Дт",НачалоМесяца(Дт));
	Запрос.УстановитьПараметр("КонПер",КонецМЕсяца(Дт)+1);
	Запрос.УстановитьПараметр("КолДней",День(КонецМЕсяца(Дт)));
	Запрос.УстановитьПараметр("ФлтПодр",Подразделение);
	
	Запрос.УстановитьПараметр("ВывПодр",ВывПодр);
	Запрос.УстановитьПараметр("ВывСос",ВывСос);
	Запрос.УстановитьПараметр("ВывТип",ВывТип);
	Запрос.УстановитьПараметр("фильтрПриоритетТС",ТолькоПриоритетнаяТехника);
	
	
	//Установим фильтр по состояниям
	Мас = НОвый Массив;
	Для каждого Эл из ФильтрСостояний Цикл
		Если Эл.Пометка ТОгда
			Мас.Добавить(Эл.Значение);
		КонецеСЛИ;
	КонецЦикла;
	Запрос.УстановитьПараметр("МасСос",Мас);
	Запрос.УстановитьПараметр("ЛюбоеСос",Мас.Количество() = ФильтрСостояний.Количество());
    Запрос.УстановитьПараметр("РаботаПоРеестрам",РаботаПоРеестрам());	
	
	
	Запрос.Текст = " ВЫБРАТЬ
	|	уатМестонахождениеТССрезПоследних.ТС,
	|	уатМестонахождениеТССрезПоследних.Подразделение,
	|	уатМестонахождениеТССрезПоследних.Состояние,
	|	уатМестонахождениеТССрезПоследних.Период
	|	INTO ВРТбл
	|ИЗ
	|	РегистрСведений.уатМестонахождениеТС.СрезПоследних(&Дт,ТС.ДатаВводаВЭксплуатацию<>ДатаВремя(1,1,1) 
	|														 и ТС.ДатаВводаВЭксплуатацию <= &Дт
	|														 и (ТС.ДатаВыбытия = ДатаВремя(1,1,1) или ТС.ДатаВыбытия > &Дт)
	|                                                        и (ТС.ТипТС.НеВыводитьВТабельТС = Ложь или ТС.ТипТС.НеВыводитьВТабельТС IS NULL)
	|													   ) КАК уатМестонахождениеТССрезПоследних
	|	
	|ГДЕ (Состояние.ЭтоПривленный = Ложь или Состояние.ЭтоПривленный IS NULL)	
	|	
	|UNION ALL
	|	
	|ВЫБРАТЬ
	|	уатМестонахождениеТС.ТС,
	|	уатМестонахождениеТС.Подразделение,
	|	уатМестонахождениеТС.Состояние,
	|	уатМестонахождениеТС.Период
	|ИЗ
	|	РегистрСведений.уатМестонахождениеТС КАК уатМестонахождениеТС
	|	WHERE Период > &Дт и Период < &КонПер
	|	    и ТС.ДатаВводаВЭксплуатацию<>ДатаВремя(1,1,1)
	|	    и ТС.ДатаВводаВЭксплуатацию<=уатМестонахождениеТС.Период
	|	    и (ТС.ДатаВыбытия = ДатаВремя(1,1,1) или ТС.ДатаВыбытия >= уатМестонахождениеТС.Период)
	|	    и (ТС.ТипТС.НеВыводитьВТабельТС = Ложь или ТС.ТипТС.НеВыводитьВТабельТС IS NULL)
	|	    и (Состояние.ЭтоПривленный = Ложь или Состояние.ЭтоПривленный IS NULL)
	|;
	|	
	|SELECT  DISTINCT
	|	Тбл.ТС,
	|	Тбл.Подразделение,
	|	Тбл.Состояние,
	|	Тбл.Период,
	|	MIN(ISNULL(Т.Период,&КонПер)) ПериодКон,
	|	Тбл.Период изначДт
	|INTO ВРТбл1	
	|FROM ВРТбл Тбл 
	|LEFT OUTER JOIN ВРТбл Т ON Т.ТС = Тбл.ТС и Т.Период > Тбл.Период
	|GROUP BY		
	|	Тбл.ТС,
	|	Тбл.Подразделение,
	|	Тбл.Состояние,
	|	Тбл.Период
	|;	
	|SELECT DISTINCT
	|	Тбл.ТС,
	|	Тбл.Подразделение,
	|	Тбл.Состояние,
	|	Тбл.Период,
	|	Тбл.ПериодКон
	|INTo ВРПодр
	|FROM ВРТбл1 Тбл
	|INNER JOIN (SELECT ТС,Период,MAX(изначДт) изНачДт FROM ВРТбл1 Т1 GROUP BY ТС,Период) Т ON Т.ТС = Тбл.ТС и Т.Период = ТБл.Период и Т.ИзначДт = Тбл.ИзначДт
	|WHERE 	(Тбл.Подразделение = &ФлтПодр OR &ФлтПодр = Значение(Справочник.ПодразделенияОрганизаций.ПустаяССылка)) 
	|              и Тбл.Состояние <> Значение(Справочник.уатСостояниеТС.Выбыло)
	|;
	|////////////////////////////////////////////////////
	//Таблица по числам работы
	|ВЫБРАТЬ 
	|	Тбл.ТС,
	|	Тбл.Подразделение,
	|	Тбл.Состояние,
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря Дт,
	|   1 ДнХоз,
	|   CASE WHEN SUM(CASE WHEN ТблРаб.ТС    IS NULL THEN 0 ELSE 1 END)=0 THEN 0 ELSE 1 END ДнЛин,
	|   CASE WHEN SUM(CASE WHEN ТблРем.ТС    IS NULL THEN 0 ELSE 1 END)=0 THEN 0 ELSE 1 END ДнРем,
	|   CASE WHEN SUM(CASE WHEN (    (НачалоПериода(ДатаКалендаря,День) = НачалоПериода(ТблРем.ДатаНачала,День)    и Час(ТблРем.ДатаНачала) < 15)  //День открытия или закрытия
	|                            or  (НачалоПериода(ДатаКалендаря,День) = НачалоПериода(ТблРем.ДатаОкончания,День) и Час(ТблРем.ДатаНачала) >= 12)
	|							) and (РАЗНОСТЬДАТ(ТблРем.ДатаНачала,ТблРем.ДатаОкончания,Час)>4 или ТблРем.ДатаОкончания = ДатаВремя(1,1,1,0,0,0)  )	
    |                      THEN 1 
	|                      WHEN КонецПериода(ТблРем.ДатаНачала,День) < НачалоПериода(ДатаКалендаря,День) и НачалоПериода(ТблРем.ДатаОкончания,День) > НачалоПериода(ДатаКалендаря,День) 
	|                      THEN 1
	|                      ELSE 0 END)=0 THEN 0 ELSE 1 END индРем,
	|
	|
	|   CASE WHEN SUM(CASE WHEN ТблОЖ.Ссылка IS NULL THEN 0 ELSE 1 END)=0 THEN 0 ELSE 1 END ДнОЖ,
	|   CASE WHEN SUM(CASE WHEN ТблРем.ТС    IS NULL THEN 0 
    |                      WHEN ТблРем.ВидОбслуживания.ИспользоватьВПланированииТО THEN 1 
	|                      ELSE 0 END                                 )=0 THEN 0 ELSE 1 END  КолТО
	|INTO ВРитТ
	|ИЗ
	|	РегистрСведений.уатРегламентированныйПроизводственныйКалендарь КАК уатРегламентированныйПроизводственныйКалендарь
	|INNER JOIN ВРПодр Тбл ON Тбл.Период <= ДатаКалендаря и ТБл.ПериодКон > ДатаКалендаря
	|LEFT OUTER JOIN (SELECT DISTINCT 
	|                    ТС,
	|                    НачалоПериода(пРаб.Период,День) Период,
	|                    CASE WHEN пРаб.ДатаОкончания = ДатаВремя(1,1,1) THEN НачалоПериода(пРаб.Период,День) ELSE НачалоПериода(пРаб.ДатаОкончания,День) END  ДатаОкончания
	|                 FROM РегистрНакопления.РаботаТС пРаб 
	|                 WHERE Период >= &Дт и ПЕриод < &КонПер и ВидДвижения = Значение(ВидДвиженияНакопления.Приход) ) ТблРаб ON ТБлРаб.ТС = ТБл.ТС 
	|													и НачалоПериода(ДатаКалендаря,День) >=  ТблРаб.Период  
	|													и НачалоПериода(ДатаКалендаря,День) <=  ТблРаб.ДатаОкончания  
	|
	|LEFT OUTER JOIN Документ.уатРемонтныйЛист ТблРем ON ТблРем.ТС = ТБл.ТС 
	|													и  НачалоПериода(ДатаКалендаря,День) >= НачалоПериода(ТблРем.ДатаНачала,День) 
	|													и (НачалоПериода(ДатаКалендаря,День) <= НачалоПериода(ТблРем.ДатаОкончания,День) OR ТблРем.ДатаОкончания = ДатаВремя(1,1,1))
	|                                                   и ТблРем.ПометкаУдаления = Ложь
	|
	|LEFT OUTER JOIN Документ.уатРемонтныйЛист.ОжиданиеРемонта ТблОЖ ON ТблОЖ.Ссылка.ТС = ТБл.ТС 
	|													и  НачалоПериода(ДатаКалендаря,День) >= НачалоПериода(ТблОЖ.ссылка.ДатаНачала,День) 
	|													и (НачалоПериода(ДатаКалендаря,День) <= НачалоПериода(ТблОЖ.ссылка.ДатаОкончания,День) OR ТблОЖ.ссылка.ДатаОкончания = ДатаВремя(1,1,1))
	|                                                   и ТблОЖ.ссылка.ПометкаУдаления = Ложь
	|													и  НачалоПериода(ДатаКалендаря,День) >= НачалоПериода(ТблОЖ.Начало,День) 
	|													и (НачалоПериода(ДатаКалендаря,День) <= НачалоПериода(ТблОЖ.Окончание,День) OR ТблОЖ.Окончание = ДатаВремя(1,1,1))
	|
	|WHERE ДатаКалендаря >= &Дт и ДатаКалендаря < &КонПер 
	|
	|GROUP BY
	|	Тбл.ТС,
	|	Тбл.Подразделение,
	|	Тбл.Состояние,
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря
	|
	|; 
	//Таблица по расходу гсм
	|ВЫБРАТЬ DISTINCT
	|	Тбл.ТС,
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря Дт,
	|   SUM(РегГСМ.РасходПоФакту) ГСМ
	|INTO ВРгсм
	|ИЗ
	|	РегистрСведений.уатРегламентированныйПроизводственныйКалендарь КАК уатРегламентированныйПроизводственныйКалендарь
	|INNER JOIN ВРПодр Тбл ON Тбл.Период <= ДатаКалендаря и ТБл.ПериодКон > ДатаКалендаря
	|LEFT OUTER JOIN  РегистрНакопления.уатРасходГСМнаТС РегГСМ ON РегГСМ.ТС = ТБл.ТС 
	|													и НачалоПериода(ДатаКалендаря,День) = НачалоПериода(РегГСМ.Период,День) 
	|                                                   и РегГСМ.Период >= &Дт и РегГСМ.ПЕриод < &КонПер
	|
	|WHERE ДатаКалендаря >= &Дт и ДатаКалендаря < &КонПер 
	|GROUP BY 
	|     Тбл.ТС,
	|     ДатаКалендаря
	|;
	//Таблица по пробегу
	|ВЫБРАТЬ DISTINCT
	|	Тбл.ТС,
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря Дт,
	|   SUM(CASE WHEN ТБл.ТС.Модель.НаличиеСпидометра THEN РегВыработка.Количество ELSE 0 END) Пробег,
	|   SUM(CASE WHEN ТБл.ТС.Модель.НаличиеСпидометра THEN 0 ELSE РегВыработка.Количество END) Мтчасы
	|INTO ВРПРб
	|ИЗ
	|	РегистрСведений.уатРегламентированныйПроизводственныйКалендарь КАК уатРегламентированныйПроизводственныйКалендарь
	|INNER JOIN ВРПодр Тбл ON Тбл.Период <= ДатаКалендаря и ТБл.ПериодКон > ДатаКалендаря
	|LEFT OUTER JOIN  РегистрНакопления.уатВыработкаТС РегВыработка ON РегВыработка.ТС = ТБл.ТС 
	|													и НачалоПериода(ДатаКалендаря,День) = НачалоПериода(РегВыработка.Период,День) 
	|                                                   и РегВыработка.Период >= &Дт и РегВыработка.ПЕриод < &КонПер
	|
	|WHERE ДатаКалендаря >= &Дт и ДатаКалендаря < &КонПер 
	|GROUP BY 
	|     Тбл.ТС,
	|     ДатаКалендаря
	|;
	//Таблица по работе ТС
	|ВЫБРАТЬ DISTINCT
	|	Тбл.ТС,
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря Дт,
	|   SUM(РегРаботаТС.КоличествоЧасов) РабЧасы
	|INTO ВРРаб
	|ИЗ
	|	РегистрСведений.уатРегламентированныйПроизводственныйКалендарь КАК уатРегламентированныйПроизводственныйКалендарь
	|INNER JOIN ВРПодр Тбл ON Тбл.Период <= ДатаКалендаря и ТБл.ПериодКон > ДатаКалендаря
	|LEFT OUTER JOIN РегистрНакопления.РаботаТС РегРаботаТС ON РегРаботаТС.ТС = ТБл.ТС 
	|													и НачалоПериода(ДатаКалендаря,День) = НачалоПериода(РегРаботаТС.Период,День) 
	|                                                   и РегРаботаТС.Период >= &Дт и РегРаботаТС.ПЕриод < &КонПер
	|
	|WHERE ДатаКалендаря >= &Дт и ДатаКалендаря < &КонПер 
	|GROUP BY 
	|     Тбл.ТС,
	|     ДатаКалендаря
	|
	|;
	//Таблица по реестрам ТС
	|ВЫБРАТЬ DISTINCT
	|	Тбл.ТС,
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря Дт,
	|   SUM(РеестрыУслуг.Количество) рееЧасы,
	|   SUM(РеестрыУслуг.Сумма+РеестрыУслуг.СуммаКм+РеестрыУслуг.СУмма1+РеестрыУслуг.Сумма2+РеестрыУслуг.СУмма3+РеестрыУслуг.Сумма4+РеестрыУслуг.Сумма5+РеестрыУслуг.Сумма6) рееСум
	|INTO ВРРее
	|ИЗ
	|	РегистрСведений.уатРегламентированныйПроизводственныйКалендарь КАК уатРегламентированныйПроизводственныйКалендарь
	|INNER JOIN ВРПодр Тбл ON Тбл.Период <= ДатаКалендаря и ТБл.ПериодКон > ДатаКалендаря
	|LEFT OUTER JOIN  РегистрНакопления.РеестрыУслуг РеестрыУслуг ON РеестрыУслуг.ТС = ТБл.ТС 
	|													и НачалоПериода(ДатаКалендаря,День) = НачалоПериода(РеестрыУслуг.Период,День) 
	|                                                   и РеестрыУслуг.Период >= &Дт и РеестрыУслуг.ПЕриод < &КонПер
	|
	|WHERE ДатаКалендаря >= &Дт и ДатаКалендаря < &КонПер 
	|GROUP BY 
	|     Тбл.ТС,
	|     ДатаКалендаря
	|
	|; 
	|SELECT 
	|	Тбл.ТС,
	|	Тбл.ТС.Наименование ТСимя,
	|	Тбл.ТС.ГаражныйНомер ГаражныйНомер,
	|	Тбл.ТС.ГосударственныйНомер ГосНомер,
	|	Тбл.ТС.ПриоритетноеТС ПриоритетноеТС,
	|	Тбл.ТС.ГодВыпуска ГодВыпуска,
	|	Тбл.ТС.упрМодель.Наименование упрМодель,
	|	Тбл.ТС.ТипТС.Наименование  типТСимя,
	|	CASE WHEN &ВывПодр THEN Тбл.Подразделение ELSE Значение(Справочник.ПодразделенияОрганизаций.ПустаяССылка) END Подразделение,
	|	CASE WHEN &ВывСос  THEN Тбл.Состояние     ELSE Значение(Справочник.уатСостояниеТС.ПустаяССылка) END Состояние,
	|	CASE WHEN &ВывТип  THEN Тбл.ТС.ТипТС      ELSE Значение(Справочник.уатТипыТС.ПустаяССылка) END типТС,
	|	уатРегламентированныйПроизводственныйКалендарь.ВидДня ВидДня,
	|	уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря ДтДень,
	|	НачалоПериода(уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря,Месяц) МесяцГод,
	|	День(уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря) Дт,
	|	CASE WHEN День(уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря)=1 и ISNULL(Т.днХоз,0)=1 THEN 1 ELSE 0 END НачЧсл,
	|	CASE WHEN День(уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря)=&КолДней и ISNULL(Т.днХоз,0)=1 THEN 1 ELSE 0 END КонЧсл,
	|   ISNULL(Т.днХоз,0)/&КолДней  срЧсл,
	|   ISNULL(Т.днХоз,0) днХоз,
	|   ISNULL(Т.днЛин,0) днЛин, 
	|   CASE WHEN ISNULL(СпрСос.ЗапретитьВыпискуПЛ,TRUE)=FALSE THEN ISNULL(Т.днХоз,0) ELSE 0  END днХозКИП,
	|   CASE WHEN  День(уатРегламентированныйПроизводственныйКалендарь.ДатаКалендаря)=&КолДней  
    |            и ISNULL(СпрСос.ЗапретитьВыпискуПЛ,TRUE)=FALSE THEN ISNULL(Т.днХоз,0) ELSE 0 END днХозКИПкон,
	|   CASE WHEN ISNULL(СпрСос.ЗапретитьВыпискуПЛ,TRUE)=FALSE THEN ISNULL(Т.днЛин,0) ELSE 0  END днЛинКИП, 
	|   ISNULL(CASE WHEN ISNULL(СпрСос.ЗапретитьВыпискуПЛ,TRUE)=TRUE THEN 0 
    |               WHEN Т.днЛин<>0 THEN Т.индРем 
    |               ELSE Т.днРем 
	|                END,0) днРемКИП, 
	|   ISNULL(CASE WHEN ISNULL(СпрСос.ЗапретитьВыпискуПЛ,TRUE)=TRUE THEN 0 
    |               WHEN Т.днЛин<>0 THEN Т.индРем 
    |               ELSE 0 
	|                END,0) днРемЛин, 
	|   ISNULL(CASE WHEN Т.днЛин<>0 THEN Т.индРем ELSE Т.днРем END,0) днРем, 
	|   ISNULL(CASE WHEN Т.днЛин<>0 THEN 0 ELSE Т.днРем END,0) днРем0, 
	|   ISNULL(CASE WHEN Т.днЛин<>0 THEN 0 ELSE Т.днОЖ END,0)  днОЖ, 
	|   ISNULL(Т.КолТО,0) КолТО,
	|   ISNULL(Т.днХоз,0) - ISNULL(Т.днЛин,0) - ISNULL(CASE WHEN Т.днЛин<>0 THEN 0 ELSE Т.днРем END,0) днВых,
	|   ISNULL(тбГСМ.ГСМ,0) ГСМ,
	|   ISNULL(тбПрб.Пробег,0) Пробег,
	|   ISNULL(тбПрб.мтЧасы,0) мтЧасы,
	|   ISNULL(тбРее.рееЧасы,0) рееЧасы,
	|   ISNULL(тбРее.рееСум,0) рееСум,
	|   ISNULL(тбРаб.РабЧасы,0) РабЧасы,
	|   CASE WHEN &РаботаПоРеестрам=true THEN ISNULL(тбРее.рееЧасы,0) ELSE ISNULL(тбРаб.РабЧасы,0) END коэфРабЧасы
	|
	|FROM  
	|	РегистрСведений.уатРегламентированныйПроизводственныйКалендарь КАК уатРегламентированныйПроизводственныйКалендарь
	|INNER JOIN (SELECT DISTINCT Подразделение,СОстояние,ТС FROM ВРитТ Т ) Тбл ON Истина
	|LEFT OUTER JOIN ВРитТ как Т ON Т.ТС = Тбл.ТС
	|						и Т.Подразделение = Тбл.ПОдразделение 
	|						и Т.СОстояние = Тбл.СОстояние 
	|						и Т.Дт = ДатаКалендаря
	|
	|LEFT OUTER JOIN ВРгсм как тбГСМ ON тбГСМ.ТС = Тбл.ТС
	|						и тбГСМ.Дт = ДатаКалендаря
	|                       и ISNULL(Т.днХоз,0)=1
	|
	|LEFT OUTER JOIN ВРПРб как тбПрб ON тбПрб.ТС = Тбл.ТС
	|						и тбПрб.Дт = ДатаКалендаря
	|                       и ISNULL(Т.днХоз,0)=1
	|
	|LEFT OUTER JOIN ВРРаб как тбРаб ON тбРаб.ТС = Тбл.ТС
	|						и тбРаб.Дт = ДатаКалендаря
	|                       и ISNULL(Т.днХоз,0)=1
	|
	|LEFT OUTER JOIN ВРРее как тбРее ON тбРее.ТС = Тбл.ТС
	|						и тбРее.Дт = ДатаКалендаря
	|                       и ISNULL(Т.днХоз,0)=1
	|
	|LEFT OUTER JOIN Справочник.уатСостояниеТС СпрСОс ON СпрСос.ссылка = Тбл.Состояние и  СпрСос.ЗапретитьВыпискуПЛ = Ложь
	|LEFT OUTER JOIN Справочник.уатТипыТС СпртипТС ON СпртипТС.ссылка = Тбл.ТС.ТипТС 
	|
	|WHERE  ДатаКалендаря >= &Дт  
	|    и  ДатаКалендаря <  &КонПер
	|    и  (Тбл.Состояние в (&МасСос) OR &ЛюбоеСос = Истина)
	|    и (&фильтрПриоритетТС <> TRUE OR ТБл.ТС.ПриоритетноеТС = TRUE  )
	|
	|УПОРЯДОЧИТЬ ПО
	| Подразделение,
	| СпрСОс.Наименование,
	| СпртипТС.Наименование,
	| Тбл.ТС
	|
	|";
	
	Если Надовыборку Тогда
		
		Запрос.Текст = Запрос.Текст+"
		|
		|ИТОГИ  
		|	СУММА(ГСМ),
		|	СУММА(Пробег),
		|	СУММА(мтЧасы),
		|	СУММА(РееЧасы),
		|	СУММА(РабЧасы),
		|	СУММА(коэфРабЧасы),
		|	СУММА(срЧсл),
		|	СУММА(НачЧсл),
		|	СУММА(КонЧсл),
		|	СУММА(ДнХозКИП),
		|	СУММА(ДнЛинКИП),
		|	СУММА(ДнРемКИП),
		|	СУММА(ДнХоз),
		|	СУММА(ДнЛин),
		|	СУММА(ДнРем),
		|	СУММА(ДнРем0),
		|	СУММА(днРемЛин),
		|	СУММА(ДнОЖ),
		|	СУММА(КолТО),
		|	СУММА(днВых)
		|ПО Общие,  
		|	Подразделение,
		|	Состояние,
		|	ТипТС,
		| Тбл.ТС,
		| Дт
		|";
		
		Возврат Запрос.Выполнить();
		
	ИНАче
		
		ТБл = Запрос.Выполнить().Выгрузить();
		Возврат Тбл;
		
	КонецЕСЛИ;
		

	
КонецФункции

