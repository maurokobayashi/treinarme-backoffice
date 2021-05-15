class TreinarmeController < ApplicationController

  # GET @ /leads?q=?&status=?&limit=?
  def leads
    @totais_hoje = { unicos: Lead.where(created_at: Date.today.all_day).distinct.count(:phone), totais: Lead.where(created_at: Date.today.all_day).count }
    query = Lead.where(lead_source: true)
    query = query.where(status: params[:status]) if params[:status].present?
    query = query.where("name ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    @leads = query.limit(params[:limit] || 30).order(id: :desc)
  end

  # GET @ /leads/fechados
  def leads_fechados
    @total_hoje = Lead.won.where(created_at: Date.today.all_day).count
    @leads = Lead.won.limit(params[:limit] || 30).order(updated_at: :desc)
  end

  # GET @ /leads/:id
  def lead
    @lead = Lead.find params[:id]
  end

  # GET @ /personals?q=?&status=?
  def personals
    @totais = { ativos: Personal.active.count, total: Personal.not_removed.count }
    query = Personal.all
    query = query.where(status: params[:status]) if params[:status].present?
    query = query.where("name ILIKE ?", "%#{params[:q]}%") if params[:q].present?
    @personals = query.limit(params[:limit] || 50).order(id: :desc)
  end

  # GET @ /cancelamentos
  def cancelamentos
    @totais = {mes: SubscriptionEvent.cancelation.where('DATE(created_at) >= ?', Date.today.at_beginning_of_month).distinct.count(:personal_id)}
    @cancelamentos = SubscriptionEvent.cancelation.last(30).reverse
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