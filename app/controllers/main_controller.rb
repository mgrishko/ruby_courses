class MainController < ApplicationController
  def classifier
    @groups = Gpc.all :select => "DISTINCT(gpcs.segment_description)", :order => 'segment_description'
    respond_to do |format| 
      format.js
    end
  end
  
  def subgroups
    i = 0
    sg = Subgroup.find(:all, :conditions => {:group_id => params[:id]})
    @subgroups = []
    while sg and sg[i]
      @subgroups << sg[i]
      sg[i].subsubgroups.each do |ssg| 
        ssg.name = "- " + ssg.name
        @subgroups << ssg
      end
      i += 1
    end
  end
  
  def categories
    if subgroup = Subgroup.find(:first, :conditions => {:code => params[:id]})
      @categories = []
      subgroup.subsubgroups.each do |ssg|
        @categories += ssg.categories
      end
    elsif subsubgroup = Subsubgroup.find(:first, :conditions => {:code => params[:id]})
      @categories = subsubgroup.categories
    end
  end
  
end
