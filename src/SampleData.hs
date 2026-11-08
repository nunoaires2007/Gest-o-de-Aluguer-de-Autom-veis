-- | Dados de teste/demonstração (Fase 1).
module SampleData
  ( clientes
  , automoveis
  , alugueres
  ) where

import Model

clientes :: LCliente
clientes =
  [ Cliente 1 "Ana Silva"    "123456789" "L-100001"
  , Cliente 2 "Bruno Costa"  "234567891" "L-100002"
  , Cliente 3 "Carla Mendes" "345678912" "L-100003"
  , Cliente 4 "Diogo Faria"  "456789123" "L-100004"   -- sem alugueres (caso limite)
  ]

-- Automóveis nomeados para poderem ser reutilizados nos alugueres.
clio, sw308, rav4, serie5 :: Automovel
clio   = Automovel 1 "AA-11-BB" "Renault" "Clio"    Economico  30
sw308  = Automovel 2 "CC-22-DD" "Peugeot" "308 SW"  Familiar   45
rav4   = Automovel 3 "EE-33-FF" "Toyota"  "RAV4"    SUV        70
serie5 = Automovel 4 "GG-44-HH" "BMW"     "Serie 5" Luxo      120

automoveis :: LAutomovel
automoveis = [clio, sw308, rav4, serie5]

-- Aluguer id cliente automóvel início fim estado
alugueres :: LAluguer
alugueres =
  [ Aluguer 1 1 clio  (Data 2026 11 1) (Data 2026 11 4)  Concluido   -- 3 dias: 3*30*0.95 = 85.5
  , Aluguer 2 1 rav4  (Data 2026 11 10) (Data 2026 11 20) Reservado  -- 10 dias: 10*70*0.90 = 630
  , Aluguer 3 2 sw308 (Data 2026 11 5) (Data 2026 11 12) Ativo       -- 7 dias: 7*45*0.90 = 283.5
  , Aluguer 4 3 clio  (Data 2026 11 8) (Data 2026 11 9)  Cancelado   -- cancelado: não bloqueia, custo ignorado
  ]
