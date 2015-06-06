class AddWebsitesTheme < ActiveRecord::Migration
  def self.up
    add_column :websites, :theme, :string, :default => nil
    for w in Website.find(:all)
      w.theme = "red"
      w.save_or_raise
    end
  end

  def self.down
    remove_column :websites, :theme
  end
end
