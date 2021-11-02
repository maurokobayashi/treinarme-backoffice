module MoipHelper

  DATE_TIME='%d/%m/%Y %H:%M:%S'
  TIME='%H:%M:%S'

  MOIP_V2_DATE='%Y-%m-%d'
  MOIP_V2_TIME='%Y-%m-%dT%H:%M:%S'

  def str_to_date(time, format=DATE_TIME)
    unless time.blank?
      Time.strptime(time, format)
    else
      nil
    end
  end

  def date_to_str(time, format=DATE_TIME)
    I18n.l(time, format: format).downcase unless time.blank?
  end

  def date_from_moip_v2(date, format=MOIP_V2_TIME)
    datetime = Time.strptime(date, format)
    self.date_to_str(datetime, DATE_TIME)
  end

  def date_from_moip_assinaturas(moip_date, format=DATE_TIME)
    datetime = DateTime.new(moip_date[:year], moip_date[:month], moip_date[:day], moip_date[:hour] || 0, moip_date[:minute] || 0, moip_date[:second] || 0, '-03:00')
    self.date_to_str(datetime, format)
  end

  def from_cents(amount)
    number_to_currency(amount/100.00, unit: "", separator: ",", delimiter: ".")
  end

  def classificar_cancelamento(codigo)
    case codigo
    when "1"
      "Dados incorretos"
    when "3"
      "Política do banco emissor"
    when "5"
      "Sem limite no cartão"
    when "7"
      "Política da Wirecard"
    when "12"
      "Política do banco emissor"
    else
      "Desconhecido"
    end
  end

end