class CreateProfessionals < ActiveRecord::Migration[7.1]
  def change
    create_table :professionals do |t|
      t.string :first_name
      t.string :last_name
      t.string :speciality
      t.string :address
      t.float :latitude
      t.float :longitude
      t.string :phone_number
      t.string :website
      t.string :hours
      t.boolean :on_duty

      t.timestamps
    end
  end
end
