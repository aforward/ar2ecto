class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table "users", :force => true do |t|
      t.datetime :created_at
      t.datetime :updated_at
      t.string   :type
      t.string   :username
      t.string   :email
      t.string   :crypted_password, :limit => 40
      t.string   :salt,             :limit => 40
      t.datetime :destroyed_at
      t.integer  :destroyed_by
    end
  end

  def self.down
    drop_table "users"
  end
end
