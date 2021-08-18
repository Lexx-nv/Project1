﻿Перем ИмяКомпоненты Экспорт;
Перем Компонента Экспорт;
Перем АктуальныйРелиз Экспорт;
Перем Права Экспорт;
Перем ИмяКомпонентыАддИн Экспорт;













Функция КлючЗащитыПрисутствует() Экспорт
	Возврат Истина;
	Результат = Ложь;
	Попытка
		Результат = Компонента.УправлениеАктивно();
	Исключение КонецПопытки;
	Если Не Результат Тогда
		Сообщить("Не обнаружен ключ защиты типового решения!", СтатусСообщения.ОченьВажное);
		ЗавершитьРаботуСистемы(Истина);
	КонецЕсли;

	Возврат Результат;
КонецФункции














Функция ПроверкаКаталогаКомпоненты(Знач ПроверяемыйКаталог = "", ТекстОшибки = "", Знач Режим = "Все") Экспорт
	Возврат Истина;
	ТекстОшибки = "";

	Если ТипЗнч(ПроверяемыйКаталог) <> Тип("Строка") Или ПустаяСтрока(ПроверяемыйКаталог) Тогда
		ТекстОшибки = "Не задан каталог (путь к файлам) для проверки";
		Возврат Ложь;
	ИначеЕсли Найти(ПроверяемыйКаталог, "/") > 0 Или Найти(ПроверяемыйКаталог, "\\") > 0 Или Найти(ПроверяемыйКаталог, ":") <> 2 Тогда


		ТекстОшибки = "Ошибка: Неправильно задан каталог (путь к файлам) системы защиты.
		|Для размещения данных файлов можно использовать только локальный путь
		|(каталог должен располагаться на диске данной рабочей станции).";
		Возврат Ложь;
	КонецЕсли;
	ПроверяемыйКаталог = СокрЛП(ПроверяемыйКаталог) + ?(Прав(СокрЛП(ПроверяемыйКаталог), 1) = "\", "", "\");
	Если ТипЗнч(Режим) <> Тип("Строка") Или ПустаяСтрока(Режим) Тогда
		Режим = "Все";
	КонецЕсли;

	Если Режим = "Все" Или Режим = "ТолькоКаталог" Тогда
		ФС = Новый Файл(ПроверяемыйКаталог);
		Если Не ФС.Существует() Тогда
			Попытка
				СоздатьКаталог(ПроверяемыйКаталог);
			Исключение
				ТекстОшибки = "Указанный каталог """ + ПроверяемыйКаталог + """ не существует и не может быть создан 
				|из-за ошибки: " + ОписаниеОшибки();
				Возврат Ложь;
			КонецПопытки;
		ИначеЕсли Не ФС.ЭтоКаталог() Тогда
			ТекстОшибки = "Указанный путь """ + ПроверяемыйКаталог + """ не является папкой!";
			Возврат Ложь;
		КонецЕсли;


		Попытка
			ВременноеИмя = Новый УникальныйИдентификатор;
			ВременноеИмя = "_TMP_" + СокрЛП(ИмяПользователя()) + "_" + ВременноеИмя;
			ВременноеИмя = СтрЗаменить(ВременноеИмя, " ", "_");
			ВременноеИмя = СтрЗаменить(ВременноеИмя, "-", "") + ".txt";
			ТекстДок = Новый ТекстовыйДокумент;
			ТекстДок.УстановитьТекст("Проверка доступности каталога на запись - ОК");
			ТекстДок.Вывод = ИспользованиеВывода.Разрешить;
			ТекстДок.Записать(ПроверяемыйКаталог + ВременноеИмя, КодировкаТекста.ANSI);
			ТекстДок = Неопределено;

			ФС = Новый Файл(ПроверяемыйКаталог + ВременноеИмя);
			Если Не ФС.Существует() Или Не ФС.ЭтоФайл() Тогда
				ТекстОшибки = ?(ПустаяСтрока(ТекстОшибки), "", ТекстОшибки + Символы.ПС) + "Не удалось создать временный файл, вероятно отсутствуют права на запись в эту папку";

			КонецЕсли;
			ФС = Неопределено;
			Попытка
				УдалитьФайлы(ПроверяемыйКаталог + ВременноеИмя);
			Исключение







			КонецПопытки;
		Исключение
			ТекстОшибки = ?(ПустаяСтрока(ТекстОшибки), "", ТекстОшибки + Символы.ПС) + "При проверке прав доступа к каталогу и работу с файлами получили ошибку  " + Символы.ПС + ОписаниеОшибки() + "
			|Возможно отсутствуют права на запись/создание/удаление файлов в этом каталоге.";


		КонецПопытки;

		ФС = Новый Файл(ПроверяемыйКаталог + "root.ini");
		Если ФС.Существует() Тогда
			ФС = Неопределено;
			Попытка
				УдалитьФайлы(ПроверяемыйКаталог, "root.ini");

				ФС = Новый Файл(ПроверяемыйКаталог + "root.ini");
				Если ФС.Существует() Тогда
					ТекстОшибки = ?(ПустаяСтрока(ТекстОшибки), "", ТекстОшибки + Символы.ПС) + "  Внимание! Указанный путь является рабочим каталогом сервера синхронизации системы защиты.
					|Следует указать другой путь для размещения файлов системы защиты на данной рабочей станции.";

				КонецЕсли;
			Исключение
				ТекстОшибки = ?(ПустаяСтрока(ТекстОшибки), "", ТекстОшибки + Символы.ПС) + "  Внимание! Указанный путь является рабочим каталогом сервера синхронизации системы защиты.
				|Следует указать другой путь для размещения файлов системы защиты на данной рабочей станции.";

			КонецПопытки;
		КонецЕсли;
	КонецЕсли;

	Если Режим = "Все" Или Режим = "ТолькоФайлы" Или Режим = "ТолькоКомпоненту" Тогда
		ФС = Новый Файл(ПроверяемыйКаталог + ИмяКомпоненты + ".dll");
		Если Не ФС.Существует() Или Не ФС.ЭтоФайл() Тогда
			ТекстОшибки = ?(ПустаяСтрока(ТекстОшибки), "", ТекстОшибки + Символы.ПС) + "Не обнаружен файл внешней компоненты ( " + ИмяКомпоненты + ".dll ) Без этого файла запуск типового решения невозможен";

		КонецЕсли;
	КонецЕсли;
	Если Режим = "Все" Или Режим = "ТолькоФайлы" Или Режим = "ТолькоФайлСхемы" Тогда
		ФС = Новый Файл(ПроверяемыйКаталог + "config.xml");
		Если Не ФС.Существует() Или Не ФС.ЭтоФайл() Тогда
			ТекстОшибки = ?(ПустаяСтрока(ТекстОшибки), "", ТекстОшибки + Символы.ПС) + "Не обнаружен конфигурационный файл СЗиУО ( config.xml ) Без этого файла запуск защиты и типового решения невозможен";

		КонецЕсли;
	КонецЕсли;
	Если Не ПустаяСтрока(ТекстОшибки) Тогда
		ТекстОшибки = "При проверке локального каталога защиты """ + ПроверяемыйКаталог + """ были обнаружены ошибки:" + Символы.ПС + ТекстОшибки;
	КонецЕсли;

	Возврат ПустаяСтрока(ТекстОшибки);
КонецФункции







Функция РелизКомпонентыАктуален(НомерРелизаКомпоненты = 0, ТекстОшибки = "") Экспорт
	Возврат Истина;
	Если НомерРелизаКомпоненты >= АктуальныйРелиз Тогда
		Результат = Истина;
	Иначе
		Результат = Ложь;
		ТекстОшибки = "ВНИМАНИЕ! Компонента защиты типового решения устарела, 
		|необходимо иметь файл " + ИмяКомпоненты + ".dll релиза: " + АктуальныйРелиз + " (или выше).
		|Рекомендуется выполнить полную переустановку системы защиты, используя дистрибутив из последней версии комплекта поставки типового решения.";
	КонецЕсли;
	Возврат Результат;
КонецФункции


Функция ЗагрузитьКомпоненту(ЛокальныйКаталог) Экспорт
	Возврат Истина;
	
	ПолноеИмяКомпоненты = ЛокальныйКаталог + ИмяКомпоненты + ".dll";
	ТекстОшибки = "Не удалось загрузить компоненту " + ПолноеИмяКомпоненты + Символы.ПС;
	Попытка
		Состояние("Загрузка компоненты защиты...");
		ЗагрузитьВнешнююКомпоненту(ПолноеИмяКомпоненты);
		Состояние("Создание объекта внешней компоненты...");
		ТекстОшибки = "Не удалось создать объект компоненты " + ПолноеИмяКомпоненты + Символы.ПС;
		глКомпонентаЗащитыУАТ = Новый("AddIn." + ИмяКомпонентыАддИн, Неопределено);
		Состояние("Проверка версии внешней компоненты...");
		ТекстОшибки = "Не удалось проверить версию компоненты " + ПолноеИмяКомпоненты + Символы.ПС;
		РелизКомпонентыЗащиты = глКомпонентаЗащитыУАТ.РелизКомпоненты();
		Если РелизКомпонентыАктуален(РелизКомпонентыЗащиты, ТекстОшибки) Тогда
			Состояние("Проверка версии внешней компоненты - ОК");
			ТекстОшибки = "OK";
		ИначеЕсли ПустаяСтрока(ТекстОшибки) Тогда
			Состояние("ОШИБКА: Устаревшая версия компоненты " + ИмяКомпоненты + ".dll");
			ТекстОшибки = "Компонента защиты устарела. Необходимо обновить систему защиты типового решения.";
		КонецЕсли;
	Исключение
		ТекстОшибки = ТекстОшибки + ОписаниеОшибки();
	КонецПопытки;

	Возврат ТекстОшибки;
КонецФункции


Компонента = глКомпонентаЗащитыУАТ;
ИмяКомпоненты = "V8UATProf";
ИмяКомпонентыАддИн = "V8UATProf";
АктуальныйРелиз = 7;
Права = глПраваУАТ;




