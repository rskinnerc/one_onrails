class AccountController < ApplicationController
  before_action :set_overview_data, only: [ :index ]

  def index
  end

  private

  def set_overview_data
    @profile = current_user.profile
    @subscription = current_user.subscription
    @addresses = current_user.addresses.take(2)
  end
end
