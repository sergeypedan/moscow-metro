# frozen_string_literal: true

require "active_record"
require "pg"

class Line < ActiveRecord::Base

  validates :name, presence: true

end
