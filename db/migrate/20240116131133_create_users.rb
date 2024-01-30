class CreateUsers < ActiveRecord::Migration[7.1]
  def change
    create_table :users do |t|
      t.string :provider
      t.string :name
      t.string :nickname
      t.string :image_url
      t.string :uid
      t.string :email
      t.string :token

      t.timestamps
    end
  end
end
