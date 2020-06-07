require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

RSpec.describe Searchkon::QueryBuilder do
  describe 'query builder for filter' do
    let (:simple_where_params) do
      {
        filters: {
          id: 1,
          title: 'foobar'
        }
      }
    end

    let (:simple_range_params) do
      {
        filters: {
          id: '(1..10)',
          created_at: '(2012-12-21..2019-12-21)'
        }
      }
    end

    let (:range_and_array_where_params) do
      {
        filters: {
          id: [1,2,3,4,5],
          created_at: '(2012-12-21..2019-12-21)'
        }
      }
    end

    it 'should return simple where query' do
      query = "SELECT \"products\".* FROM \"products\" WHERE (products.title like '%foobar%') AND \"products\".\"id\" = 1"
      expect(Searchkon::QueryBuilder.filter('Product', simple_where_params).to_sql).to eq query
    end

    it 'should return simple range query' do
      query = "SELECT \"products\".* FROM \"products\" WHERE (products.created_at between '2012-12-21' and '2019-12-21') AND (products.id between '1' and '10')"

      expect(Searchkon::QueryBuilder.filter('Product', simple_range_params).to_sql).to eq query
    end

    it 'should return simple where relational query' do
      relational_params = { filters: { 'coupons.id': 1 } }
      query = "SELECT \"products\".* FROM \"products\" INNER JOIN \"coupons\" ON \"coupons\".\"product_id\" = \"products\".\"id\" WHERE \"coupons\".\"id\" = 1"

      expect(Searchkon::QueryBuilder.filter('Product', relational_params).to_sql).to eq query
    end

    it 'should return range relational query' do
      relational_params = { filters: { 'coupons.id': [1,2,3] } }
      query = "SELECT \"products\".* FROM \"products\" INNER JOIN \"coupons\" ON \"coupons\".\"product_id\" = \"products\".\"id\" WHERE \"coupons\".\"id\" IN (1, 2, 3)"

      expect(Searchkon::QueryBuilder.filter('Product', relational_params).to_sql).to eq query
    end

    it 'should return simple where relational query with two relations' do
      relational_params = { filters: { 'coupons.id': 1, 'payments.id': 1 } }
      query = "SELECT \"products\".* FROM \"products\" INNER JOIN \"coupons\" ON \"coupons\".\"product_id\" = \"products\".\"id\" INNER JOIN \"payments\" ON \"payments\".\"product_id\" = \"products\".\"id\" WHERE \"coupons\".\"id\" = 1 AND \"payments\".\"id\" = 1"
      expect(Searchkon::QueryBuilder.filter('Product', relational_params).to_sql).to eq query
    end

    it 'should return range query and array where' do
      query = "SELECT \"products\".* FROM \"products\" WHERE (products.created_at between '2012-12-21' and '2019-12-21') AND \"products\".\"id\" IN (1, 2, 3, 4, 5)"

      expect(Searchkon::QueryBuilder.filter('Product', range_and_array_where_params).to_sql).to eq query
    end

    it 'should return all if params empty' do
      query = "SELECT \"products\".* FROM \"products\""

      expect(Searchkon::QueryBuilder.filter('Product', {}).to_sql).to eq query
    end

    it 'should raise error if model not exist' do
      expect { Searchkon::QueryBuilder.filter('foobar', simple_where_params) }.to raise_error NameError
    end

    it 'should return all if all filter column not exist' do
      query = "SELECT \"products\".* FROM \"products\""
      invalid_mock_params = {
        filters: {
          blah: 1,
          foo: 'foobar'
        }
      }

      expect(Searchkon::QueryBuilder.filter('Product', invalid_mock_params).to_sql).to eq query
    end

    it 'should return query if one filter column not exist' do
      query = "SELECT \"products\".* FROM \"products\" WHERE \"products\".\"id\" = 1"
      some_invalid_mock_params = {
        filters: {
          id: 1,
          foo: 'foobar'
        }
      }

      expect(Searchkon::QueryBuilder.filter('Product', some_invalid_mock_params).to_sql).to eq query
    end

    it 'should return fulltext query if params has fulltext key' do
      query = "SELECT \"products\".* FROM \"products\" INNER JOIN \"coupons\" ON \"coupons\".\"product_id\" = \"products\".\"id\" WHERE (products.title like '%foobar%' or coupons.code like '%foobar%')"
	   	params = {
        filters: {
          'title,coupons.code': 'foobar'
        }
      }

      expect(Searchkon::QueryBuilder.filter('Product', params).to_sql).to eq query
    end
  end
end
