require File.expand_path('concerns/seed_service', File.dirname(__FILE__))

module Services
  module V1
    module System
      class SeedService < NiftyServices::BaseActionService

        action_name :initial_application_db_seed

        attr_reader :admin_user, :post

        include System::Concerns::SeedService

        DEFAULT_AMMOUNT = 5

        def user_can_execute_action?
          return true
        end

        def execute_service_action
          create_admin_user
          create_sample_posts_and_comments(DEFAULT_AMMOUNT)
        end

        private
        def create_sample_posts_and_comments(ammount = 1)
          ammount.to_i.times do |index|
            create_posts_for(admin_user, DEFAULT_AMMOUNT)
          end
        end

        def create_admin_user
          service = Users::CreateService.new(params_for_user_service(:admin)).execute
          user_service_handle_response(service, :admin)

          service.record
        end

        def create_posts_for(user, ammount = 1)
          ammount.to_i.times do
            create_post_for(user)
          end
        end

        def create_comments_for(post, user, ammount = 1)
          ammount.to_i.times do
            create_comment_for(post, user)
          end
        end

        def record_error_key
          :seeds
        end

        def admin_user
          @admin_user ||= User.find_by(email: ADMIN_USER_EMAIL) || create_admin_user
        end

        private
        def create_post_for(user)
          params = params_for_post_service(
            title: Faker::Lorem.sentence,
            content: Faker::Lorem.sentence(10, true, 4)
          )
          service = Posts::CreateService.new(user, params).execute

          if service.success?
            create_comments_for(service.post, user, DEFAULT_AMMOUNT)
          end
        end

        def create_comment_for(post, user)
          params = params_for_comment_service(content: Faker::Lorem.paragraph)

          service = Comments::CreateService.new(post, user, params).execute
          service
        end
      end
    end
  end
end