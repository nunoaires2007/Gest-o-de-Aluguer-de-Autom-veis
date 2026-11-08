# Gestão de Aluguer de Automóveis

Projeto semestral de **Programação Funcional** em **Haskell**.

## Descrição

Aplicação para gerir uma empresa de aluguer de automóveis com três listas: **clientes**, **automóveis** e **alugueres**.
O sistema permite:

- consultar os alugueres de um cliente;
- verificar que automóveis estão disponíveis num período de datas;
- calcular o custo de cada aluguer (e o total de um cliente).

O projeto evolui em três fases, de acordo com a framework da unidade curricular:

| Fase | Foco | Estado |
|---|---|---|
| 1 | Modelação e núcleo funcional (tipos, pattern matching, recursão) | em curso |
| 2 | Lógica funcional: HOF, `map`/`filter`/folds, composição, `Maybe`/`Either` | por fazer |
| 3 | Aplicação final: ficheiros, parsing, menu, relatórios | por fazer |

## Modelo de dados (`src/Model.hs`)

| Tipo | Descrição |
|---|---|
| `Categoria` | `Economico`, `Familiar`, `SUV`, `Luxo` |
| `Estado` | `Reservado`, `Ativo`, `Concluido`, `Cancelado` |
| `Data` | `Data { ano, mes, dia }` (todos `Int`) |
| `Cliente` | id, nome, nif, carta de condução |
| `Automovel` | id, matrícula, marca, modelo, categoria, tarifa diária |
| `Aluguer` | id, id do cliente, automóvel, data de início, data de fim, estado |
| `LCliente`, `LAutomovel`, `LAluguer` | sinónimos de tipo para as listas |

**Decisão de modelação — datas simples:** não se consideram anos bissextos nem meses de tamanhos diferentes. Cada mês tem 30 dias e cada ano 360 (convenção comercial 30/360). Uma data é convertida em `ano*360 + mes*30 + dia`.
Um período de aluguer é o intervalo [início, fim): a devolução num dia não impede que outro aluguer comece nesse mesmo dia.

## Módulos (`src/`)

| Módulo | Conteúdo |
|---|---|
| `Model.hs` | Tipos de dados. |
| `Pricing.hs` | `diferencaDias`, `numDias` (mínimo 1 dia), `desconto` (5% a partir de 3 dias, 10% a partir de 7) e `custoAluguer`. |
| `Domain.hs` | Funções de consulta e regras (abaixo). |
| `SampleData.hs` | Dados de teste: 4 clientes, 4 automóveis, 4 alugueres. |

Dependências: `Model` → `Pricing` → `Domain` → `SampleData`.

### Funções do `Domain.hs`

| Função | O que faz |
|---|---|
| `procurarCliente` | Procura um cliente pelo id (`Maybe`). |
| `procurarAutomovel` | Procura um automóvel pelo id (`Maybe`). |
| `alugueresDoCliente` | Alugueres de um cliente. |
| `sobrepoe` | Dois períodos [i1,f1) e [i2,f2) sobrepõem-se se `i1 < f2 && i2 < f1`. |
| `ocupaAutomovel` | O aluguer é desse automóvel e não está cancelado. |
| `automovelDisponivel` | O automóvel está livre num período. |
| `disponiveis` | Lista os automóveis livres num período. |
| `custoTotalCliente` | Soma dos custos dos alugueres não cancelados de um cliente. |

Na Fase 1 estas funções usam **pattern matching, guards e recursão**; `map`, folds, composição e `Either` ficam para a Fase 2.

## Como usar (ghci)

Não há `Main` nem `cabal`: as funções testam-se no terminal.

```
cd src
ghci Domain.hs SampleData.hs
```

Dentro do `ghci`, importar os dados e o `Pricing`:

```haskell
:m + SampleData
:m + Pricing
```

Exemplos:

```haskell
procurarCliente 2 clientes
procurarCliente 99 clientes                                       -- Nothing
map aluguerId (alugueresDoCliente 1 alugueres)                    -- [1,2]
map autoId (disponiveis automoveis alugueres (Data 2026 11 6) (Data 2026 11 9))   -- [1,3,4]
map custoAluguer alugueres                                        -- [85.5,630.0,283.5,30.0]
custoTotalCliente 1 alugueres                                     -- 715.5
```

Comandos úteis: `:r` recarrega · `:t função` mostra o tipo · `:m + Módulo` importa um módulo · `:q` sai.

## Testes

Os testes são feitos no `ghci`, comparando o resultado de cada chamada com o esperado. Estão descritos em [`docs/testes_fase1.md`](docs/testes_fase1.md): 21 testes que cobrem pesquisas (`Maybe`), alugueres de um cliente, sobreposição, disponibilidade e custos, incluindo casos limite.

## Estrutura do projeto

```
aluguer de carros/
├── README.md
├── src/
│   ├── Model.hs
│   ├── Pricing.hs
│   ├── Domain.hs
│   └── SampleData.hs
├── docs/
│   ├── testes_fase1.md   relatório de testes
└── .github/              CODEOWNERS e template de Pull Request
```

## Equipa

Afonso Salgado, 
Afonso Martins, 
Nuno Aires.