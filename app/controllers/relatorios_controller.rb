class RelatoriosController < ApplicationController

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

  def horarios
    qtd_dias = params[:dias] ? params[:dias].to_i : 180
    result_leads = []

    uniq_leads = Lead.where('DATE(created_at) >= ? AND array_length(requested_time, 1) > 0', qtd_dias.days.ago).to_a.uniq{|a|a.phone}
    uniq_leads.each do |lead|
      lead.requested_time.each do |i|
        horarios = i.split(",")
        horarios.each{|h| result_leads.push h.strip}
      end
    end

    result_deals = []
    uniq_deals = Lead.won.where('DATE(created_at) >= ? AND array_length(requested_time, 1) > 0', qtd_dias.days.ago)
    uniq_deals.each do |lead|
      lead.requested_time.each do |i|
        horarios = i.split(",")
        horarios.each{|h| result_deals.push h.strip}
      end
    end

    leads_array = result_leads.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }.to_a
    deals_array = result_deals.each_with_object(Hash.new(0)) { |word,counts| counts[word] += 1 }.to_a

    #sorting
    leads_array = leads_array.each{|h| h[0] = h[0].gsub("h", "").to_i}.sort.each{|h| h[0] = h[0].to_s+"h"}
    deals_array = deals_array.each{|h| h[0] = h[0].gsub("h", "").to_i}.sort.each{|h| h[0] = h[0].to_s+"h"}

    final_array = []
    leads_array.each do |l|
      item = deals_array.select{|d| d[0] == l[0]}.first || []
      final_array.push [l[0], l[1], item[1] || 0]
    end
    @resultados = final_array
  end

  def leads
  end

  def palavras
    limit = params[:limit] || 50
    qtd_leads = params[:qtd_leads] ? params[:qtd_leads].to_i : 1000
    min_occurrences = 5

    leads = Lead.where(lead_source: true).where.not(comment: [nil, ""]).last(qtd_leads).uniq{|l| l.phone}
    comments = leads.map {|l| l.comment}
    joined_comments = comments.join(" ").gsub("\n", " ").gsub("\r", " ")
    downcase_comments = ActiveSupport::Inflector.transliterate joined_comments.downcase
    word_cloud = downcase_comments.gsub(/para|gostaria|estou|tenho|fazer|preciso|quero|tudo|anos|minha|mais|muito|saber|como|nome|voce|voltar|esta|moro|tambem|seria|queria|dias|entao|mesmo|vezes|ficar|pouco|acima|conta|aqui|meus|chamo|pois|isso|porem|ganho|faco|desde|aguardo|desde|duas|sempre|procuro|buscando|alguns|cada|qual|assim|tive|obrigado|obrigada|quanta|muito|devido/, "")
                  .chars.select {|c| c =~ Regexp.union(/[a-z]/, " ")}.join("")

    @word_cloud = word_cloud.split.select{|w| w.length > 3}.group_by{|w| w}.map{|k,v| [k,v.size]}.sort_by(&:last).select{|x,y| y>min_occurrences}.last(limit).reverse.to_h
  end

  def personals
    status = params[:status].present? ? (params[:status] == "active" ? 1 : 2) : nil

    query = Lead.won.joins(:personal)
    query = query.where("personals.status = ?", status) if status.present?
    query = query.group("leads.personal_id").order("leads.personal_id")
    hash = query.count
    sorted_array = Hash[hash.sort_by { |k,v| [-1 * v, -1 * k] }].to_a.first(50)

    sorted_array.each do |i|
      p = Personal.find i[0]
      i[0] = p
    end

    @resultados = sorted_array
  end


private
  def normalize_bairro bairro
    ActiveSupport::Inflector.transliterate(bairro.split(",")[0].try(:strip).try(:downcase) || "")
  end


end