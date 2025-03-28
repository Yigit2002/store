class HomeController < ApplicationController
  def index
    render plain: "Hoşgeldiniz"
  end
end