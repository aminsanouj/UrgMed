class AddRegionToEmergencyNumbers < ActiveRecord::Migration[7.1]
  def change
    add_column :emergency_numbers, :region, :string
  end
end
