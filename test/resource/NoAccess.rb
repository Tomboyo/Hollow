# This class does not inherit ResourceInterface, so it is not publicly
# accessible despite being in the resource folder.
class NoAccess
  def initialize
  end

  def self.get(query = nil, data = nil)
    return "::GET"
  end

  def get(query = nil, data = nil)
    return "get"
  end
end
