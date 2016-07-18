module Controllers
  module Comments
    extend ActiveSupport::Concern

    included do
      def fetch_comment_for(post_id, comment_id)
        post = Post.find_by(id: post_id)

        return nil if post.blank?

        post.comments.find_by(id: comment_id)
      end

      post '/comments' do
        post = Post.find_by(id: params[:post_id])
        service = execute_service('Comments::CreateService', post, current_user, service_params(:comment))

        json response_for_create_service(service, :comment)
      end

      delete '/comments/:comment_id' do
        comment = fetch_comment_for(params[:post_id], params[:comment_id])
        service = execute_service('Comments::DeleteService', comment, current_user)

        json response_for_delete_service(service, :comment)
      end

      put '/comments/:comment_id' do
        comment = fetch_comment_for(params[:post_id], params[:comment_id])
        service = execute_service('Comments::UpdateService', comment, current_user, params)

        json response_for_update_service(service, :comment)
      end

      get '/:id' do
        comment = fetch_comment_for(params[:post_id], params[:comment_id])
      end
    end
  end
end