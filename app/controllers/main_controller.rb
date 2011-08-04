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

  def countries
    @countries = Country.all :order => 'description'
    respond_to do |format|
      format.js
    end
  end

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
    REF_BOOKS['man'][I18n.locale]
    #hash = {}
    #hash[1] = t 'man.hash1'
    #hash[2] = t 'man.hash2'
    #hash[3] = t 'man.hash3'
    #hash[4] = t 'man.hash4'
    #hash[5] = t 'man.hash5'
    #hash[6] = t 'man.hash6'
    #hash[7] = t 'man.hash7'
    #hash[8] = t 'man.hash8'
    #hash[9] = t 'man.hash9'
    #hash[10] = t 'man.hash10'
    #hash[11] = t 'man.hash11'
    #hash[12] = t 'man.hash12'
    #hash[13] = t 'man.hash13'
    #hash[14] = t 'man.hash14'
    #hash[15] = t 'man.hash15'
    #hash[16] = t 'man.hash16'
    #hash[17] = t 'man.hash17'
    #hash[18] = t 'man.hash18'
    #hash[19] = t 'man.hash19'
    #hash[20] = t 'man.hash20'
    #hash[21] = t 'man.hash21'
    #hash[22] = t 'man.hash22'
    #hash[23] = t 'man.hash23'
    #hash[24] = t 'man.hash24'
    #hash[25] = t 'man.hash25'
    #hash[26] = t 'man.hash26'
    #hash[27] = t 'man.hash27'
    #hash[28] = t 'man.hash28'
    #hash[29] = t 'man.hash29'
    #hash[30] = t 'man.hash30'
    #hash[31] = t 'man.hash31'
    #hash[32] = t 'man.hash32'
    #hash[33] = t 'man.hash33'
    #hash[34] = t 'man.hash34'
    #hash[35] = t 'man.hash35'
    #hash[36] = t 'man.hash36'
    #hash[37] = t 'man.hash37'
    #hash[38] = t 'man.hash38'
    #hash[39] = t 'man.hash39'
    #hash[40] = t 'man.hash40'
    #hash[41] = t 'man.hash41'
    #hash[42] = t 'man.hash42'
    #hash[43] = t 'man.hash43'
    #hash[44] = t 'man.hash44'
    #hash[45] = t 'man.hash45'
    #id = BaseItem.packaging_types.find{|i|i[:code]==params[:id]}[:id]
    #@case = {:id => id, :description => hash[id]}
##    if File.exists?(File.join(Rails.root,'pi',"#{id}.jpg"))
      #@case[:img] = "pi/#{id}.jpg"
##    end
  end

end

