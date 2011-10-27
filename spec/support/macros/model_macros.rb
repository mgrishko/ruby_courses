module ModelMacros
  def prepare_ability_for(resource_name, role = nil)
    fabricator = "#{role.blank? ? "" : "#{role.to_s}_"}#{resource_name.to_s}"
    before do
      resource = Fabricate(fabricator.to_sym)
      @ability = "#{resource_name.to_s.capitalize}Ability".constantize.new(resource)
    end
  end
end