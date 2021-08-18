﻿&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	КаталогДляСохраненияДанныхПечати = УправлениеПечатью.ПолучитьЛокальныйКаталогФайловПечати();
	
КонецПроцедуры

&НаКлиенте
Процедура ПутьККаталогуНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	Если ПодключитьРасширениеРаботыСФайлами() Тогда
		ДиалогОткрытияФайла = Новый ДиалогВыбораФайла(РежимДиалогаВыбораФайла.ВыборКаталога);
		ДиалогОткрытияФайла.ПолноеИмяФайла = "";
		ДиалогОткрытияФайла.Каталог = КаталогДляСохраненияДанныхПечати;
		ДиалогОткрытияФайла.МножественныйВыбор = Ложь;
		ДиалогОткрытияФайла.Заголовок = НСтр("ru = 'Выберите путь к каталогу для файлов печати'");
		Если ДиалогОткрытияФайла.Выбрать() Тогда
			КаталогДляСохраненияДанныхПечати = ДиалогОткрытияФайла.Каталог + "\";
		КонецЕсли;
	Иначе
		Предупреждение(НСтр("ru = 'Для выбора каталога необходимо установить расширение для работы с файлами в Веб-клиенте.'"));
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОК(Команда)
	
	УправлениеПечатью.СохранитьЛокальныйКаталогФайловПечати(КаталогДляСохраненияДанныхПечати);
	Закрыть(КаталогДляСохраненияДанныхПечати);
	
КонецПроцедуры
