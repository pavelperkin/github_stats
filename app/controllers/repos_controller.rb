class ReposController < ApplicationController

  respond_to :js

  def toggle_activation
    @repo = Repo.find(params[:repo_id])
    @repo.update(observed: !@repo.observed)
  end

end
