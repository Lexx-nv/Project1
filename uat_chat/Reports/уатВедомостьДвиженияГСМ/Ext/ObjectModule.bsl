#Если Клиент Тогда
	
//=================================================================================
// ПРОЦЕДУРЫ И ФУНКЦИИ НАЧАЛЬНОЙ НАСТРОЙКИ ОТЧЕТА


// Процедура установки начальных настроек отчета с использованием текста запроса
//
Процедура УстановитьНачальныеНастройки(ДополнительныеПараметры = Неопределено) Экспорт
	
	// Содержит название отчета, которое будет выводиться в шапке.
	// Тип: Строка.
	// Пример:
	// УниверсальныйОтчет.мНазваниеОтчета = "Название отчета";
	УниверсальныйОтчет.мНазваниеОтчета = СокрЛП(ЭтотОбъект.Метаданные().Синоним);
	
	Если ДополнительныеПараметры <> Неопределено Тогда
		
		//уатОбщегоНазначения.уатВосстановитьРеквизитыОтчета(ЭтотОбъект, ДополнительныеПараметры);
		
	КонецЕсли;
	
	УниверсальныйОтчет.мВыбиратьИмяРегистра = Ложь;
	УниверсальныйОтчет.мВыбиратьИспользованиеСвойств = Ложь;
	
	ТекстЗапроса = 
	"ВЫБРАТЬ
	|	ВложенныйЗапрос.ТС КАК ТС,
	|	ВложенныйЗапрос.ТСГосНомер КАК ТСГосНомер,
	|	ВложенныйЗапрос.ТСГарНомер КАК ТСГарНомер,
	|	ВложенныйЗапрос.ГСМ КАК ГСМ,
	|	ВложенныйЗапрос.Колонна КАК Колонна,
	|	ВложенныйЗапрос.Организация КАК Организация,
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ДЕНЬ) КАК ПериодДень,
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, НЕДЕЛЯ) КАК ПериодНеделя,
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ДЕКАДА) КАК ПериодДекада,
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, МЕСЯЦ) КАК ПериодМесяц,
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, КВАРТАЛ) КАК ПериодКвартал,
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ПОЛУГОДИЕ) КАК ПериодПолугодие,
	|	НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ГОД) КАК ПериодГод,
	|	ВложенныйЗапрос.Регистратор КАК Регистратор,
	|	ВложенныйЗапрос.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|	ВложенныйЗапрос.ВводОстатков КАК ВводОстатков,
	|	ВложенныйЗапрос.ВыданоНаливом КАК ВыданоНаливом,
	|	ВложенныйЗапрос.ВыданоТалоны КАК ВыданоТалоны,
	|	ВложенныйЗапрос.ВыданоНаличные КАК ВыданоНаличные,
	|	ВложенныйЗапрос.ВыданоПластиковаяКарта КАК ВыданоПластиковаяКарта,
	|	ВложенныйЗапрос.ВыданоПоставщик КАК ВыданоПоставщик,
	|	ВложенныйЗапрос.РасходПоНорме КАК РасходПоНорме,
	|	ВложенныйЗапрос.РасходПоФакту КАК РасходПоФакту,
	|	ВложенныйЗапрос.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|	ВложенныйЗапрос.ВозвратНаСклад КАК ВозвратНаСклад,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.РасходПоНорме > ВложенныйЗапрос.РасходПоФакту
	|			ТОГДА ВложенныйЗапрос.РасходПоНорме - ВложенныйЗапрос.РасходПоФакту
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Экономия,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.РасходПоНорме <> 0
	|				И ВложенныйЗапрос.РасходПоНорме > ВложенныйЗапрос.РасходПоФакту
	|			ТОГДА ВЫРАЗИТЬ((ВложенныйЗапрос.РасходПоНорме - ВложенныйЗапрос.РасходПоФакту) / ВложенныйЗапрос.РасходПоНорме * 100 КАК ЧИСЛО(8, 1))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ЭкономияПроцент,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.РасходПоНорме < ВложенныйЗапрос.РасходПоФакту
	|			ТОГДА ВложенныйЗапрос.РасходПоФакту - ВложенныйЗапрос.РасходПоНорме
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Пережог,
	|	ВЫБОР
	|		КОГДА ВложенныйЗапрос.РасходПоНорме <> 0
	|				И ВложенныйЗапрос.РасходПоНорме < ВложенныйЗапрос.РасходПоФакту
	|			ТОГДА ВЫРАЗИТЬ((ВложенныйЗапрос.РасходПоФакту - ВложенныйЗапрос.РасходПоНорме) / ВложенныйЗапрос.РасходПоНорме * 100 КАК ЧИСЛО(8, 1))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПережогПроцент,
	|	уатНоменклатураГСМ.ГруппаГСМ.Ссылка КАК ГруппаГСМ
	|{ВЫБРАТЬ
	|	ТС.*,
	|	ТСГосНомер,
	|	ТСГарНомер,
	|	ГСМ.*,
	|	КоличествоНачальныйОстаток,
	|	ВыданоНаливом,
	|	ВыданоТалоны,
	|	ВыданоНаличные,
	|	ВыданоПластиковаяКарта,
	|	ВыданоПоставщик,
	|	РасходПоНорме,
	|	РасходПоФакту,
	|	КоличествоКонечныйОстаток,
	|	ВозвратНаСклад,
	|	Экономия,
	|	ЭкономияПроцент,
	|	Пережог,
	|	ПережогПроцент,
	|	ВводОстатков,
	|	Колонна.* КАК Колонна,
	|	Организация.* КАК Организация,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Регистратор,
	|	ГруппаГСМ.*}
	|ИЗ
	|	(ВЫБРАТЬ
	|		уатОстаткиГСМнаТСОстатки.ТС КАК ТС,
	|		уатОстаткиГСМнаТСОстатки.ТС.ГосударственныйНомер КАК ТСГосНомер,
	|		уатОстаткиГСМнаТСОстатки.ТС.ГаражныйНомер КАК ТСГарНомер,
	|		уатОстаткиГСМнаТСОстатки.ГСМ КАК ГСМ,
	|		уатМестонахождениеТС.Организация КАК Организация,
	|		уатМестонахождениеТС.Колонна КАК Колонна,
	|		уатОстаткиГСМнаТСОстатки.КоличествоНачальныйОстаток КАК КоличествоНачальныйОстаток,
	|		0 КАК ВыданоНаливом,
	|		0 КАК ВыданоТалоны,
	|		0 КАК ВыданоНаличные,
	|		0 КАК ВыданоПластиковаяКарта,
	|		0 КАК ВыданоПоставщик,
	|		0 КАК РасходПоНорме,
	|		0 КАК РасходПоФакту,
	|		уатОстаткиГСМнаТСОстатки.КоличествоКонечныйОстаток КАК КоличествоКонечныйОстаток,
	|		0 КАК ВозвратНаСклад,
	|		0 КАК ВводОстатков,
	|		уатОстаткиГСМнаТСОстатки.Период КАК Период,
	|		уатОстаткиГСМнаТСОстатки.Регистратор КАК Регистратор
	|	ИЗ
	|		РегистрНакопления.уатОстаткиГСМнаТС.ОстаткиИОбороты(&ДатаНач, &ДатаКон, Регистратор) КАК уатОстаткиГСМнаТСОстатки
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаСреза, ) КАК уатМестонахождениеТС
	|			ПО уатОстаткиГСМнаТСОстатки.ТС = уатМестонахождениеТС.ТС
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		уатОборотыПоЗаправкамГСМОбороты.ТС,
	|		уатОборотыПоЗаправкамГСМОбороты.ТС.ГосударственныйНомер,
	|		уатОборотыПоЗаправкамГСМОбороты.ТС.ГаражныйНомер,
	|		уатОборотыПоЗаправкамГСМОбороты.ГСМ,
	|		уатОборотыПоЗаправкамГСМОбороты.Организация,
	|		уатОборотыПоЗаправкамГСМОбороты.Колонна,
	|		0,
	|		ВЫБОР
	|			КОГДА уатОборотыПоЗаправкамГСМОбороты.ВидЗаправки = ЗНАЧЕНИЕ(Перечисление.уатВидыДвиженияГСМ.ЗаправкаСклад)
	|				ТОГДА уатОборотыПоЗаправкамГСМОбороты.КоличествоОборот
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА уатОборотыПоЗаправкамГСМОбороты.ВидЗаправки = ЗНАЧЕНИЕ(Перечисление.уатВидыДвиженияГСМ.ЗаправкаТалоны)
	|				ТОГДА уатОборотыПоЗаправкамГСМОбороты.КоличествоОборот
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА уатОборотыПоЗаправкамГСМОбороты.ВидЗаправки = ЗНАЧЕНИЕ(Перечисление.уатВидыДвиженияГСМ.ЗаправкаНаличные)
	|				ТОГДА уатОборотыПоЗаправкамГСМОбороты.КоличествоОборот
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА уатОборотыПоЗаправкамГСМОбороты.ВидЗаправки = ЗНАЧЕНИЕ(Перечисление.уатВидыДвиженияГСМ.ЗаправкаПластиковаяКарта)
	|				ТОГДА уатОборотыПоЗаправкамГСМОбороты.КоличествоОборот
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		ВЫБОР
	|			КОГДА уатОборотыПоЗаправкамГСМОбороты.ВидЗаправки = ЗНАЧЕНИЕ(Перечисление.уатВидыДвиженияГСМ.ЗаправкаПоставщик)
	|				ТОГДА уатОборотыПоЗаправкамГСМОбороты.КоличествоОборот
	|			ИНАЧЕ 0
	|		КОНЕЦ,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		уатОборотыПоЗаправкамГСМОбороты.Период,
	|		уатОборотыПоЗаправкамГСМОбороты.Регистратор
	|	ИЗ
	|		РегистрНакопления.уатОборотыПоЗаправкамГСМ.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК уатОборотыПоЗаправкамГСМОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		уатРасходГСМнаТСОбороты.ТС,
	|		уатРасходГСМнаТСОбороты.ТС.ГосударственныйНомер,
	|		уатРасходГСМнаТСОбороты.ТС.ГаражныйНомер,
	|		уатРасходГСМнаТСОбороты.ГСМ,
	|		уатРасходГСМнаТСОбороты.Организация,
	|		уатРасходГСМнаТСОбороты.Колонна,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		уатРасходГСМнаТСОбороты.РасходПоНормеОборот,
	|		уатРасходГСМнаТСОбороты.РасходПоФактуОборот,
	|		0,
	|		0,
	|		0,
	|		уатРасходГСМнаТСОбороты.Период,
	|		уатРасходГСМнаТСОбороты.Регистратор
	|	ИЗ
	|		РегистрНакопления.уатРасходГСМнаТС.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК уатРасходГСМнаТСОбороты
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		уатОстаткиГСМнаТСОбороты.ТС,
	|		уатОстаткиГСМнаТСОбороты.ТС.ГосударственныйНомер,
	|		уатОстаткиГСМнаТСОбороты.ТС.ГаражныйНомер,
	|		уатОстаткиГСМнаТСОбороты.ГСМ,
	|		уатМестонахождениеТС.Организация,
	|		уатМестонахождениеТС.Колонна,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		уатОстаткиГСМнаТСОбороты.КоличествоРасход,
	|		0,
	|		уатОстаткиГСМнаТСОбороты.Период,
	|		уатОстаткиГСМнаТСОбороты.Регистратор
	|	ИЗ
	|		РегистрНакопления.уатОстаткиГСМнаТС.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК уатОстаткиГСМнаТСОбороты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаСреза, ) КАК уатМестонахождениеТС
	|			ПО уатОстаткиГСМнаТСОбороты.ТС = уатМестонахождениеТС.ТС
	|	ГДЕ
	|		уатОстаткиГСМнаТСОбороты.Регистратор ССЫЛКА Документ.уатСливГСМ
	|	
	|	ОБЪЕДИНИТЬ ВСЕ
	|	
	|	ВЫБРАТЬ
	|		уатОстаткиГСМнаТСОбороты.ТС,
	|		уатОстаткиГСМнаТСОбороты.ТС.ГосударственныйНомер,
	|		уатОстаткиГСМнаТСОбороты.ТС.ГаражныйНомер,
	|		уатОстаткиГСМнаТСОбороты.ГСМ,
	|		уатМестонахождениеТС.Организация,
	|		уатМестонахождениеТС.Колонна,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		0,
	|		уатОстаткиГСМнаТСОбороты.КоличествоПриход,
	|		уатОстаткиГСМнаТСОбороты.Период,
	|		уатОстаткиГСМнаТСОбороты.Регистратор
	|	ИЗ
	|		РегистрНакопления.уатОстаткиГСМнаТС.Обороты(&ДатаНач, &ДатаКон, Регистратор, ) КАК уатОстаткиГСМнаТСОбороты
	|			ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатМестонахождениеТС.СрезПоследних(&ДатаСреза, ) КАК уатМестонахождениеТС
	|			ПО уатОстаткиГСМнаТСОбороты.ТС = уатМестонахождениеТС.ТС
	|	ГДЕ
	|		уатОстаткиГСМнаТСОбороты.Регистратор ССЫЛКА Документ.уатВводОстатковГСМ) КАК ВложенныйЗапрос
	|		ЛЕВОЕ СОЕДИНЕНИЕ РегистрСведений.уатНоменклатураГСМ КАК уатНоменклатураГСМ
	|		ПО ВложенныйЗапрос.ГСМ = уатНоменклатураГСМ.Номенклатура
	|{ГДЕ
	|	ВложенныйЗапрос.ТС.*,
	|	ВложенныйЗапрос.ТСГосНомер,
	|	ВложенныйЗапрос.ТСГарНомер,
	|	ВложенныйЗапрос.ГСМ.*,
	|	ВложенныйЗапрос.КоличествоНачальныйОстаток,
	|	ВложенныйЗапрос.ВыданоНаливом,
	|	ВложенныйЗапрос.ВыданоТалоны,
	|	ВложенныйЗапрос.ВыданоНаличные,
	|	ВложенныйЗапрос.ВыданоПластиковаяКарта,
	|	ВложенныйЗапрос.ВыданоПоставщик,
	|	ВложенныйЗапрос.РасходПоНорме,
	|	ВложенныйЗапрос.РасходПоФакту,
	|	ВложенныйЗапрос.КоличествоКонечныйОстаток,
	|	ВложенныйЗапрос.ВозвратНаСклад,
	|	(ВЫБОР
	|			КОГДА ВложенныйЗапрос.РасходПоНорме > ВложенныйЗапрос.РасходПоФакту
	|				ТОГДА ВложенныйЗапрос.РасходПоНорме - ВложенныйЗапрос.РасходПоФакту
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Экономия,
	|	(ВЫБОР
	|			КОГДА ВложенныйЗапрос.РасходПоНорме <> 0
	|					И ВложенныйЗапрос.РасходПоНорме > ВложенныйЗапрос.РасходПоФакту
	|				ТОГДА ВЫРАЗИТЬ((ВложенныйЗапрос.РасходПоНорме - ВложенныйЗапрос.РасходПоФакту) / ВложенныйЗапрос.РасходПоНорме * 100 КАК ЧИСЛО(8, 1))
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ЭкономияПроцент,
	|	(ВЫБОР
	|			КОГДА ВложенныйЗапрос.РасходПоНорме < ВложенныйЗапрос.РасходПоФакту
	|				ТОГДА ВложенныйЗапрос.РасходПоФакту - ВложенныйЗапрос.РасходПоНорме
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК Пережог,
	|	(ВЫБОР
	|			КОГДА ВложенныйЗапрос.РасходПоНорме <> 0
	|					И ВложенныйЗапрос.РасходПоНорме < ВложенныйЗапрос.РасходПоФакту
	|				ТОГДА ВЫРАЗИТЬ((ВложенныйЗапрос.РасходПоФакту - ВложенныйЗапрос.РасходПоНорме) / ВложенныйЗапрос.РасходПоНорме * 100 КАК ЧИСЛО(8, 1))
	|			ИНАЧЕ 0
	|		КОНЕЦ) КАК ПережогПроцент,
	|	ВложенныйЗапрос.ТС.Колонна.* КАК Колонна,
	|	ВложенныйЗапрос.ТС.Организация.* КАК Организация,
	|	(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ДЕНЬ)) КАК ПериодДень,
	|	(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, НЕДЕЛЯ)) КАК ПериодНеделя,
	|	(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ДЕКАДА)) КАК ПериодДекада,
	|	(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, МЕСЯЦ)) КАК ПериодМесяц,
	|	(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, КВАРТАЛ)) КАК ПериодКвартал,
	|	(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ПОЛУГОДИЕ)) КАК ПериодПолугодие,
	|	(НАЧАЛОПЕРИОДА(ВложенныйЗапрос.Период, ГОД)) КАК ПериодГод,
	|	ВложенныйЗапрос.Регистратор.* КАК Регистратор,
	|	уатНоменклатураГСМ.ГруппаГСМ.Ссылка.* КАК ГруппаГСМ,
	|	(ВЫБОР
	|			КОГДА ВложенныйЗапрос.ТС.ДатаВыбытия <> ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ИСТИНА
	|			КОГДА ВложенныйЗапрос.ТС.ДатаВыбытия = ДАТАВРЕМЯ(1, 1, 1)
	|				ТОГДА ЛОЖЬ
	|		КОНЕЦ) КАК ТСВыбыло}
	|{УПОРЯДОЧИТЬ ПО
	|	ТС.*,
	|	ТСГосНомер,
	|	ТСГарНомер,
	|	ГСМ.*,
	|	Колонна.*,
	|	Организация.*,
	|	КоличествоНачальныйОстаток,
	|	ВыданоНаливом,
	|	ВыданоТалоны,
	|	ВыданоНаличные,
	|	ВыданоПластиковаяКарта,
	|	ВыданоПоставщик,
	|	РасходПоНорме,
	|	РасходПоФакту,
	|	КоличествоКонечныйОстаток,
	|	ВозвратНаСклад,
	|	Экономия,
	|	ЭкономияПроцент,
	|	Пережог,
	|	ПережогПроцент,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Регистратор,
	|	ГруппаГСМ}
	|ИТОГИ
	|	СУММА(КоличествоНачальныйОстаток),
	|	СУММА(ВводОстатков),
	|	СУММА(ВыданоНаливом),
	|	СУММА(ВыданоТалоны),
	|	СУММА(ВыданоНаличные),
	|	СУММА(ВыданоПластиковаяКарта),
	|	СУММА(ВыданоПоставщик),
	|	СУММА(РасходПоНорме),
	|	СУММА(РасходПоФакту),
	|	СУММА(КоличествоКонечныйОстаток),
	|	СУММА(ВозвратНаСклад),
	|	ВЫБОР
	|		КОГДА СУММА(РасходПоНорме) > СУММА(РасходПоФакту)
	|			ТОГДА СУММА(РасходПоНорме) - СУММА(РасходПоФакту)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Экономия,
	|	ВЫБОР
	|		КОГДА СУММА(РасходПоНорме) <> 0
	|				И СУММА(РасходПоНорме) > СУММА(РасходПоФакту)
	|			ТОГДА ВЫРАЗИТЬ((СУММА(РасходПоНорме) - СУММА(РасходПоФакту)) / СУММА(РасходПоНорме) * 100 КАК ЧИСЛО(8, 1))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ЭкономияПроцент,
	|	ВЫБОР
	|		КОГДА СУММА(РасходПоНорме) < СУММА(РасходПоФакту)
	|			ТОГДА СУММА(РасходПоФакту) - СУММА(РасходПоНорме)
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК Пережог,
	|	ВЫБОР
	|		КОГДА СУММА(РасходПоНорме) <> 0
	|				И СУММА(РасходПоНорме) < СУММА(РасходПоФакту)
	|			ТОГДА ВЫРАЗИТЬ((СУММА(РасходПоФакту) - СУММА(РасходПоНорме)) / СУММА(РасходПоНорме) * 100 КАК ЧИСЛО(8, 1))
	|		ИНАЧЕ 0
	|	КОНЕЦ КАК ПережогПроцент
	|ПО
	|	Общие,
	|	ТС,
	|	ТСГосНомер,
	|	ТСГарНомер,
	|	ГСМ,
	|	Колонна,
	|	Организация,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Регистратор,
	|	ГруппаГСМ
	|{ИТОГИ ПО
	|	ТС.*,
	|	ТСГосНомер,
	|	ТСГарНомер,
	|	ГСМ.*,
	|	Колонна.*,
	|	Организация.*,
	|	ПериодДень,
	|	ПериодНеделя,
	|	ПериодДекада,
	|	ПериодМесяц,
	|	ПериодКвартал,
	|	ПериодПолугодие,
	|	ПериодГод,
	|	Регистратор.*,
	|	ГруппаГСМ}";	
	
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ПустаяПластиковаКарта", Справочники.уатПластиковыеКарты.ПустаяСсылка());
	// В универсальном отчете включен флаг использования свойств и категорий.
	//Если УниверсальныйОтчет.ИспользоватьСвойстваИКатегории Тогда
	//	
	//	// Добавление свойств и категорий поля запроса в таблицу полей.
	//	// Необходимо вызывать для каждого поля запроса, предоставляющего возможность использования свойств и категорий.
	//	
	//	// УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля(<ПсевдонимТаблицы>.<Поле> , 
	//                                                  <ПсевдонимПоля>, <Представление>, <Назначение>);
	//	УниверсальныйОтчет.ДобавитьСвойстваИКатегорииДляПоля("уатДТП.Заказчик", "Заказчик", "Заказчик", 
	//                                ПланыВидовХарактеристик.НазначенияСвойствКатегорийОбъектов.Справочник_Контрагенты);
	//	
	//	// Добавление свойств и категорий в исходный текст запроса.
	//	УниверсальныйОтчет.ДобавитьВТекстЗапросаСвойстваИКатегории(ТекстЗапроса);
	//	
	//КонецЕсли;
	
	// Инициализация текста запроса построителя отчета
	УниверсальныйОтчет.ПостроительОтчета.Текст = ТекстЗапроса;
	
	Пока УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Количество() > 0 Цикл
		
		УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки.Удалить(УниверсальныйОтчет.ПостроительОтчета.ИзмеренияСтроки[0]);
		
	КонецЦикла;
	
	// Представления полей отчета.
	// Необходимо вызывать для каждого поля запроса.
	// УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить(<ИмяПоля>, <ПредставлениеПоля>);
	
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТС"        , "ТС / оборудование (все поля)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГарНомер", "ТС (гар. номер)");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСГосНомер", "ТС (гос. номер)"); 
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ГСМ"       , "ГСМ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ГруппаГСМ" , "Вид ГСМ");
	УниверсальныйОтчет.мСтруктураПредставлениеПолей.Вставить("ТСВыбыло"  , "ТС выбыло");

	УниверсальныйОтчет.УстановитьПредставленияПолей(УниверсальныйОтчет.мСтруктураПредставлениеПолей, УниверсальныйОтчет.ПостроительОтчета);
	
	//// Заполнение начальных настроек универсального отчета
	//УниверсальныйОтчет.УстановитьНачальныеНастройки(Истина);
	
	// Добавление предопределенных группировок строк отчета.
	// Необходимо вызывать для каждой добавляемой группировки строки.
	// УниверсальныйОтчет.ДобавитьИзмерениеСтроки(<ПутьКДанным>);
	
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("Организация");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ТС");
	УниверсальныйОтчет.ДобавитьИзмерениеСтроки("ГСМ");
	
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоНачальныйОстаток", "Нач. остаток", Истина, "ЧДЦ=3");
	УниверсальныйОтчет.ДобавитьПоказатель("ВводОстатков", "Ввод нач. остатков", Истина, "ЧДЦ=3");
	УниверсальныйОтчет.ДобавитьПоказатель("ВыданоНаливом", "Наливом", Истина, "ЧДЦ=3", "Выдано", "Выдано");
	УниверсальныйОтчет.ДобавитьПоказатель("ВыданоТалоны", "Талоны", Истина, "ЧДЦ=3", "Выдано", "Выдано");
	УниверсальныйОтчет.ДобавитьПоказатель("ВыданоНаличные", "Наличные", Истина, "ЧДЦ=3", "Выдано", "Выдано");
	УниверсальныйОтчет.ДобавитьПоказатель("ВыданоПластиковаяКарта", "Пластик. карта", Истина, "ЧДЦ=3", "Выдано", "Выдано");
	УниверсальныйОтчет.ДобавитьПоказатель("ВыданоПоставщик", "Поставщик", Истина, "ЧДЦ=3", "Выдано", "Выдано");
	УниверсальныйОтчет.ДобавитьПоказатель("ВозвратНаСклад", "Возврат на склад", Истина, "ЧДЦ=3");
	УниверсальныйОтчет.ДобавитьПоказатель("РасходПоНорме", "Норма", Истина, "ЧДЦ=3", "РасходГорючего", "Расход горючего");
	УниверсальныйОтчет.ДобавитьПоказатель("РасходПоФакту", "Факт", Истина, "ЧДЦ=3", "РасходГорючего", "Расход горючего");
	УниверсальныйОтчет.ДобавитьПоказатель("Экономия", "Экономия", Истина, "ЧДЦ=3", "РасходГорючего", "Расход горючего");
	УниверсальныйОтчет.ДобавитьПоказатель("ЭкономияПроцент", "Экономия, %", Истина, "ЧДЦ=2", "РасходГорючего", "Расход горючего");
	УниверсальныйОтчет.ДобавитьПоказатель("Пережог", "Пережог", Истина, "ЧДЦ=3", "РасходГорючего", "Расход горючего");
	УниверсальныйОтчет.ДобавитьПоказатель("ПережогПроцент", "Пережог, %", Истина, "ЧДЦ=2", "РасходГорючего", "Расход горючего");
	УниверсальныйОтчет.ДобавитьПоказатель("КоличествоКонечныйОстаток", "Кон. остаток", Истина, "ЧДЦ=3");
	
	// Добавление предопределенных отборов отчета.
	// Необходимо вызывать для каждого добавляемого отбора.
	УниверсальныйОтчет.ДобавитьОтбор("Колонна");
	УниверсальныйОтчет.ДобавитьОтбор("ТС");
	УниверсальныйОтчет.ДобавитьОтбор("ГСМ");
	УниверсальныйОтчет.ДобавитьОтбор("ТСВыбыло", Истина, ВидСравнения.Равно, Ложь);

	
	// Установка связи подчиненных и родительских полей
	// УниверсальныйОтчет.УстановитьСвязьПолей(<ПутьКДанным>, <ПутьКДанным>);
	
	// Установка связи полей и измерений
	// УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения(<ИмяПоля>, <ИмяИзмерения>);
	//УниверсальныйОтчет.УстановитьСвязьПоляИИзмерения("ВыполнениеЗаказовНаТС", "ЗаказНаТС");	
	
	// Заполнение начальных настроек универсального отчета
	УниверсальныйОтчет.УстановитьНачальныеНастройки(Ложь);
	
	// Добавление дополнительных полей
	// Необходимо вызывать для каждого добавляемого дополнительного поля.
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТСГосНомер");
	УниверсальныйОтчет.ДобавитьДополнительноеПоле("ТС.Модель");
	
	ЗапросПоОрганизациям = Новый Запрос;
	ЗапросПоОрганизациям.Текст = "ВЫБРАТЬ
	|	уатПраваИНастройки.Объект КАК Организация,
	|	уатПраваИНастройки.Значение КАК ТочностьОстатковТоплива
	|ИЗ
	|	РегистрСведений.уатПраваИНастройки КАК уатПраваИНастройки
	|ГДЕ
	|	уатПраваИНастройки.Объект ССЫЛКА Справочник.Организации
	|	И уатПраваИНастройки.ПравоНастройка = ЗНАЧЕНИЕ(ПланВидовХарактеристик.уатПраваИНастройки.ТочностьОстатковТоплива)";
	
	Организации = ЗапросПоОрганизациям.Выполнить().Выгрузить();
	Для Каждого ТекСтрока Из Организации Цикл
		ЭлементУслОформления = УниверсальныйОтчет.ПостроительОтчета.УсловноеОформление.Добавить(""); 
		ЭлементУслОформления.Использование = Истина; 
		
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("КоличествоНачальныйОстаток", "КоличествоНачальныйОстаток", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("ВводОстатков", "ВводОстатков", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("ВыданоНаливом", "ВыданоНаливом", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("ВыданоТалоны", "ВыданоТалоны", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("ВыданоНаличные", "ВыданоНаличные", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("ВыданоПластиковаяКарта", "ВыданоПластиковаяКарта", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("ВыданоПоставщик", "ВыданоПоставщик", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("ВозвратНаСклад", "ВозвратНаСклад", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("РасходПоНорме", "РасходПоНорме", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("РасходПоФакту", "РасходПоФакту", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("Экономия", "Экономия", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("Пережог", "Пережог", ТипОбластиОформления.Поле); 
		ЭлементОбласть = ЭлементУслОформления.Область.Добавить("КоличествоКонечныйОстаток", "КоличествоКонечныйОстаток", ТипОбластиОформления.Поле); 
		
		ЭлементОтбор = ЭлементУслОформления.Отбор.Добавить("Организация","Организация","Организация"); 
		ЭлементОтбор.Использование = Истина; 
		ЭлементОтбор.ВидСравнения = ВидСравнения.Равно; 
		ЭлементОтбор.Значение = ТекСтрока.Организация;
		
		ЭлементОформления = ЭлементУслОформления.Оформление.Формат; 
		ЭлементОформления.Использование = Истина; 
		ЭлементОформления.Значение = "ЧДЦ=" + ТекСтрока.ТочностьОстатковТоплива;
	КонецЦикла;
	
	//УниверсальныйОтчет.мРассчитыватьШиринуКолонок = Ложь;
КонецПроцедуры // УстановитьНачальныеНастройки()

//=================================================================================
// ПРОЦЕДУРЫ И ФУНКЦИИ ФОРМИРОВАНИЯ ОТЧЕТА 

// Процедура формирования отчета
//
Процедура СформироватьОтчет(ТабличныйДокумент) Экспорт
	
	УниверсальныйОтчет.ПостроительОтчета.Параметры.Вставить("ДатаСреза", ?(ЗначениеЗаполнено(УниверсальныйОтчет.ДатаКон), УниверсальныйОтчет.ДатаКон, ТекущаяДата()));
	УниверсальныйОтчет.СформироватьОтчет(ТабличныйДокумент);
	
	ТабличныйДокумент.Область(, 2, 3, 2).ШиринаКолонки = 17;
	ТабличныйДокумент.ОриентацияСтраницы = ОриентацияСтраницы.Ландшафт;
	ТабличныйДокумент.ТолькоПросмотр = уатПраваИНастройки.уатПраво("ЗащитаПечатныхФорм", глПраваУАТ);
	
КонецПроцедуры // СформироватьОтчет()

//=================================================================================
// ПРОЦЕДУРЫ И ФУНКЦИИ ОБЩЕГО НАЗНАЧЕНИЯ

// Процедура обработки расшифровки
//
Процедура ОбработкаРасшифровки(Расшифровка, Объект) Экспорт
	
	// Дополнительные параметры в расшифровывающий отчет можно передать
	// посредством инициализации переменной "ДополнительныеПараметры".
	
	ДополнительныеПараметры = уатОбщегоНазначения.уатСохранитьРеквизитыОтчета(ЭтотОбъект);
	УниверсальныйОтчет.ОбработкаРасшифровкиУниверсальногоОтчета(Расшифровка, Объект, ДополнительныеПараметры);
	
КонецПроцедуры // ОбработкаРасшифровки()

// Формирует структуру для сохранения настроек отчета
//
Процедура СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками) Экспорт
	
	УниверсальныйОтчет.СформироватьСтруктуруДляСохраненияНастроек(СтруктураСНастройками);
	уатОбщегоНазначения.уатСохранитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	
КонецПроцедуры // СформироватьСтруктуруДляСохраненияНастроек()

// Заполняет настройки отчета из структуры сохраненных настроек
//
Функция ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками) Экспорт
	
	уатОбщегоНазначения.уатВосстановитьРеквизитыОтчета(ЭтотОбъект, СтруктураСНастройками);
	Возврат УниверсальныйОтчет.ВосстановитьНастройкиИзСтруктуры(СтруктураСНастройками, ЭтотОбъект);
	
КонецФункции // ВосстановитьНастройкиИзСтруктуры()

// Содержит значение используемого режима ввода периода.
// Тип: Число.
// Возможные значения: 0 - произвольный период, 1 - на дату, 2 - неделя, 3 - декада, 
// 4 - месяц, 5 - квартал, 6 - полугодие, 7 - год
// Значение по умолчанию: 0
// Пример:
УниверсальныйОтчет.мРежимВводаПериода = 0;
	
#КонецЕсли
