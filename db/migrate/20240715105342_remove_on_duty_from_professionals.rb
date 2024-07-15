class RemoveOnDutyFromProfessionals < ActiveRecord::Migration[7.1]
  def change
    remove_column :professionals, :on_duty, :boolean
  end
end
