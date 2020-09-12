# frozen_string_literal: true

class ApplicationController < ActionController::Base
  skip_before_action :verify_authenticity_token

  helper_method def admin_authorization?
    Rails.application.secret_key_base == (request.headers['Authorization'] || cookies['Authorization'])
  end

  def check_admin_authorization!
    return if admin_authorization?
    respond_to do |format|
      format.html { redirect_to admin_root_path }
      format.json { head :unauthorized }
    end
  end

  def random_card
    card = Card.order(:used_at).limit(Card.count / 10).sample
    raise ActiveRecord::RecordNotFound, "Couldn't find random Card" if card.nil?
    card.update(used_at: Time.now.utc)
    card
  end
end
