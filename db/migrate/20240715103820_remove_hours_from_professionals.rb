class RemoveHoursFromProfessionals < ActiveRecord::Migration[7.1]
  def change
    remove_column :professionals, :hours, :string
  end
end
