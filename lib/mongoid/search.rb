module Mongoid
  module Search
    # This is an Base search module for Mongoid documents.
    #
    # It implements common functionality for defining search methods
    # and basic search algorithm.

    extend ActiveSupport::Concern

    module ClassMethods

      # Defines auto complete methods.
      #
      #   class Article
      #     include Mongoid::Document
      #     field :author, type: String
      #     embeds_many :tags
      #     belongs_to :category, class_name: "ArticleCategory"
      #     has_many :sources
      #     auto_complete_for :author, { :tags => :name, :category => :title, :sources => [:url, :publisher] }
      #   end
      #
      #   #=> Article.distinct_authors("Ar")
      #   #=> Article.distinct_tags_names("New")
      #   #=> Article.distinct_category_titles("Natur")
      #   #=> Article.distinct_sources_urls("http://www.bbc")
      #   #=> Article.distinct_sources_publishers("PragProg")
      #
      def auto_complete_for(*args)
        opts = {}
        args << opts

        # It defines methods which returns array of distinct values by specified search query.
        # Example:
        #   Article.distinct_authors(:search => "Steven King", limit: 10)
        define_search_methods(*args)
      end

      # Defines distinct and filter methods.
      #
      #   class Article
      #     include Mongoid::Document
      #     field :author, type: String
      #     embeds_many :tags
      #     belongs_to :category, class_name: "ArticleCategory"
      #     has_many :sources
      #     filter_by :author, { :tags => :name, :category => :title, :sources => [:url, :publisher] }
      #   end
      #
      #   #=> Article.by_author("Steven King")
      #   #=> Article.by_tags_name("New")
      #   #=> Article.by_category_title("Natur")
      #   #=> Article.by_sources_url("http://www.bbc")
      #
      def filter_by(*args)
        opts = {}
        opts[:optional_method_prefix] = "by_"
        args << opts

        # It defines methods which returns array of distinct values by specified search query.
        # It also defines optional search method with algorithm in a given block.
        define_search_methods(*args) do |klass, query_key, query, options|
          if query.blank?
            self
          else
            conditions = { query_key => /^#{query}$/i }
            conditions.merge!(criteria.selector) if criteria

            klass.where(conditions)
          end
        end
      end

      # Defines search methods.
      #
      # @param [Symbol, Hash] search accessors
      # @param [Hash] options should be the last param
      # @option [Symbol] prefix is a method name prefix
      # @param [Block] block is an optional search method algorithm
      def define_search_methods(*args, &block)
        @options = args.extract_options!
        @optional_algorithm = block if block_given?

        args.each do |arg|
          if arg.kind_of?(Hash)            #  { :tags => :name }
            arg.keys.each do |key|
              if arg[key].kind_of?(Array)  #  { :sources => [:url, :publisher] }
                arg[key].each do |field|
                  _define_search_method(field.to_s, key.to_s)
                end
              else
                _define_search_method(arg[key].to_s, key.to_s)
              end
            end
          else
            _define_search_method(arg.to_s)
          end
        end
      end

      protected

      # Defines search method
      #
      # @param [String] field_name field by which search will be executed.
      # @param [String] relation_name name of relation if it is not a self field, nil by default.
      def _define_search_method(field_name, relation_name = nil)
        relation = _relate!(field_name, relation_name)

        base_name = "#{relation ? "#{relation_name}_" : ""}#{field_name}"

        klass = relation && !relation.embedded? ? relation.class_name.constantize : self
        query_key = relation && relation.embedded? ? "#{relation_name}.#{field_name}" : field_name

        # Defining distinct values method.
        # Example:
        #   Article.distinct_authors(:search => "Steven King", limit: 10)
        distinct_method_name = "distinct_#{base_name.pluralize}"
        unless method_defined?(distinct_method_name)
          define_singleton_method("#{distinct_method_name}") do |options = {}|
            limit = (options[:limit] || 0).to_i
            query = options[:search]
            regexp = /^#{query}/i

            conditions = criteria ? criteria.selector : {}
            conditions.merge!(query_key => regexp) unless query.blank?

            values = klass.where(conditions).all.distinct(query_key)
            values = values.select { |v| v =~ regexp } if query.present? && relation && relation.embedded?

            limit > 0 ? values.sort.first(limit) : values.sort
          end
        end

        # Defines optional method
        if @optional_algorithm.present?
          define_singleton_method("#{@options[:optional_method_prefix]}#{base_name}") do |query, options = {}|
            @optional_algorithm.call(klass, query_key, query, options)
          end
        end
      end

      # Validates relation and returns relation or nil.
      # Raises exception if relation of field with given name does not exist.
      #
      # @param [String] field_name field by which search will be executed.
      # @param [String] relation_name name of relation if it is not a self field, nil by default.
      def _relate!(field_name, relation_name)
        if relation_name
          relation = self.relations[relation_name]
          raise "Incorrect relation #{relation_name} for model #{self.name}" if relation.nil?
          _validate_field!(relation.class_name.constantize, field_name)
        else
          relation = nil
          _validate_field!(self, field_name)
        end
        relation
      end

      # Validates field existence.
      # Raises exception if field with given name does not exist.
      #
      # @param [Object] klass
      # @param [String] field_name
      def _validate_field!(klass, field_name)
        unless klass.fields.keys.include?(field_name)
          raise "Incorrect field #{field_name} for model #{klass.name}"
        end
      end
    end
  end
end