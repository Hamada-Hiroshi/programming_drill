class Admin::AppsController < ApplicationController
  before_action :authenticate_admin!

  def index
  end

  def cancel
  end
end
