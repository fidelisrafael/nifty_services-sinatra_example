module Services
  module V1
    module Comments
      class DeleteService < NiftyServices::BaseDeleteService

        record_type ::Comment

        private
        def user_can_delete_record?
          # post owner or comment owner can delete
          [@record.user_id, post.user_id].member?(@user.id)
        end

        def after_success
          logger.info('Successfully deleted comment ID %s for post ID' % [@record.id, post.id])
        end

        def post
          @record.post
        end
      end
    end
  end
end
