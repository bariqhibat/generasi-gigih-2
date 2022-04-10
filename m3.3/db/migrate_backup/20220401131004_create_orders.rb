class CreateOrders < ActiveRecord::Migration[7.0]
  def change
    create_table :orders do |t|
      t.string :order_date
      t.string :customer_id

      t.timestamps
    end
  end
end
