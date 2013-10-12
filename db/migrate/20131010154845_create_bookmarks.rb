class CreateBookmarks < ActiveRecord::Migration
  def change
    create_table :bookmarks do |t|
      t.string :title
      t.string :url
      t.boolean :like, default: false
      t.boolean :del_flg, default: false

      t.timestamps
    end
  end
end
