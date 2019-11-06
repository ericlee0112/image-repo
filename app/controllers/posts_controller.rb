require 'sidekiq/api'
class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  after_action :wait_for_sidekiq, only: [:create]

  def index
    @posts = Post.all.order('created_at DESC')
  end

  def show
  end

  def new
    @post = Post.new
  end

  def edit
  end

  def create
    if post_params[:images].count == 1
      @post = Post.new({:title => post_params[:title], :images => post_params[:images]})
      result = @post.save
    else
      result = ImageWorker.perform_async(post_params[:images], post_params[:title])
      sleep(0.5)
    end
    
    respond_to do |format|
      if result
        format.html { redirect_to '/', notice: 'Post(s) were successfully uploaded.' }
        format.json { render :index, status: :created}
      else
        format.html { render :new, notice: 'Post(s) failed to upload' }
        format.json { render json: result.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, notice: 'Post failed to update' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :body, images: [])
    end

    def wait_for_sidekiq
      sleep(1) until Sidekiq::Workers.new.size == 0 && Sidekiq::Queue.new.size == 0
    end
end
