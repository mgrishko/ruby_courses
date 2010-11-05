module Terbium
  module Controller
    class Base < ApplicationController
      unloadable

      include Dsl

      before_filter :set_translation
      after_filter :unset_translation

      def set_translation
        target.locale = translation if translates?
      end

      def unset_translation
        target.locale = nil if translates?
      end

      acts_as_terbium

      def index
        @records = target.scoped(terbium_config.scope).scoped(:conditions => boolean_filters).scoped(:conditions => search_query, :order => resource_session[:order]).paginate(:page => params[:page], :include => resource_children | includes)
        render_action :index
      end

      def show
        @record = plural? ? target.find(params[:id]) : target
        render_action :show
      end

      def new
        @record = plural? ? target.new : resource_parent_record.send("build_#{resource}")
        session[:terbium_back] = request.referrer
        render_action :new
      end

      def edit
        @record = plural? ? target.find(params[:id]) : target
        session[:terbium_back] = request.referrer
        render_action :edit
      end

      def create
        @record = plural? ? target.new(params[model_name]) : resource_parent_record.send("build_#{resource}", params[model_name])
        if @record.save
          flash[:notice] = "#{model_name.humanize} was successfully created."
          if params[:commit] == 'Save'
            redirect_to edit_resource_path
          else
            redirect_to(session[:terbium_back] || plural? ? resources_path : resource_path)
          end
        else
          render_action :new
        end
      end

      def update
        @record = plural? ? target.find(params[:id]) : target
        if @record.update_attributes params[model_name]
          flash[:notice] = "#{model_name.humanize} was successfully updated."
          if params[:commit] == 'Save'
            redirect_to edit_resource_path
          else
            redirect_to(session[:terbium_back] || plural? ? resources_path : resource_path)
          end
        else
          render_action :edit
        end
      end

      def destroy
        @record = plural? ? target.find(params[:id]) : target
        @record.destroy
        redirect_to(request.referrer || plural? ? resources_path : resource_path)
      end

      private

      def search_query fields = index_fields
        fields ||= searchable_fields(fields)
        if resource_session[:query].present?
          cond = fields.map { |f| "#{f.query_column} like '%#{resource_session[:query]}%'" if f.query_column.present? }.compact.join(' or ')
        end
      end

      def includes fields = nil
        fields ||= index_fields
        @includes ||= fields.map{|f| f if f.to_s.include?('.')}.compact.map do |field|
          field = [field.main_model.to_s.underscore.to_sym] + field.to_s.split('.').map(&:to_sym)
          field.delete_at(-1)
          segment = []
          (field.size - 1).downto(1) do |i|
            parent_model = field[i-1].to_s.classify.constantize rescue nil
            segment = parent_model && parent_model.reflections.keys.include?(field[i]) ? [{field[i].to_sym => segment}] : []
          end
          segment[0]
        end
      end

    end
  end
end
