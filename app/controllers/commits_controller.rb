class CommitsController < ApplicationController

  def index
    @commits = Commit.desc.includes(:user)
  end

end
