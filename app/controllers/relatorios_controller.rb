class RelatoriosController < ApplicationController

  def personals
    hash = Lead.won.group(:personal_id).order(:personal_id).count
    sorted_array = Hash[hash.sort_by { |k,v| [-1 * v, -1 * k] }].to_a.first(30)

    sorted_array.each do |i|
      p = Personal.find i[0]
      i[0] = p
    end

    @resultados = sorted_array
  end

  def bairros
    last_days = params[:dias] || 180
    limit = 50
    resultado = []

    locations_fechados = Lead.won.where("DATE(created_at) >= ?", Date.today-(params[:dias].try(:to_i) || last_days)).group("location").count
    array_fechados = locations_fechados.sort_by{|_key, value| -value}.to_a
    array_fechados.each {|item| item[0] = normalize_bairro(item[0])}

    locations_buscados = Lead.where("DATE(created_at) >= ?", Date.today-(params[:dias].try(:to_i) || last_days)).group("location").distinct.count(:phone)
    array_buscados = locations_buscados.sort_by{|_key, value| -value}.to_a
    array_buscados.each {|item| item[0] = normalize_bairro(item[0])}

    locations_atendidos = Location.joins(:personal).where("personals.status in (0,1)").group("locations.name").count
    array_atendidos = locations_atendidos.sort_by {|_key, value| -value}.to_a
    array_atendidos.each {|item| item[0] = normalize_bairro(item[0])}

    bairros_processados = []
    array_atendidos.each{ |item|
      bairro = item[0]
      qtd_atendidos = item[1]
      bairro_buscado = array_buscados.find{ |el| el[0] == bairro }
      qtd_buscados = bairro_buscado.present? ? bairro_buscado[1] : 0
      bairro_fechado = array_fechados.find{ |el| el[0] == bairro }
      qtd_fechados = bairro_fechado.present? ? bairro_fechado[1] : 0

      if bairros_processados.include? bairro
        bairro_to_update = resultado.find { |el| el[0] == bairro }
        bairro_to_update[1] = bairro_to_update[1]+qtd_buscados
        bairro_to_update[2] = bairro_to_update[2]+qtd_fechados
        # bairro_to_update[3] = bairro_to_update[3]+qtd_atendidos
      else
        resultado.push [bairro, qtd_buscados, qtd_fechados, qtd_atendidos]
        bairros_processados.push bairro
      end
    }

    # sort by ATENDIDOS
    @resultados = resultado.sort_by{|el| el[3]}.reverse.first(params[:limit].try(:to_i) || limit)
  end

  def leads

  end



private
  def normalize_bairro bairro
    ActiveSupport::Inflector.transliterate(bairro.split(",")[0].try(:strip).try(:downcase) || "")
  end


end