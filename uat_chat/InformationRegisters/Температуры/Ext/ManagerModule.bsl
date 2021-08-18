﻿Функция СоединениеСopenweathermap(ПроксиСервер)
	Соединение = Новый HTTPСоединение(
										"api.openweathermap.org", // сервер (хост)
										80, // порт, по умолчанию для http используется 80, для https 443
										, // пользователь для доступа к серверу (если он есть)
										, // пароль для доступа к серверу (если он есть)
										ПроксиСервер, //ПроксиСервер здесь указывается прокси, если он есть
										, // таймаут в секундах, 0 или пусто - не устанавливать
										// защищенное соединение, если используется https
										);
	Возврат Соединение;
КонецФункции	

Функция СоединениеГисМетео(ПроксиСервер)
	Соединение = Новый HTTPСоединение(
										"informer.gismeteo.ru/xml", // сервер (хост)
										, // порт, по умолчанию для http используется 80, для https 443
										, // пользователь для доступа к серверу (если он есть)
										, // пароль для доступа к серверу (если он есть)
										ПроксиСервер, //ПроксиСервер здесь указывается прокси, если он есть
										, // таймаут в секундах, 0 или пусто - не устанавливать
										// защищенное соединение, если используется https
										);
	Возврат Соединение;
КонецФункции	

Процедура ПогодаГисМетео(ВыбранныйГород,Место,Соединение) 
	
	Попытка
		ПутьКФайлу = КаталогВременныхФайлов()+"\WeatherData.xml";
		
		Тбл = Новый таблицаЗначений;
		Тбл.Колонки.Добавить("Дт");
		Тбл.Колонки.Добавить("Зн");
		Стр = Тбл.Добавить();
		Стр.Дт = КонецДня(ТекущаяДата());
		Стр.Зн = 999;
		Стр = Тбл.Добавить();
		Стр.Дт = КонецДня(ТекущаяДата())+3600*24;
		Стр.Зн = 999;
		
		Результат = Соединение.Получить(ВыбранныйГород+"_1.xml", ПутьКФайлу);
		
		Чтение = Новый ЧтениеXML;
		Чтение.ОткрытьФайл(ПутьКФайлу);
		Пока Чтение.Прочитать() Цикл
			Если Чтение.ТипУзла = ТипУзлаXML.КонецЭлемента Тогда
				продолжить;
			ИНачеЕсли Чтение.Имя = "FORECAST" Тогда
				
				Если   Найти("0,3",Чтение.значениеатрибута("tod"))<>0 Тогда Продолжить; КонецеСЛИ;   //ночь и вечер нам не надо
				
				пДт =  Дата(Чтение.значениеатрибута("year"),Чтение.значениеатрибута("month"),Чтение.значениеатрибута("day"),Чтение.значениеатрибута("hour"),0,0);
				
				Пока Чтение.Прочитать() Цикл
					Если Чтение.Имя = "TEMPERATURE" Тогда
						
						пТмп = (Число(Чтение.значениеатрибута("min")) + Число(Чтение.значениеатрибута("max")))/2;
						Если пДт>КонецДня(ТекущаяДата()) ТОгда //т.е. это прогноз
							Стр = Тбл[1];
						ИНаче
							Стр = Тбл[0];
						КонецеСЛИ;
						
						Если пДт <= Стр.Дт Тогда
							Стр.Дт = пДт;
							Попытка
								Стр.Зн = Число(птмп);
							Исключение КонецПопытки;
						КонецеСЛИ;
						Прервать;
					КонеЦЕСЛИ;	
				КонецЦикла;
				
			КонецеслИ;
		КонецЦикла;
		Чтение.Закрыть();
		
		Набор = РегистрыСведений.Температуры.СоздатьНаборЗаписей();
		Для каждого стр из Тбл Цикл
			Если Стр.Зн = 999 ТОгда ПродолжитЬ; КонецЕСЛИ;
			Набор.Отбор.Место.Установить(Место);
			Набор.Отбор.Период.Установить(Стр.Дт);
			Набор.Прочитать();
			Если Набор.Количество()=0 Тогда
				Зап = набор.Добавить();
				Зап.Период = Стр.Дт;
				Зап.Место = Место; 
				Зап.Темп = 99;
			ИНаче
				Зап = Набор[0];
			КонецеСЛИ;
			
			Если Зап.РучнаяКор ТОгда ПродолжитЬ; КонецЕСЛИ;
			
			Если Зап.Темп <> Стр.Зн ТОгда
				Зап.Темп = Стр.Зн;
				Набор.Записать();
				//Сообщить("Записана температура "+Место+" на "+Стр.Дт+" - "+Стр.Зн);
			КонецЕСЛИ;
			
		КонецЦиклА;
		
		УдалитьФайлы(ПутьКФайлу);
		
	Исключение
		
	КонецПопытки;
	
	
КонецПроцедуры

