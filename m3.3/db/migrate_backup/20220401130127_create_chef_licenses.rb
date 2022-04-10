class CreateChefLicenses < ActiveRecord::Migration[7.0]
  def change
    create_table :chef_licenses do |t|
      t.string :earn_date
      t.string :chef_id

      t.timestamps
    end
  end
end
