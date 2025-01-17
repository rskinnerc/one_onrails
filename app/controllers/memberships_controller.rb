class MembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_membership, only: %i[ edit update destroy ]

  # GET /memberships
  def index
    unless policy(@organization).list_memberships?
      redirect_to organizations_path, alert: "You are not authorized to perform this action."
      return
    end

    @memberships = policy_scope(@organization, policy_scope_class: MembershipPolicy::Scope)
  end

  # GET /memberships/new
  def new
    unless policy(@organization).add_membership?
      redirect_to organization_memberships_path(@organization), alert: "You are not authorized to perform this action."
    end

    @membership = Membership.new
  end

  # GET /memberships/1/edit
  def edit
    unless policy(@organization).add_membership?
      redirect_to organization_memberships_path(@organization), alert: "You are not authorized to perform this action."
    end
  end

  # POST /memberships
  def create
    @membership = Membership.new(membership_params)

    if @membership.save
      redirect_to @membership, notice: "Membership was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /memberships/1
  def update
    if @membership.update(membership_params)
      redirect_to @membership, notice: "Membership was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /memberships/1
  def destroy
    @membership.destroy!
    redirect_to memberships_path, notice: "Membership was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = policy_scope(@organization, policy_scope_class: MembershipPolicy::Scope).find(params[:id])
    end

    def set_organization
      @organization = policy_scope(Organization).find(params[:organization_id])
    end

    # Only allow a list of trusted parameters through.
    def membership_params
      params.fetch(:membership, {})
    end
end
