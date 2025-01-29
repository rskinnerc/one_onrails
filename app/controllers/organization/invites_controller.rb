class Organization::InvitesController < ApplicationController
  before_action :set_organization
  before_action :set_organization_invite, only: %i[ show edit update destroy ]

  # GET /organization/invites
  def index
    @organization_invites = @organization.invites.where.not(status: :accepted)
  end

  # GET /organization/invites/1
  def show
  end

  # GET /organization/invites/new
  def new
    @organization_invite = Organization::Invite.new
  end

  # GET /organization/invites/1/edit
  def edit
  end

  # POST /organization/invites
  def create
    @organization_invite = Organization::Invite.new(organization_invite_params)

    if @organization_invite.save
      redirect_to @organization_invite, notice: "Invite was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /organization/invites/1
  def update
    if @organization_invite.update(organization_invite_params)
      redirect_to @organization_invite, notice: "Invite was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /organization/invites/1
  def destroy
    @organization_invite.destroy!
    redirect_to organization_invites_path, notice: "Invite was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_organization_invite
      @organization_invite = Organization::Invite.find(params.expect(:id))
    end

    def set_organization
      @organization = current_user.organizations.find(params.expect(:organization_id))
    end

    # Only allow a list of trusted parameters through.
    def organization_invite_params
      params.fetch(:organization_invite, {})
    end
end
