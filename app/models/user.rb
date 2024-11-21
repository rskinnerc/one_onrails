class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_one :profile, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_one :default_address, -> { where(default: true) }, class_name: "Address"
  has_one :subscription, dependent: :destroy
  has_many :purchases, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true
end
