# DashaMail

API wrapper для DashaMail [API](https://dashamail.ru/api/).

## Оглавление
0. [Установка](#install)
   * [Установка Ruby](#install_ruby)
   * [Установка Rails](#install_rails)
1. [Методы для работы с Адресными Базами](#lists)
   * [Получаем список баз пользователя](#lists_get)
   * [Добавляем адресную базу](#lists_add)
   * [Обновляем контактную информацию адресной базы](#lists_update)
   * [Удаляем адресную базу и всех активных подписчиков в ней](#lists_delete)
   * [Получаем подписчиков в адресной базе с возможность фильтра и регулировки выдачи](#lists_get_members)
   * [Получаем список отписавшихся подписчиков как из всех баз, так и в разрезе конкретной адресной базы](#lists_get_unsubscribed)
   * [Получаем список подписчиков, нажавших «Это Спам», как из всех баз, так и в разрезе конкретной базы](#lists_get_complaints)
   * [Получаем активность подписчика в различных рассылках](#lists_member_activity)
   * [Импорт подписчиков из файла](#lists_upload)
   * [Добавляем подписчика в базу](#lists_add_member)
   * [Добавляем несколько подписчиков в базу](#lists_add_member_batch)
   * [Редактируем подписчика в базе](#lists_update_member)
   * [Удаляем подписчика из базы](#lists_delete_member)
   * [Отписываем подписчика из базы](#lists_unsubscribe_member)
   * [Перемещаем подписчика в другую адресную базу](#lists_move_member)
   * [Копируем подписчика в другую адресную базу](#lists_copy_member)
   * [Добавить дополнительное поле в адресную базу](#lists_add_merge)
   * [Обновить настройки дополнительного поля в адресной базе](#lists_update_merge)
   * [Удалить дополнительное поле из адресной базы](#lists_delete_merge)
   * [Получить последний статус конкретного email в адресных базах](#lists_last_status)
   * [Получить историю и результаты импорта адресной базы](#lists_get_import_history)
   * [Проверяет email-адрес на валидность и наличие в черных списках или статусе отписки](#lists_check_email)
2. [Методы для работы с Рассылками](#campaigns)
   * [Получаем список рассылок пользователя](#campaigns_get)
   * [Создаем рассылку](#campaigns_create)
   * [Создаем авторассылку](#campaigns_create_auto)
   * [Обновляем параметры рассылки](#campaigns_update)
   * [Обновляем параметры авторассылки](#campaigns_update_auto)
   * [Удаляем кампанию](#campaigns_delete)
   * [Добавляем вложение](#campaigns_attach)
   * [Удаляем приложенный файл](#campaigns_delete_attachment)
   * [Получаем html шаблоны](#campaigns_get_templates)
   * [Получаем шаблоны из ЛК](#campaigns_get_saved_templates)
   * [Добавляем html шаблон](#campaigns_add_template)
   * [Удаляем html шаблон](#campaigns_delete_template)
   * [Принудительно вызываем срабатывание авторассылки (при этом она должна быть активна)](#campaigns_force_auto)
   * [Создаем мультикампанию](#campaigns_multi_create)
   * [Получаем данные о мультикампаниях](#campaigns_multi_get)
   * [Обновляем параметры рассылок в рамках мультикампании](#campaigns_multi_update)
   * [Получаем папки рассылок](#campaigns_get_folders)
   * [Перемещаем рассылку в папку](#campaigns_move_to_folder)
   * [Ставим рассылку на паузу](#campaigns_pause)
   * [Возобновляем поставленную на паузу рассылку](#campaigns_restart_paused)
3. [Методы для работы с Отчетами](#reports)
   * [Список отправленных писем в рассылке](#reports_sent)
   * [Список доставленных писем в рассылке](#reports_delivered)
   * [Список открытых писем в рассылке](#reports_opened)
   * [Список писем в рассылке, где адресат перешел по любой ссылке](#reports_clicked)
   * [Список писем отписавшихся подписчиков в рассылке](#reports_unsubscribed)
   * [Список возвратившихся писем в рассылке](#reports_bounced)
   * [Краткая статистка по рассылке](#reports_summary)
   * [Статистика по браузерам, ОС и почтовым клиентам](#reports_clients)
   * [Статистика по регионам открытия](#reports_geo)
   * [Список событий с письмами в рамках рассылки за определенный период](#reports_events)
4. [Методы для работы с Аккаунтом](#account)
   * [Получить текущий баланс аккаунта](#account_get_balance)
   * [Получить список всех заданных webhooks или webhook по определенному событию](#account_get_webhooks)
   * [Обновить или добавить webhooks для событий](#account_add_webhooks)
   * [Удаляем вебхуки для событий](#account_delete_webhooks)
   * [Отправить письмо подтверждения обратного адреса для использования в ЛК или транзакционных рассылках](#account_confirm_from_email)
   * [Получить список всех подтвержденных email-адресов на аккаунте](#account_get_confirmed)
   * [Добавить домен отправки или домен статистики на аккаунт](#account_add_domain)
   * [Получить и проверить валидность DNS-записей для настройки домена отправки или статистики](#account_check_domains)
   * [Удаляем домен отправки или статистики](#account_delete_domain)

## <a name="install"></a> Установка

### <a name="install_ruby"></a> Установка Ruby

    $ gem install dashamail

### <a name="install_rails"></a> Установка Rails

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

Вы можете изменять `api_key`, `timeout`, `open_timeout`, `faraday_adapter`, `proxy`, `ssl_options`, `symbolize_keys`, `logger`, и `debug`:

```ruby
Dashamail::Request.api_key = "123"
Dashamail::Request.timeout = 15
Dashamail::Request.open_timeout = 15
Dashamail::Request.symbolize_keys = true
Dashamail::Request.debug = false
Dashamail::Request.ssl_options = { verify: false }
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

### <a name="lists"></a> Методы для работы с Адресными Базами

#### <a name="lists_get"></a> [Получаем список баз пользователя](https://dashamail.ru/api_details/?method=lists.get)

```ruby
response = Dashamail::Request.lists.get.retrieve!
lists = response.data
```

#### <a name="lists_add"></a> [Добавляем адресную базу](https://dashamail.ru/api_details/?method=lists.add)

```ruby
body = {
  name: "Test"
}
response = Dashamail::Request.lists.add.create!(body: body)
list_id = response.data[:list_id]
```

#### <a name="lists_update"></a> [Обновляем контактную информацию адресной базы](https://dashamail.ru/api_details/?method=lists.update)

```ruby
body = {
  list_id: list_id,
  name: "Test renamed"
}
response = Dashamail::Request.lists.update.create!(body: body)
result = response.data
```

#### <a name="lists_delete"></a> [Удаляем адресную базу и всех активных подписчиков в ней](https://dashamail.ru/api_details/?method=lists.delete)

```ruby
body = {
  list_id: list_id
}
response = Dashamail::Request.lists.delete.create!(body: body)
result = response.data
```

#### <a name="lists_get_members"></a> [Получаем подписчиков в адресной базе с возможность фильтра и регулировки выдачи](https://dashamail.ru/api_details/?method=lists.get_members)

```ruby
params = {
  list_id: list_id
}
response = Dashamail::Request.lists.get_members.retrieve!(params: params)
members = response.data
```

#### <a name="lists_get_unsubscribed"></a> [Получаем список отписавшихся подписчиков как из всех баз, так и в разрезе конкретной адресной базы.](https://dashamail.ru/api_details/?method=lists.get_unsubscribed)

```ruby
params = {
  list_id: list_id
}
response = Dashamail::Request.lists.get_unsubscribed.retrieve!(params: params)
unsubscribed_members = response.data
```

#### <a name="lists_get_complaints"></a> [Получаем список подписчиков, нажавших «Это Спам», как из всех баз, так и в разрезе конкретной базы](https://dashamail.ru/api_details/?method=lists.get_complaints)

```ruby
params = {
  list_id: list_id
}
response = Dashamail::Request.lists.get_complaints.retrieve!(params: params)
complaints = response.data
```

#### <a name="lists_member_activity"></a> [Получаем активность подписчика в различных рассылках](https://dashamail.ru/api_details/?method=lists.member_activity)

```ruby
params = {
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.member_activity.retrieve!(params: params)
activity = response.data
```

#### <a name="lists_upload"></a> [Импорт подписчиков из файла](https://dashamail.ru/api_details/?method=lists.upload)

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

#### <a name="lists_add_member"></a> [Добавляем подписчика в базу](https://dashamail.ru/api_details/?method=lists.add_member)

```ruby
body = {
  list_id: list_id,
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.add_member.create!(body: body)
member_id = response.data[:member_id]
```

#### <a name="lists_add_member_batch"></a> [Добавляем несколько подписчиков в базу](https://dashamail.ru/api_details/?method=lists.add_member_batch)

```ruby
body = {
  list_id: list_id,
  batch: "pavel.osetrov@me.com;retail.deppa@yandex.ru",
  update: true
}
response = Dashamail::Request.lists.add_member_batch.create!(body: body)
result = response.data
```

#### <a name="lists_update_member"></a> [Редактируем подписчика в базе](https://dashamail.ru/api_details/?method=lists.update_member)

```ruby
body = {
  list_id: list_id,
  email: "pavel.osetrov@me.com",
  gender: 'm'
}
response = Dashamail::Request.lists.update_member.create!(body: body)
result = response.data
```

#### <a name="lists_delete_member"></a> [Удаляем подписчика из базы](https://dashamail.ru/api_details/?method=lists.delete_member)

```ruby
body = {
  member_id: member_id
}
response = Dashamail::Request.lists.delete_member.create!(body: body)
result = response.data
```

#### <a name="lists_unsubscribe_member"></a> [Отписываем подписчика из базы](https://dashamail.ru/api_details/?method=lists.unsubscribe_member)

```ruby
body = {
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.unsubscribe_member.create!(body: body)
result = response.data
```

#### <a name="lists_move_member"></a> [Перемещаем подписчика в другую адресную базу](https://dashamail.ru/api_details/?method=lists.move_member)

```ruby
body = {
  member_id: member_id,
  list_id: list_id
}
response = Dashamail::Request.lists.move_member.create!(body: body)
result = response.data
```

#### <a name="lists_copy_member"></a> [Копируем подписчика в другую адресную базу](https://dashamail.ru/api_details/?method=lists.copy_member)

```ruby
body = {
  member_id: member_id,
  list_id: list_id
}
response = Dashamail::Request.lists.copy_member.create!(body: body)
result = response.data
```

#### <a name="lists_add_merge"></a> [Добавить дополнительное поле в адресную базу](https://dashamail.ru/api_details/?method=lists.add_merge)

```ruby
body = {
  list_id: list_id,
  type: 'text',
  title: 'Город'
}
response = Dashamail::Request.lists.add_merge.create!(body: body)
result = response.data
```

#### <a name="lists_update_merge"></a> [Обновить настройки дополнительного поля в адресной базе](https://dashamail.ru/api_details/?method=lists.update_merge)

```ruby
body = {
  list_id: list_id,
  merge_id: 1,
  req: 'off'
}
response = Dashamail::Request.lists.update_merge.create!(body: body)
result = response.data
```

#### <a name="lists_delete_merge"></a> [Удалить дополнительное поле из адресной базы](https://dashamail.ru/api_details/?method=lists.delete_merge)

```ruby
body = {
  list_id: list_id,
  merge_id: 1
}
response = Dashamail::Request.lists.delete_merge.create!(body: body)
result = response.data
```

#### <a name="lists_last_status"></a> [Получить последний статус конкретного email в адресных базах](https://dashamail.ru/api_details/?method=lists.last_status)

```ruby
params = {
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.last_status.retrieve!(params: params)
status = response.data
```

#### <a name="lists_get_import_history"></a> [Получить историю и результаты импорта адресной базы](https://dashamail.ru/api_details/?method=lists.get_import_history)

```ruby
params = {
  list_id: list_id
}
response = Dashamail::Request.lists.get_import_history.retrieve!(params: params)
import_history = response.data
```

#### <a name="lists_check_email"></a> [Проверяет email-адрес на валидность и наличие в черных списках или статусе отписки](https://dashamail.ru/api_details/?method=lists.check_email)

```ruby
params = {
  email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.lists.check_email.retrieve!(params: params)
valid = response.data
```

### <a name="campaigns"></a> Методы для работы с Рассылками

#### <a name="campaigns_get"></a> [Получаем список рассылок пользователя](https://dashamail.ru/api_details/?method=campaigns.get)

```ruby
response = Dashamail::Request.campaigns.get.retrieve!
campaigns = response.data
```

#### <a name="campaigns_create"></a> [Создаем рассылку](https://dashamail.ru/api_details/?method=campaigns.create)

```ruby
body = {
        list_id: list_id,
        name: "Campaigns test"
}
response = Dashamail::Request.campaigns.create.create!(body: body)
campaign_id = response.data[:campaign_id]
```

#### <a name="campaigns_create_auto"></a> [Создаем авторассылку](https://dashamail.ru/api_details/?method=campaigns.create_auto)

```ruby
body = {
        list_id: list_id,
        name: "Auto campaigns test"
}
response = Dashamail::Request.campaigns.create_auto.create!(body: body)
campaign_id = response.data[:campaign_id]
```

#### <a name="campaigns_update"></a> [Обновляем параметры рассылки](https://dashamail.ru/api_details/?method=campaigns.update)

```ruby
body = {
        campaign_id: campaign_id,
        name: "Campaigns test renamed"
}
response = Dashamail::Request.campaigns.update.create!(body: body)
result = response.data
```

#### <a name="campaigns_update_auto"></a> [Обновляем параметры авторассылки](https://dashamail.ru/api_details/?method=campaigns.update_auto)

```ruby
body = {
        campaign_id: campaign_id,
        name: "Auto campaigns test renamed"
}
response = Dashamail::Request.campaigns.update_auto.create!(body: body)
result = response.data
```

#### <a name="campaigns_delete"></a> [Удаляем кампанию](https://dashamail.ru/api_details/?method=campaigns.delete)

```ruby
body = {
        campaign_id: campaign_id
}
response = Dashamail::Request.campaigns.delete.create!(body: body)
result = response.data
```

#### <a name="campaigns_attach"></a> [Добавляем вложение](https://dashamail.ru/api_details/?method=campaigns.attach)

```ruby
body = {
        campaign_id: campaign_id,
        file: "https://storage.deppa.ru/uploads/logo.jpg",
        name: "logo.jpg"
}
response = Dashamail::Request.campaigns.attach.create!(body: body)
attach_id = response.data[:id]
```

#### <a name="campaigns_delete_attachment"></a> [Удаляем приложенный файл](https://dashamail.ru/api_details/?method=campaigns.delete_attachment)

```ruby
body = {
        campaign_id: campaign_id,
        id: attach_id
}
response = Dashamail::Request.campaigns.delete_attachment.create!(body: body)
result = response.data
```

#### <a name="campaigns_get_templates"></a> [Получаем html шаблоны](https://dashamail.ru/api_details/?method=campaigns.get_templates)

```ruby
response = Dashamail::Request.campaigns.get_templates.retrieve!
templates = response.data
```

#### <a name="campaigns_get_saved_templates"></a> [Получаем шаблоны из ЛК](https://dashamail.ru/api_details/?method=campaigns.get_saved_templates)

```ruby
response = Dashamail::Request.campaigns.get_saved_templates.retrieve!
templates = response.data
```

#### <a name="campaigns_add_template"></a> [Добавляем html шаблон](https://dashamail.ru/api_details/?method=campaigns.add_template)

```ruby
body = {
        name: "Hello",
        template: "<h1>Hello world!</h1>"
}
response = Dashamail::Request.campaigns.add_template.create!(body: body)
template_id = response.data[:id]
```

#### <a name="campaigns_delete_template"></a> [Удаляем html шаблон](https://dashamail.ru/api_details/?method=campaigns.delete_template)

```ruby
body = {
        id: template_id
}
response = Dashamail::Request.campaigns.delete_template.create!(body: body)
result = response.data
```

#### <a name="campaigns_force_auto"></a> [Принудительно вызываем срабатывание авторассылки (при этом она должна быть активна)](https://dashamail.ru/api_details/?method=campaigns.force_auto)

```ruby
body = {
        campaign_id: campaign_id,
        member_id: member_id,
        delay: 3600
}
response = Dashamail::Request.campaigns.force_auto.create!(body: body)
result = response.data
```

#### <a name="campaigns_multi_create"></a> [Создаем мультикампанию](https://dashamail.ru/api_details/?method=campaigns.multi_create)

```ruby
body = {
        data: [{
                       list_id: list_id,
                       name: "Campaigns test"
               }]
} 

response = Dashamail::Request.campaigns.multi_create.create!(body: body)
result = response.data
```

#### <a name="campaigns_multi_get"></a> [Получаем данные о мультикампаниях](https://dashamail.ru/api_details/?method=campaigns.multi_get)

```ruby
response = Dashamail::Request.campaigns.multi_get.retrieve!
result = response.data
```

#### <a name="campaigns_multi_update"></a> [Обновляем параметры рассылок в рамках мультикампании](https://dashamail.ru/api_details/?method=campaigns.multi_update)

```ruby
body = {
        campaign_id: campaign_id,
        data: [{
                       list_id: list_id,
                       name: "Campaigns test"
               }]
} 

response = Dashamail::Request.campaigns.multi_update.create!(body: body)
result = response.data
```

#### <a name="campaigns_get_folders"></a> [Получаем папки рассылок](https://dashamail.ru/api_details/?method=campaigns.get_folders)

```ruby
response = Dashamail::Request.campaigns.get_folders.retrieve!
result = response.data
```

#### <a name="campaigns_move_to_folder"></a> [Перемещаем рассылку в папку](https://dashamail.ru/api_details/?method=campaigns.move_to_folder)

```ruby
body = {
        campaign_id: campaign_id,
        folder_id: folder_id
}
response = Dashamail::Request.campaigns.move_to_folder.create!(body: body)
result = response.data
```

#### <a name="campaigns_pause"></a> [Ставим рассылку на паузу](https://dashamail.ru/api_details/?method=campaigns.pause)

```ruby
body = {
        campaign_id: campaign_id
}
response = Dashamail::Request.campaigns.pause.create!(body: body)
result = response.data
```

#### <a name="campaigns_restart_paused"></a> [Возобновляем поставленную на паузу рассылку](https://dashamail.ru/api_details/?method=campaigns.restart_paused)

```ruby
body = {
        campaign_id: campaign_id
}
response = Dashamail::Request.campaigns.restart_paused.create!(body: body)
result = response.data
```

### <a name="reports"></a> Методы для работы с Отчетами

#### <a name="reports_sent"></a> [Список отправленных писем в рассылке](https://dashamail.ru/api_details/?method=reports.sent)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.sent.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_delivered"></a> [Список доставленных писем в рассылке](https://dashamail.ru/api_details/?method=reports.delivered)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.delivered.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_opened"></a> [Список открытых писем в рассылке](https://dashamail.ru/api_details/?method=reports.opened)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.opened.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_clicked"></a> [Список писем в рассылке, где адресат перешел по любой ссылке](https://dashamail.ru/api_details/?method=reports.clicked)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.clicked.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_unsubscribed"></a> [Список писем отписавшихся подписчиков в рассылке](https://dashamail.ru/api_details/?method=reports.unsubscribed)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.unsubscribed.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_bounced"></a> [Список возвратившихся писем в рассылке](https://dashamail.ru/api_details/?method=reports.bounced)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.bounced.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_summary"></a> [Краткая статистка по рассылке](https://dashamail.ru/api_details/?method=reports.summary)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.summary.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_clients"></a> [Статистика по браузерам, ОС и почтовым клиентам](https://dashamail.ru/api_details/?method=reports.clients)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.clients.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_geo"></a> [Статистика по регионам открытия](https://dashamail.ru/api_details/?method=reports.geo)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.geo.retrieve!(params: params)
reports = response.data
```

#### <a name="reports_events"></a> [Список событий с письмами в рамках рассылки за определенный период](https://dashamail.ru/api_details/?method=reports.events)

```ruby
params = {
        campaign_id: campaign_id
}
response = Dashamail::Request.reports.events.retrieve!(params: params)
reports = response.data
```

### <a name="account"></a> Методы для работы с Аккаунтом

#### <a name="account_get_balance"></a> [Получить текущий баланс аккаунта](https://dashamail.ru/api_details/?method=account.get_balance)

```ruby
response = Dashamail::Request.account.get_balance.retrieve!
result = response.data
```

#### <a name="account_get_webhooks"></a> [Получить список всех заданных webhooks или webhook по определенному событию](https://dashamail.ru/api_details/?method=account.get_webhooks)

```ruby
response = Dashamail::Request.account.get_webhooks.retrieve!
result = response.data
```

#### <a name="account_add_webhooks"></a> [Обновить или добавить webhooks для событий](https://dashamail.ru/api_details/?method=account.add_webhooks)

```ruby
body = {
        open: "https://example.com/webhooks/open"
}
response = Dashamail::Request.account.add_webhooks.create!(body: body)
result = response.data
```

#### <a name="account_delete_webhooks"></a> [Удаляем вебхуки для событий](https://dashamail.ru/api_details/?method=account.delete_webhooks)

```ruby
body = {
        event_name: "open"
}
response = Dashamail::Request.account.delete_webhooks.create!(body: body)
result = response.data
```

#### <a name="account_confirm_from_email"></a> [Отправить письмо подтверждения обратного адреса для использования в ЛК или транзакционных рассылках](https://dashamail.ru/api_details/?method=account.confirm_from_email)

```ruby
body = {
        email: "pavel.osetrov@me.com"
}
response = Dashamail::Request.account.confirm_from_email.create!(body: body)
result = response.data
```

#### <a name="account_get_confirmed"></a> [Получить список всех подтвержденных email-адресов на аккаунте](https://dashamail.ru/api_details/?method=account.get_confirmed)

```ruby
response = Dashamail::Request.account.get_confirmed.retrieve!
result = response.data
```

#### <a name="account_add_domain"></a> [Добавить домен отправки или домен статистики на аккаунт](https://dashamail.ru/api_details/?method=account.add_domain)

```ruby
body = {
        domain: "example.com"
}
response = Dashamail::Request.account.add_domain.create!(body: body)
result = response.data
```

#### <a name="account_check_domains"></a> [Получить и проверить валидность DNS-записей для настройки домена отправки или статистики](https://dashamail.ru/api_details/?method=account.check_domains)

```ruby
body = {
        domain: "example.com"
}
response = Dashamail::Request.account.check_domains.create!(body: body)
result = response.data
```

#### <a name="account_delete_domain"></a> [Удаляем домен отправки или статистики](https://dashamail.ru/api_details/?method=account.delete_domain)

```ruby
body = {
        domain: "example.com"
}
response = Dashamail::Request.account.delete_domain.create!(body: body)
result = response.data
```