require "discordrb"

module Util
  class ImageHandler
    attr_accessor :location

    def initialize(location)
      @location = location
    end

    def create_embed_image
      Discordrb::Webhooks::EmbedImage.new(url: @location)
    end
  end
end
