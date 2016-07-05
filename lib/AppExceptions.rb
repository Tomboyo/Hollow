# Generic usage error
class ApplicationError < RuntimeError
end

# Resource is not equipped to handle requests of a certain type
class ResourceMethodUndefinedError < ApplicationError
end