class ReposController < ApplicationController

  respond_to :js

  def toggle_activation
    repo = Repo.find(params[:repo_id])
    repo.update(observed: !repo.observed)
    @repos = repo.organization.repos.sort_by { |r| r.observed ? 0 : 1 }
  end

end
