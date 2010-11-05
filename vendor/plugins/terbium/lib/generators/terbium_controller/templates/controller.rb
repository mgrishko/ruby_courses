class <%= prefix.classify %>::<%= controller_name %> < Terbium::Controller::Base
  before_filter :
<% attributes = model ? model.columns.map(&:name) - ['id', 'created_at', 'updated_at'] : [] -%>

  index do
<% attributes.each do |attribute| -%>
    field :<%= attribute %>
<% end -%>
  end

  form do
<% attributes.each do |attribute| -%>
    field :<%= attribute %>
<% end -%>
  end

end
