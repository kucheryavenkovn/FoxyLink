﻿&НаКлиенте
Перем КонтекстЯдра;
&НаКлиенте
Перем КоллекцияИсключаемыхКлючей;

// { Plugin interface

&НаКлиенте
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
	КонтекстЯдра = КонтекстЯдраПараметр;
КонецПроцедуры

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат Объект().ОписаниеПлагина(ВозможныеТипыПлагинов);
КонецФункции

// } Plugin interface

// { Settings interface

// Функция - Получить настройки
// 
// Возвращаемое значение:
//   - Структура
//
&НаКлиенте
Функция ПолучитьНастройки() Экспорт
	ИмяКлючаФайлаНастройки = "configpath";

	Если Не ЗначениеЗаполнено(Объект.Настройки) Тогда
		ПутьФайлаНастроек = КонтекстЯдра.ПутьФайлаНастроек();
		ФайлНастройки = Новый Файл(ПутьФайлаНастроек);
		СоздатьКоллекцияИсключаемыхКлючей();
		
		Настройки = ПрочитатьНастройкиИзФайлаJSon(ПутьФайлаНастроек);
		Настройки = ДобавитьВНастройкиДанныеИзВложенныхФайловНастроек(Настройки, ИмяКлючаФайлаНастройки, ФайлНастройки.Путь);
		Объект.Настройки = Новый ФиксированнаяСтруктура(Настройки);
		
		Если Объект.Настройки.Свойство("Отладка") Тогда
			ЕстьФлагОтладки = Объект.Настройки.Отладка;
			
			Если ЕстьСвойство(КонтекстЯдра.Объект, "ФлагОтладки") Тогда
				КонтекстЯдра.Объект.ФлагОтладки  = ЕстьФлагОтладки;			
				КонтекстЯдра.Отладка(КонтекстЯдра.СтрШаблон_("НовоеЗначение КонтекстЯдра.Объект.ФлагОтладки %1", КонтекстЯдра.Объект.ФлагОтладки));
			КонецЕсли;
			Если ЕстьСвойство(КонтекстЯдра.Объект, "DebugLog") Тогда
				КонтекстЯдра.Объект.DebugLog  = ЕстьФлагОтладки;			
				КонтекстЯдра.Отладка(КонтекстЯдра.СтрШаблон_("НовоеЗначение КонтекстЯдра.Объект.DebugLog %1", КонтекстЯдра.Объект.DebugLog));
			КонецЕсли;
		
			КонтекстЯдра.Отладка(КонтекстЯдра.СтрШаблон_("Объект.Настройки.Отладка %1", Объект.Настройки.Отладка));
			КонтекстЯдра.Отладка(КонтекстЯдра.СтрШаблон_("ЕстьСвойство(КонтекстЯдра.Объект, ФлагОтладки) %1", ЕстьСвойство(КонтекстЯдра.Объект, "ФлагОтладки")));
			КонтекстЯдра.Отладка(КонтекстЯдра.СтрШаблон_("КонтекстЯдра.Объект.ФлагОтладки %1", КонтекстЯдра.Объект.ФлагОтладки));
			
			Если ЕстьФлагОтладки Тогда
				КонтекстЯдра.Отладка("");
				КонтекстЯдра.Отладка("Файл настроек <" + ПутьФайлаНастроек + ">");
				КонтекстЯдра.Отладка("Переданные настройки:");
				ПоказатьСвойстваВРежимеОтладки(Объект.Настройки);
				КонтекстЯдра.Отладка("");
			КонецЕсли; 
		КонецЕсли;
		
	КонецЕсли; 
	Возврат Объект.Настройки;
КонецФункции

// Функция - Получить настройку
//
// Параметры:
//  КлючНастройки	 - 	 - 
// 
// Возвращаемое значение:
//   - 
//
&НаКлиенте
Функция ПолучитьНастройку(Знач КлючНастройки) Экспорт
	
	ПолучитьНастройки();
	
	Результат = Неопределено;
	Объект.Настройки.Свойство(КлючНастройки, Результат);
	Возврат Результат;

