require 'sidekiq/api'
module PostsHelper
    def wait_for_sidekiq
        sleep(1) until Sidekiq::Workers.new.size == 0 && Sidekiq::Queue.new.size == 0
    end
end
