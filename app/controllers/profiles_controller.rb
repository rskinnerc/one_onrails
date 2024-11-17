class ProfilesController < ApplicationController
  before_action :set_profile, only: %i[ show edit update destroy ]


  # GET /profile
  def show
  end

  # GET /profiles/new
  def new
    @profile = current_user.build_profile
  end

  # GET /profiles/1/edit
  def edit
  end

  # POST /profiles
  def create
    @profile = current_user.build_profile(profile_params)

    if @profile.save
      redirect_to @profile, notice: "Profile was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /profiles/1
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

  # DELETE /profiles/1
  def destroy
    @profile.destroy!
    redirect_to profile_path, notice: "Profile was successfully destroyed.", status: :see_other
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_profile
      @profile = current_user.profile
    end

    # Only allow a list of trusted parameters through.
    def profile_params
      params.expect(profile: [ :first_name, :last_name, :phone, :avatar, :country, :remove_avatar ])
    end
end
