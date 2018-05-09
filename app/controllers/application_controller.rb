class ApplicationController < ActionController::API
  rescue_from ActiveRecord::RecordInvalid, with: :handle_validation_error
  rescue_from ActionController::ParameterMissing, with: :handle_bad_request
  rescue_from ActiveRecord::RecordNotFound, with: :handle_not_found
  private
  
  def handle_validation_error(err)
    render_error(400, err.record.errors.full_messages.join("\n"))
  end
  
  def handle_bad_request(err)
    render_error(400, err.message)
  end
  
  def handle_not_found(err)
    render_error(404, "Not Found")
  end
  
  def render_error(status, message)
    render json: { error: message }, status: status
  end
end
