class StoriesController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create]

  def index
    @stories = params[:q] ? Story.search_for(params[:q]) : Story.all
  end

  def show
    @story = Story.find params[:id]
  end

  def new
    @story = Story.new
  end

  def create
    safe_story_params = params.require(:story).permit(:title, :link, :category)
    @story = Story.new safe_story_params.merge(:upvotes => 1)
    @story.user = current_user
    if @story.save
      redirect_to @story
    else
      render :new
    end
  end

  def edit
    @story = Story.find( params[:id] )
  end

  def update
    @story = Story.find( params[:id] )
    safe_story_params = params.require(:story).permit(:title, :link, :category)
    if @story.update(safe_story_params)
      redirect_to root_path
    else
      render :edit
    end
  end

  def destroy
    story = Story.find(params[:id])
    story.destroy
    redirect_to root_path
  end
end
