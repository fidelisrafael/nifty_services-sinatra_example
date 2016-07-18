module Services
  module V1
    module Users
      class ActivationMailDeliveryService < NiftyServices::BaseActionService

        INTERVAL_TO_SEND_ANOTHER_MAIL = 1.minutes

        # action_name :send_account_activation_mail

        attr_reader :user

        def initialize(user, options = {})
          @user = user
          super(options)
        end

        private
        def valid_user?
          valid_object?(@user, User)
        end

        def valid_record?
          valid_user?
        end

        def user_can_execute_action?
          return true if @user.activation_sent_at.blank?

          # only users which deactivated account can execute this action
          if @user.account_activated?
            return not_authorized_error!(%s(users.account_already_activated))
          end

          Time.now.utc > (@user.activation_sent_at + INTERVAL_TO_SEND_ANOTHER_MAIL)
        end

        def execute_service_action
          @user.send_account_activation_mail!
        end

        def record_error_key
          :users
        end
      end
    end
  end
end
