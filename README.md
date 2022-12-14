# Прототип игры семейства match-3

## Описание

- Консольное приложение на [Lua](https://www.lua.org/).
- Зависимости: `ansicolors`, `lualogging`, `lua-cjson`, `busted` (опционально, для запуска unit-тестов).

## Архитектура: [Model-View-Controller (MVC)](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)
  - `board` - модель;
  - `board_view` - представление;
  - `input` - контроллер.

## Установка зависимостей

```
# luarocks install ansicolors
# luarocks install lualogging
# luarocks install lua-cjson
# luarocks install busted
```

## Запуск

```
# lua main.lua
```
