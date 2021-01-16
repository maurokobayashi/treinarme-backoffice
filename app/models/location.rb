# == Schema Information
#
# Table name: locations
#
#  id          :integer          not null, primary key
#  name        :string(255)      not null
#  lng         :float            not null
#  lat         :float            not null
#  personal_id :integer          not null
#

class Location < ActiveRecord::Base

  belongs_to :personal
  geocoded_by :name, :latitude  => :lat, :longitude => :lng

end
