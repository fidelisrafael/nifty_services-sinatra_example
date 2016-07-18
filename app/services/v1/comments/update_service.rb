module Services
  module V1
    module Comments
      class UpdateService < NiftyServices::BaseUpdateService

        record_type ::Comment

        WHITELIST_ATTRIBUTES = [ :content ]

        private
        def record_attributes_hash
          @options.fetch(:comment, {})
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
