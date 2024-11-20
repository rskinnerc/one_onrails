class AddressesController < ApplicationController
  before_action :set_address, only: %i[ show edit update destroy ]

  def index
    @addresses = current_user.addresses.all
  end

  def show
  end

  def new
    @address = Address.new
  end

  def edit
  end

  def create
    if address_params[:default] == "1"
      current_user.addresses.update_all(default: false)
    end

    @address = current_user.addresses.build(address_params)

    if @address.save
      redirect_to @address, notice: "Address was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if address_params[:default] == "1"
      current_user.addresses.update_all(default: false)
    end

    if @address.update(address_params)
      redirect_to @address, notice: "Address was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy!
    redirect_to addresses_path, notice: "Address was successfully destroyed.", status: :see_other
  end

  private
    def set_address
      @address = current_user.addresses.find(params.expect(:id))
    end

    def address_params
      params.expect(address: [ :address_line_1, :address_line_2, :city, :country, :state, :postal_code, :default ])
    end
end
