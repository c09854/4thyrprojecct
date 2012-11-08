class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :username, :null => false
      t.string :first_name, :null => false
      t.string :last_name, :null => false
      t.string :email, :null => false
      t.date :dob, :null => false, :default => Date.today.years_ago.to_s
      t.password :password, :null => false
      t.confirm_password :confirm_password, :null => false
      t.float :balance, :null => false, :default => 100

      t.timestamps
    end
  end
end
