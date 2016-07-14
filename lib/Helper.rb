module Helper
  # Application standard processing method.
  # Accepts a lambda function f that must return a hash object or raise an
  # error. Will create a JSON response from the return value of f or the
  # error.message extracted from an ApplicationError. In the event of a
  # non-ApplicationError, a message may be sent to the client provided debug has
  # been set to true.
  def process_request(f, suppress_warnings=false)
    return JSON.generate(f.call())
  rescue ResourceMethodInvalidException => e
    return JSON.generate({ error: 'The resource you requested can not respond to this request (see OPTIONS)' })
  rescue ResourceInvalidException => e
    return JSON.generate({ error: 'The resource you requested does not exist (Case sensitive!) (see OPTIONS)' })
  rescue ApplicationException => e
    return JSON.generate({ error: e.message })
  rescue => e
    unless suppress_warnings
      warn "#{e}:"
      warn e.backtrace.join("\n")
    end
    return JSON.generate({ internal_error: "An internal error occurred" })
  end
end
