module Services
  module V1
    module Users
      class ActivateAccountService < NiftyServices::BaseUpdateService

        record_type User

        def record_attributes_whitelist
          [:activated_at]
        end

        # mock to changed_attributes_array work properly
        def record_attributes_hash
          { activated_at: nil }
        end

        def update_record
          @user.activate_account!
          @user
        end

        def user_name
          @user.try(:fullname)
        end

        private
        # when record(user) it's not valid we assume that token it's not valid
        def invalid_record_error_key
          'users.invalid_account_activation_token'
        end

        def user_can_update_record?
          # user exists, but account is already activated
          unless @user.account_deactivated?
            # return as not_found to not expose user activation status
            return not_found_error!(invalid_record_error_key)
          end

          # only user can activate your owned account
          @record == @user
        end

        def after_success
          logger.info('Successfully activated user %s account!' % @user.email)
        end
      end
    end
  end
end
