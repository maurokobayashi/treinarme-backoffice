# == Schema Information
#
# Table name: subscriptions
#
#  id          :integer          not null, primary key
#  code        :string(255)      not null
#  status      :integer          default(0), not null
#  amount      :integer          default(0), not null
#  personal_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#  plan_id     :integer          not null
#

class Subscription < ActiveRecord::Base

  belongs_to :personal
  # belongs_to :plan
  # has_many :invoices, dependent: :destroy

  enum status: { created:0, active:1, suspended:2, expired:3, overdue:4, canceled:5, trial:6 }

end
