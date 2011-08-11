require 'spec_helper'
describe ApplicationHelper do
  describe '#html_pager' do
    it 'should show right number of items per full page' do
      base_items = []
      19.times do
        base_items << BaseItem.new
      end
      paged_collection =  base_items.paginate :page=>1, :per_page => 10
      pager = "<span>1 - 10 #{t 'pager.from'} #{paged_collection.total_entries}</span>"
      helper.html_pager(paged_collection).should include(pager)
    end

    it 'should show right number of items per partial page' do
      base_items = []
      19.times do
        base_items << BaseItem.new
      end
      paged_collection =  base_items.paginate :page=>2, :per_page => 10
      pager = "<span>11 - 19 #{t 'pager.from'} #{paged_collection.total_entries}</span>"
      helper.html_pager(paged_collection).should include(pager)
    end

    it 'should not appear if collection is smaller than items per page' do
      base_items = []
      9.times do
        base_items << BaseItem.new
      end
      paged_collection =  base_items.paginate :page=>1, :per_page => 10
      helper.html_pager(paged_collection).should == nil
    end
  end
end

