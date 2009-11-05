class PackagingItem < Article
  set_table_name :packaging_items
  belongs_to :articles
end
