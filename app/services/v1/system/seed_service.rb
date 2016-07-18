module Services
  module V1
    module System
      class SeedService < NiftyServices::BaseActionService

        action_name :initial_application_db_seed

        attr_reader :admin_user, :post

        ADMIN_USER_EMAIL = 'admin_user@myapp.com'

        def user_can_execute_action?
          return true
        end

        def execute_service_action
          create_admin_user
          create_post_for(admin_user)
        end

        def create_admin_user
          default_admin_params = {
            validate_api_key: false,
            allow_admin_creation: true,
            activate_user_account: true,
            user: {
              name: 'Admin User',
              role: 'admin',
              email: ADMIN_USER_EMAIL,
              password: 'admin_secret_pass',
              password_confirmation: 'admin_secret_pass'
            }
          }

          service = Users::CreateService.new(default_admin_params).execute

          if service.success?
            logger.info '[Seed Script] Successfully created admin user!'
          else
            logger.warn '[Seed Script] Something went wrong in admin user creation'
            logger.error service.errors
          end

          service.record
        end

        def create_post_for(user)
          params = {
            post: {
              title: 'My awesome post using NiftyServices!',
              content: "Don't you think this super awesome?"
            },
            logger: self.logger
          }

          service = Posts::CreateService.new(user, params).execute

          if service.success?
            create_comment_for(service.post, user)
          end
        end

        def create_comment_for(post, user)
          params = {
            comment: {
              content: "My awesome comment using NiftyServices!"
            },
            logger: self.logger
          }

          service = Comments::CreateService.new(post, user, params).execute
          service.success?
        end

        def record_error_key
          :seeds
        end

        def admin_user
          @admin_user ||= User.find_by(email: ADMIN_USER_EMAIL) || create_admin_user
        end
      end
    end
  end
end