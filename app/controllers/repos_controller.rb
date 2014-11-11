class ReposController < ApplicationController
  before_action :get_repo
  respond_to :js, :html

  def toggle_activation
    @repo.update(observed: !@repo.observed)
    @repos = @repo.organization.repos
  end

  def show
    @pulls = @repo.pulls.desc.includes(:comments)
    @users = User.most_active_for_last_hour_for_repo(@repo)
  end

  private

  def get_repo
    @repo = Repo.find(params[:id])
  end

end
