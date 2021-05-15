# == Schema Information
#
# Table name: reviews
#
#  id               :integer          not null, primary key
#  lead_id          :integer          not null
#  review_invite_id :integer          not null
#  question1        :text
#  rate             :integer          not null
#  recommends       :boolean          default(TRUE)
#  status           :integer          not null
#  created_at       :datetime
#  updated_at       :datetime
#  question2        :text
#  question3        :text
#  notified         :boolean          default(FALSE)
#
class Review < ActiveRecord::Base

  belongs_to :lead
  belongs_to :review_invite

  enum status: { created: 0, approved: 1, denied: 2, reported: 3, removed: 4 }

end
