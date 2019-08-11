module ApplicationHelper
  def full_title page_title = ""
    base_title = "Ruby on Rails Tutorial Sample App"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end

  def correct_user
    if @user.is_user?(current_user)
      flash[:danger] = "You dont have authority to access this page"
      redirect_to root_url
    end
  end
end
