class Cloud < ActiveRecord::Base
  belongs_to :tag
  belongs_to :item
  belongs_to :user
  validates_presence_of :tag_id
  attr_accessor :q
  belongs_to :clouded_item, :class_name => 'Item', :foreign_key => :item_id

  #FIXME: требуется рефакторинг.
  def self.get_clouds retailer, supplier=nil, all_suppliers=nil
    # BI опубликованные, но не приватные
    public_ids = BaseItem.public_last_published.to_ids
    # BI опубликованные, приватные
    private_ids = BaseItem.private_last_published.to_ids
    #FIXME: изменить модель user добавить связь has_many receivers
    # BI для текущего receiver
    this_receiver_ids = Receiver.where(:user_id => retailer.id ).map{|r| r.base_item_id}
    result = []
    tags = retailer.tags
    if supplier or all_suppliers
      #/suppliers/1 = ok
      #BI получение и приватных и принадлежащих пользователю как ресиверу
      this_receiver_private_ids = this_receiver_ids & private_ids
      # BI и приватные данного пользователя, и опубликованные неприватные
      ids = (public_ids | this_receiver_private_ids).compact.uniq

      tags.each do |tag|
        count = 0
        cl = nil
        tag.clouds.where(:user_id => retailer.id).each do |cloud|
          item = cloud.item
          if supplier
            if item.user_id == supplier.id
              count += item.base_items.where(:id => ids).count
            else
              next
            end
          else
            count += item.base_items.where(:id => ids).count
          end
          cloud.q = count
          cl = cloud
        end
        result << cl if cl and cl.q > 0
      end
    else
      #retailer_items = ok
      # BI попавшие в подписку и помеченные как accepted
      accepted_ids = retailer.subscription_results.accepted.map{|sr| sr.base_item_id}
      # BI  - приватные данного пользователя и опубликованные неприватные и помеченные как accepted
      this_receiver_private_ids = this_receiver_ids & private_ids & accepted_ids
      ids = (public_ids & accepted_ids) | this_receiver_private_ids
      tags.each do |tag|
        count = 0
        cl = nil
        tag.clouds.where(:user_id => retailer.id).each do |cloud|
          item = cloud.item
          count += item.base_items.where(:id => ids).count
          cloud.q = count
          cl = cloud
        end
        result << cl if cl and cl.q > 0
      end
    end
    result.compact
  end
end


# == Schema Information
#
# Table name: clouds
#
#  id         :integer         not null, primary key
#  tag_id     :integer         not null
#  item_id    :integer         not null
#  user_id    :integer         not null
#  created_at :datetime
#  updated_at :datetime
#

