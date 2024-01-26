# Anilibria
iOS App for Anilibria.tv 

## Инструкция по сборке проекта.
1) Склонируйте репозиторий.
```
https://github.com/MNasybullin/Anilibria-ios-app.git
```
2) В папке проекта установите CocoaPods
```
pod install
```
3) Для открытия проекта используйте сгенерированный файл Anilibria-ios-app.xcworkspace

## В проекте используется:
- CocoaPods (https://github.com/CocoaPods/CocoaPods)
- SwiftGen (https://github.com/SwiftGen/SwiftGen)
- SwiftLint (https://github.com/realm/SwiftLint)
- SkeletonView (https://github.com/Juanpe/SkeletonView.git)
- FDFullscreenPopGesture (https://github.com/forkingdog/FDFullscreenPopGesture)

## AniLibria API – v3.0.14
- https://github.com/anilibria/docs/blob/master/api_v3.md

## Rest API
```
http(s)://api.anilibria.tv/v3/
```

# Список методов:

## Открытые методы
- [x] **GET title** – *Получить информацию о тайтле*
- [x] **GET title/list** – *Получить информацию о нескольких тайтлах сразу*
- [x] **GET title/updates** – *Список тайтлов отсортированный по времени добавления нового релиза*
- [x] **GET title/changes** – *Список тайтлов отсортированный по времени изменения*
- [x] **GET title/schedule** – *Расписание выхода тайтлов, отсортированное по дням недели*
- [x] **GET title/random** – *Возвращает случайный тайтл из базы*
- [x] **GET title/search** – *Возвращает список найденных по фильтрам тайтлов*
- [ ] **GET title/search/advanced** – *Поиск информации по продвинутым фильтрам с поддержкой сортировки*
- [x] **GET title/franchises** - *Получить информацию о франшизе по ID тайтла*
- [x] **GET franchise/list** – *Возвращает список всех франшиз*
- [x] **GET youtube** – *Информация о вышедших роликах на наших YouTube каналах в хронологическом порядке*
- [ ] **GET feed** – *Список обновлений тайтлов и роликов на наших YouTube каналах в хронологическом порядке*
- [x] **GET years** – *Возвращает список годов выхода доступных тайтлов по возрастанию*
- [x] **GET genres** – *Возвращает список жанров доступных тайтлов по алфавиту*
- [x] **GET team** – *Возвращает список участников команды когда-либо существовавших на проекте.*
- [ ] **GET torrent/seed_stats** – *Возвращает список пользователей и их статистику на трекере.*
- [ ] **GET torrent/rss** – *Возвращает список обновлений на сайте в одном из форматов RSS ленты*

## Пользовательские методы требующие авторизации
- [x] **login**
- [x] **logout**
- [x] **GET user/favorites** – *Получить список избранных тайтлов пользователя*
- [x] **PUT user/favorites** – *Добавить тайтл в список избранных*
- [x] **DEL user/favorites** – *Удалить тайтл из списка избранных*
- [x] **GET user** - *Получить информацию об аккаунте пользователя*
