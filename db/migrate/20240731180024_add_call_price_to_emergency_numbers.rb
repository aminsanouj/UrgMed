class AddCallPriceToEmergencyNumbers < ActiveRecord::Migration[7.1]
  def change
    add_column :emergency_numbers, :call_price, :string
  end
end
