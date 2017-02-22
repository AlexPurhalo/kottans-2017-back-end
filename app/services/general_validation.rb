class ValidationService
  def initialize(*args_arr); (@errors = Array.new) && args_arr.each { |errors_arr| @errors.concat(errors_arr)}; end

  attr_reader :errors

  def without_errors?; errors.empty? ? true : false; end
end