﻿
Перем Распаковщик;
Перем Параметры;
Перем ПрофильНастроек;

Процедура Синхронизировать()

	СоздатьРаспаковщик();
	
	Попытка
		
		Если Не Распаковщик.СинхронизироватьХранилищеКонфигурацийСГит(Параметры) Тогда
			ВызватьИсключение "Синхронизация завершилась неудачно. См. лог";
		КонецЕсли;
	Исключение
		Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
		ВызватьИсключение;
	КонецПопытки;
	
	Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
	
КонецПроцедуры

Процедура СохранитьВыгруженныеФайлыВАрхив()

	СоздатьРаспаковщик();
	
	Попытка
		
		Если Не Распаковщик.СохранитьВыгруженныеФайлыВАрхив(Параметры) Тогда
			ВызватьИсключение "Выгрузка завершилась неудачно. См. лог";
		КонецЕсли;
	Исключение
		Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
		ВызватьИсключение;
	КонецПопытки;
	
	Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
	
КонецПроцедуры

Процедура ПолучитьСУдаленногоУзла()
	
	СоздатьРаспаковщик();
	
	Попытка
		
		Результат = Распаковщик.ВыполнитьGitPull(Параметры.КаталогЛокальногоРепозитория, Параметры.GitURL, Параметры.ВеткаРепозитория);
		Если Результат <> 0 Тогда
			ВызватьИсключение "Git pull завершился с кодом <"+Результат+">";
		КонецЕсли;
		
	Исключение
		Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
		ВызватьИсключение;
	КонецПопытки;
	
	Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
	
КонецПроцедуры

Процедура ОтправитьНаУдаленныйУзел()
	СоздатьРаспаковщик();
	
	Попытка
		
		Результат = Распаковщик.ВыполнитьGitPush(Параметры.КаталогЛокальногоРепозитория, Параметры.GitURL, Параметры.ВеткаРепозитория);
		Если Результат <> 0 Тогда
			ВызватьИсключение "Git push завершился с кодом <"+Результат+">";
		КонецЕсли;
		
	Исключение
		Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
		ВызватьИсключение;
	КонецПопытки;
	
	Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
	
КонецПроцедуры

Процедура ПрочитатьПараметры()
	Параметры = ПолучитьПараметрыИзОкружения();
КонецПроцедуры

Функция АбсолютныйПуть(Знач ОтносительныйПуть)
	
	Каталог = Новый Файл(ТекущийСценарий().Источник).Путь;
	Возврат Каталог + "\" + ОтносительныйПуть;
	
КонецФункции

Процедура СоздатьРаспаковщик()

	Если Распаковщик = Неопределено Тогда
		ПодключитьСценарий(АбсолютныйПуть("\libs\unpack.os"), "V83Unpack");
		Распаковщик = Новый V83Unpack;
		Если ВключенаОтладка() Тогда
			Распаковщик.РежимОтладки(Истина);
		КонецЕсли;
		
		Если ВключеноУплотнение() Тогда
			Распаковщик.РежимУплотнения(Истина);
		КонецЕсли;

		Если НомерОчереди() <> 0 Тогда
			Распаковщик.НомерОчереди(НомерОчереди());
		КонецЕсли;
		
		Если ВключеноСохранениеАрхивов() Тогда
			Распаковщик.РежимСохраненияАрхивов(Истина);
		КонецЕсли;
		
		ПараметрыИнициализации = Распаковщик.ПолучитьПараметрыИнициализации();
		Если Параметры.Свойство("ПутьКПлатформе83") Тогда
			ПараметрыИнициализации.ПутьКПлатформе83 = Параметры.ПутьКПлатформе83;
		КонецЕсли;
		ПараметрыИнициализации.ПутьGit = Параметры.ПутьGit;
		ПараметрыИнициализации.ДоменПочтыДляGit = Параметры.ДоменПочтыДляGit;
		Распаковщик.Инициализация(ПараметрыИнициализации);
		
	КонецЕсли;

КонецПроцедуры

