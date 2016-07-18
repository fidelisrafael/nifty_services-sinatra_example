module Helpers
  module LocaleHelper
    VALID_LOCALES = [
      :en,
      :"pt-BR"
    ]

    DEFAULT_LOCALE = (ENV['LOCALE'] || 'en').to_sym

    def set_locale
      I18n.locale = current_locale
    end

    def locale_from_request
      params['locale'] || headers['X-Locale']
    end

    def current_locale
      locale = locale_from_request || DEFAULT_LOCALE
      valid_locale = VALID_LOCALES.member?(locale.to_sym)

      valid_locale ? locale : I18n.default_locale
    end

  end
end
