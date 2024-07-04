class CreateEmergencyNumbers < ActiveRecord::Migration[7.1]
  def change
    create_table :emergency_numbers do |t|
      t.string :name
      t.string :phone_number
      t.text :description

      t.timestamps
    end
  end
end
