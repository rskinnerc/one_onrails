class CreateRegistrationsFlag < ActiveRecord::Migration[8.0]
  def up
    Flipper.disable(:registrations)
    Rails.logger.info "Registrations flag created"
  end

  def down
    Flipper.remove(:registrations)
    Rails.logger.info "ROLLED BACK - Registrations flag removed"
  end
end
