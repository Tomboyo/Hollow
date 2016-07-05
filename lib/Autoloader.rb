class Autoloader  
  attr_reader :paths, :basedir

  def initialize(basedir)
    @paths = []
    set_basedir(basedir)
  end

  def set_basedir(basedir)
    raise ArgumentError.new("Basedir string should not be empty (did you mean '.'?)") if basedir.lstrip.empty?
    raise LoadError.new("#{basedir} is not a directory.") unless File::directory?(basedir)
    @basedir = basedir
  end
    
  def add_path(path)
    raise ArgumentError.new("Path string should not be empty (did you mean '.'?)") if path.lstrip.empty?
    return if @paths.include?(path)
    raise LoadError.new("#{@basedir}/#{path} is not a directory.") unless File::directory?("#{@basedir}/#{path}")
    @paths << "#{path}"
  end
  
  def require_file(name)
    return true if Object.const_defined?(name)
    success = false
    @paths.each do |path|
      next unless File::exists?("#{@basedir}/#{path}/#{name}.rb")
      success = require("#{@basedir}/#{path}/#{name}")
      break
    end
    return success
  end
  
  def require_files_in(path)
    raise ArgumentError.new("Path string should not be empty (did you mean '.'?)") if path.lstrip.empty?
    path = "#{@basedir}/#{path}"
    raise LoadError.new("#{path} is not a directory.") unless File::directory?(path)
    
    Dir::entries(path).select do |file|
      next unless File::file?("#{path}/#{file}") && File::extname("#{path}/#{file}") == '.rb'
      require("#{path}/#{File::basename("#{file}", '.rb')}")
    end
  end
end