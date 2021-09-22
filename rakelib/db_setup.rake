# frozen_string_literal: true

desc "Prepares local DB"

namespace :db do
  task :setup do

    require_relative "../config/db_connection"

    ActiveRecord::Schema.define do
      create_table :lines, id: false, primary_key: :uid do |t|
        t.primary_key :uid, null: false, limit: 3
        t.string  :name_ru, null: false
        t.string  :name_en, null: false
        t.string  :name_prepositional
        t.string  :color
        t.integer :open_year
      end

      change_column :lines, :uid, :string

      create_table :adm_areas do |t|
        t.string :name_ru, null: false
        t.string :name_en, null: false
      end

      add_index :adm_areas, :name_ru, unique: true

      create_table :statuses do |t|
        t.string :name_ru, null: false
        t.string :name_en, null: false
      end

      create_table :stations do |t|
        t.string     :name_ru, null: false
        t.string     :name_en, null: false
        t.string     :line_uid, null: false
        t.decimal    :latitude
        t.decimal    :longitude
        t.boolean    :works
        t.references :status, foreign_key: { on_delete: :cascade }
        t.bigint     :global_id, null: false
        t.integer    :gov_id, null: false
      end

      add_index :stations, :global_id, unique: true
      add_index :stations, :gov_id,    unique: true
      add_index :stations, :name_ru,   unique: true

      add_foreign_key :stations, :lines, column: :line_uid, primary_key: :uid, on_delete: :cascade, type: :string
    end

  end
end
