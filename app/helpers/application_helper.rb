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
    # ToDo Cover current_user nil with tests.
    if !current_user.nil? && current_user.accounts.any? { |account| account.active? }
      raw uservoice_config_javascript(:sso => { :guid         => current_user.id,
                                                :email        => current_user.email,
                                                :display_name => current_user.short_name
                                              })
    end
  end
  
  # Renders fieldset with a legend and two columns with content. The first column
  # contains a long hint, the second one contains inputs.
  # @param [String] fieldset legend
  # @param [String] long hint text
  # @param [block] block of inputs
  def two_col_fieldset(legend, hint, &block)
    hint_html = content_tag(:div, hint, { class: "large-hint" })
    hint_wrapper_html = content_tag(:div, hint_html, { class: "span5" })
    inputs_html = content_tag(:div, capture(&block), { class: "span7 offset1" })
    
    field_set_tag legend do
      content_tag :div, hint_wrapper_html.concat(inputs_html), { class: "inputs" }
    end
  end
end
