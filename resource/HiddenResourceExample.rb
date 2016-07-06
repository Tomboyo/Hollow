# This class does not inherit ResourceInterface, so it is not publicly accessible despite being in the resource folder.
class HiddenResourceExample
  def self.get
    return "The system can get this, but not the world."
  end
  
  def get
    return "The system can get this, but not the world."
  end
end