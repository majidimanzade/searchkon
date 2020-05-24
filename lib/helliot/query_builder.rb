module Helliot
  class QueryBuilder
    class << self
      include Helliot::Filterable
      include Helliot::RegexFormatter

      def filter model, params = {}
        @model = model.constantize
        @res = @model.all
        valid_params = validate_params(params, @model.searchable_columns)
        create_filters valid_params
        @res
      end

      private

        def create_filters valid_params
          valid_params.each do |filter|
            if(filter[:scope] == :fulltext)
              fulltext_query filter[:key], filter[:value]
            elsif(relational? filter[:key])
              relation_query filter[:key]
              where_query filter[:key], filter[:value], filter[:scope]
            elsif(range? filter[:value])
              range_query filter[:key], filter[:value]
            else
              where_query filter[:key], filter[:value], filter[:scope]
            end
          end
        end

        def fulltext_query key, value
          query = ""
          keys = key.to_s.split(',')
          keys.each do |fulltext_key|
            relation_query fulltext_key if(relational? fulltext_key)
            query << " or " unless query.blank?
            if relational? fulltext_key
              relations = relation_values fulltext_key
              table_name = get_relation_table_name relations.relation
              query << "#{table_name}.#{relations.key} like :value"
            else
              query << "#{@model.table_name}.#{fulltext_key} like :value"
            end
          end
          @res = @res.where(query, {value: "%#{value}%"})
        end

        def where_query key, value, scope
          exact_query key, value if scope == :exact
          like_query key, value if scope == :like
        end

        def like_query key, value
          if(relational? key)
            relations = relation_values key
            table_name = get_relation_table_name relations.relation
            @res = @res.where("#{table_name}.#{relations.key} like ?", "%#{value}%")
          else
            @res = @res.where("#{@model.table_name}.#{key} like ?", "%#{value}%")
          end
        end

        def exact_query key, value
          @res = @res.where(key => value)
        end

        def range_query key, value
          range = range_values value
          @res = @res.where("#{@model.table_name}.#{key} between ? and ?", range.from, range.to)
        end

        def relation_query key
          relations = relation_values key
          @res = @res.joins(relations.relation.to_sym)
        end

        def get_relation_table_name relation
          @model.reflect_on_all_associations.detect { |association| association.name == relation.to_sym }.table_name
        end
    end
  end
end