Процедура КлонироватьУдаленныйРепо()
	
	СоздатьРаспаковщик();
	Распаковщик.РежимОтладки(ВключенаОтладка());
	Распаковщик.Инициализация(Распаковщик.ПолучитьПараметрыИнициализации());
	
	ФайлКлона = Новый Файл(Параметры.КаталогЛокальногоРепозитория + "\.git\");
	Если ФайлКлона.Существует() Тогда
		Сообщить("Каталог " + ФайлКлона.ПолноеИмя + " уже существует. Пропускаем клонирование");
		Возврат;
	КонецЕсли;
	
	РепоКлонирован = Распаковщик.КлонироватьРепозитарий(Параметры.КаталогЛокальногоРепозитория, Параметры.GitURL);
	Если Не РепоКлонирован Тогда
		Сообщить("Удаленный репозиторий не удалось клонировать");
		ЗавершитьРаботу(1);
	КонецЕсли;
	
КонецПроцедуры

Процедура СгенерироватьФайлVERSION()
	
	СоздатьРаспаковщик();
	
	ФайлВерсий = Новый Файл(Параметры.КаталогВыгрузки + "\VERSION");
	Если ФайлВерсий.Существует() Тогда
		Сообщить("Файл " + ФайлВерсий.ПолноеИмя + " уже существует. Пропускаем генерацию файла VERSION");
		Возврат;
	КонецЕсли;
	
	Распаковщик.ЗаписатьФайлВерсийГит(Параметры.КаталогВыгрузки);
	Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
	
КонецПроцедуры

Процедура СгенерироватьФайлAUTHORS()
	
	ФайлХранилища = Новый Файл(Параметры.ПутьКФайлуХранилища1С);
	Если Не ФайлХранилища.Существует() Тогда
		ВызватьИсключение "Файл хранилища <" + ФайлХранилища.ПолноеИмя + "> не существует.";
	КонецЕсли;
	
	Каталог = Параметры.КаталогВыгрузки;
	ФайлАвторов = Новый Файл(Каталог + "\AUTHORS");
	Если ФайлАвторов.Существует() Тогда
		Сообщить("Файл " + ФайлАвторов.ПолноеИмя + " уже существует. Пропускаем генерацию файла AUTHORS");
		Возврат;
	КонецЕсли;
	
	СоздатьРаспаковщик();
	
	Попытка
		ПараметрыИнициализации = Распаковщик.ПолучитьПараметрыИнициализации();
		ПараметрыИнициализации.ДоменПочтыДляGit = Параметры.ДоменПочтыДляGit;
		Распаковщик.Инициализация(ПараметрыИнициализации);
		
		Сообщить("Формирую файл в каталоге " + Каталог);
		Распаковщик.СформироватьПервичныйФайлПользователейДляGit(ФайлХранилища.ПолноеИмя, ФайлАвторов.ПолноеИмя);
		Сообщить("Файл сгенерирован");
		
		// Сообщить("Получен файл авторов из хранилища 1С " + ФайлАвторов.ПолноеИмя + " 
		// |Рекомендуется его изменить, для настройки соответствия авторов.
		// |Прервать выполнение для изменения [yes/NO]" );
		
		// ОтветПользователя = "";
		// Если ВвестиСтроку(ОтветПользователя,3) Тогда
			
		// Иначе
			// ВызватьИсключение("Выполнение прервано для редактирования файла авторов");
		// КонецЕсли;
	Исключение
		Сообщить("ОШИБКА: Не удалось сформировать файл авторов");
		Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
		ВызватьИсключение;
	КонецПопытки;
	Распаковщик.УдалитьЗарегистрированныеВременныеФайлы();
	
КонецПроцедуры

Функция ПолучитьПараметрыИзОкружения()

	СИ = Новый СистемнаяИнформация();
	Окружение = СИ.ПеременныеСреды();
	
	Сообщить(Окружение["storage_dir"] + "\1cv8ddb.1CD");
	
	Параметры = Новый Структура;
	Параметры.Вставить("ПутьКФайлуХранилища1С", Новый Файл(Окружение["storage_dir"]).ПолноеИмя + "\1cv8ddb.1CD");
	Параметры.Вставить("КаталогЛокальногоРепозитория", Новый Файл(Окружение["git_local_repo"]).ПолноеИмя);
	Параметры.Вставить("ПутьКПлатформе83", Окружение["v8_executable"]);
	Параметры.Вставить("ПутьGit", Окружение["git_executable"]);
	Параметры.Вставить("GitURL", Окружение["git_remote_repo"]);
	Параметры.Вставить("ДоменПочтыДляGit", Окружение["git_email_domain"]);
	Параметры.Вставить("КаталогВыгрузки", Окружение["unpack_dir"] + НомерОчереди()); 
	Параметры.Вставить("ВеткаРепозитория", Окружение["branch"]); 
	Параметры.Вставить("ПутьZIP", Окружение["zip_executable"]); 
	Параметры.Вставить("ПутьСохраненияАрхивов", Окружение["zip_path"]); 
	
	Возврат Параметры;

КонецФункции

Функция ВключенаОтладка()
	Количество = АргументыКоманднойСтроки.Количество();
	Если Количество > 1 Тогда
		Для Сч = 0 По Количество - 1 Цикл
			Если АргументыКоманднойСтроки[Сч] = "-debug" Тогда
				Возврат Истина;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
	Возврат  Ложь;
КонецФункции

Функция НомерОчереди()
	Количество = АргументыКоманднойСтроки.Количество();
	Если Количество > 1 Тогда
		Для Сч = 0 По Количество - 1 Цикл
			Если Строка(АргументыКоманднойСтроки[Сч]) = "-n" Тогда
				Возврат Число(АргументыКоманднойСтроки[Сч + 1]);
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
	Возврат  "";
КонецФункции

Функция ВключеноУплотнение()
	Количество = АргументыКоманднойСтроки.Количество();
	Если Количество > 1 Тогда
		Для Сч = 0 По Количество - 1 Цикл
			Если АргументыКоманднойСтроки[Сч] = "-compress" Тогда
				Возврат Истина;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
	Возврат  Ложь;
КонецФункции

Функция ВключеноСохранениеАрхивов()
	Количество = АргументыКоманднойСтроки.Количество();
	Если Количество > 1 Тогда
		Для Сч = 0 По Количество - 1 Цикл
			Если АргументыКоманднойСтроки[Сч] = "-zip" Тогда
				Возврат Истина;
			КонецЕсли;	
		КонецЦикла;
	КонецЕсли;
	
	Возврат  Ложь;
КонецФункции

Функция АдресПрофиля()
	Если АргументыКоманднойСтроки.Количество() > 0 Тогда
		_адресПрофиля = АргументыКоманднойСтроки[0];
		Попытка 
			_дескриптор = Новый Файл(_адресПрофиля);
			ПрофильНастроек = _дескриптор.ПолноеИмя;
			_дескриптор = "";
		Исключение
			ВызватьИсключение "Ошибка доступа к файлу профиля " + _адресПрофиля;
		КонецПопытки
	Иначе
		ВызватьИсключение("Ошибка запуска: не указан профиль настроек");
	КонецЕсли;
	
	Возврат _адресПрофиля;
	
КонецФункции

Процедура УстановитьПеременныеОкруженияИзПрофиля(_имяФайлаПрофиля)

	_файлНастроек = Новый ЧтениеТекста(_имяФайлаПрофиля);
	
	Настройка = _файлНастроек.ПрочитатьСтроку();
	
	Пока Настройка <> Неопределено Цикл
		Сообщить(Настройка);
		Ключ = "";
		Значение = "";
		АдресРазделителя = 0;
		
		Для сч = 1 по СтрДлина(Настройка) Цикл
			Если Сред(Настройка, сч, 1) = ":" Тогда
				
				Ключ = СокрЛП(Сред(Настройка, 1, сч - 1));
				Значение = СокрЛП(Сред(Настройка, сч + 1, СтрДлина(Настройка) - сч));
				
				Сообщить("Установлено " + Ключ + " в значение " + Значение);
				
				Прервать;
			
			КонецЕсли;
		КонецЦикла;
		
		СИ = Новый СистемнаяИнформация();
		СИ.УстановитьПеременнуюСреды(Ключ, Значение);
		
		Настройка = _файлНастроек.ПрочитатьСтроку();
	КонецЦикла

КонецПроцедуры

СИ = Новый СистемнаяИнформация();
Окружение = СИ.ПеременныеСреды();

Если Окружение["storage_dir"] = "" Тогда

	Сообщить("Режим запуска - настройки через переменные окружения от сервера сборок");

Иначе

	Сообщить("Режим запуска - настройки в файле настроек");
	УстановитьПеременныеОкруженияИзПрофиля(АдресПрофиля());

КонецЕсли;

ПрочитатьПараметры();

Если ВключеноСохранениеАрхивов() Тогда
	СохранитьВыгруженныеФайлыВАрхив();
Иначе
	КлонироватьУдаленныйРепо();
	ПолучитьСУдаленногоУзла();
	СгенерироватьФайлAUTHORS();
	СгенерироватьФайлVERSION();
	Синхронизировать();
	ОтправитьНаУдаленныйУзел();
КонецЕсли;