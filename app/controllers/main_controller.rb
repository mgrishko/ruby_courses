class MainController < ApplicationController
  layout false
  def classifier
    @groups = Gpc.all :select => "DISTINCT(gpcs.segment_description)", :order => 'segment_description'
    respond_to do |format| 
      format.js
    end
  end
  
  def subgroups
    @subgroups = Gpc.all :select => "DISTINCT(gpcs.description)", :order => 'description', :conditions => ['segment_description = ?', CGI::unescape(params[:id])]
  end
  
  def categories
    @categories = Gpc.all :select => "code, name", :order => 'code,name', :conditions => ['description = ?', CGI::unescape(params[:id])]
  end
  
end
