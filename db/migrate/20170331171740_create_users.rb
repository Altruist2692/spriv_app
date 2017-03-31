class CreateUsers < ActiveRecord::Migration[5.0]
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :user_login
      t.string :company_id
      t.string :email
      t.string :phone
      t.string :person_id
      t.integer :status_id
      t.integer :status_timeout
      t.boolean :as_html
      t.timestamps
    end
  end
end
