class SiteController < ApplicationController
  def index
    if session[:start]
      redirect_to :controller => 'words',
        :action => 'answers',
        :id => session[:current_word_id]
    end
  end

  def login
    #TODO
  end

  def logout
    reset_session
  end

  def start
    @user = User.find(session[:user_id])
    @user.start = Time.now
    @user.end_of_session = Time.now + 90.minutes
    @user.save
    session[:user_id] = @user.id
    session[:user_name] = @user.name
    group_id = @user.id.modulo(12) + 1
    session[:word_ids] = Word.where(group_id: group_id).pluck(:id).shuffle
    session[:total_word] = session[:word_ids].size
    word_id = session[:word_ids].shift
    session[:current_word_id] = word_id
    session[:start] = @user.start
    session[:end_of_session] = @user.end_of_session
    redirect_to :controller => 'words', :action => 'answers', :id => word_id
  end

end
