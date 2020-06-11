# Searchkon

Searchkon is Advanced active record search(filter) command that makes easy to search throw models and  their relationships.

## Introduction

Lets say we want to return a list of products filtered by multiple parameters. our request contain below parameters:

```json
      {
        filters: {
          title: 'foobar',
          id: [1, 2, 3, 4],
          created_at: '(2012-12-21..2019-12-21)'
          categories.name: 'mobile'
        }
      }

```

Filter above parameters with Searchkon gem:

```rb
Searchkon::QueryBuilder.filter('Product', filters)
```

## Getting Start


Add Searchkon to your Gemfile:
```sh
gem 'searchkon'
```

### Searchable columns

at the first we should determine witch columns of model can be filter in Searchkon

```rb
class Product < ActiveRecord::Base

  has_many :coupons
  has_many :payments

  def self.searchable_columns
    {
      like: ['title', 'coupons.code'],
      exact: [
        'created_at',
        'coupons.title', ## relational filter on coupons table
        'payments.id', ## relational filter on payments table
        'id'
      ]
    }
  end
end

```


<b> like: </b> if you add specific column in your like scope, your query will be like below sql.
```sql
select * from products where title like %foo%
```

<b>exact:</b> Searchkon create query using equal operation.

```sql
select * from products where created_at = foo
```

### Simple where query

<b>Important: </b> Searchkon just accept filters key, you can add your filterable columns in filter key.


```rb
     params =  {
        filters: {
          id: 1,
          title: 'foobar'
        }
     }
```

```rb
Searchkon::QueryBuilder.filter('Product', params)
```

sql result:
```sql
SELECT "products".* FROM "products" WHERE (products.title like '%foobar%') AND "products"."id" = 1
```

### Search Range

```rb
     params = {
        filters: {
          id: '(1..10)',
          created_at: '(2012-12-21..2019-12-21)'
        }
      }
```

sql result:

```sql
SELECT "products".* FROM "products" WHERE (products.title like '%foobar%') AND "products"."id" = 1
```


### Search in relational table


```rb
     params = {
		{ 
          filters: { 'coupons.id': [1,4,8] }
        }
      }
```

sql result:

```sql
SELECT "products".* FROM "products" INNER JOIN "coupons" ON "coupons"."product_id" = "products"."id" WHERE "coupons"."id" IN (1, 4, 8)
```


### Invalid Column in query

if your filter parameters contain invalid column name, Searchkon skip it and create query without that column.

```rb
     invalid_mock_params = {
        filters: {
          id: 1,
          foo: 'foobar'
        }
      }
```

```rb
Searchkon::QueryBuilder.filter('Product', invalid_mock_params)
```

sql result:


```sql
SELECT "products".* FROM "products" WHERE "products"."id" = 1
```
