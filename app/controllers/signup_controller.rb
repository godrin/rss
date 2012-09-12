class SignupController < ApplicationController
  TmpUser=Struct.new(:email,:password, :password_repeat)
  if false
    def sign_up
      @user=TmpUser.new
    end

    def sign_up_save
      #user=TmpUser.new(*params["user"])
      user=params["user"]
      email,password,password_repeat=user["email"],user["password"],user["password_repeat"]
      if password!=password_repeat
        redirect_to :action=>'passwords_not_equal'
      end
      user=User.find(:first,:conditions=>{:email=>email})
      if user
        redirect_to :action=>'error'
      else
        user=User.new
        user.email=email
        user.password=password
        pp email,password
        user.save
      end
      #  pp user
      redirect_to :controller=>'rss',:action=>'index'

    end
  end
end
