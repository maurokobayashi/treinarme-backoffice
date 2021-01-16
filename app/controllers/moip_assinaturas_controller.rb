class MoipAssinaturasController < ApplicationController

  # GET @ /assinaturas
  def assinaturas
    get_response = Moip::Assinaturas::Subscription.list({limit: 10, offset: 0})
    if get_response[:success]
      @assinaturas = get_response[:subscriptions]
    end
  end

  # GET @ /assinaturas/:id
  def assinatura
    @assinatura = Moip::Assinaturas::Subscription.details(:id)
  end

  # GET @ /assinaturas/:id/faturas
  def faturas
    @faturas = Moip::Assinaturas::Invoice.list(:id)
  end

  # GET @ /faturas/:id
  def fatura
    @fatura = Moip::Assinaturas::Invoice.details(:id)
  end

end