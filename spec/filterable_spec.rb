require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class DummyClass
  include Searchkon::RegexFormatter
  include Searchkon::Filterable
end

RSpec.describe Searchkon::Filterable do
  describe 'filterable test' do
    it 'should return correct filter with scope' do
      filrtetables = {
        like: ['name', 'cities.name'],
        exact: ['cities.id']
      }
      filters = {'cities.name,name': 'Don', 'cities.id': 1}
      result = [{:value=>1, :key => "cities.id", :scope=>:exact},
       {:value=>"Don", :key=> "cities.name,name", :scope=>:fulltext}]

      dc = DummyClass.new

      expect(dc.validate_params(filters, filrtetables)).to eq result
    end
  end
end