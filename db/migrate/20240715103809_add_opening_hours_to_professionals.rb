class AddOpeningHoursToProfessionals < ActiveRecord::Migration[7.1]
  def change
    add_column :professionals, :opening_hours, :jsonb
  end
end
