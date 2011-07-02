module Nokogiri
  module XML
    class Reader
      def find_descendant str
        doc = Nokogiri::XML::DocumentFragment.parse self.outer_xml
        find_in_node doc.children, str
      end
      protected
      def find_in_node nodeset, str
        nodeset.each do |n|
          return n if n.name == str
          node = find_in_node n.children, str
          return node if node
        end
        return nil
      end
    end
  end
end