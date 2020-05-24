module Searchkon
  module Filterable

    def validate_params filters, model_filterables
      valid_params = []
      unless filters.blank?
        valid_params.concat formatted_simple_params(model_filterables, filters)
        valid_params.concat formatted_fulltext_params(model_filterables, filters)
      end
      valid_params
    end
  private

    def formatted_simple_params model_filterables, filters
      valid_params = []
      model_filterables.each do |scope, columns|
        columns.each do |column|
          value_of_column = filters[column.to_sym]

          value_of_column.reject! { |c| c.blank? } if value_of_column.kind_of?(Array)
          next if value_of_column.blank?
          next unless valid_range? value_of_column

          valid_params.push({value: value_of_column, key: column, scope: scope}) if filters.include?(column.to_sym)
        end
      end
      valid_params
    end

    def valid_range? value
      if range? value
        return (date_range?(value) or digit_range?(value))
      end
      true
    end

    def formatted_fulltext_params model_filterables, filters
      valid_params = []
      filters.each do |key, value|
        if key.to_s.include? ','
          valid_keys = validate_fulltext_keys key, model_filterables
          valid_params.push({value: value, key: valid_keys, scope: :fulltext}) unless valid_keys.blank?
        end
      end
      valid_params
    end

    def validate_fulltext_keys keys, model_filterables
      valid_params = []
      return if keys.blank?

      keys.to_s.split(',')&.each do |key|
        valid_params << key if model_filterables[:like].include?(key)
      end

      return if valid_params.blank?
      valid_params.join(',')
    end
  end
end