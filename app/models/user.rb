class User < ApplicationRecord
  has_many :friendships
  has_many :friends, through: :friendships
  has_many :subscribes
  has_many :targets, through: :subscribes

  validates_presence_of :email
end