Процедура Погодаopenweathermap(МЕсто,НаСегодня=Ложь,Соединение) 
	
	идГорода = Место.КодМестаДляТемпературы;
	
	Если НаСегодня ТОгда
		Запрос = Новый HTTPЗапрос("/data/2.5/weather?id="+идГорода+"&APPID=71973b497e67fb239668069570f03b23");
	ИНАче
		Запрос = Новый HTTPЗапрос("/data/2.5/forecast?id="+идГорода+"&APPID=71973b497e67fb239668069570f03b23");
	КонецесЛИ;
	
	Результат = Соединение.Получить(Запрос);
	
	МасСв = новый Массив;
	
	
	ТБл = Новый ТаблицаЗначений;
	Тбл.Колонки.Добавить("Дт",Новый ОписаниеТипов("Дата"));
	Тбл.Колонки.Добавить("Темп");
	
	родСвво = "";
	пДт = ТекущаяДата();

	чтДЖ = Новый ЧтениеJSON;
	чтДЖ.УстановитьСтроку(Результат.ПолучитьТелоКакСтроку());
	чтДЖ.Прочитать();	
	Пока чтДЖ.Прочитать() Цикл
		
		Если  чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.ИмяСвойства Тогда
			свво =  чтДж.ТекущееЗначение;
			чтДЖ.Прочитать();
			Если свво = "temp" and родСвво = "main" Тогда
				НовСтр      = Тбл.Добавить();
				НовСтр.ДТ   = пДт;
				НоВстр.Темп = чтДж.ТекущееЗначение-273;
				пДт = Неопределено;
			ИначеЕсли свво = "dt" Тогда
				пДт = Дата(1970,1,1)+чтДж.ТекущееЗначение+3600*5; //UTC+5
			КонецеСЛИ;
		Конецесли;
		
		Если  чтДж.ТипТекущегоЗначения = ТипЗначенияJSON.НачалоОбъекта Тогда 
			родСвво = свво;
		КонецеСЛИ;
		
	КонецЦикла;

	Если НаСегодня=Ложь ТОгда
		кнДт = КонецДня(ТекущаяДата());
		Для а=-Тбл.Количество() по -1 Цикл
			
			Стр = Тбл[-а-1];
			Если    Час(Стр.дт)<11 
				или Час(Стр.дт)>13 
				или кнДТ > Стр.Дт Тогда
				Тбл.Удалить(-а-1);
			КонецеслИ;
			
		КонецЦикла;
	КонецеслИ;
	
	ТБл.Сортировать("дт");
	Для каждого Стр из ТБл Цикл
		Зап = РегистрыСведений.Температуры.СоздатьМенеджерЗаписи();
		Зап.Период = Стр.Дт;
		Зап.Место = МЕсто;
		Зап.Темп = ОКР(Стр.Темп);
		Зап.Записать();
	КонецЦикла;
	
КонецПроцедуры
 
Процедура ЗагрузитьТемпературу() Экспорт
	
	Запрос = Новый Запрос;
	Запрос.Текст = "ВЫБРАТЬ
	               |	уатГаражи.Ссылка,
	               |	уатГаражи.КодМестаДляТемпературы
	               |ИЗ
	               |	Справочник.уатГаражи КАК уатГаражи
				   |WHERE Подстрока(КодМестаДляТемпературы,1,1) <> "" ""
				   |
				   | UNION ALL
				   |
				   |ВЫБРАТЬ
	               |	уатГаражи.Ссылка,
	               |	уатГаражи.КодМестаДляТемпературы
	               |ИЗ
	               |	Справочник.Организации КАК уатГаражи
				   |WHERE Подстрока(КодМестаДляТемпературы,1,1) <> "" ""
				   |
				   |
				   |";
	
	ТБл =Запрос.Выполнить().Выгрузить();
	
	ПогодныйИнформер = Константы.ПогодныйИнформер.Получить();
	ПроксиСервер = глАвтограф.СформироватьДанныеПроксиСервера();
				   
	Для каждого Стр из ТБл Цикл 
		Если  ПогодныйИнформер = Перечисления.ПогодныеИнформеры.ГисМетео Тогда
			Соединение = СоединениеГисМетео(ПроксиСервер);
			ПогодаГисМетео(Стр.КодМестаДляТемпературы,Стр.ССылка,Соединение); 
		Иначе
			Соединение = СоединениеСopenweathermap(ПроксиСервер);
			Погодаopenweathermap(Стр.ССылка,Истина,Соединение);
			Погодаopenweathermap(Стр.ССылка,Ложь,Соединение);
		КонецЕсли;	
	КонецЦикла;
	
КонецПроцедуры

Функция ПолучитьТемпературу(Дт,Место=Неопределено) Экспорт
	
	Набор = РегистрыСведений.Температуры.СоздатьНаборЗаписей();
	Набор.Отбор.Период.Установить(Дт);
	Если ЗначениеЗаполнено(МЕсто) Тогда
		Набор.Отбор.Место.Установить(Место);
	КонецЕСЛИ;
	
	Набор.Прочитать();
	Если Набор.Количество()=0 Тогда
		Возврат 999;
	ИНаче
		Возврат Набор[0].темп;
	КонецеСЛИ;
	
КонецФункции


	
	//Это пример формирования данных прокси-сервера
	//ПроксиСервер.Пользователь = "Vova";
	//ПроксиСервер.Пароль = "123";
    // прокси сервер прописывается для каждого протокола отдельно
    //ПроксиСервер.Установить("http", Константы.АдресПрокси.Получить(), Константы.ПортПрокси.Получить());
    //ПроксиСервер.Установить("https", "192.168.0.1", "6547");
	
	//Найти ID для города : https://openweathermap.org/find?q=
	
	//"1497543"; - Это Нижневартовск
	//"581313"; //Это Апшеронск - для теста