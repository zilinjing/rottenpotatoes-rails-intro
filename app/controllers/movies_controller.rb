class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    @all_ratings = Movie.all_ratings
    # check if form was submitted with ratings
    if params[:ratings].present?
      @ratings_to_show = params[:ratings].keys
    
    # first visit OR when user unchecks everything
    else
      @ratings_to_show = @all_ratings
    end 
    
    # Get the sort column from params
    @sort_by = params[:sort_by]
    # Get the movies to display based on selected ratings
    @movies = Movie.with_ratings(@ratings_to_show)
    if @sort_by.present?
      # .order is an ActiveRecord method that sorts at the database level
      if ['title', 'release_date'].include?(@sort_by)
        # .to_sym converts the string to a symbol 'title' becomes :title
        @movies = @movies.order(@sort_by.to_sym)
      end
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

  private
  # Making "internal" methods private is not required, but is a common practice.
  # This helps make clear which methods respond to requests, and which ones do not.
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
  end
end
