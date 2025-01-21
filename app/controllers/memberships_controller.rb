class MembershipsController < ApplicationController
  before_action :set_organization
  before_action :set_membership, only: %i[ edit update destroy ]

  # GET /memberships
  def index
    unless policy(@organization).list_memberships?
      redirect_to organizations_path, alert: "You are not authorized to perform this action."
      return
    end

    @memberships = @organization.memberships
  end

  # GET /memberships/1/edit
  def edit
    unless policy(@organization).add_membership?
      redirect_to organization_memberships_path(@organization), alert: "You are not authorized to perform this action."
    end
  end

  # PATCH/PUT /memberships/1
  def update
    unless policy(@organization).add_membership?
      redirect_to organization_memberships_path(@organization), alert: "You are not authorized to perform this action."
      return
    end

    if @membership.update(membership_params)
      redirect_to organization_memberships_path(@organization), notice: "Membership was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /memberships/1
  def destroy
    unless policy(@membership).destroy?
      redirect_to organization_memberships_path(@organization), alert: "You are not authorized to perform this action."
      return
    end

    @membership.destroy!
    redirect_to organization_memberships_path(@organization), notice: "Membership was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = policy_scope(@organization, policy_scope_class: MembershipPolicy::Scope).find(params[:id])
    end

    def set_organization
      @organization = current_user.organizations.find(params[:organization_id])
    end

    # Only allow a list of trusted parameters through.
    def membership_params
      params.expect(membership: [ :role ])
    end
end
