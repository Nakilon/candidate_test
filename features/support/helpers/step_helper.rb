# frozen_string_literal: true

def find_user_id(users_information:, user_login:)
  users_id = []
  users_information.each do |user|
    users_id << user['id'] if user['login'] == user_login
  end
  users_id.uniq!

  if users_id.size != 1
    raise "Логин пользователя неуникален! Найдено пользователей с аналогичным логином: #{users_id.size}, id: #{users_id.inspect}"
  end

  users_id.first
end
