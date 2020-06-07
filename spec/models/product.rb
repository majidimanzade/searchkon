class Product < ActiveRecord::Base

  has_many :coupons
  has_many :payments

  def self.searchable_columns
    {
      like: ['title', 'coupons.code'],
      exact: [
        'created_at',
        'coupons.id',
        'payments.id',
        'id'
      ]
    }
  end
end