# DashaMail

API wrapper для DashaMail [API](https://dashamail.ru/api/).

## Установка Ruby

    $ gem install dashamail

## Установка Rails

добавьте в Gemfile:

    gem 'dashamail'

и запустите `bundle install`.

Затем:

    rails g dashamail:install

## Требования

Необходимо получить [api_key](https://lk.dashamail.ru/?page=account&action=integrations)

## Использование Rails

В файл `config/dashamail.yml` вставьте ваши данные

## Использование Ruby

Создайте экземпляр объекта `Dashamail::Request`:

```ruby
dasha = Dashamail::Request.new(api_key: 123)
```

Вы можете изменять `api_key`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `symbolize_keys`, `logger`, и `debug`:

```ruby
Dashamail::Request.api_key = "123"
Dashamail::Request.timeout = 15
Dashamail::Request.open_timeout = 15
Dashamail::Request.symbolize_keys = true
Dashamail::Request.debug = false
```

Либо в файле `config/initializers/dashamail.rb` для Rails.

## Debug Logging

Pass `debug: true` to enable debug logging to STDOUT.

```ruby
delivery = Dashamail::Request.new(api_key: "123", debug: true)
```

### Custom logger

Ruby `Logger.new` is used by default, but it can be overrided using:

```ruby
delivery = Dashamail::Request.new(api_key: "123", debug: true, logger: MyLogger.new)
```

Logger can be also set by globally:

```ruby
Dashamail::Request.logger = MyLogger.new
```

## Примеры

### Методы для работы с Адресными Базами

#### Получаем список баз пользователя

```ruby
response = Dashamail::Request.lists.get.retrieve
result = response.body
```