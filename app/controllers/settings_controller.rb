class SettingsController < ApplicationController
  before_action :set_setting, only: %i[ show edit update ]

  # GET /account/settings
  def show
    if @setting.nil?
      redirect_to edit_settings_path, alert: "Please set up your settings."
    end
  end

  # GET /account/settings/edit
  def edit
    @setting ||= current_user.build_setting
  end

  # PATCH/PUT /account/settings
  def update
    @setting ||= current_user.build_setting
    if @setting.update(setting_params)
      respond_to do |format|
        format.html { redirect_to settings_path, notice: "Settings were successfully updated." }
        format.json { head :ok }
      end
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

    def set_setting
      @setting = current_user.setting
    end

    def setting_params
      params.expect(setting: [ :theme ])
    end
end
