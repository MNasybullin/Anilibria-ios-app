# Anilibria
iOS App for Anilibria.tv 

## В проекте используется:
- SwiftGen (https://github.com/SwiftGen/SwiftGen) | Homebrew
- SwiftLint (https://github.com/realm/SwiftLint) | Homebrew

## AniLibria API – v2.13.1
- https://github.com/anilibria/docs/blob/master/api_v2.md

## Rest API
```
http(s)://api.anilibria.tv/v2/
```

# Список методов:

## Открытые методы
- [x] [**getTitle**] – *Получить информацию о тайтле*
- [x] [**getTitles**](#-gettitles) – *Получить информацию о нескольких тайтлах сразу*
- [ ] [**getUpdates**](#-getupdates) – *Список тайтлов отсортированный по времени добавления нового релиза*
- [ ] [**getChanges**](#-getchanges) – *Список тайтлов отсортированный по времени изменения*
- [ ] [**getSchedule**](#-getschedule) – *Расписание выхода тайтлов, отсортированное по дням недели*
- [ ] [**getRandomTitle**](#-getrandomtitle) – *Возвращает случайный тайтл из базы*
- [x] [**getYouTube**](#-getyoutube) – *Информация о вышедших роликах на наших YouTube каналах в хронологическом порядке*
- [ ] [**getFeed**](#-getfeed) – *Список обновлений тайтлов и роликов на наших YouTube каналах в хронологическом порядке*
- [ ] [**getYears**](#-getyears) – *Возвращает список годов выхода доступных тайтлов по возрастанию*
- [ ] [**getGenres**](#-getgenres) – *Возвращает список жанров доступных тайтлов по алфавиту*
- [ ] [**getCachingNodes**](#-getcachingnodes) – *Список кеш серверов с которых можно брать данные*
- [ ] [**getTeam**](#-getteam) – *Возвращает список участников команды когда-либо существовавших на проекте.*
- [ ] [**getSeedStats**](#-getseedstats) – *Возвращает список пользователей и их статистику на трекере.*
- [ ] [**getRSS**](#-getrss) – *Возвращает список обновлений на сайте в одном из форматов RSS ленты*
- [ ] [**searchTitles**](#-searchtitles) – *Возвращает список найденных по фильтрам тайтлов*
- [ ] [**advancedSearch**](#-advancedsearch) – *Поиск информации по продвинутым фильтрам с поддержкой сортировки*

## Пользовательские методы требующие авторизации
- [ ] [**getFavorites**](#-getfavorites) – *Получить список избранных тайтлов пользователя*
- [ ] [**addFavorite**](#-addfavorite) – *Добавить тайтл в список избранных*
- [ ] [**delFavorite**](#-delfavorite) – *Удалить тайтл из списка избранных*
