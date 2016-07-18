module Services
  module V1
    module Users
      class CreateService < NiftyServices::BaseCreateService

        record_type ::User

        WHITELIST_ATTRIBUTES = [
          :name,
          :first_name,
          :last_name,
          :email,
          :password,
          :password_confirmation
        ]

        USER_ROLE_ATTRIBUTE = :role

        def initialize(options = {})
          super(nil, options)
        end

        def new_user?
          @record.persisted?
        end

        private
        def record_attributes_hash
          @options[:user]
        end

        def record_attributes_whitelist
          whitelist = WHITELIST_ATTRIBUTES
          whitelist.push(USER_ROLE_ATTRIBUTE) if allow_admin_creation?

          whitelist
        end

        # since there's no owner user for a User, by pass validation
        def valid_user?
          return true
        end

        def record_error_key
          :users
        end

        def user_can_create_record?
          if validate_api_key? && !valid_api_key?
            return not_authorized_error!(%s(invalid_api_key))
          end

          return true
        end

        def default_options
          { validate_api_key: true }
        end

        def allow_admin_creation?
          option_enabled?(:allow_admin_creation)
        end

        def after_success
          after_success_actions
        end

        def after_success_actions
          activate_user_account! if option_enabled?(:activate_user_account)
        end

        def activate_user_account!
          @record.activate_account!
        end
      end
    end
  end
end
