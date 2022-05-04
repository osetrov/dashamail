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
dasha = Dashamail::Request.new(api_key: "123", debug: true)
```

### Custom logger

Ruby `Logger.new` is used by default, but it can be overrided using:

```ruby
dasha = Dashamail::Request.new(api_key: "123", debug: true, logger: MyLogger.new)
```

Logger can be also set by globally:

```ruby
Dashamail::Request.logger = MyLogger.new
```

## Примеры

### Методы для работы с Адресными Базами

#### [Получаем список баз пользователя](https://dashamail.ru/api_details/?method=lists.get)

```ruby
response = Dashamail::Request.lists.get.retrieve!
lists = response.data
```

#### [Добавляем адресную базу](https://dashamail.ru/api_details/?method=lists.add)

```ruby
body = {
  name: "Test"
}
response = Dashamail::Request.lists.add.create!(body: body)
list_id = response.data[:list_id]
```

#### [Обновляем контактную информацию адресной базы](https://dashamail.ru/api_details/?method=lists.update)

```ruby
body = {
  list_id: list_id,
  name: "Test renamed"
}
response = Dashamail::Request.lists.update.create!(body: body)
result = response.data
```

#### [Удаляем адресную базу и всех активных подписчиков в ней.](https://dashamail.ru/api_details/?method=lists.delete)

```ruby
body = {
  list_id: list_id
}
response = Dashamail::Request.lists.delete.create!(body: body)
result = response.data
```

#### [Получаем подписчиков в адресной базе с возможность фильтра и регулировки выдачи.](https://dashamail.ru/api_details/?method=lists.get_members)

```ruby
params = {
  list_id: list_id
}
response = Dashamail::Request.lists.get_members.retrieve!(params: params)
members = response.data
```

#### [Получаем список отписавшихся подписчиков как из всех баз, так и в разрезе конкретной адресной базы.](https://dashamail.ru/api_details/?method=lists.get_unsubscribed)

```ruby
params = {
  list_id: list_id
}
response = Dashamail::Request.lists.get_unsubscribed.retrieve!(params: params)
unsubscribed_members = response.data
```

#### [Получаем список подписчиков, нажавших «Это Спам», как из всех баз, так и в разрезе конкретной базы.](https://dashamail.ru/api_details/?method=lists.get_complaints)

```ruby
params = {
  list_id: list_id
}
response = Dashamail::Request.lists.get_complaints.retrieve!(params: params)
complaints = response.data
```

#### [Получаем активность подписчика в различных рассылках](https://dashamail.ru/api_details/?method=member_activity)

```ruby
params = {
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.member_activity.retrieve!(params: params)
activity = response.data
```

#### [Импорт подписчиков из файла](https://dashamail.ru/api_details/?method=lists.upload)

```ruby
body = {
  list_id: list_id,
  file: "https://example.com/file.xls",
  email: 0,
  type: "xls"
}
response = Dashamail::Request.lists.upload.create!(body: body)
result = response.data
```

#### [Добавляем подписчика в базу](https://dashamail.ru/api_details/?method=lists.add_member)

```ruby
body = {
  list_id: list_id,
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.add_member.create!(body: body)
member_id = response.data[:member_id]
```

#### [Добавляем несколько подписчиков в базу](https://dashamail.ru/api_details/?method=lists.add_member_batch)

```ruby
body = {
  list_id: list_id,
  batch: "pavel.osetrov@me.com;retail.deppa@yandex.ru",
  update: true
}
response = Dashamail::Request.lists.add_member_batch.create!(body: body)
result = response.data
```

#### [Редактируем подписчика в базе](https://dashamail.ru/api_details/?method=lists.update_member)

```ruby
body = {
  list_id: list_id,
  email: "pavel.osetrov@me.com",
  gender: 'm'
}
response = Dashamail::Request.lists.update_member.create!(body: body)
result = response.data
```

#### [Удаляем подписчика из базы.](https://dashamail.ru/api_details/?method=lists.delete_member)

```ruby
body = {
  member_id: member_id
}
response = Dashamail::Request.lists.delete_member.create!(body: body)
result = response.data
```

#### [Отписываем подписчика из базы.](https://dashamail.ru/api_details/?method=lists.unsubscribe_member)

```ruby
body = {
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.unsubscribe_member.create!(body: body)
result = response.data
```

#### [Перемещаем подписчика в другую адресную базу.](https://dashamail.ru/api_details/?method=lists.move_member)

```ruby
body = {
  member_id: member_id,
  list_id: list_id
}
response = Dashamail::Request.lists.move_member.create!(body: body)
result = response.data
```

#### [Копируем подписчика в другую адресную базу.](https://dashamail.ru/api_details/?method=lists.copy_member)

```ruby
body = {
  member_id: member_id,
  list_id: list_id
}
response = Dashamail::Request.lists.copy_member.create!(body: body)
result = response.data
```

#### [Добавить дополнительное поле в адресную базу.](https://dashamail.ru/api_details/?method=lists.add_merge)

```ruby
body = {
  list_id: list_id,
  type: 'text',
  title: 'Город'
}
response = Dashamail::Request.lists.add_merge.create!(body: body)
result = response.data
```

#### [Обновить настройки дополнительного поля в адресной базе.](https://dashamail.ru/api_details/?method=lists.update_merge)

```ruby
body = {
  list_id: list_id,
  merge_id: 1,
  req: 'off'
}
response = Dashamail::Request.lists.update_merge.create!(body: body)
result = response.data
```

#### [Удалить дополнительное поле из адресной базы.](https://dashamail.ru/api_details/?method=lists.delete_merge)

```ruby
body = {
  list_id: list_id,
  merge_id: 1
}
response = Dashamail::Request.lists.delete_merge.create!(body: body)
result = response.data
```

#### [Получить последний статус конкретного email в адресных базах](https://dashamail.ru/api_details/?method=lists.last_status)

```ruby
params = {
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.last_status.retrieve!(params: params)
status = response.data
```

#### [Получить историю и результаты импорта адресной базы](https://dashamail.ru/api_details/?method=lists.get_import_history)

```ruby
params = {
  list_id: list_id
}
response = Dashamail::Request.lists.get_import_history.retrieve!(params: params)
import_history = response.data
```

#### [Проверяет email-адрес на валидность и наличие в черных списках или статусе отписки](https://dashamail.ru/api_details/?method=lists.check_email)

```ruby
params = {
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.check_email.retrieve!(params: params)
valid = response.data
```



