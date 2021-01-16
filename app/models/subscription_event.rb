# == Schema Information
#
# Table name: subscription_events
#
#  id          :integer          not null, primary key
#  personal_id :integer
#  event       :integer
#  created_at  :datetime
#  updated_at  :datetime
#

class SubscriptionEvent  < ActiveRecord::Base

  enum event: { creation: 0, cancelation: 1 }

  belongs_to :personal

end
