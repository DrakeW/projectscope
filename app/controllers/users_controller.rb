class UsersController < ApplicationController
  def show
  	@all_projects = Project.all
  	@all_metrics = ProjectMetrics.metric_names
  	@preferred_projects = current_user.preferred_projects
  	@preferred_metrics = current_user.preferred_metrics
  end

  def update_preference
  	
  end
end
