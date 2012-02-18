module ApplicationHelper
  include Uservoice::ViewHelpers
  # Sets content for title in head and for body header.
  #
  # @param [String] page_title page title
  # @param [Hash] options optional.
  # @option[Symbol] :page_title if true or does not present then it sets content for body title.
  def title(page_title, options = {})
    set_page_title = options[:page_title].nil? ? true : options[:page_title]
    if set_page_title
      content_for(:page_title, page_title.to_s)
      content_for(:head_title, page_title.to_s)
    else
      content_for(:head_title, page_title.to_s)
    end
  end

  # Renders Uservoice widget with SSO parameters for current user (id, email, short_name)
  def user_voice_widget
    if Settings.uservoice.show_widget && current_user.present? &&
        current_user.memberships.any? { |membership| membership.account.active? }
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
  def two_col_fieldset(legend, hint = nil, &block)
    hint_html = content_tag(:div, hint, class: "large-hint")
    hint_wrapper_html = content_tag(:div, hint_html, class: "span5 columns")
    inputs_html = content_tag(:div, capture(&block), class: "span8 offset1 columns")

    field_set_tag legend do
      content_tag :div, hint_wrapper_html.concat(inputs_html), { class: "row inputs" }
    end
  end
end