КонецФункции

// Позволяет одним вызовом получить значение из вложенных друг в друга структур
// по строке ключей, объединенных точкой. 
//
// Параметры:
//  ПутьНастроек		 - Строка	 - Путь или ключ настроек
//  СтруктураНастроек	 - Произвольный, Неопределено - полученное значение
//		( необязательно )
// 
// Возвращаемое значение:
//   Булево - Истина, если ключ/путь найден, иначе Ложь
//
// Пример: 
// 		Структура = Новый Структура("Ключ1", Новый Структура("Ключ2", Новый Структура("Ключ3", 42)));
//		РезультатПроверки = ЕстьНастройка("Ключ1.Ключ2.Ключ3", ВремЗнач);
// В результате получим ВремЗнач == 42
//
&НаКлиенте
Функция ЕстьНастройка(Знач ПутьНастроек, СтруктураНастроек = Неопределено) Экспорт
	
	Если СтруктураНастроек = Неопределено Тогда
		СтруктураНастроек = ПолучитьНастройки();
	КонецЕсли;
	
	Если ТипЗнч(СтруктураНастроек) = Тип("Структура") Или ТипЗнч(СтруктураНастроек) = Тип("ФиксированнаяСтруктура") Тогда
		
		ПозТочки = Найти(ПутьНастроек, ".");
		
		Если ПозТочки = 0 Тогда
			Возврат СтруктураНастроек.Свойство(ПутьНастроек);
		Иначе
			ИмяТекущегоСвойства = Лев(ПутьНастроек, ПозТочки - 1);
			ОстатокПути = Сред(ПутьНастроек, ПозТочки + 1);
			Если СтруктураНастроек.Свойство(ИмяТекущегоСвойства) Тогда
				Возврат ЕстьНастройка(ОстатокПути, СтруктураНастроек[ИмяТекущегоСвойства]);
			КонецЕсли;
		КонецЕсли;
		
	КонецЕсли;
	
	Возврат Ложь;
	
КонецФункции

// Процедура - Обновить
//
&НаКлиенте
Процедура Обновить() Экспорт
	Объект.Настройки = Неопределено;
	ПолучитьНастройки();
КонецПроцедуры

&НаКлиенте
// Процедура - Добавить настройку
//
// Параметры:
//  Ключ	 - 	 - 
//  Значение - 	 - 
//
Процедура ДобавитьНастройку(Знач Ключ, Знач Значение) Экспорт

	ПолучитьНастройки();
	
	Объект.Настройки.Вставить(Ключ, Значение);

КонецПроцедуры

&НаКлиенте
// Процедура - Добавить настройки
//
// Параметры:
//  ИсточникНастроек - 	 - 
//
Процедура ДобавитьНастройки(Знач ИсточникНастроек) Экспорт

	ПолучитьНастройки();
	
	Для каждого КлючЗначение Из ИсточникНастроек Цикл
		ДобавитьНастройку(КлючЗначение.Ключ, КлючЗначение.Значение);
	КонецЦикла; 
КонецПроцедуры

// } Settings interface

&НаСервере
Функция Объект()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции

// } Settings interface

&НаКлиенте
Функция ДобавитьВНастройкиДанныеИзВложенныхФайловНастроек(Знач Настройки, Знач ИмяКлючаФайлаНастройки, 
					Знач КаталогРодительскойНастройки)

	Результат = Новый Структура;
	Для каждого Настройка Из Настройки Цикл
		Значение = Настройка.Значение;
		Если ТипЗнч(Значение) = Тип("Структура") Тогда
			ПутьДопФайлаНастроек = Неопределено;
			Если Значение.Свойство(ИмяКлючаФайлаНастройки, ПутьДопФайлаНастроек) Тогда
				Значение = ПрочитатьНастройкиИзФайлаJSon(КаталогРодительскойНастройки + "/" + ПутьДопФайлаНастроек);
			КонецЕсли;
		КонецЕсли;
		
		Если ТипЗнч(Значение) = Тип("Строка") Тогда
			Значение = Заменить_workspaceRoot_на_РабочийКаталогПроекта(Значение);
		КонецЕсли;
		
		Результат.Вставить(Настройка.Ключ, Значение);			
	КонецЦикла;
	Возврат Результат;

