# config/initializers/pusher.rb
require 'pusher'

Pusher.app_id = '882756'
Pusher.key = 'ecd2d8017953832e4ceb'
Pusher.secret = '3c1a0e34a497bff537e0'
Pusher.cluster = 'us2'
Pusher.logger = Rails.logger
Pusher.encrypted = true
