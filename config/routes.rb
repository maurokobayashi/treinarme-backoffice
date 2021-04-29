Rails.application.routes.draw do
  root 'dashboard#index'

  get 'sair', to: 'dashboard#sair', as: "signout"

  get 'operacao', to: 'dashboard#operacao'
  get 'financeiro', to: 'dashboard#financeiro'
  get 'financeiro/faturamento', to: 'dashboard#financeiro_faturamento'
  get 'relatorios', to: 'dashboard#relatorios'

  get 'bairros', to: 'dashboard#bairros'

  get '/assinaturas', to: 'moip_assinaturas#assinaturas'
  get '/assinaturas/:id', to: 'moip_assinaturas#assinatura', as: "assinatura"
  get '/assinaturas/:id/faturas', to: 'moip_assinaturas#faturas', as: "faturas"
  get '/fatura/:id', to: 'moip_assinaturas#fatura'

  get '/pedidos', to: 'moip#pedidos'
  get '/pedido/:id', to: 'moip#pedido', as: "pedido"
  get '/retentativas', to: 'moip#retentativas'

  get '/leads', to: 'treinarme#leads'
  get '/leads/fechados', to: 'treinarme#leads_fechados', as: "leads_fechados"
  get '/leads/:id', to: 'treinarme#lead', as: "lead"
  get '/personals', to: 'treinarme#personals'
  get '/personals/:id', to: 'treinarme#personal', as: "personal"
  get '/cancelamentos', to: 'treinarme#cancelamentos'
  get '/cancelamentos/:id', to: 'treinarme#cancelamento', as: "cancelamento"


  # charts
  get '/charts/leads_per_day', to: 'charts#leads_per_day', as: "leads_per_day"
  get '/charts/leads_fechados_per_day', to: 'charts#leads_fechados_per_day', as: "leads_fechados_per_day"
  get '/charts/leads_per_week', to: 'charts#leads_per_week', as: "leads_per_week"
  get '/charts/leads_by_substatus', to: 'charts#leads_by_substatus', as: "leads_by_substatus"

  get '/charts/cancelamentos_per_month', to: 'charts#cancelamentos_per_month', as: "cancelamentos_per_month"

  get '/charts/faturamento_por_dia', to: 'charts#faturamento_por_dia', as: "faturamento_por_dia"

  get 'charts/bairros_mais_buscados', to: 'charts#bairros_mais_buscados', as: "bairros_mais_buscados"
  get 'charts/bairros_mais_concorridos', to: 'charts#bairros_mais_concorridos', as: "bairros_mais_concorridos"
end
