class DashboardController < ApplicationController

  # ROOT
  def index
    @saldo = moip_v2_api.balances.show
    @leads_count = Lead.where('DATE(created_at) = ?', Date.today).count
    @leads_unicos_count = Lead.where('DATE(created_at) = ?', Date.today).distinct.count(:phone)
    @leads_fechados = Lead.won.where('DATE(updated_at) = ?', Date.today).count
    @assinaturas = Subscription.active.where('DATE(created_at) = ?', Date.today).count
    @cancelamentos_count = SubscriptionEvent.cancelation.where('DATE(created_at) = ?', Date.today).distinct.count(:personal_id)
  end

  # GET @ /faturamento
  def faturamento
    api = moip_v2_api

    dia_hoje = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.to_s, Date.today.to_s] } }, limit: 1, offset: 0)
    @dia_hoje = dia_hoje[:summary]

    dia_mes_passado = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.last_month.to_s, Date.today.last_month.to_s] } }, limit: 1, offset: 0)
    @dia_mes_passado = dia_mes_passado[:summary]

    acumulado_mes_corrente = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.at_beginning_of_month.to_s, Date.today.to_s] } }, limit: 1, offset: 0)
    @acumulado_mes_corrente = acumulado_mes_corrente[:summary]

    acumulado_mes_passado = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.last_month.at_beginning_of_month.to_s, Date.today.last_month.to_s] } }, limit: 1, offset: 0)
    @acumulado_mes_passado = acumulado_mes_passado[:summary]
  end

  # GET @ /operacao
  def operacao
  end

  # GET @ /relatorios
  def relatorios
  end

  # GET @ /bairros
  def bairros
  end

  # GET @ /sair
  def sair
    cookies.delete :backoffice_singed_in
    redirect_to "https://www.treinar.me"
  end

end