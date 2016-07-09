# This class does not inherit ResourceInterface, so it is not publicly
# accessible despite being in the resource folder.
class NoAccess
  def initialize
  end

  def self.get
    return "::GET"
  end

  def get
    return "get"
  end
end
