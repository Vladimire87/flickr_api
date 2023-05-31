# frozen_string_literal: true

class PagesController < ApplicationController
  def index
    Flickr.cache = '/tmp/flickr-api.yml'
    begin
      flickr = Flickr.new(ENV['flickr_key'], ENV['flickr_secret'])
      if params[:flickr_user_id].blank?
        flash.now[:notice] = 'Enter ID'
        @photo_ids = [] # Set empty array since there is no search
      else
        photos = flickr.photos.search(user_id: params[:flickr_user_id])
        @photo_ids = photos.map { |photo| flickr.photos.getInfo(photo_id: photo['id'].to_s) }
      end
    rescue StandardError => e
      # Handle the error gracefully
      puts "Error: #{e.message}"
      @photo_ids = [] # Set an empty array in case of error
    end
    console
  end
end
