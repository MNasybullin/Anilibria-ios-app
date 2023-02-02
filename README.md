# Anilibria
iOS App for Anilibria.tv 

## В проекте используется:
- SwiftGen (https://github.com/SwiftGen/SwiftGen) | Homebrew
- SwiftLint (https://github.com/realm/SwiftLint) | Homebrew
- Firebase (https://firebase.google.com) | Swift Package Manager
    - FirebaseAnalytics
    - FirebaseMessaging
- SkeletonView (https://github.com/Juanpe/SkeletonView.git) | Swift Package Manager

## AniLibria API – v2.13.1
- https://github.com/anilibria/docs/blob/master/api_v2.md

## Rest API
```
http(s)://api.anilibria.tv/v2/
```

# Список методов:

## Открытые методы
- [x] **getTitle** – *Получить информацию о тайтле*
- [x] **getTitles** – *Получить информацию о нескольких тайтлах сразу*
- [x] **getUpdates** – *Список тайтлов отсортированный по времени добавления нового релиза*
- [x] **getChanges** – *Список тайтлов отсортированный по времени изменения*
- [x] **getSchedule** – *Расписание выхода тайтлов, отсортированное по дням недели*
- [x] **getRandomTitle** – *Возвращает случайный тайтл из базы*
- [x] **getYouTube** – *Информация о вышедших роликах на наших YouTube каналах в хронологическом порядке*
- [ ] **getFeed** – *Список обновлений тайтлов и роликов на наших YouTube каналах в хронологическом порядке*
- [x] **getYears** – *Возвращает список годов выхода доступных тайтлов по возрастанию*
- [x] **getGenres** – *Возвращает список жанров доступных тайтлов по алфавиту*
- [x] **getCachingNodes** – *Список кеш серверов с которых можно брать данные*
- [x] **getTeam** – *Возвращает список участников команды когда-либо существовавших на проекте.*
- [ ] **getSeedStats** – *Возвращает список пользователей и их статистику на трекере.*
- [ ] **getRSS** – *Возвращает список обновлений на сайте в одном из форматов RSS ленты*
- [x] **searchTitles** – *Возвращает список найденных по фильтрам тайтлов*
- [ ] **advancedSearch** – *Поиск информации по продвинутым фильтрам с поддержкой сортировки*

## Пользовательские методы требующие авторизации
- [x] **login**
- [x] **logout**
- [x] **getFavorites** – *Получить список избранных тайтлов пользователя*
- [x] **addFavorite** – *Добавить тайтл в список избранных*
- [x] **delFavorite** – *Удалить тайтл из списка избранных*
- [x] **profileInfo** - *Получить информацию о пользователе*
