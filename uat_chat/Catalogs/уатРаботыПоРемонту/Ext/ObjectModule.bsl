////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт; // Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения


////////////////////////////////////////////////////////////////////////////////
// ЭКСПОРТНЫЕ ПРОЦЕДУРЫ И ФУНКЦИИ ДОПОЛНИТЕЛЬНЫХ МЕТОДОВ ОБЪЕКТА

// Возвращает структуру обязательных / уникальных реквизитов элемента
// Если ДляЭлемента = Истина, возвращаемая структура содержит реквизиты для проверки элемента
// Если ДляГруппы = Истина, аналогично для группы
// Возвращаемая структура содержит строковые идентификаторы реквизитов или вложенные структуры для табличных частей
// Для реквизита значение структуры содержит число 1-Обязательный, 3-Уникальный
Функция ПолучитьОбязательныеРеквизиты(ДляЭлемента=Истина, ДляГруппы=Ложь) Экспорт
	ОбязательныеРеквизиты=Новый Структура();
	ОбязательныеРеквизиты.Вставить("Код",1);
	ОбязательныеРеквизиты.Вставить("Наименование",1);
	
	Если ДляЭлемента Тогда
		ОбязательныеРеквизиты.Вставить("Номенклатура",1);
	КонецЕсли;
	
	Возврат ОбязательныеРеквизиты;
КонецФункции



////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА

Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	//Записывать изменения этого справочника может только пользователь с ролью "уатНачальникОТК"
	Если Не РольДоступна("уатНачальникОТК") Тогда
		ТекстПредупреждения = "Нарушение прав доступа!";
		//Предупреждение(ТекстПредупреждения);
		Отказ = Истина;
		Возврат;
	КонецЕсли;	
	
	//Если мы создаем элемент/группу на верхнем уровне, т.е. нет родителя
	//или что-то перемещаем на верхний уровень из какой-то группы или с верхнего уровня (т.е. предопределенные группы) куда-то
	//- то балалайка!!!
	
	//Ссылка.Пустая() - Это значит создается новый элемент
	Если (Не ЗначениеЗаполнено(Родитель)) Или ( Не ЗначениеЗаполнено(Ссылка.Родитель) И (Не Ссылка.Пустая()) ) Тогда
		ТекстПредупреждения = "Вы не имеете права редактировать объекты на верхнем уровне!!!";
		//Предупреждение(ТекстПредупреждения);
		Отказ = Истина;
	КонецЕсли;	
	
	
	ГруппаКУдалению = Справочники.уатРаботыПоРемонту.КУдалению;
	
	//10.07.2019 - Блокируем папку "К удалению"
	Если (Не Ссылка.Пустая()) И (глОбщий.глРодитель(Родитель) = ГруппаКУдалению Или глОбщий.глРодитель(Ссылка.Родитель) = ГруппаКУдалению) Тогда
		Отказ = Истина;
	КонецЕсли;	
	
	//Если мы перемещаем объект (элемент или папку) из одной верхней группы в другую верхнюю группу, то проверим, не использовалась ли она в рем. листах за последние 20 дней
	//Это НЕ АКТУАЛЬНО для НОВЫХ элементов
	Если (Не Ссылка.Пустая()) И (глОбщий.глРодитель(Родитель) <> глОбщий.глРодитель(Ссылка.Родитель))Тогда // определили, что происходит смена верхней группы
		
		//А теперь проверим, не используется ли перемещаемая работа/группа в ремонтных листах за последние 20 дней
		Запрос = Новый Запрос;
		Запрос.Текст = 
		"ВЫБРАТЬ ПЕРВЫЕ 1
		|	уатРемонтныйЛистРаботы.Ссылка
		|ИЗ
		|	Документ.уатРемонтныйЛист.Работы КАК уатРемонтныйЛистРаботы
		|		ВНУТРЕННЕЕ СОЕДИНЕНИЕ Документ.уатРемонтныйЛист КАК уатРемонтныйЛист
		|		ПО уатРемонтныйЛистРаботы.Ссылка = уатРемонтныйЛист.Ссылка
		|ГДЕ
		|	уатРемонтныйЛистРаботы.Работа В ИЕРАРХИИ(&Работа)
		|	И уатРемонтныйЛист.ДатаНачала > &Дата20";
		
		Запрос.УстановитьПараметр("Дата20", ТекущаяДата()-60*60*24*20);
		Запрос.УстановитьПараметр("Работа", Ссылка);
		
		РезультатЗапроса = Запрос.Выполнить();
		Выборка = РезультатЗапроса.Выбрать();
		Если Выборка.Следующий() Тогда
			ТекстПредупреждения = "Нельзя изменять основную группу. Этот элемент используется в других ремонтных листах!!!";
			//Предупреждение(ТекстПредупреждения);
			Отказ = Истина;
		КонецЕсли;;
		
	КонецЕсли;	
	
	уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВСправочниках(ЭтотОбъект, Отказ, , Права);
	Если ЭтоГруппа=Ложь Тогда
		СтрПолнНаименование = ПолноеНаименование();
	КонецеСЛИ;
КонецПроцедуры

////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли