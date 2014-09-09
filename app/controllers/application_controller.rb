class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :set_I18n_locale_to_browser_accept_language_or_default

  def render_check_template(action=params[:action])
    render action, layout: params[:render_template] != 'false'
  end


  private
  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first
  end

  def set_I18n_locale_to_browser_accept_language_or_default

    i18n_locale = extract_locale_from_accept_language_header
    if i18n_locale == "de" || i18n_locale == "en"
      I18n.locale = i18n_locale
    else
      I18n.locale = I18n.default_locale
    end
  end

end