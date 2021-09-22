# frozen_string_literal: true

require "active_record"
require "pg"

class Line < ActiveRecord::Base

  validates :color, length: { maximum: 7 }, allow_blank: true
  validates :name_en, presence: true, uniqueness: true
  validates :name_ru, presence: true, uniqueness: true
  validates :open_year, numericality: { only_integer: true, greater_than: 1930 }, allow_nil: true
  validates :uid, length: { maximum: 3 }, presence: true, uniqueness: true

end
