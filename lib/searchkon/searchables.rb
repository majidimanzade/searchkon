module Searchkon
  module Searchables
    def searchable_columns
      self.column_names
    end
  end
end