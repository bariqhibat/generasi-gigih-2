class ApplicationController < ActionController::Base
    rescue_from ActiveRecord::RecordNotFound, :with => :render_404

    def render_404
        render 'error'
    end
end
