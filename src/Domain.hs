-- | Regras e consultas do domínio (Fase 1): pattern matching, guards e recursão.
module Domain
  ( procurarCliente
  , procurarAutomovel
  , alugueresDoCliente
  , sobrepoe
  , ocupaAutomovel
  , automovelDisponivel
  , disponiveis
  , custoTotalCliente
  ) where

import Model
import Pricing (custoAluguer)

-- | Procura um cliente pelo identificador.
procurarCliente :: ClienteId -> LCliente -> Maybe Cliente
procurarCliente _ [] = Nothing
procurarCliente i (c:cs)
  | clienteId c == i = Just c
  | otherwise        = procurarCliente i cs

-- | Procura um automóvel pelo identificador.
procurarAutomovel :: AutoId -> LAutomovel -> Maybe Automovel
procurarAutomovel _ [] = Nothing
procurarAutomovel i (a:as)
  | autoId a == i = Just a
  | otherwise     = procurarAutomovel i as

-- | Alugueres de um cliente.
alugueresDoCliente :: ClienteId -> LAluguer -> LAluguer
alugueresDoCliente _ [] = []
alugueresDoCliente cid (a:as)
  | aluguerCliente a == cid = a : alugueresDoCliente cid as
  | otherwise               = alugueresDoCliente cid as

-- | Dois períodos [i1,f1) e [i2,f2) sobrepõem-se se cada um começa antes de o outro acabar.
sobrepoe :: (Data, Data) -> (Data, Data) -> Bool
sobrepoe (i1, f1) (i2, f2) = i1 < f2 && i2 < f1

-- | O aluguer bloqueia o automóvel se for desse carro e não estiver cancelado.
ocupaAutomovel :: AutoId -> Aluguer -> Bool
ocupaAutomovel aid a = autoId (aluguerAuto a) == aid && estado a /= Cancelado

-- | O automóvel está livre em [ini, f) se nenhum aluguer que o ocupe se sobrepõe a esse período.
automovelDisponivel :: LAluguer -> Data -> Data -> Automovel -> Bool
automovelDisponivel [] _ _ _ = True
automovelDisponivel (a:as) ini f auto
  | ocupaAutomovel (autoId auto) a && sobrepoe (ini, f) (inicio a, fim a) = False
  | otherwise = automovelDisponivel as ini f auto

-- | Automóveis disponíveis num período.
disponiveis :: LAutomovel -> LAluguer -> Data -> Data -> LAutomovel
disponiveis autos alus ini f = filter (automovelDisponivel alus ini f) autos

-- | Custo total dos alugueres não cancelados de um cliente.
custoTotalCliente :: ClienteId -> LAluguer -> Double
custoTotalCliente cid alus = somaCustos (alugueresDoCliente cid alus)
  where
    somaCustos [] = 0
    somaCustos (a:as)
      | estado a == Cancelado = somaCustos as
      | otherwise             = custoAluguer a + somaCustos as