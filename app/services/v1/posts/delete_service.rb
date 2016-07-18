module Services
  module V1
    module Posts
      class DeleteService < NiftyServices::BaseDeleteService

        record_type ::Post

        private
        def user_can_delete_record?
          @record.user_id == @user.id
        end

        def after_success
          logger.info('Successfully Deleted Post ID %s' % @record.id)
        end
      end
    end
  end
end
