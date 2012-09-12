class MainController < ApplicationController
  def index

  end

  def create
    ps=params[:item]
    mail=ps["mail"]
    password=ps["password"]
      pp mail,password
      
      pp "----"
    user=User.new()
    pp user.methods.sort
    user.email=mail
    user.password=password
    user.save
    redirect_to :action=>'index'
  end
end
