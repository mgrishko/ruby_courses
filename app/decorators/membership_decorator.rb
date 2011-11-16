class MembershipDecorator < ApplicationDecorator
  decorates :membership

  def display_name
    "#{membership.user.first_name} #{membership.user.last_name}"
  end
  
  def role_name
    return "Owner" if membership.user == membership.account.owner
    return membership.role.capitalize
  end
  
  def edit_link(opts = {})
    h.edit_link(model, opts)
  end

  def destroy_link(opts = {})
    h.destroy_link(model, opts)
  end
  
  #def edit_link
  #  h.link_to(I18n.t("edit", scope: scope), [:edit, model], :class => "btn small") if h.can?(:update, model)
  #end
  
  #def destroy_link
  #  h.link_to I18n.t("destroy", scope: scope), model, :confirm => 'Are you sure?', :method => :delete, :class => "btn small danger" if h.can?(:destroy, model)
  #end
  
  private

  #  def scope
  #    "memberships.defaults"
  #  end
end