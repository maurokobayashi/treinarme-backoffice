module UtilHelper

  def human_time_for(from_time, to_time = Time.now)
    from_time = from_time.to_time if from_time.respond_to?(:to_time)
    to_time = to_time.to_time if to_time.respond_to?(:to_time)
    distance_in_minutes = (((to_time - from_time).abs)/60).round
    distance_in_seconds = ((to_time - from_time).abs).round

    case distance_in_minutes
    when 0..1
      case distance_in_seconds
      when 0..45   then 'agora mesmo'
      else             'há ± 1 minuto'
      end

    when 2..59           then "há #{distance_in_minutes} minutos"
    when 60..89          then 'há ± 1 hora'
    when 90..1439        then "há ± #{(distance_in_minutes.to_f / 60.0).round} horas"
    when 1440..2879      then 'ontem'
    when 2880..43199     then "há #{(distance_in_minutes / 1440).round} dias"
    when 43200..86399    then 'há ± 1 mês'
    when 86400..525959   then "há #{(distance_in_minutes / 43200).round} meses"
    when 525960..1051919 then 'há ± 1 ano'
    else                      "há mais de #{(distance_in_minutes / 525960).round} anos"
    end
  end

  def mask_phone(phone)
    "(#{phone[0,2]}) #{phone[2, (phone.length-6)]}-#{phone[-4,4]}".html_safe
  end

  def unmask_phone(phone)
    phone.gsub!(/[^0-9]/, '')
  end

  def short_location(location)
    (location.split(',').first.split('-').first).split.map(&:capitalize)*' '
  end

  def short_name (name)
    first = name.split(' ').first
    last = name.split(' ').last
    if first != last
      "#{first} #{last}"
    else
      first
    end


  end
end