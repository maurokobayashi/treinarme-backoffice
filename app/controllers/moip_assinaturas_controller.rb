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
    get_response = Moip::Assinaturas::Subscription.details(params[:id])
    if get_response[:success]
      @assinatura = get_response[:subscription]
    end
  end

  # GET @ /assinaturas/:id/faturas
  def faturas
    @faturas = Moip::Assinaturas::Invoice.list(params[:id])
  end

  # GET @ /faturas/:id
  def fatura
    @fatura = Moip::Assinaturas::Invoice.details(params[:id])
  end

end