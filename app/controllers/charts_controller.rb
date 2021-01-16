class ChartsController < ApplicationController

  def bairros_mais_buscados
    result_buscados = []
    locations = Lead.where("DATE(created_at) >= ?", Date.today-(params[:dias].try(:to_i) || 180)).group("location").distinct.count(:phone)
    sorted_array = locations.sort_by{|_key, value| -value}.to_a

    bairros_processados = []
    qtd_total = 0
    sorted_array.each{ |item|
      bairro = item[0].split(",")[0].try(:strip).try(:downcase) || ""
      bairro = ActiveSupport::Inflector.transliterate(bairro)
      qtd = item[1]
      if bairros_processados.include? bairro
        bairro_to_update = result_buscados.find { |el| el[0] == bairro }
        bairro_to_update[1] = bairro_to_update[1]+qtd
      else
        result_buscados.push [bairro, qtd]
        bairros_processados.push bairro
      end
      qtd_total+=qtd
    }
    result_buscados = result_buscados.sort_by{|el| el[1]}.reverse.first(params[:limit].try(:to_i) || 20)


    result_fechados = []
    locations_fechados = Lead.won.where("DATE(created_at) >= ?", Date.today-(params[:dias].try(:to_i) || 180)).group("location").count
    sorted_array_fechados = locations_fechados.sort_by{|_key, value| -value}.to_a

    bairros_processados = []
    qtd_total = 0
    sorted_array_fechados.each{ |item|
      bairro = item[0].split(",")[0].try(:strip).try(:downcase) || ""
      bairro = ActiveSupport::Inflector.transliterate(bairro)
      qtd = item[1]
      if bairros_processados.include? bairro
        bairro_to_update = result_fechados.find { |el| el[0] == bairro }
        bairro_to_update[1] = bairro_to_update[1]+qtd
      else
        result_fechados.push [bairro, qtd]
        bairros_processados.push bairro
      end
      qtd_total+=qtd
    }


    result_fechados_join_buscados = []
    # montar array de leads fechados por bairro
    result_buscados.each do |buscado|
      bairro_buscado = buscado[0]
      bairro_fechado = result_fechados.find { |el| el[0] == bairro_buscado }
      result_fechados_join_buscados.push bairro_fechado
    end

    render json: [{name: "buscados", data: result_buscados}, {name: "fechados", data: result_fechados_join_buscados}]
  end

  def bairros_mais_concorridos
    locations = Location.joins(:personal).where("personals.status in (0,1)").group("locations.name").count;

    sorted_hash = locations.sort_by {|_key, value| -value};
    sorted_array = sorted_hash.to_a;

    result = []
    bairros_processados = []
    qtd_total = 0
    sorted_array.each{ |item|
      bairro = item[0].split(",")[0].try(:strip).try(:downcase) || ""
      bairro = ActiveSupport::Inflector.transliterate(bairro)
      qtd = item[1]
      if bairros_processados.include? bairro
        bairro_to_update = result.find { |el| el[0] == bairro }
        bairro_to_update[1] = bairro_to_update[1]+qtd
      else
        result.push [bairro, qtd]
        bairros_processados.push bairro
      end
      qtd_total+=qtd
    }
    result = result.sort_by{|el| el[1]}.reverse
    render json: result.first(params[:limit].try(:to_i) || 20)
  end

  def leads_per_day
    render json: Lead.where('DATE(created_at) >= ?', 15.days.ago).group_by_day(:created_at).distinct.count(:phone)
  end

  def leads_per_week
    render json: Lead.where('DATE(created_at) >= ?', 90.days.ago).group_by_week(:created_at).distinct.count(:phone)
  end

  def leads_by_substatus
    render json: Lead.where('DATE(created_at) >= ? AND substatus IN (2,6)', 1.year.ago).group(:substatus).group_by_month(:created_at, format: "%b-%Y").distinct.count(:phone).chart_json
  end

  def cancelamentos_per_month
    render json: SubscriptionEvent.cancelation.where('DATE(created_at) >= ?', 12.months.ago).group_by_month(:created_at, format: "%b-%Y").distinct.count(:personal_id)
  end

  def faturamento_por_dia
    api = moip_v2_api
    pedidos = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.at_beginning_of_month.to_s, Date.today.to_s] } }, limit: 1500)
    faturamento = []
    pedidos[:orders].each do |pedido|
      valor = pedido[:amount][:total].to_i/100
      data = Date.strptime(pedido[:created_at], "%Y-%m-%dT%H:%M:%S")
      faturamento.push [data.day.to_s, valor]
    end
    faturamento = faturamento.group_by(&:first).map{ |x, y| [x, y.inject(0){ |sum, i| sum + i.last }] }
    soma = 0
    faturamento = faturamento.reverse.map do |a, b|
      soma = soma + b
      [a, soma]
    end

    pedidos_mes_passado = api.order.find_all(filters: { status: { in: ["PAID"] }, createdAt: { bt: [Date.today.last_month.at_beginning_of_month.to_s, Date.today.last_month.to_s] } }, limit: 1500)
    faturamento_mes_passado = []
    pedidos_mes_passado[:orders].each do |pedido|
      valor = pedido[:amount][:total].to_i/100
      data = Date.strptime(pedido[:created_at], "%Y-%m-%dT%H:%M:%S")
      faturamento_mes_passado.push [data.day.to_s, valor]
    end
    faturamento_mes_passado = faturamento_mes_passado.group_by(&:first).map{ |x, y| [x, y.inject(0){ |sum, i| sum + i.last }] }
    soma = 0
    faturamento_mes_passado = faturamento_mes_passado.reverse.map do |a, b|
      soma = soma + b
      [a, soma]
    end

    render json: [{name: Date.today.strftime("%B"), data: faturamento}, {name: Date.today.last_month.strftime("%B"), data: faturamento_mes_passado}]
  end


end