# encoding = utf-8
module Terbium
  module CoreExt
    module ActionView
      module Base

        def link_to_if_path *args, &block
          path = swallow_nil{block.call}
          path ? link_to(*args.insert(1, path)) : args[0]
        end

        def admined_controllers &block
          Rails.application.routes.admined_controllers(route_prefix).each do |c|
            c = c.controller_name
            block.call(c.humanize, send("#{route_prefix}_#{c}_path".to_sym)) if respond_to?("#{route_prefix}_#{c}_path".to_sym)
          end
        end

        def render_field record, field
          query = params[:association_query] || resource_session[:query]
          if field.toggable?
            case field.type
            when :boolean then
              res = check_box_tag field.name, true, record.send(field.name), :id => "#{model_name}_#{field}_#{record.id}", :ajax => resource_path(record, "toggle_#{field}"), :title => field.label
            else
              ''
            end
          else
            if field[:render]
              case field[:render]
              when Symbol then
                res = send(field[:render], record)
              when Proc then
                res = field[:render].bind(self).call(record)
              else ''
              end
            else
              res = h(record.call_chain(field.name))
            end
            res.to_s.gsub!(/#{query}/i) do |m|
              "<strong>#{m}</strong>"
            end if query.present?
          end
          url = url_for [route_prefix, record.call_chain(field.record)] rescue nil
          res = link_to res, url if url && field.association?
          res
        end

        def render_head field
          if field.column?
            case resource_session[:order]
            when field.order then
              sign = '▾ '
              order = "#{field.order} desc"
            when "#{field.order} desc" then
              sign = '▴ '
              order = ''
            else
              sign = ''
              order = field.order
            end
            sign + link_to(field.label, resources_path(:order => order), :title => field.label)
          else
            field.label
          end
        end

        def current_path args = {}
          "/#{request.path_info.split('/').delete_if(&:blank?).join('/')}?#{args.to_query}"
        end

        def current_url args = {}
          "#{request.protocol}#{request.host_with_port}#{current_path args}"
        end

      end
    end
  end
end

