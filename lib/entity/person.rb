# frozen_string_literal: true

# A simple person entity to work with the database using ActiveRecord
class Person < ActiveRecord::Base
  table_name = 'people'
end
