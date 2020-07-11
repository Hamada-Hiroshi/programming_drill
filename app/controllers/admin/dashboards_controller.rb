class Admin::DashboardsController < ApplicationController
  before_action :authenticate_admin!

  def index
    #sum=0
    #@users = User.group_by_day(:created_at).count.to_a.sort{|x,y| x[0] <=> y[0]}.map { |x,y| { x => (sum += y)} }.reduce({}, :merge)
    @users = User.where(status: true)
    @new_user = User.group_by_day(:created_at).count
    @apps = App.where(status: true)
    @app_lang = App.where(status: true).joins(:lang).group(:name).count
    @learnings = Learning.joins(:app).where(:apps => {status: true})
    @learning_lang = Learning.joins({:app => :lang}).group(:name).where(:apps => {status: true}).count
  end
end
