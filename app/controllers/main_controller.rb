# encoding = utf-8
class MainController < ApplicationController
  before_filter :internalization, :only => [:classifier, :subgroups, :categories]

  layout false

  def classifier
    if I18n.locale == :en
      @groups = Gpc.select("DISTINCT(gpcs.segment_description_en)").order('segment_description_en').all
    else
      @groups = Gpc.select("DISTINCT(gpcs.segment_description_ru)").order('segment_description_ru').all
    end
    respond_to do |format|
      format.js
    end
  end

  def export_form
    @export_forms = EXPORT_FORMS
  end

  def subgroups
    if I18n.locale == :en
      @subgroups = Gpc.where(['segment_description_en = ?', CGI::unescape(params[:id])]).order('class_description_en').all.group_by(&:family_description_en)
    else
      @subgroups = Gpc.where(['segment_description_ru = ?', CGI::unescape(params[:id])]).order('class_description_ru').all.group_by(&:family_description_ru)
    end
  end

  def categories
    if I18n.locale == :en
      @categories = Gpc.select("code, brick_en").where(['class_description_en = ? OR gpcs.family_description_en = ?', CGI::unescape(params[:id]),CGI::unescape(params[:id])]).order('code, brick_en').all
    else
      @categories = Gpc.select("code, brick_ru").where(['class_description_ru = ? OR gpcs.family_description_ru = ?', CGI::unescape(params[:id]),CGI::unescape(params[:id])]).order('code ,brick_ru').all
    end
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

  private

    def internalization
      @code = :code
      if I18n.locale == :en
        @brick, @class_description, @family_description, @segment_description = :brick_en,
          :class_description_en, :family_description_en, :segment_description_en
      else
        @brick, @class_description, @family_description, @segment_description = :brick_ru,
          :class_description_ru, :family_description_ru, :segment_description_ru
      end
    end

end
