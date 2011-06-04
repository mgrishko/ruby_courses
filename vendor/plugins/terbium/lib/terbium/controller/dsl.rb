module Terbium
  module Controller
    module Dsl

      def self.included base
        base.class_eval do
          class_attribute :terbium_fields
          self.terbium_fields = {}

          extend ClassMethods
        end
      end

      [:index, :show, :form, :create, :update].each do |sym|
        define_method("#{sym}_fields") do
          self.class.terbium_fields[sym]
        end
      end

      def terbium_config
        self.class.terbium_config
      end

      def terbium_actions
        self.class.actions
      end

      module ClassMethods

        def terbium_config
          @terbium_config ||= Terbium::Controller::Config.new
        end

        def configure &block
          block.bind(terbium_config).call
        end

        def actions *actions
          actions.present? ? @actions = actions : (@actions || [])
        end

        [:index, :show, :form, :create, :update].each do |sym|
          class_eval <<-EOS
            def #{sym}
              @terbium_option = :#{sym}
              terbium_fields[@terbium_option] = []
              yield if block_given?
            end
          EOS
          define_method("#{sym}_fields") do
            terbium_fields[sym]
          end
        end

        def field name, options = {}
          field = ::Terbium::Field.new(model_name.classify.constantize, name, options)
          generate_association_actions field if field.association?
          generate_change_actions field if field.toggable?
          terbium_fields[@terbium_option] << field
        end

        def generate_association_actions field
          field.collection? ? generate_collection_association_actions(field) : generate_single_association_actions(field)
        end

        def generate_single_association_actions field
          define_method "associated_#{field}_choosing" do
            @records = field.association.klass.scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @field = field
            render 'terbium/associated/one'
          end
        end

        def generate_collection_association_actions field
          define_method "associated_#{field}" do
            @records = field.association.klass.scoped(:conditions => {:id => params[:ids]}).scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @field = field
            render 'terbium/associated/many'
          end

          define_method "associated_#{field}_choosing" do
            @records = field.association.klass.scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @choosen = field.association.klass.scoped(:conditions => {:id => params[:ids]}).scoped(:conditions => search_query(field.association_fields)).paginate(:page => params[:page], :include => includes(field.association_fields))
            @field = field
            render 'terbium/associated/many'
          end
        end

        def generate_change_actions field
          define_method "toggle_#{field}" do
            @record = model.find params[:id]
            @field = field
            @record.toggle! field.name.to_sym
            render 'terbium/toggle'
          end
        end

        def route_member_actions
          unless @route_member_actions
            @route_member_actions = {}
            actions.each do |action|
              @route_member_actions.merge!(action => :get)
            end
            index_fields.each do |field|
              @route_member_actions.merge!("toggle_#{field}" => :post) if field.toggable?
            end if index_fields
          end
          @route_member_actions
        end

        def route_collection_actions
          unless @route_collection_actions
            @route_collection_actions = {}
            [:form_fields, :update_fields, :create_fields].each do |fields|
              fields = send fields
              fields.each do |field|
                if field.association?
                  field.collection? ? @route_collection_actions.merge!("associated_#{field}" => :post, "associated_#{field}_choosing" => :post) : @route_collection_actions.merge!("associated_#{field}_choosing" => :post)
                end
              end if fields
            end
          end
          @route_collection_actions
        end

      end

    end
  end
end
