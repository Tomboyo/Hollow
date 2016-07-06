module Helper
  
  # Application standard processing method.
  # Accepts a lambda function f that must return a hash object or raise an error.
  # Will create a JSON response from the return value of f or the error.message extracted from an ApplicationError.
  # In the event of a non-ApplicationError, a message may be sent to the client provided an environment variable called "debug" has been set to true.
  def process_request(f)
    return JSON.generate(f.call())
  rescue ResourceMethodUndefinedError => error
    return JSON.generate({'error' => 'The resource you requested can not respond to this request (see OPTIONS)'})
  rescue ApplicationError => error
    return JSON.generate({'error' => error.message})
  rescue => error
    return JSON.generate({'error' => "An internal error occurred. #{@debug ? error.message : ''}"})
  end
  
end