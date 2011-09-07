# encoding = utf-8
class MainController < ApplicationController

  layout false

  def classifier
    @groups = Gpc.all :select => "DISTINCT(gpcs.segment_description)", :order => 'segment_description'
    respond_to do |format|
      format.js
    end
  end

  def export_form
    @export_forms = EXPORT_FORMS
  end

  def subgroups
    @subgroups = Gpc.all(:order => 'description', :conditions => ['segment_description = ?', CGI::unescape(params[:id])]).group_by(&:group)
  end

  def categories
    @categories = Gpc.all :select => "code, name", :order => 'code,name', :conditions => ['description = ? OR gpcs.group = ?', CGI::unescape(params[:id]),CGI::unescape(params[:id])]
  end

  #def countries
    #@countries = Country.all :order => 'description'
    #respond_to do |format|
      #format.js
    #end
  #end

  def cases
    @id = if PackagingItem.find_by_id(params[:packagin_item_id])
      PackagingItem.find(params[:packagin_item_id]).id
    else
      if params[:packagin_item_id].to_s == '0'
        0
      else
        ''
      end
    end
    @results = params[:hide_px] ? BaseItem.packaging_types.delete_if{|i|i[:code]=='PX'} : BaseItem.packaging_types
    respond_to do |format|
      format.js
    end
  end

  def show_man
    id = BaseItem.packaging_types.find{|i|i[:code]==params[:id]}[:id]
    man = BaseItem.packaging_types.find{|i| i[:code] == params[:id]}[:description]
    @case = {:id => id, :description => man}
#    if File.exists?(File.join(Rails.root,'pi',"#{id}.jpg"))
      @case[:img] = "pi_new/#{id}.jpg"
#    end
  end

end

