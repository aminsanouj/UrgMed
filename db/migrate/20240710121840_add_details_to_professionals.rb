class AddDetailsToProfessionals < ActiveRecord::Migration[7.1]
  def change
    add_column :professionals, :street, :string
    add_column :professionals, :postal_code, :string
    add_column :professionals, :city, :string
  end
end
