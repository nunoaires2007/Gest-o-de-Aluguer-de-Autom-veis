-- | Cálculo do custo de um aluguer (funções puras).
module Pricing
  ( diferencaDias
  , numDias
  , desconto
  , custoAluguer
  ) where

import Model

-- | Converte uma data em "dias" com a convenção simples de 30 dias por mês
-- e 360 por ano (sem anos bissextos nem meses de tamanhos diferentes).
paraDias :: Data -> Int
paraDias (Data a m d) = a * 360 + m * 30 + d

-- | Dias entre duas datas: @diferencaDias d1 d2 = d2 - d1@.
diferencaDias :: Data -> Data -> Int
diferencaDias d1 d2 = paraDias d2 - paraDias d1

-- | Dias cobrados num aluguer (mínimo de 1 dia).
numDias :: Aluguer -> Int
numDias a = max 1 (diferencaDias (inicio a) (fim a))

-- | Desconto por duração: 10% a partir de 7 dias, 5% a partir de 3, senão 0.
desconto :: Int -> Double
desconto n
  | n >= 7    = 0.10
  | n >= 3    = 0.05
  | otherwise = 0

-- | Custo = dias * tarifa diária do automóvel * (1 - desconto).
custoAluguer :: Aluguer -> Double
custoAluguer a = fromIntegral n * tarifaDia (aluguerAuto a) * (1 - desconto n)
  where n = numDias a
