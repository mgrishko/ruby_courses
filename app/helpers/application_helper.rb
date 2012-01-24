module ApplicationHelper
  # Sets content for title in head and for body header.
  #
  # @param [String] page_title page title
  # @param [Hash] options optional. if options[:body] == true or does not present it sets content for body title.
  def title(page_title, options = {})
    set_page_title = options[:page_title].nil? ? true : options[:page_title]
    if set_page_title
      content_for(:page_title, page_title.to_s)
      content_for(:head_title, page_title.to_s)
    else
      content_for(:head_title, page_title.to_s)
    end
  end

  # Sets SSO parameters for current user (id, email, short_name)
  def user_voice_widget
    if !current_user.nil? && current_user.accounts.any? { |account| account.active? }
      raw uservoice_config_javascript(:sso => { :guid         => current_user.id,
                                                :email        => current_user.email,
                                                :display_name => current_user.short_name
                                              })
    end
  end
end
