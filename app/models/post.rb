class Post < ApplicationRecord
    has_many_attached :images

    def thumbnail input
        return self.image[input].variant(resize: '300x300!').processed
    end
end
