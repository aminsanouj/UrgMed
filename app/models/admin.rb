class Admin < ApplicationRecord
  # Include default devise modules
  devise :database_authenticatable, :rememberable, :validatable
end
