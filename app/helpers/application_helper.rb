module ApplicationHelper
  def full_title page_title = ""
    base_title = "Ruby on Rail Toturial Demo App"
    page_title.empty? ? base_title : "#{page_title} | #{base_title}"
  end

  def current_user?
    current_user == @user
  end

  def correct_user
    unless current_user?
      flash[:danger] = "Ban khong duoc truy cap trang nay"
      redirect_to root_path
    end
  end
end
