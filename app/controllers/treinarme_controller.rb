class TreinarmeController < ApplicationController

  # GET @ /leads?q=?&status=?
  def leads
    leads_hoje = Lead.where('DATE(created_at) = ?', Date.today).count
    leads_hoje_unicos = Lead.where('DATE(created_at) = ?', Date.today).distinct.count(:phone)
    @totais = {hoje: leads_hoje, hoje_unicos: leads_hoje_unicos}
    @leads = Lead.where(lead_source: true).limit(20).order(id: :desc)
  end

  # GET @ /leads/:id
  def lead
    @lead = Lead.find params[:id]
  end

  # GET @ /personals?q=?&status=?
  def personals

  end

  # GET @ /cancelamentos
  def cancelamentos
    @totais = {mes: SubscriptionEvent.cancelation.where('DATE(created_at) >= ?', Date.today.at_beginning_of_month).count}
    @cancelamentos = SubscriptionEvent.cancelation.where('DATE(created_at) >= ?', 40.days.ago).reverse
  end

  # GET @ /cancelamentos/:id
  def cancelamento
    @cancelamento = SubscriptionEvent.find params[:id]
    @personal = @cancelamento.personal

    # obtendo a data de inativação da assinatura
    @assinatura = Subscription.active.where("personal_id = ?", @personal.id).last
    if @assinatura.present?
      @moip_subscription = Moip::Assinaturas::Subscription.details(@assinatura.code)
      expiracao = Date.new(@cancelamento.created_at.year, @cancelamento.created_at.month, @moip_subscription[:subscription][:creation_date][:day])
      @expiracao = (expiracao < @cancelamento.created_at) ? expiracao+1.month : expiracao
    end

  end

end