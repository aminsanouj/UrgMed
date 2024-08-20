class AddDepartmentToEmergencyNumbers < ActiveRecord::Migration[7.1]
  def change
    add_column :emergency_numbers, :department, :string
  end
end
