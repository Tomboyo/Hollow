class Autoloader
  attr_reader :paths, :basedir

  def initialize(basedir)
    @paths = []
    set_basedir(basedir)
  end

  def set_basedir(basedir)
    if basedir.lstrip.empty?
      raise ArgumentError.new("Basedir must not be empty (did you mean '.'?)")
    end

    unless File::directory?(basedir)
      raise LoadError.new("#{basedir} is not a directory.")
    end

    @basedir = basedir
  end

  def add_path(path)
    if path.lstrip.empty?
      raise ArgumentError.new("Path must not be empty (did you mean '.'?)")
    end

    return if @paths.include?(path)

    unless File::directory?("#{@basedir}/#{path}")
      raise LoadError.new("#{@basedir}/#{path} is not a directory.")
    end

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
    if path.lstrip.empty?
      raise ArgumentError.new("Path must not be empty (did you mean '.'?)")
    end

    path = "#{@basedir}/#{path}"
    unless File::directory?(path)
      raise LoadError.new("#{path} is not a directory.")
    end

    Dir::entries(path).select do |file|
      next unless File::file?("#{path}/#{file}") &&
        File::extname("#{path}/#{file}") == '.rb'
      require("#{path}/#{File::basename("#{file}", '.rb')}")
    end
  end
end
