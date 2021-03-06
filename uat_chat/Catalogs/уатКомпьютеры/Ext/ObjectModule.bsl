////////////////////////////////////////////////////////////////////////////////
// ПЕРЕМЕННЫЕ ОБЪЕКТА

Перем Права Экспорт;	// Переменная объекта - ссылка на коллекцию прав, настроек и переменных окружения
Перем ПроверкаПередЗаписью Экспорт; // Переменная - дополнительно для отключения проверок доступа при начальном старте системы


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
	ОбязательныеРеквизиты.Вставить("Наименование",3);
	
	Если ДляЭлемента Тогда
	КонецЕсли;
	
	Если ДляГруппы Тогда
	КонецЕсли;

	Возврат ОбязательныеРеквизиты;
КонецФункции

// Проверяет корректность заполнения объекта.
// Возвращает Истина если все заполнено корректно и Ложь иначе.
// В случае некорректного заполнения формирует строку описанием возникших ошибок "Ошибки"
// На вход может быть передана структура ДопРеквизиты с дополнительными реквизитами для проверки
// может управляться булевыми флагами выполняемых проверок Заполнение, Уникальность
// (могут быть и другие необязательные)
// Обычно выполняется универсальным обработчиком, но могут быть добавлены доп. проверки
Функция ПроверитьКорректность(Ошибки="", ДопРеквизиты=Неопределено, Заполнение=Истина, Уникальность=Истина) Экспорт
	//Возврат спПроверитьКорректность(ЭтотОбъект, Ошибки, ДопРеквизиты, Заполнение, Уникальность);
КонецФункции
 
// Функция проверяет, допустимо ли изменение объекта
// Возвращает Истина, если изменения возможны, ложь иначе
// Если изменения доступны частично, возвращает ложь и структуру блокируемых на изменение реквизитов,
Функция ДоступностьИзменения(БлокироватьРеквизиты=Неопределено) Экспорт
    // Здесь может быть прописано определение наличия ссылок
	Возврат Истина;
КонецФункции


////////////////////////////////////////////////////////////////////////////////
// ПРОЦЕДУРЫ - ОБРАБОТЧИКИ СТАНДАРТНЫХ СОБЫТИЙ ОБЪЕКТА

// Стандартный обработчик ПередЗаписью элемента справочника
//
Процедура ПередЗаписью(Отказ)
	Если ОбменДанными.Загрузка Тогда
		Возврат;
	КонецЕсли;
	
	Если ПроверкаПередЗаписью Тогда
		уатОбщегоНазначения.уатПроверкаПравПередЗаписьюВСправочниках(ЭтотОбъект, Отказ, , Права);
	КонецЕсли;	
КонецПроцедуры


////////////////////////////////////////////////////////////////////////////////
// ИСПОЛНЯЕМАЯ ЧАСТЬ МОДУЛЯ

// сохранение ссылки на коллекцию прав, настроек и окружения
Права = Неопределено;
#Если Клиент Тогда
	Права = глПраваУАТ;
#КонецЕсли
ПроверкаПередЗаписью = Истина;