КонецФункции

&НаКлиенте
Функция ПрочитатьНастройкиИзФайлаJSon(Знач ПутьФайлаНастроек)
	Результат = Новый Структура();
	ФайлНастроек = Новый Файл(ПутьФайлаНастроек);
	ФайлНастроекСуществует = Не ПустаяСтрока(ПутьФайлаНастроек) И 
		(КонтекстЯдра.ЕстьПоддержкаАсинхронныхВызовов Или ФайлНастроек.Существует());

	Если ФайлНастроекСуществует Тогда
		Соответствие = ПрочитатьФайлJSON(ПутьФайлаНастроек, Истина);

		Результат = ПреобразоватьСоответствиеВСтруктуру(Соответствие, КоллекцияИсключаемыхКлючей);
	КонецЕсли;
	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ПрочитатьФайлJSON(Знач ИмяФайла, Знач ЧитатьВСоответствие = Ложь) //Экспорт
	ФайлСуществующий = Новый Файл(ИмяФайла);
		
	JsonСтрока = ПрочитатьФайл(ИмяФайла);
	JsonСтрока = УбратьКомментарииИзJsonСтроки(JsonСтрока);

	Результат = Неопределено;
	ЧтениеJSON = Вычислить("Новый ЧтениеJSON");
	ЧтениеJSON.УстановитьСтроку(JsonСтрока);
	Выполнить("Результат = ПрочитатьJSON(ЧтениеJSON, ЧитатьВСоответствие)");

	Возврат Результат;
КонецФункции

