class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]

  def show
  end

  def new
    @profile = current_user.build_profile
  end

  def edit
    unless @profile.present?
      redirect_to profile_path, notice: "Profile not found. Please create a new profile."
    end
  end

  def create
    @profile = current_user.build_profile(profile_params)

    if @profile.save
      redirect_to @profile, notice: "Profile was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if profile_params[:remove_avatar] == "1"
      @profile.avatar.purge
    end

    if @profile.update(profile_params.except(:remove_avatar))
      redirect_to @profile, notice: "Profile was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    unless @profile.present?
      redirect_to profile_path, notice: "Profile not found. Please create a new profile."
      return
    end
    @profile.destroy!
    redirect_to profile_path, notice: "Profile was successfully destroyed.", status: :see_other
  end

  private
    def set_profile
      @profile = current_user.profile
    end

    def profile_params
      params.expect(profile: [ :first_name, :last_name, :phone, :avatar, :country, :remove_avatar ])
    end
end
