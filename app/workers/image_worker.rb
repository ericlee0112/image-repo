class ImageWorker
  include Sidekiq::Worker

  #Sidekiq will continuosly retry methods that fail. 
  #There are cases when this wouldn’t be ideal, such as whenever credit cards are involved. 
  #If so, you can turn it off 
  sidekiq_options retry: false
  def perform(images, title)
    images.each do |image|
      post = Post.new({:title => title, :images => image})
      post.save
    end
  end
end

class ImageRemoveWorker
  include Sidekiq::Worker
  sidekiq_options retry: false
  def perform
    Post.destroy_all
  end
end