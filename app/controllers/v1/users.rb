module Controllers
  module Users
    extend ActiveSupport::Concern

    included do
      post do
        service = execute_service('Users::CreateService', service_params(:user))

        json response_for_create_service(service, :user)
      end

      post '/auth' do
        service = execute_service('Users::AuthService', params) # Services::V1::Users::AuthService.new(params).execute

        json response_for_service(service, auth_token: service.auth_token)
      end

      delete '/auth/:token' do
        status_code = 404
        user = User.find_by(auth_token: params[:token])

        if user.try(:clear_auth_token!)
          status_code =  204
        end

        status status_code
      end

      post '/resend_activation_mail' do
        user = User.find_by(email: params[:email])
        service = execute_service('Users::ActivationMailDeliveryService', user)

        json simple_response_for_service(service)
      end

      post '/activate_account/:token' do
        user = User.find_by(activation_token: params[:token])
        service = execute_service('Users::ActivateAccountService', user, user)

        json response_for_update_service(service, :user)
      end
    end
  end
end