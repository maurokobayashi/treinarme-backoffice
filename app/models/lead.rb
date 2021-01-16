# == Schema Information
#
# Table name: leads
#
#  id             :integer          not null, primary key
#  personal_id    :integer          not null
#  name           :string(255)      not null
#  email          :string(255)      not null
#  phone          :string(255)      not null
#  age            :integer
#  comment        :text
#  location       :string(255)
#  rejected       :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  budget         :string(255)
#  pain           :string(255)
#  requested_time :string(255)      default([]), is an Array
#  status         :integer          default(0), not null
#  substatus      :integer          default(0), not null
#  archived       :boolean          default(FALSE)
#  hot            :boolean          default(FALSE)
#  lead_source    :boolean          default(FALSE)
#

class Lead < ActiveRecord::Base

  belongs_to :personal
  # has_many :review_invites, dependent: :destroy
  # has_many :reviews, dependent: :destroy

  enum status: { pending: 0, prospect: 1, lost: 2, won: 3 }
  enum substatus: { novo: 0, aguardando_retorno: 1, aula_teste_agendada: 2, aluno_desistiu: 3, nao_me_interessei: 4, nao_consegui_contato: 5, contrato_fechado: 6 }

end
