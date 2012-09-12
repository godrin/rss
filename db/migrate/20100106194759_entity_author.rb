class EntityAuthor < ActiveRecord::Migration
  def self.up
    add_column :entities,:author,:string
  end

  def self.down
  end
end
