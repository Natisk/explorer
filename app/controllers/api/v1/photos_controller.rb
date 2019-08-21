# frozen_string_literal: true
module Api::V1
  class PhotosController < BaseController

    before_action :set_by_tourer_photo_id, only: %i[show update destroy]
    before_action :check_tour

    # GET /api/v1/tours/:tour_local_id/photos
    def index
      render json: {photos: @tour.photos}, status: :ok
    end

    # GET /api/v1/tours/:tour_local_id/photos/:tourer_photo_id
    def show
      photo = @tour.photos.find_by(tourer_photo_id: params[:tourer_photo_id])
      render json: { photo: photo }, status: :ok
    end

    # POST /api/v1/tours/:tour_local_id/photos
    def create
      photo = @tour.photos.build(photo_params)

      if photo.save
        render json: photo, status: :created
      else
        render json: { errors: photo.errors }, status: :unprocessable_entity
      end
      # if photos.all? { |photo| photo.persisted? }
      #   render json: photos, status: :created
      # else
      #   errors = photos.map do |photo|
      #     photo.errors.empty? ? {file_name:  photo.file_name, status: :created} : {file_name: photo.file_name, errors: photo.errors.full_messages}
      #   end
      #   render json: errors, status: :unprocessable_entity
      # end
    end

    # PATCH/PUT /api/v1/tours/:tour_local_id/photos/:tourer_photo_id
    def update
      photo = @tour.photos.find_by(tourer_photo_id: params[:tourer_photo_id])

      if photo.update(photo_params)
        render json: { photo: photo } , status: :ok
      else
        render json: { errors: photo.errors }, status: :unprocessable_entity
      end
      # photos = @tour.update(photo_params)
      # ##TODO check if record updated
      # if photos.all? { |photo| photo.changed? }
      #   render json: photos, status: :ok
      # else
      #   errors = photos.map do |photo|
      #     photo.errors.empty? ? {file_name:  photo.file_name, status: :created} : {file_name: photo.file_name, errors: photo.errors.full_messages}
      #   end
      #   render json: errors, status: :unprocessable_entity
      # end
    end

    # DELETE /api/v1/tours/:tour_local_id/photos/:tourer_photo_id
    def destroy
      @photo.destroy
      render json: {message: 'Photo was deleted.'},  head: :no_content, status: :ok
    end

    private

      def set_by_tourer_photo_id
        @photo = Photo.find_by(tourer_photo_id: params[:tourer_photo_id])
      end

      def photo_params
        params.require(:photo).permit(permitted_photo_params)
      end

      def set_tour
        @tour = Tour.find_by(local_id: params[:tour_local_id])
      end

      def permitted_photo_params
        [:file_name,
         :taken_date_time,
         :latitude,
         :longitude,
         :country_code,
         :elevation_meters,
         :heading,
         :street_view_thumbnail_url,
         :street_view_url,
         :connection,
         :connection_distance_km,
         :tourer_photo_id,
         :tourer_version]
      end

      def check_tour
        set_tour

        unless api_user.tours.include?(@tour)
          render json: {errors: {authorization: 'You cannot perform this action.'}}
        end
      end
  end

end
