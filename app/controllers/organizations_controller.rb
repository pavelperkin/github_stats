class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :destroy]

  def index
    @organizations = Organization.all
    @users = User.most_active_for_last_day
  end

  def show
    @commits = @organization.commits.desc.includes(:user)
    @repos = @organization.repos
  end

  def new
    @organization = Organization.new
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to @organization, notice: t('notices.successfully_created', model: 'Organization')
    else
      render :new
    end
  end

  def destroy
    @organization.destroy
    redirect_to organizations_url, notice: t('notices.successfully_destroyed', model: 'Organization')
  end

  private
    def set_organization
      @organization = Organization.find(params[:id])
    end

    def organization_params
      params.require(:organization).permit(:name)
    end
end
