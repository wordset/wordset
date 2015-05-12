class Admin::PostsController < ApplicationController
  layout "admin"
  before_filter :authenticate_admin!

  def index
    @posts = Post.all
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.create(post_params)
    flash[:notice] = "Created"
    redirect_to edit_admin_post_path(@post)
  end

  def publish
    @post = Post.find(params[:id])
    @post.publish!
    flash[:notice] = "Published!"
    redirect_to admin_posts_path
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    edit
    @post.update_attributes(post_params)
    flash[:notice] = "Saved"
    render "edit"
  end

 private
  def post_params
    params.require(:post).permit(:title, :slug, :body, :author_name, :text)
  end
end
