# == Schema Information
#
# Table name: personals
#
#  id                                    :integer          not null, primary key
#  name                                  :string(255)      not null
#  username                              :string(255)      not null
#  facebook_id                           :string(255)      not null
#  gender                                :integer          not null
#  phone                                 :string(255)      not null
#  email                                 :string(255)      not null
#  status                                :integer          not null
#  price_min                             :integer
#  cref                                  :string(255)
#  price_negotiable                      :boolean          default(FALSE), not null
#  offers_trial                          :boolean          default(FALSE), not null
#  profile_image_url                     :string(255)
#  resume                                :text             default([]), is an Array
#  speciality_ids                        :integer          default([]), is an Array
#  user_id                               :integer
#  price_max                             :integer
#  plan                                  :integer
#  search_result_count                   :integer
#  profile_view_count                    :integer
#  created_at                            :datetime
#  updated_at                            :datetime
#  lead_control_manual_priority_since    :date
#  lead_control_lifecycle_priority_since :date
#  send_sms                              :boolean          default(TRUE)
#

class Personal < ActiveRecord::Base

  enum status: { trial: 0, active: 1, inactive: 2, removed: 3 }
  enum plan: { professional_55: 0, professional_75: 1, professional_85: 2, professional_test_trainer: 3, professional_100: 4 }
  enum gender: { male: 0, female: 1 }

  # belongs_to :user
  # has_many :locations, dependent: :destroy
  # has_one :availability, class_name: 'Schedule', dependent: :destroy
  has_many :leads, dependent: :destroy
  # has_many :statistics, dependent: :destroy
  # has_many :channels, dependent: :destroy
  # has_many :subscriptions, dependent: :destroy
  has_many :subscription_events, dependent: :destroy
  # has_one :discount, dependent: :destroy
  # has_one :lifecycle, dependent: :destroy

  scope :trial, -> { where(status: Personal.statuses[:trial]) }
  scope :active, -> { where(status: Personal.statuses[:active]) }
  scope :inactive, -> { where(status: Personal.statuses[:inactive]) }
  scope :removed, -> { where(status: Personal.statuses[:removed]) }

end
