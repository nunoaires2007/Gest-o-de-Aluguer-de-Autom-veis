module Model where

data Categoria = Economico | Familiar | SUV |Luxo
        deriving (Show, Eq, Ord)

data Estado =  Reservado | Ativo | Concluido | Cancelado
    deriving (Show, Eq)

data Data = Data { ano :: Int, mes :: Int, dia :: Int }
  deriving (Show, Eq, Ord)


type ClienteId = Int
type AutoId = Int
type AluguerId = Int

data Cliente = Cliente {

    clienteId :: ClienteId
    , nome :: String
    , nif :: String
    , cartaConducao :: String
    } deriving (Show, Eq)

data Automovel = Automovel {

    autoId :: Int
    , matricula :: String
    , marca :: String
    , modelo :: String
    , categoria :: Categoria
    , tarifaDia :: Double 
    } deriving (Show, Eq)

data Aluguer = Aluguer {
    aluguerId :: AluguerId
    , idcliente :: Int
    , aluguerAuto :: Automovel
    , inicio :: Data
    , fim :: Data
    , estado :: Estado
} deriving (Show, Eq)

type LCliente = [Cliente]
type LAutomovel = [Automovel]
type LAluguer = [Aluguer]