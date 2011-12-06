# ToDo tags_list validation should proxy tag validation.

module Mongoid
  module Taggable
    extend ActiveSupport::Concern

    included do
      embeds_many :tags, as: :taggable, versioned: false
      accepts_nested_attributes_for :tags, allow_destroy: true
      attr_accessible :tags_attributes
    end

    # @return [String] tags list getter.
    def tags_list
      @tags_list ||= tags.map(&:name).join(", ")
    end

    # Tags list attribute setter method.
    # It also prepares but not saves in db embedded tags:
    #   * marks for destruction old tags.
    #   * adds new tags.
    # Embedded tags will be saved in the db with parent document.
    #
    # @param [String] val tags joined by tag separator.
    def tags_list=(val)
      @tags_list = val

      valid_tags = val.split(",").map(&:strip).compact
      current_tags = self.tags.map(&:name)
      tags_attrs = {}

      # Marking removed tags for destruction
      self.tags.each_with_index do |tag, i|
        destruction_mark = valid_tags.include?(tag.name) ? "false" : "1"
        tags_attrs[i.to_s] = tag.attributes.merge({ "_destroy" => destruction_mark })
      end

      # Adding new tags
      i = tags_attrs.length
      valid_tags.each_with_index do |name, j|
        tags_attrs[(i+j).to_s] = self.tags.build(name: name).attributes unless current_tags.include?(name)
      end

      # Setting (but not saving in db) embedded tags
      self.write_attributes("tags_attributes" => tags_attrs)
    end
  end
end