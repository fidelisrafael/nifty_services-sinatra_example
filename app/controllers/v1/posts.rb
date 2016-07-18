module Controllers
  module Posts
    extend ActiveSupport::Concern

    included do
      def fetch_post_for(user, id)
        return nil unless user

        user.posts.find_by(id: id)
      end

      post do
        service = execute_service('Posts::CreateService', current_user, service_params(:post))

        json response_for_create_service(service, :post)
      end

      delete '/:id' do
        post = fetch_post_for(current_user, params[:id])

        service = execute_service('Posts::DeleteService', post, current_user)

        json response_for_delete_service(service, :post)
      end

      put '/:id' do
        post =  fetch_post_for(current_user, params[:id])
        service = execute_service('Posts::UpdateService', post, current_user, params)

        json response_for_update_service(service, :post)
      end

      get '/:id' do
        post  = post = fetch_post_for(current_user, params[:id])
      end
    end
  end
end