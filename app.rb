module NiftyServicesSamples
  class SinatraApp < Sinatra::Base

    set :sessions, false
    set :root, File.dirname(__FILE__)

    register Sinatra::ActiveRecordExtension
    register Sinatra::Namespace

    helpers Helpers::ServicesHelpers
    helpers Helpers::LocaleHelper

    configure do
      I18n::Backend::Simple.send(:include, I18n::Backend::Fallbacks)
      I18n.load_path = Dir[File.join(settings.root, 'locales', '*.yml')]
      I18n.backend.load_translations
    end

    set :database, { adapter: "sqlite3", database: "nifty_services.sqlite3" }

    before do
      set_locale
    end

    namespace '/v1' do
      namespace '/users' do
        include Controllers::Users
      end

      namespace '/posts' do
        include Controllers::Posts

        namespace '/:post_id' do
          include Controllers::Comments
        end
      end

    end


  end
end