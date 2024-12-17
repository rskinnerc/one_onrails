class User::Setting < ApplicationRecord
  belongs_to :user

  enum :theme, { light: 0, night: 1 }
end
