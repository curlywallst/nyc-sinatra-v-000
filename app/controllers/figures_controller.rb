class FiguresController < ApplicationController


  get '/figures' do
    @figures = Figure.all
    erb :'/figures/index'
  end

  get '/figures/new' do
    @landmarks = Landmark.all
    @titles = Title.all
    erb :'/figures/new'
  end

  post '/figures' do

    @figure = Figure.create(:name => params[:figure][:name])

    if params[:title][:name] != ""
      @figure.titles << Title.find_or_create_by(params[:title])
    end
    if !!params[:figure][:title_ids]
      @figure.titles << Title.find_by_id(params[:figure][:title_ids])
    end

    if params[:landmark][:name] != ""
      landmark = Landmark.create(params[:landmark])
      landmark.figure_id = @figure.id
      @figure.landmarks << landmark
    elsif !!params[:figure][:landmark_ids]
      @figure.landmarks  << Landmark.find_by_id(params[:figure][:landmark_ids])
    end
    redirect to :"/figures/#{@figure.id}"
  end

  get '/figures/:id/edit' do
    @figure = Figure.find_by_id(params[:id])
    @titles = Title.all
    @landmarks = Landmark.all
    erb :'/figures/edit'
  end

  patch '/figures/:id' do

    @figure = Figure.find_by_id(params[:id])
    @figure.name = params[:figure][:name]
    if !!params[:figure][:title_ids]
      title = Title.find_by_id(params[:figure][:title_ids])

      @figure.titles << title if !@figure.titles.include?(title)
    end
    if params[:landmark][:name] != ""
      landmark = Landmark.create(params[:landmark])
      landmark.figure_id = @figure.id
      @figure.landmarks << landmark
    elsif !!params[:figure][:landmark_ids]
      @figure.landmarks  << Landmark.find_by_id(params[:figure][:landmark_ids])
    end


    @figure.save
    redirect to :"/figures/#{@figure.id}"
  end

  get '/figures/:id' do
    @figure = Figure.find_by_id(params[:id])
    @landmarks = @figure.landmarks

    erb :'/figures/show'
  end


end
