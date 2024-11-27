class CreateSubscriptionAtSignUpFlag < ActiveRecord::Migration[8.0]
  def up
    Flipper.disable(:subscription_at_sign_up)
    Rails.logger.info "Subscription at sign up flag created"
  end

  def down
    Flipper.remove(:subscription_at_sign_up)
    Rails.logger.info "ROLLED BACK - Subscription at sign up flag removed"
  end
end