&НаКлиенте
Функция ПрочитатьФайл(Знач ИмяФайла, Знач Кодировка = Неопределено) //Экспорт
	Если Не ЗначениеЗаполнено(Кодировка) Тогда
		Кодировка = КодировкаТекста.UTF8;
	КонецЕсли;

	Результат = "";
	Попытка
		Чтение = Новый ЧтениеТекста(ИмяФайла, Кодировка, , , Ложь);
		Результат  = Чтение.Прочитать();
		Чтение.Закрыть();
	Исключение
		ИнфоОшибки = ИнформацияОбОшибке();
		Если Найти(ИнфоОшибки.Описание, "Неправильный путь к файлу") = 0 Тогда // TODO проверить и исправить на английском интерфейсе

			СообщениеОшибки = СтрШаблон_("Не удалось прочитать файл %1
			|
			|Ошибка: %2" + КраткоеПредставлениеОшибки(ИнфоОшибки), ИмяФайла);

			ВызватьИсключение СообщениеОшибки;
		КонецЕсли;
	КонецПопытки;

	Возврат Результат;
КонецФункции

&НаКлиенте
Функция УбратьКомментарииИзJsonСтроки(Знач JsonСтрока)
	Результат = Новый ТекстовыйДокумент;
	ПРИЗНАК_КОММЕНТАРИЯ = "//";
	ТекстовыйДокумент = Новый ТекстовыйДокумент;
	ТекстовыйДокумент.УстановитьТекст(JsonСтрока);
	Для Счетчик = 1 По ТекстовыйДокумент.КоличествоСтрок() Цикл
		Строка = ТекстовыйДокумент.ПолучитьСтроку(Счетчик);
		Если Лев(СокрЛП(Строка), 2) = ПРИЗНАК_КОММЕНТАРИЯ Тогда
			Продолжить;
		КонецЕсли;
		Результат.ДобавитьСтроку(Строка);
	КонецЦикла;
	Возврат Результат.ПолучитьТекст();
КонецФункции

&НаКлиенте
Функция ПреобразоватьСоответствиеВСтруктуру(Знач Соответствие, Знач КоллекцияИсключаемыхКлючей)
	Результат = Новый Структура;
	Для каждого КлючЗначение Из Соответствие Цикл
		Если КоллекцияИсключаемыхКлючей.Получить(КлючЗначение.Ключ) = Неопределено Тогда
			Значение = КлючЗначение.Значение;
			Если ТипЗнч(Значение) = Тип("Соответствие") Тогда
				Значение = ПреобразоватьСоответствиеВСтруктуру(Значение, КоллекцияИсключаемыхКлючей);
			КонецЕсли;
			
			Попытка
			
				Результат.Вставить(КлючЗначение.Ключ, Значение);
			
			Исключение
				Инфо = ИнформацияОбОшибке();
				ОписаниеОшибки = "Ошибка загрузки настроек. Неверный ключ
				|" + КлючЗначение.Ключ + "
				|" + ПодробноеПредставлениеОшибки(Инфо);

				КонтекстЯдра.ЗафиксироватьОшибкуВЖурналеРегистрации("Настройки", ОписаниеОшибки);

				КонтекстЯдра.ВывестиСообщение(ОписаниеОшибки, СтатусСообщения.ОченьВажное);
				
				ВызватьИсключение;
			
			КонецПопытки;
		КонецЕсли;
	КонецЦикла;
	Возврат Результат;
КонецФункции

&НаКлиенте
Процедура СоздатьКоллекцияИсключаемыхКлючей()
	КоллекцияИсключаемыхКлючей = Новый Соответствие;
	КоллекцияИсключаемыхКлючей.Вставить("$schema", "$schema");	
КонецПроцедуры

&НаКлиенте
Функция Заменить_workspaceRoot_на_РабочийКаталогПроекта(Знач ИсходнаяСтрока)
	Возврат СтрЗаменить(ИсходнаяСтрока, "$workspaceRoot", КонтекстЯдра.Объект.КаталогПроекта);
КонецФункции

&НаКлиенте
Функция ЕстьСвойство(Знач Объект, Знач ИмяСвойства) Экспорт
    НачальноеЗНачение = Новый УникальныйИдентификатор();
    ЗначениеРеквизита = Новый Структура(ИмяСвойства, НачальноеЗНачение);
    ЗаполнитьЗначенияСвойств(ЗначениеРеквизита, Объект);
    Если ЗначениеРеквизита[ИмяСвойства] <> НачальноеЗНачение Тогда
        Возврат Истина;
    КонецЕсли;
    Возврат Ложь;
КонецФункции

&НаКлиенте
Процедура ПоказатьСвойстваВРежимеОтладки(Знач ПарамНастройки)
	Для Каждого КлючЗначение Из ПарамНастройки Цикл
		КонтекстЯдра.Отладка("Ключ <" + КлючЗначение.Ключ + ">, Значение = <" + КлючЗначение.Значение + ">");
		ТипЗначения = ТипЗнч(КлючЗначение.Значение);
		Если ТипЗначения = Тип("ФиксированнаяСтруктура") Или ТипЗначения = Тип("Структура") Тогда
			ПоказатьСвойстваВРежимеОтладки(КлючЗначение.Значение);
		КонецЕсли;
	КонецЦикла;
КонецПроцедуры

Функция СтрШаблон_(Знач СтрокаШаблон, Знач Парам1 = Неопределено, Знач Парам2 = Неопределено, Знач Парам3 = Неопределено, Знач Парам4 = Неопределено, Знач Парам5 = Неопределено) Экспорт
	
	МассивПараметров = Новый Массив;
	МассивПараметров.Добавить(Парам1);
	МассивПараметров.Добавить(Парам2);
	МассивПараметров.Добавить(Парам3);
	МассивПараметров.Добавить(Парам4);
	МассивПараметров.Добавить(Парам5);
	
	Для Сч = 1 По МассивПараметров.Количество() Цикл
		ТекЗначение = МассивПараметров[Сч-1];
		СтрокаШаблон = СтрЗаменить(СтрокаШаблон, "%"+Сч, Строка(ТекЗначение));
	КонецЦикла;
	
	Возврат СтрокаШаблон;
	
КонецФункции