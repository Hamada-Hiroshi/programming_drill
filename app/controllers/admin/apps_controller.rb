class Admin::AppsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @apps = App.all
  end

  def cancel
  end
end
