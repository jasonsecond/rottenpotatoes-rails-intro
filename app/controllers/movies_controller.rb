class MoviesController < ApplicationController
  
  def movie_params
    params.require(:movie).permit(:title, :rating, :description, :release_date)
    session[:fliter] = nil
    session[:order] = nil
  end

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end
  
  helper_method :bg_color_class
  def bg_color_class(str)
    if params[:order] == str
      'hilite'
    end
  end
  helper_method :rating_help
  def rating_help(rating)
    if params["ratings"] == nil
      if !params[:submitted] #just entered page
        true
      else ################################################use intentionally unchecked everything
        false
      end
    else# something was checked
      params["ratings"].has_key?(rating)
    end 
  end

  def index
    #setting up variables
    @all_ratings = Movie.get_raitings
    if params.key?(:order)
      session[:order] = params[:order]
    elsif session.key?(:order)
      params[:order] = session[:order]
      redirect_to movies_path(params) and return
    end
    
    # @slected_ratings = params.key?("ratings") ? params["ratings"].keys : @all_ratings
    
    if params.key?("ratings")
      session[:filter] = params["ratings"]
      @slected_ratings = params["ratings"].keys
    else
      if params[:utf8]
        @selected_ratings = []
      elsif session.key?(:filter)
        params["ratings"] = session[:filter]
        redirect_to movies_path(params) and return
      else
        @selected_ratings = @all_ratings
      end
    end
    
    
    @movies = Movie.order(params[:order]).where(:rating => @slected_ratings)
      
    #rails s -p $PORT -b $IP
  end

  def new
    # default: render 'new' template
    session[:fliter] = nil
    session[:order] = nil
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
    # session[:fliter] = nil
    # session[:order] = nil
  end
end
