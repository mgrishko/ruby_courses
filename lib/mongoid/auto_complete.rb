# ToDo tags_list validation should proxy tag validation.

module Mongoid
  module AutoComplete
    extend ActiveSupport::Concern

    #included do
    #  cattr_accessor :auto_complete_fields
    #end

    module ClassMethods

      #   class Article
      #     include Mongoid::Document
      #     field :author, type: String
      #     embeds_many :tags
      #     belongs_to :category, class_name: "ArticleCategory"
      #     has_many :sources
      #     auto_complete_for :author, { :tags => :name, :category => :title, :sources => [:url, :publisher] }
      #   end
      #
      #   #=> Article.complete_author("Ar")
      #   #=> Article.complete_tags_name("New")
      #   #=> Article.complete_category_title("Natur")
      #   #=> Article.complete_sources_url("http://www.bbc")
      #
      def auto_complete_for(*args)
        args.each do |arg|
          if arg.kind_of?(Hash)            #  { :tags => :name }
            arg.keys.each do |key|
              if arg[key].kind_of?(Array)  #  { :sources => [:url, :publisher] }
                arg[key].each do |field|
                  _define_complete_method(field.to_s, key.to_s)
                end
              else
                _define_complete_method(arg[key].to_s, key.to_s)
              end
            end
          else
            _define_complete_method(arg.to_s)
          end
        end
      end

      def _define_complete_method(field_name, relation_name = nil)
        if relation_name
          relation = self.relations[relation_name]
          raise "Incorrect relation #{relation_name} for class #{self.name}" if relation.nil?
          _check_field(relation.class_name.constantize, field_name)
        else
          relation = nil
          _check_field(self, field_name)
        end

        method_name = "complete_#{relation ? "#{relation_name}_" : ""}#{field_name}"
        klass = relation && !relation.embedded? ? relation.class_name.constantize : self
        query_key = relation && relation.embedded? ? "#{relation_name}.#{field_name}" : field_name

        unless method_defined?(method_name)
          define_singleton_method(method_name) do |query, options = {}|
            return [] if query.blank?

            limit = options.delete(:limit) || 10

            regexp = /^#{query}/i
            conditions = { query_key => regexp }
            conditions.merge!(criteria.selector) if criteria

            values = klass.where(conditions).all.distinct(query_key)
            values = values.select { |v| v =~ regexp } if relation && relation.embedded?

            values.sort.first(limit)
          end
        end
      end

      def _check_field(klass, field_name)
        unless klass.fields.keys.include?(field_name)
          raise "Incorrect field #{relation_name} for class #{klass.name}"
        end
      end
    end

  end
end