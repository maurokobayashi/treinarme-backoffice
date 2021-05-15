# == Schema Information
#
# Table name: review_invites
#
#  id         :integer          not null, primary key
#  lead_id    :integer          not null
#  uuid       :string(255)      not null
#  status     :integer          default("created"), not null
#  created_at :datetime
#  updated_at :datetime
#
class ReviewInvite < ActiveRecord::Base

  TEMPO_DE_ESPERA = 30

  belongs_to :lead

  has_one :review, dependent: :destroy
  before_validation :generate_uuid, on: [:create]
  validates :lead, :uuid, presence: true

  enum status: { created: 0, sent: 1, opened: 2, used: 3, reported: 4 }

  private
    def generate_uuid
      self.uuid = SecureRandom.hex(6)
    end

end
