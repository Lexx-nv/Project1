﻿#Если Клиент Тогда

Перем НП Экспорт;        

НП =  Новый НастройкаПериода;     
Организация = УправлениеПользователями.ПолучитьЗначениеПоУмолчанию(глЗначениеПеременной("глТекущийПользователь"), "ОсновнаяОрганизация");

#КонецЕсли

