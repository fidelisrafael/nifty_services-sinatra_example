module Services
  module V1
    module Users
      class AuthService < NiftyServices::BaseService

        attr_reader :auth_token

        after_success do
          data = [@auth_token, auth_user.id]
          logger.info("Succesfully set auth_token = '%s' for user %s" % data)
        end

        after_error do
          logger.warn('Cant authenticate user(%s), cuz:' % options[:email])
          logger.error(errors)
        end

        def execute
          execute_action do
            if authenticate_user
              @auth_token = @user.generate_auth_token!
              success_response
            end
          end
        end

        private
        def can_execute?
          unless auth_user
            return not_authorized_error!(%s(users.invalid_credentials))
          end

          unless auth_user.account_activated?
            return forbidden_error!(%s(users.account_not_activated))
          end

          return true
        end

        def authenticate_user
          User.authenticate(options[:email], options[:password])
        end

        def auth_user
          @user ||= authenticate_user
        end

      end
    end
  end
end
