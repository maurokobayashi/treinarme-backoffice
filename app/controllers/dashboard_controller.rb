class DashboardController < ApplicationController

  # ROOT
  def index
    @saldo = moip_v2_api.balances.show
    @leads_count = Lead.where(created_at: Date.today.all_day).count
    @leads_unicos_count = Lead.where(created_at: Date.today.all_day).distinct.count(:phone)
    @leads_fechados = Lead.won.where(created_at: Date.today.all_day).count
    @assinaturas = Subscription.active.where(created_at: Date.today.all_day).count
    @cancelamentos_count = SubscriptionEvent.cancelation.where(created_at: Date.today.all_day).distinct.count(:personal_id)
  end

  # GET @ /financeiro
  def financeiro
  end

  # GET @ /financeiro/faturamento
  def financeiro_faturamento
    api = moip_v2_api

    dia_hoje = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.to_s, Date.today.to_s] } }, limit: 1, offset: 0)
    @dia_hoje = dia_hoje[:summary]
    # @dia_hoje = {amount: 67500, count: 9}

    dia_mes_passado = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.last_month.to_s, Date.today.last_month.to_s] } }, limit: 1, offset: 0)
    @dia_mes_passado = dia_mes_passado[:summary]
    # @dia_mes_passado = {amount: 60000, count: 8}

    acumulado_mes_corrente = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.at_beginning_of_month.to_s, Date.today.to_s] } }, limit: 1, offset: 0)
    @acumulado_mes_corrente = acumulado_mes_corrente[:summary]
    # @acumulado_mes_corrente = {amount: 2242500, count: 298}

    acumulado_mes_passado = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.last_month.at_beginning_of_month.to_s, Date.today.last_month.to_s] } }, limit: 1, offset: 0)
    @acumulado_mes_passado = acumulado_mes_passado[:summary]
    # @acumulado_mes_passado = {amount: 2388500, count: 318}
  end

  # GET @ /operacao
  def operacao
  end

  # GET @ /relatorios
  def relatorios
    @assinaturas = Subscription.active.where(created_at: Date.today.all_day).count
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