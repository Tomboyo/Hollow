module Helper
  # Application standard processing method.
  # Accepts a lambda function f that must return a hash object or raise an
  # error. Will create a JSON response from the return value of f or the
  # error.message extracted from an ApplicationError. In the event of a
  # non-ApplicationError, a message may be sent to the client provided debug has
  # been set to true.
  def process_request(f, suppress_warnings=false)
    return JSON.generate(f.call())
  rescue ResourceMethodInvalidError => error
    return JSON.generate({ error: 'The resource you requested can not respond to this request (see OPTIONS)' })
  rescue ResourceInvalidError => error
    return JSON.generate({ error: 'The resource you requested does not exist (see OPTIONS)' })
  rescue ApplicationError => error
    return JSON.generate({ error: error.message })
  rescue => error
    unless suppress_warnings
      warn "#{error}:"
      warn error.backtrace.join("\n")
    end
    return JSON.generate({ internal_error: "An internal error occurred" })
  end
end
