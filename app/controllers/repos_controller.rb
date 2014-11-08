class ReposController < ApplicationController
  before_action :get_repo
  respond_to :js, :html

  def toggle_activation
    @repo.update(observed: !@repo.observed)
    @repos = @repo.organization.get_sorted_repos
  end

  def show
    @pulls = @repo.pulls.includes(:comments)
  end

  private

  def get_repo
    @repo = Repo.find(params[:id])
  end

end
