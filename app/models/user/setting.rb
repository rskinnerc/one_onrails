class User::Setting < ApplicationRecord
  belongs_to :user

  enum :theme, { light: 0, dark: 1 }
end
