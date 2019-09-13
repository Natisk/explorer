# frozen_string_literal: true
class PhotoSerializer < ActiveModel::Serializer

  attributes %i[
                 file_name
                 taken_date_time
                 latitude
                 longitude
                 elevation_meters
                 country
                 heading
                 street_view_url
                 street_view_thumbnail_url
                 connection
                 connection_distance_km
                 tourer_photo_id
               ]

  def country
    object.country.present? ? object.country.name : ''
  end

end
