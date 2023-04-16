# frozen_string_literal: true

require 'macaw_framework'
require 'active_record'
require 'yaml'
require_relative './lib/entity/person'
require_relative './lib/errors/unprocessable_body_error'

# Configuring ActiveRecord
db_config = File.open('./db/database.yaml')
ActiveRecord::Base.establish_connection(YAML.safe_load(db_config))

# Instantiating MacawFramework Class
server = MacawFramework::Macaw.new

# Defining a GET endpoint to list all persons in the database
server.get('/people') do |context|
  return Person.all.as_json, 200
end

# Defining a GET endpoint to recover person with provided id
server.get('/people/:person_id') do |context|
  return Person.find(context[:params][:person_id]).as_json, 200
end

# Defining a POST endpoint to create a new person in the database
server.post('/add_new_person') do |context|
  begin
    parsed_body = JSON.parse(context[:body])
    name = parsed_body['name']
    age = parsed_body['age']
    raise UnprocessableBodyError if name.nil? || age.nil?

    Person.create!(name: name, age: age)
    return "Person created with success!!!", 201
  rescue UnprocessableBodyError => e
    return JSON.pretty_generate({ error: e }), 422
  rescue StandardError => e
    return JSON.pretty_generate({ error: e }), 500
  end
end

# Defining a DELETE endpoint to delete an existing person in the database
server.delete('/delete_person') do |context|
  begin
    parsed_body = JSON.parse(context[:body])
    id = parsed_body['id']
    raise UnprocessableBodyError.new('Please inform a JSON body with an "id" parameter') if id.nil?

    Person.delete(id.to_i)
    return "Person deleted.", 200
  rescue UnprocessableBodyError => e
    return JSON.pretty_generate({ error: e }), 422
  rescue StandardError => e
    return JSON.pretty_generate({ error: e }), 500
  end
end

# Sta
server.start!
