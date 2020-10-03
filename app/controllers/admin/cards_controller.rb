# frozen_string_literal: true

class Admin::CardsController < ApplicationController
  before_action :check_admin_authorization!

  def index; end
end
