class LangsController < ApplicationController
  before_action :set_method

  def set_method
    @langs = Lang.all
    @lang = Lang.find(params[:id])
    @apps = @lang.apps.where(status: true)
    @apps.each do |app|
      app.score = app.average_rate
    end
  end

  def show
    @apps = @apps.page(params[:page]).reverse_order
  end

  def rate_show
    @apps = @apps.sort_by { |app| app.score.to_f }.reverse
    @apps = Kaminari.paginate_array(@apps).page(params[:page])
  end

  def popular_show
    @apps = @apps.sort_by { |app| app.learnings.count }.reverse
    @apps = Kaminari.paginate_array(@apps).page(params[:page])
  end
end
