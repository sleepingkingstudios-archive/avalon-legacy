class ArticlesController < ApplicationController
  def index
  end

  # GET /articles/new
  def new
    @article = Article.new
    @categories = Category.all
  end

  def create
    @article = Article.new(params[:article])
    
    if @article.save
      redirect_to @article
    else
      render :action => "new"
    end # if-else
  end # method create

  def show
    path = params[:id]
    path_tokens = path.split "/"
    @article = Article.find(params[:id])
  end

  def edit
  end

  def update
  end

  def destroy
  end
end # controller ArticlesController
