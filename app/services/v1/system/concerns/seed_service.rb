module Services
  module V1
    module System
      module Concerns
        module SeedService

          ADMIN_USER_EMAIL = 'admin_user@myapp.com'

          ADMIN_USER_DATA = {
            name: 'Admin User',
            role: 'admin',
            email: ADMIN_USER_EMAIL,
            password: 'admin_secret_pass',
            password_confirmation: 'admin_secret_pass'
          }

          DEFAULT_POST_DATA = {
            title: 'My awesome post using NiftyServices!',
            content: "Don't you think this super awesome?"
          }

          DEFAULT_COMMENT_DATA = {
            content: "My awesome comment using NiftyServices!"
          }

          def params_for_user_service(user_type = :admin)
            {
              validate_api_key: false,
              allow_admin_creation: true,
              activate_user_account: true,
              user: (user_type == :admin ? ADMIN_USER_DATA : {})
            }
          end

          def user_service_handle_response(service, user_type = :admin)
            if service.success?
              logger.info "[Seed Script] Successfully created #{user_type} user!"
            else
              logger.warn "[Seed Script] Something went wrong in #{user_type} user creation"
              logger.error service.errors
            end
          end

          def params_for_post_service(post_data = {})
            post_data = DEFAULT_POST_DATA.merge(post_data)

            default_service_params.merge(post: post_data)
          end

          def params_for_comment_service(comment_data = {})
            comment_data = DEFAULT_COMMENT_DATA.merge(comment_data)

            default_service_params.merge(comment: comment_data)
          end

          def default_service_params
            { logger:self.logger }
          end
        end
      end
    end
  end
end