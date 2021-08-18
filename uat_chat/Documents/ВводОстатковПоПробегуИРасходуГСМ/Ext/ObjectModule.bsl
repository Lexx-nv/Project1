﻿
Процедура ОбработкаПроведения(Отказ, РежимПроведения)
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	ВводОстатковПоПробегуИРасходуГСМТС.ТС,
	               |	ВводОстатковПоПробегуИРасходуГСМТС.Период,
	               |	ВводОстатковПоПробегуИРасходуГСМТС.Пробег Количество,
	               |	ВводОстатковПоПробегуИРасходуГСМТС.РасходГСМ РасходПоФакту,
				   |    ВводОстатковПоПробегуИРасходуГСМТС.Ссылка.Организация Организация,
				   |    Значение(Справочник.уатПараметрыВыработки.ПробегОбщий)ПараметрВыработки,
				   |    Значение(Справочник.ОборудованиеРаботыГСМ.Двигатель)Оборудование,
				   |    &КА Контрагент,
				   |    Значение(ВидДвиженияНакопления.Приход) ВидДвижения
	               |ИЗ
	               |	Документ.ВводОстатковПоПробегуИРасходуГСМ.ТС КАК ВводОстатковПоПробегуИРасходуГСМТС
				   |WHERE ВводОстатковПоПробегуИРасходуГСМТС.Ссылка = &сс";
				   Запрос.УстановитьПараметр("сс",Ссылка);
				   Запрос.УстановитьПараметр("КА",Справочники.Контрагенты.НайтиПоКоду("22"));
				   
				   
		Тбл = Запрос.Выполнить().Выгрузить();
		
		Наб = Движения.уатВыработкаТС;
		Наб.Загрузить(Тбл.Скопировать(,"Организация,ТС,ПараметрВыработки,Количество,Период,ВидДвижения"));
		Наб.Записать();
		
		Наб = Движения.уатРасходГСМнаТС;
		Наб.Загрузить(Тбл.Скопировать(,"ТС,РасходПоФакту,Период,ВидДвижения,Оборудование,Контрагент"));
		Наб.Записать();
		
	
	
	                              
КонецПроцедуры
