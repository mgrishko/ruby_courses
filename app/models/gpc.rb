# == Schema Information
#
# Table name: gpcs
#
#  id                     :integer         not null, primary key
#  brick_en               :string(255)
#  code                   :integer
#  created_at             :datetime
#  updated_at             :datetime
#  segment_description_en :string(255)
#  class_description_en   :string(255)
#  family_description_en  :string(255)
#  brick_ru               :string(255)
#  segment_description_ru :string(255)
#  class_description_ru   :string(255)
#  family_description_ru  :string(255)
#  brick_definition_en    :text
#  brick_definition_ru    :text
#

class Gpc < ActiveRecord::Base
end



