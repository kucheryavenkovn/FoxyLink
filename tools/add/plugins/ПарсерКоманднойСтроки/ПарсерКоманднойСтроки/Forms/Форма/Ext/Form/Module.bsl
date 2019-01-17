﻿
// { Plugin interface
&НаКлиенте
Функция ОписаниеПлагина(ВозможныеТипыПлагинов) Экспорт
	Возврат ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов);
КонецФункции

&НаСервере
Функция ОписаниеПлагинаНаСервере(ВозможныеТипыПлагинов)
	Возврат ЭтотОбъектНаСервере().ОписаниеПлагина(ВозможныеТипыПлагинов);
КонецФункции

&НаКлиенте
Процедура Инициализация(КонтекстЯдраПараметр) Экспорт
КонецПроцедуры
// } Plugin interface

&НаКлиенте
Функция Разобрать(СтрокаПараметров) Экспорт
	Возврат РазобратьНаСервере(СтрокаПараметров);
КонецФункции

&НаСервере
Функция РазобратьНаСервере(СтрокаПараметров)
	Возврат ЭтотОбъектНаСервере().Разобрать(СтрокаПараметров);
КонецФункции

// { Helpers
&НаСервере
Функция ЭтотОбъектНаСервере()
	Возврат РеквизитФормыВЗначение("Объект");
КонецФункции
// } Helpers
