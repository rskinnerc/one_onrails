class OrganizationPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      user.organizations
    end
  end

  def show?
    user.member_of?(record)
  end

  def new?
    create?
  end

  def create?
    user.has_active_subscription? && user.subscription.plan.organizations_limit > user.organizations.count
  end

  def edit?
    update?
  end

  def update?
    user.owner_of?(record)
  end

  def destroy?
    update?
  end
end
