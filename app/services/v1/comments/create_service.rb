module Services
  module V1
    module Comments
      class CreateService < NiftyServices::BaseCreateService

        record_type ::Comment

        WHITELIST_ATTRIBUTES = [
          :content
        ]

        attr_reader :post

        def initialize(post, user, options = {})
          @post = post
          super(user, options)
        end

        private
        def build_record
          params = record_allowed_attributes.merge(user_id: @user.id)
          build_record_scope.build(params)
        end

        def build_record_scope
          @post.comments
        end

        def record_attributes_hash
          @options.fetch(:comment, {})
        end

        def record_attributes_whitelist
          WHITELIST_ATTRIBUTES
        end

        def record_error_key
          :comments
        end

        def user_can_create_record?
          return not_found_error!(%s(posts.not_found)) unless valid_post?

          if duplicated_comment_for_user?
            return forbidden_error!(%s(posts.duplicated_comment_for_user))
          end

          return true
        end

        def duplicated_comment_for_user?
          comment = @post.comments.where(content: comment_content, user_id: @user.id).last

          return false if comment.blank?

          return (comment.created_at + 1.hour).utc > Time.now.utc
        end

        def comment_content
          record_allowed_attributes[:content]
        end

        def after_success
          log_comment_creation
          send_notification_to_quoted_users if option_enabled?(:notify_user)
        end

        def log_comment_creation
          logger.info 'Sucessfully added new comment by user_id for post id %s' % [@user.id, @record.id]
          logger.info 'Comment details: %s' % @record.to_json
        end

        def send_notification_to_quoted_users
          # suppose that users can quote others users in comments
          # @record.quoted_users.each do |user|
          #  user.send_comment_quote_notification(@record)
          # end
        end

        def valid_post?
          valid_object?(@post, Post)
        end
      end
    end
  end
end
