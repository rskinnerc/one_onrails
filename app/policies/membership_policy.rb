class MembershipPolicy < ApplicationPolicy
  class Scope < ApplicationPolicy::Scope
    def resolve
      # organization.memberships
      scope.memberships
    end
  end

  def show?
    user.member_of?(record.organization)
  end

  def create?
    user.owner_of?(record.organization)
  end

  def update?
    create?
  end

  def destroy?
    create? && user != record.user
  end
end
