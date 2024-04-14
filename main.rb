# frozen_string_literal: true

require 'macaw_framework'
require 'active_record'
require 'yaml'
require_relative './lib/entity/person'
require_relative './lib/errors/unprocessable_body_error'

# Configuring ActiveRecord
db_config = File.open('./db/database.yaml')
ActiveRecord::Base.establish_connection(YAML.safe_load(db_config, aliases: true))

# Instantiating MacawFramework Class
server = MacawFramework::Macaw.new

# Defining a GET endpoint to list all persons in the database
server.get('/people') do |_context|
  return JSON.pretty_generate(Person.all.as_json), 200, {"Content-Type" => "application/json", "random-header" => "random value"}
end

# Defining a GET endpoint to recover person with provided id
server.get('/people/:person_id') do |context|
  return JSON.pretty_generate(Person.where(id: context[:params][:person_id]).first.as_json), 200
end

# Defining a POST endpoint to create a new person in the database
server.post('/add_new_person') do |context|
  begin
    parsed_body = JSON.parse(context[:body])
    name = parsed_body['name']
    age = parsed_body['age']
    raise UnprocessableBodyError if name.nil? || age.nil?

    Person.create!(name: name, age: age)
    return JSON.pretty_generate({ message: "Person created with success!!!" }), 201
  rescue UnprocessableBodyError => e
    return JSON.pretty_generate({ error: e }), 422
  rescue StandardError => e
    return JSON.pretty_generate({ error: e }), 500
  end
end

server.patch('/people/:person_id') do |context|
  raise UnprocessableBodyError.new unless context[:params][:person_id]

  body = JSON.parse(context[:body])
  name = ActiveRecord::Base.connection.quote(body["name"])
  age = ActiveRecord::Base.connection.quote(body["age"])
  Person.update(
    context[:params][:person_id].to_i,
    name: name,
    age: age
  )
  [JSON.pretty_generate({ message: "Updated person #{context[:params][:person_id]}" }), 200]
rescue UnprocessableBodyError
  ["Person with id #{context[:params][:person_id]} does not exist", 400]
rescue StandardError => e
  [JSON.pretty_generate(e.message), 500]
end

# Defining a DELETE endpoint to delete an existing person in the database
server.delete('/delete_person') do |context|
  begin
    parsed_body = JSON.parse(context[:body])
    id = parsed_body['id']
    raise UnprocessableBodyError.new('Please inform a JSON body with an "id" parameter') if id.nil?

    person = Person.find_by(id: id.to_i)
    if person.nil?
      return JSON.pretty_generate({ error: "Person with ID #{id} not found." }), 404
    else
      person.destroy
      return JSON.pretty_generate("Person with ID #{id} deleted."), 200
    end
  rescue UnprocessableBodyError => e
    return JSON.pretty_generate({ error: e.message }), 422
  rescue StandardError => e
    return JSON.pretty_generate({ error: e }), 500
  end
end

# Start Server
server.start!
