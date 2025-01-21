class OrganizationsController < ApplicationController
  before_action :set_organization, only: %i[ show edit update destroy ]

  # GET /organizations
  def index
    @organizations = current_user.organizations
  end

  # GET /organizations/1
  def show
  end

  # GET /organizations/new
  def new
    @organization = Organization.new
  end

  # GET /organizations/1/edit
  def edit
    unless policy(@organization).update?
      redirect_to organization_path(@organization), alert: "You are not authorized to perform this action."
    end
  end

  # POST /organizations
  def create
    @organization = Organization.new(organization_params)

    unless policy(@organization).create?
      return redirect_to organizations_path, alert: "You have reached the organization limit."
    end

    begin
      Organization.transaction do
        @organization.save!
        current_user.memberships.create!(organization: @organization, role: "owner")
        redirect_to @organization, notice: "Organization was successfully created.", status: :see_other
      end
    rescue ActiveRecord::RecordInvalid
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organizations/1
  def update
    unless policy(@organization).update?
      return redirect_to organization_path(@organization), alert: "You are not authorized to perform this action."
    end

    if @organization.update(organization_params)
      redirect_to @organization, notice: "Organization was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /organizations/1
  def destroy
    unless policy(@organization).destroy?
      return redirect_to organization_path(@organization), alert: "You are not authorized to perform this action."
    end

    @organization.destroy!
    redirect_to organizations_path, notice: "Organization was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization
      @organization = current_user.organizations.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def organization_params
      params.fetch(:organization, {}).permit(:name)
    end
end
