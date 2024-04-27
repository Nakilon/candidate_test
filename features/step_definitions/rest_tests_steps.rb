# frozen_string_literal: true

When(/^получаю информацию о пользователях$/) do
  users_full_information = $rest_wrap.get('/users')
  $logger.info('Информация о пользователях получена')
  @scenario_data.users_full_info = users_full_information
end

When(/^лишние пользователи удалены$/) do
  $rest_wrap.get("/users").each do |user|
    next if user["login"] == $rest_wrap.login
    $logger.warn "deleting #{user}"
    $rest_wrap.delete "/users/#{user["id"]}"
  end
  step %(получаю информацию о пользователях)
end

When(/^проверяю (наличие|отсутствие) логина (\w+\.\w+) в списке пользователей$/) do |presence, login|
  search_login_in_list = true ^ (presence == 'отсутствие')

  logins_from_site = @scenario_data.users_full_info.map { |f| f&.[] 'login' }
  login_presents = logins_from_site.include?(login)

  if login_presents
    message = "Логин #{login} присутствует в списке пользователей"
    search_login_in_list ? $logger.info(message) : raise(message)
  else
    message = "Логин #{login} отсутствует в списке пользователей"
    search_login_in_list ? raise(message) : $logger.info(message)
  end
end

When(/^добавляю пользователя c логином (\w+\.\w+) именем (\w+) фамилией (\w+) паролем ([\d\w@!#]+)$/) do
|login, name, surname, password|

  response = $rest_wrap.post('/users', login: login,
                                       name: name,
                                       surname: surname,
                                       password: password,
                                       active: 1)
  $logger.info(response.inspect)
end

When(/^удаляю пользователя c логином (\w+\.\w+)$/) do |login|
  step %(нахожу пользователя с логином #{login})
  response = $rest_wrap.delete("/users/#{@scenario_data.users_id[login]}")
  $logger.info(response.inspect)
end

When(/^нахожу пользователя с логином (\w+\.\w+)$/) do |login|
  step %(получаю информацию о пользователях)

  if @scenario_data.users_id[login].nil?
    @scenario_data.users_id[login] = find_user_id(users_information: @scenario_data
                                                                         .users_full_info,
                                                  user_login: login)
  end

  $logger.info("Найден пользователь #{login} с id:#{@scenario_data.users_id[login]}")
end

When(/^устанавливаю пользователю с логином (\w+\.\w+) имя (\w+)$/) do |login, name|
  step %(нахожу пользователя с логином #{login})
  $rest_wrap.put("/users/#{@scenario_data.users_id[login]}", name: name)
end

When(/^проверяю, что у пользователя с логином (\w+\.\w+) имя (\w+)$/) do |login, name|
  step %(получаю информацию о пользователях)
  expect(@scenario_data.users_full_info.find{ |user| user["login"] == login }["name"]).to eq(name)
end
