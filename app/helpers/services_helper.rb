module Helpers
  module ServicesHelpers
    def service_params(root_key)
      params.symbolize_keys.slice(root_key)
            .merge(service_default_options)
            .symbolize_keys
    end

    def current_user
      @current_user ||= User.find_by(auth_token: auth_token_from_request)
    end

    def api_key_from_request
      params['api_key'] || headers['X-API-Key']
    end

    def auth_token_from_request
      params['auth_token'] || headers['X-Auth-Token']
    end

    def service_default_options
      { api_key: api_key_from_request }
    end

    def execute_service(service_name, *params)
      "Services::V1::#{service_name}".constantize.new(*params).execute
    end

    def simple_response_for_service(service)
      status service.response_status_code

      if service.success?
        response = success_response_for_service(service)
      else
        response = error_response_for_service(service)
      end

      response
    end

    def success_response_for_service(service)
      {
        success: true,
        status: service.response_status,
        status_code: service.response_status_code
      }
    end

    def error_response_for_service(service, response_append = {})
      {
        error: true,
        status: service.response_status,
        status_code: service.response_status_code,
        errors: service.errors
      }.merge(response_append)
    end

    def response_for_service(service, response_append = {}, force_merge = false)
      response = simple_response_for_service(service)
      response.merge!(response_append) if force_merge || service.success?

      response
    end

    def response_for_update_service(service, record_type, options = {})
      update_response = {
        updated: service.changed?,
        changed_attributes: service.changed_attributes
      }

      update_response.merge!(serialized_object_from_service(service, record_type, options))

      response_for_service(service, update_response)
    end

    def response_for_delete_service(service, record_type, options = {})
      service_response = serialized_object_from_service(service, record_type, options)
      response_for_service(service, service_response)
    end

    def response_for_create_service(service, record_type, options = {})
      service_response = {}

      if service.success?
        service_response = serialized_object_from_service(service, record_type, options)
      end

      response_for_service(service, service_response)
    end

    def serialized_object_from_service(service, record_type, options = {})
      record = service.send(:record)
      response_root = options.fetch(:root, record_type.to_sym)

      { response_root => record.as_json }
    end
  end
end
