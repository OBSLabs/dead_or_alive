module DeadOrAlive
  module ControllerMethods
    def track_action_usage
      DeadOrAlive::ControllerRepo.new.controller!(self.class,params[:action])
    end
  end
end
