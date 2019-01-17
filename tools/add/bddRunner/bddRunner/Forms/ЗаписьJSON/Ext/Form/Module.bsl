﻿Перем ТекущийУровень;	//для отбивки табами
Перем ФайлJSON;			//куда сохранять
Перем ТекстJSON;		//текст файла
Перем СимволТаб;		//
Перем Разделитель;

Перем ЕстьНачалоМассиваОбъекта;
Перем ЕстьНачалоЗначения;


Процедура ЗаписатьНачалоОбъекта() Экспорт
	ТекстJSON = ТекстJSON + 
				Разделитель+
				?(ЕстьНачалоЗначения,"",Символы.ПС+ДобавитьОтбивку())+
				"{";
	ТекущийУровень = ТекущийУровень + 1;
	Разделитель = "";
	ЕстьНачалоМассиваОбъекта = Истина;
КонецПроцедуры

Процедура ЗаписатьКонецОбъекта() Экспорт
	ТекущийУровень = ТекущийУровень - 1;
	ТекстJSON = ТекстJSON +
				Символы.ПС +
				ДобавитьОтбивку()+
				"}";
	Разделитель = ",";
КонецПроцедуры

Процедура ЗаписатьНачалоМассива() Экспорт
	ТекстJSON = ТекстJSON + 
				Разделитель+
				?(ЕстьНачалоЗначения, "", Символы.ПС)+
				"[";
	ТекущийУровень = ТекущийУровень + 1;
	Резделитель = "";
	ЕстьНачалоМассиваОбъекта = Истина;
	ЕстьНачалоЗначения = Ложь;
КонецПроцедуры

Процедура ЗаписатьКонецМассива() Экспорт
	ТекущийУровень = ТекущийУровень - 1;
	ТекстJSON = ТекстJSON +
				?(ЕстьНачалоМассиваОбъекта, "", Символы.ПС+ДобавитьОтбивку()) +
				"]";
	Разделитель = ",";
	ЕстьНачалоМассиваОбъекта = Ложь;
КонецПроцедуры

Процедура ЗаписатьИмяСвойства(ИмяСвойства) Экспорт
	ТекстJSON = ТекстJSON + 
				Разделитель+
				Символы.ПС+
				ДобавитьОтбивку()+
				""""+
				ИмяСвойства+
				""": ";
	Разделитель = "";
	ЕстьНачалоЗначения = Истина;
	ЕстьНачалоМассиваОбъекта = Ложь;
КонецПроцедуры

Процедура ЗаписатьЗначение(Значение) Экспорт
	
	Если ТипЗнч(Значение) = Тип("Строка") Тогда
		Значение = СтрЗаменить(Значение, "\", "\\");
		Значение = СтрЗаменить(Значение, """", "\""");
		Выделение = """";
	Иначе
		Значение = Формат(Значение,"ЧН=; ЧГ=");
		Выделение = "";
	КонецЕсли;
	ТекстJSON = ТекстJSON + 
				Выделение+
				Значение+
				Выделение;
	Разделитель = ",";
	ЕстьНачалоЗначения = Ложь;
КонецПроцедуры

Процедура ОткрытьФайл(ПутьКФайлу, СимволОтбивки) Экспорт
	//ФайлJSON = Новый ЗаписьТекста(ПутьКФайлу);
	ФайлJSON = ПутьКФайлу;
	ТекстJSON = "";
	СимволТаб = СимволОтбивки;
	ТекущийУровень = 0;
	Разделитель = "";
	ЕстьНачалоЗначения = Ложь;
	ЕстьНачалоМассиваОбъекта = Ложь;
КонецПроцедуры

Процедура ЗакрытьФайл() Экспорт
	ПутьКВременномуФайлу=ПолучитьИмяВременногоФайла("json");
	ВременныйФайл = Новый ЗаписьТекста(ПутьКВременномуФайлу);
    ВременныйФайл.Записать(СокрЛП(ТекстJSON));
    ВременныйФайл.Закрыть();

	УбитьВОМ(ПутьКВременномуФайлу, ФайлJSON, КаталогВременныхФайлов()+"\kill_bom");
КонецПроцедуры

Функция ДобавитьОтбивку()
	ВремСтрока = "";
	Для Сч=1 По ТекущийУровень Цикл
		ВремСтрока = ВремСтрока + СимволТаб;
	КонецЦикла;
	
	Возврат ВремСтрока;
КонецФункции

Процедура УбитьВОМ(Знач ИсходныйФайл, РезультирующийФайл, ВременнаяПапка, МассивФайлов = Неопределено)
    Если МассивФайлов = Неопределено Тогда
        МассивФайлов = Новый Массив;
    КонецЕсли;
    бин = Новый ДвоичныеДанные(ИсходныйФайл);
    размер = бин.Размер();
    новыйРазмер = Макс(Окр(размер/2,0),3);
    массив = РазделитьФайл(ИсходныйФайл,новыйРазмер);
    Если массив.Количество() = 2 Тогда
        МассивФайлов.Вставить(0,массив[1]);
    КонецЕсли;
    Если новыйРазмер = 3 Тогда
        ОбъединитьФайлы(МассивФайлов,РезультирующийФайл);
        УдалитьФайлы(ВременнаяПапка);
    Иначе
        УбитьВОМ(массив[0],РезультирующийФайл,ВременнаяПапка,МассивФайлов);
    КонецЕсли;
КонецПроцедуры