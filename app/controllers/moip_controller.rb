class MoipController < ApplicationController

  # GET @ /pedidos?q=?&status=?
  def pedidos
    filters = {}
    filters[:status] = { in: [params[:status]] } if params[:status].present?
    filters[:createdAt] = params[:created_at] if params[:created_at].present?

    api = moip_v2_api
    response = api.order.find_all(q: params[:q], filters: filters, limit: params[:limit] || 20)
    @totais = response[:summary]
    @pedidos = response[:orders]
  end

  # GET @ /pedidos/:id
  def pedido
    api = moip_v2_api
    @pedido = api.order.show(params[:id])
    @pagamento = api.payment.show(@pedido[:payments].first[:id])
  end

  # GET @ /retentativas?q=?
  def retentativas
    api = moip_v2_api
    response = api.order.find_all(q: params[:q], filters: {status: {in: ["NOT_PAID"]}}, limit: 30)
    @pedidos = response[:orders]
  end

end