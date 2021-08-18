﻿// Инициализирует таблицы значений, содержащие данные табличных частей документа.
// Таблицы значений сохраняет в свойствах структуры "ДополнительныеСвойства".
//
Процедура ИнициализироватьДанныеДокумента(ДокументСсылка, СтруктураДополнительныеСвойства) Экспорт
	мЗапрос = Новый Запрос;
	мЗапрос.Текст = 
	"ВЫБРАТЬ
	|	ЗНАЧЕНИЕ(ВидДвиженияНакопления.Приход) КАК ВидДвижения,
	|	уатЗаявкаНаРемонтРаботы.Работа КАК Номенклатура,
	|	уатЗаявкаНаРемонтРаботы.Количество,
	|	уатЗаявкаНаРемонтРаботы.Ссылка.ТС,
	|	уатЗаявкаНаРемонтРаботы.Ссылка.Организация,
	|	уатЗаявкаНаРемонтРаботы.Ссылка.ТС.Колонна КАК Колонна,
	|	уатЗаявкаНаРемонтРаботы.Ссылка КАК ЗаявкаНаРемонт,
	|	уатЗаявкаНаРемонтРаботы.Ссылка КАК Регистратор,
	|	уатЗаявкаНаРемонтРаботы.Ссылка.Дата КАК Период,
	|	уатЗаявкаНаРемонтРаботы.Ссылка.ВидОбслуживания
	|ИЗ
	|	Документ.уатЗаявкаНаРемонт.Работы КАК уатЗаявкаНаРемонтРаботы
	|ГДЕ
	|	уатЗаявкаНаРемонтРаботы.Ссылка = &Ссылка";

	мЗапрос.УстановитьПараметр("Ссылка",ДокументСсылка);
	
	МассивРезультатов = мЗапрос.ВыполнитьПакет();
	
	ТаблицаДокумента = МассивРезультатов[0].Выгрузить();
	
	//управляемая блокировка
	Блокировка = Новый БлокировкаДанных;
	ЭлементБлокировки = Блокировка.Добавить("РегистрНакопления.уатЗаявкиНаРемонт");
	ЭлементБлокировки.Режим = РежимБлокировкиДанных.Исключительный;
	ЭлементБлокировки.ИсточникДанных = ТаблицаДокумента;
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("Организация", "Организация");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ТС", "ТС");
	ЭлементБлокировки.ИспользоватьИзИсточникаДанных("ЗаявкаНаРемонт", "ЗаявкаНаРемонт");
	Блокировка.Заблокировать();
	
	СтруктураДополнительныеСвойства.ТаблицыДляДвижений.Вставить("ТаблицаЗаявокНаРемонт", ТаблицаДокумента);
КонецПроцедуры // ИнициализироватьДанныеДокумента()

// Выполняет контроль возникновения отрицательных остатков.
//
Процедура ВыполнитьКонтроль(ДокументСсылка, ДополнительныеСвойства, Отказ, УдалениеПроведения = Ложь) Экспорт
	
КонецПроцедуры