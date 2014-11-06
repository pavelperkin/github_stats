class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :edit, :update, :destroy]

  def index
    @organizations = Organization.all
  end

  def show
    @commits = @organization.commits.desc.includes(:user)
    @repos = @organization.repos.sort_by { |r| r.observed ? 0 : 1 }
  end

  def new
    @organization = Organization.new
  end

  def edit
  end

  def create
    @organization = Organization.new(organization_params)
    if @organization.save
      redirect_to @organization, notice: t('notices.successfully_created', model: 'Organization')
    else
      render :new
    end
  end

  def update
    if @organization.update(organization_params)
      redirect_to @organization, notice: t('notices.successfully_updated', model: 'Organization')
    else
      render :edit
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
