class LanguagesController < ApplicationController
  before_action :set_method

  def set_method
    @languages = Language.all
    @language = Language.find(params[:id])
    @apps = @language.apps.where(status: true)
    @apps.each do |app|
      app.score = app.average_rate
    end
  end

  def show
    @apps = @apps.page(params[:page]).reverse_order
  end

  def rate_show
    @apps = @apps.sort_by { |app| app.score.to_i }.reverse
    @apps = Kaminari.paginate_array(@apps).page(params[:page])
  end

end
