module Services
  module V1
    module Posts
      class CreateService < NiftyServices::BaseCreateService

        record_type ::Post

        WHITELIST_ATTRIBUTES = [
          :title,
          :content
        ]

        private
        def on_save_record_error(error)
          logger.error(error)
          if error.is_a?(ActiveRecord::RecordNotUnique)
            return unprocessable_entity_error!(%s(posts.duplicate_record))
          end
        end

        def build_record_scope
          @user.posts
        end

        def record_attributes_hash
          @options.fetch(:post, {})
        end

        def record_attributes_whitelist
          WHITELIST_ATTRIBUTES
        end

        def record_error_key
          :posts
        end

        def user_can_create_record?
          return true
        end

        def after_success
          notify_subscribers if option_enabled?(:notify_subscribers)
          log_creation
        end

        def log_creation
          logger.info 'Sucessfully added new post for user id %s' % @user.id
          logger.info 'Post details: %s' % @record.to_json
        end

        def notify_subscribers
          # suppose user have subscriber to posts
          # @user.subscribers.each do |subscriber|
          #  subscriber.send_new_post_notify(@record)
          # end
        end
      end
    end
  end
end
