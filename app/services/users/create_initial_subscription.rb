class Users::CreateInitialSubscription
  include Callable

  def initialize(user:)
    @user = user
  end

  def call
    unless subscription_at_sign_up_enabled?
      return result(success: false, errors: [ "Subscription at sign up is not enabled" ])
    end

    return result(success: false, errors: [ "User is required" ]) unless user

    subscription_at_sign_up!
  end

  private

  attr_reader :user

  def subscription_at_sign_up!
    user.create_subscription!(plan: plan, status: :active, start_date: Time.zone.now)

    result(success: true, object: user)
  end

  def plan
    Plan.initial_subscription
  end

  def subscription_at_sign_up_enabled?
    Flipper.enabled?(:subscription_at_sign_up)
  end
end
