class MoviesController < ApplicationController

  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    redirect = false
    @sort = params[:sort] ? params[:sort]: session[:sort]
    @ratings = params[:ratings] ? params[:ratings] : session[:ratings]
    @all_ratings = Movie.pluck(:rating).uniq
    
    if(params[:sort] != @sort) || (params[:ratings] != @ratings)
      redirect = true
    end
    
    if @ratings.nil?
      @ratings = {}
      @all_ratings.each{ |i| @ratings[i] =1}
    end
    
    redirect_to movies_path(sort: @sort, ratings: @ratings) if redirect
    @movies = Movie.order(@sort)
    #@movies = Movie.find(conditions: {rating: @ratings.keys},order: @sort)
    @movies = Movie.order(@sort).where(rating: @ratings.keys)
    
    session[:sort] = @sort
    session[:ratings] = @ratings
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
