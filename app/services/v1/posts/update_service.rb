module Services
  module V1
    module Posts
      class UpdateService < NiftyServices::BaseUpdateService

        record_type ::Post

        WHITELIST_ATTRIBUTES = [
          :title,
          :content
        ]

        private
        def record_attributes_hash
          @options.fetch(:post, {})
        end

        def record_attributes_whitelist
          WHITELIST_ATTRIBUTES
        end

        def user_can_update_record?
          @record.user_id == @user.id
        end

        def after_success
          if changed?
            logger.info 'Successfully update post ID %s' % @record.id
            logger.info 'Changed attributes are %s' % changed_attributes
          end
        end
      end
    end
  end
end
