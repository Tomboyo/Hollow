require_relative '../lib/Autoloader'
require 'minitest/autorun'

describe Autoloader do
  $sandbox = File::expand_path(File::dirname(__FILE__)) << '/AutoloaderTestFiles'
  $count = 0;
  $requires = $" #"
  
  before do
    @autoloader = Autoloader.new($sandbox)
    
    # Remove class definitions and tell Ruby to allow files to be required again before each test
    [:AClass, :BClass, :CClass].each do |klass|
      if Object.const_defined?(klass)
        index = $requires.find_index do |x|
          x.end_with?("#{klass}.rb")
        end
        $requires.delete_at(index)
        Object.send(:remove_const, klass)        
        Object.const_defined?(klass).must_equal false
      end
    end
  end
  
  describe 'When the base directory is set' do
    it 'will raise an error if that directory is invalid' do
      proc { @autoloader.set_basedir("NotAPath") }.must_raise LoadError
      proc { @autoloader.set_basedir("") }.must_raise ArgumentError
    end
    
    it 'will not print or puts' do
      # Use this script's directory
      proc {
        @autoloader.set_basedir($sandbox)
        begin
          @autoloader.set_basedir("NotAPath")
        rescue Exception
        end
      }.must_be_silent
    end
  end
  
  describe 'When a search path is added' do
    it 'will raise an error if that path is invalid' do
      proc { @autoloader.add_path("NotAPath") }.must_raise LoadError
      proc { @autoloader.add_path("") }.must_raise ArgumentError
      @autoloader.paths().empty?.must_equal true
    end
    
    it 'will record the path' do
      @autoloader.add_path("A")
      @autoloader.paths().include?("A").must_equal true
    end
    
    it 'will not print or puts' do
      proc {
        @autoloader.add_path("A")
        @autoloader.add_path("A") # Verifies that repeated path-adding behaves the same way
        begin
          @autoloader.add_path("NotAPath")
        rescue Exception
        end
      }.must_be_silent
    end
    
    it 'will not duplicate added paths' do
      @autoloader.add_path("A")
      length = @autoloader.paths().length
      
      @autoloader.add_path("A")
      @autoloader.paths().length.must_equal length
    end
  end
  
  describe "When a file is required" do    
    it 'will indicate if the file was successfully required or is already loaded' do
      @autoloader.add_path("A")
      
      @autoloader.require_file("NotAClass").must_equal false
      Object.const_defined?("NotAClass").must_equal false
      
      @autoloader.require_file("AClass")
      #@autoloader.require_file("AClass").must_equal true
      Object.const_defined?("AClass").must_equal true
      
      # If a file was previously required, it should still return true
      @autoloader.require_file("AClass").must_equal true
    end
    
    it 'will search in all added paths for the required file' do
      @autoloader.add_path("A")
      @autoloader.add_path("B")
      @autoloader.add_path("C")

      @autoloader.require_file("AClass").must_equal true
      Object.const_defined?("AClass").must_equal true
      
      @autoloader.require_file("BClass").must_equal true
      Object.const_defined?("BClass").must_equal true
      
      @autoloader.require_file("CClass").must_equal true
      Object.const_defined?("CClass").must_equal true
    end
    
    it 'will not print or puts' do
      proc {
        @autoloader.require_file("NotAClass")
        @autoloader.require_file("AClass")
      }.must_be_silent
    end
  end
  
  describe 'When all files in a path are required' do
    it 'will raise an error if the path is invalid' do
      proc { @autoloader.require_files_in("NotAPath") }.must_raise LoadError
      proc { @autoloader.require_files_in("") }.must_raise ArgumentError
    end
    
    it 'will require all files in the path' do
      @autoloader.require_files_in("C")
      Object.const_defined?("CClass").must_equal true
      Object.const_defined?("CClassTwo").must_equal true
    end
    
    it 'will not print or puts' do
      proc {
        begin
          @autoloader.require_files_in("NA")
        rescue Exception
        end
        @autoloader.require_files_in("C")
      }.must_be_silent
    end
  end
end