class RemoveAddressFromProfessionals < ActiveRecord::Migration[7.1]
  def change
    remove_column :professionals, :address, :string
  end
end
