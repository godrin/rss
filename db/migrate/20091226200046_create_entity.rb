class CreateEntity < ActiveRecord::Migration
  def self.up
    create_table :entities do |t|
      t.string :url
      t.string :urlrss
      t.string :name  # or title
      t.string :description # or body
      t.string :type
      t.string :state
      t.timestamp :publication
      t.timestamps
    end
    add_index :entities,:url
    add_index :entities,:type
    add_index :entities,:name
  end

  def self.down
    drop_table :entities
  end
end
