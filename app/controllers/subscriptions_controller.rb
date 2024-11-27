class SubscriptionsController < ApplicationController
  before_action :set_subscription, only: %i[ show ]

  def show
  end

  private
    def set_subscription
      @subscription = current_user.subscription
    end

    def subscription_params
      params.fetch(:subscription, {})
    end
end
