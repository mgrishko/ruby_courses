module ActiveRecord
  module Validations
    module ClassMethods

      @@is_valid_gtin_count_msg = 'has invalid length'
      @@is_valid_gtin_checksum_msg = 'checksum is not correct'

      def validates_is_gtin(*attr_names)
        configuration = {
          :on => :save,
          :length_message => @@is_valid_gtin_count_msg,
          :checksum_message => @@is_valid_gtin_checksum_msg
        }

        configuration.update(attr_names.extract_options!)

        validates_each(attr_names, configuration) do |record, attr_name, value|
          is_valid_gtin(record, attr_name, value, configuration[:length_message], configuration[:checksum_message])
        end
      end


      def validates_gtin
        validates_presence_of :gtin
        validates_uniqueness_of :gtin, :scope => :user_id
        validate :is_valid_gtin
      end

      protected
        def is_valid_gtin(record, attr_name, value, length_msg, checksum_msg)
          return nil if value.nil?
          s = value.to_s.rjust 8, '0'

          if [8, *(12..14)].grep(s.size).size != 0
            tmp = s.split '' 
            checknum = tmp.pop.to_i

            sum = 0
            i = true
            tmp.reverse.each do |n|
              sum += n.to_i * (i ? 3 : 1)
              i = !i
            end

            if checknum != (10 - (sum % 10)).to_i
              record.errors.add(attr_name, checksum_msg)
            end

          else
            record.errors.add(attr_name, length_msg)
          end
        end

    end
  end
end
