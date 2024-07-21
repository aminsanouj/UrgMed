class AddIsLocalToEmergencyNumbers < ActiveRecord::Migration[6.0]
  def change
    add_column :emergency_numbers, :is_local, :boolean, default: false
  end
end
