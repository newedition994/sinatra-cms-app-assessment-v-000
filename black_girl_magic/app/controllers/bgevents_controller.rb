class BgEventsController < ApplicationController

  get "/bgevents" do
    redirect_if_not_logged_in
    @bgevents = BgEvent.all
    erb :'bgevents/index'
  end

  get "/bgevents/new" do
    redirect_if_not_logged_in
    @error_message = params[:error]
    @bgevents = User.find(session[:user_id]).bg_events
    erb :'bgevents/new'
  end

  post '/bgevents' do
    if params[:description] == "" || params[:name] == ""
      redirect to "/bgevents/new"
    else
      @bgevent = current_user.bg_events.create(description: params[:description], name: params[:name])
      redirect to "/bgevents/#{@bgevent.id}"
    end
  end

  get '/bgevents/:id' do
    redirect_if_not_logged_in
    @bgevent = BgEvent.find_by_id(params[:id])
    erb :'bgevents/show'
  end

  get '/bgevents/:id/edit' do
    redirect_if_not_logged_in
    @bgevent = BgEvent.find_by_id(params[:id])
    if @bgevent.user_id == current_user.id
      erb :'bgevents/edit'
    else
      redirect to '/bgevents'
    end
  end

  patch '/bgevents/:id' do
    @bgevent =BgEvent.find_by_id(params[:id])
    if @bgevent.user_id != current_user.id
      redirect to '/bgevents'
    elsif params[:description] == ""
      redirect to "/bgevents/#{parmas[:id]}/edit"
    else
      @bgevent.description = params[:description]
      @bgevent.save
      redirect to "/bgevents/#{@bgevent.id}"
    end
  end

  delete '/bgevents/:id/delete' do
    redirect_if_not_logged_in
    @bgevent = BgEvent.find_by_id(params[:id])
    if @bgevent.user_id == current_user.id
      @bgevent.delete
      redirect to '/bgevents'
    else
      redirect to '/bgevents'
    end
  end
end
