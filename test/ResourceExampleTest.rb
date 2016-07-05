require_relative '../resource/ResourceExample'
require 'minitest/autorun'

describe ResourceExample do
  before do
    @re = ResourceExample.new(5)
  end
  
  describe 'When get is called statically' do
    it 'must reply with "ResourceExample::GET"' do
      ResourceExample::get().must_equal "ResourceExample::GET"
    end
  end
  
  describe 'When get is called on an instance' do
    it 'will return its id' do
      @re.get().must_equal 5
    end
  end
end