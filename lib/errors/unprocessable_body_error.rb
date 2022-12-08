# frozen_string_literal: true

# Defining the error returned when an invalid body is passed with the request
class UnprocessableBodyError < StandardError
  def initialize(
    msg = 'Please inform a body on your request in JSON format with a "name" and "age" properties'
  )
    super
  end
end
