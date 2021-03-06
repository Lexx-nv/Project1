// Универсальная процедура, которая инициирует механизм подбора
// номенклатуры в документы (открывает основную форму обработки подбор).
//
// Параметры:
//  ФормаДокумента - форма документа, в который осуществляется подбор,
//  СтруктураПараметров - параметры, которые передаются в форму подбора.
//
Процедура ОткрытьПодборНоменклатуры(ФормаДокумента, СтруктураПараметров) Экспорт

	СтруктураПараметров.Вставить("ЗакрыватьПриВыборе", Ложь);
	
	// По умолчанию услуги нелья подбирать
	Если НЕ СтруктураПараметров.Свойство("ОтборУслугПоСправочнику") Тогда
		СтруктураПараметров.Вставить("ОтборУслугПоСправочнику", Истина);
	КонецЕсли; 
	Если НЕ СтруктураПараметров.Свойство("ПодбиратьУслуги") Тогда
		СтруктураПараметров.Вставить("ПодбиратьУслуги", Ложь);
	КонецЕсли; 
	
	ОткрытьФормуМодально("ОбщаяФорма.ФормаПодбораНоменклатурыУправляемая", СтруктураПараметров, ФормаДокумента);
	
КонецПроцедуры //
