ActiveRecord::Schema.define do
  self.verbose = false

  create_table :products, :force => true do |t|
    t.string :key
    t.string :title
    t.timestamps
  end

  create_table :coupons, :force => true do |t|
    t.string :title
    t.timestamps
  end

  create_table :payments, :force => true do |t|
    t.string :title
    t.timestamps
  end

end