# Relatório de testes — Fase 1 (RentHS)

Os testes fazem-se no terminal, com o `ghci`: chamamos cada função com dados conhecidos e comparamos o resultado com o esperado.

## 1. Preparar o ambiente

```
cd src
ghci Domain.hs SampleData.hs
```

O `ghci` carrega também `Model.hs` e `Pricing.hs`, porque o `Domain` os importa. Se aparecer um erro de compilação, corrige-se o ficheiro indicado e usa-se `:r` (recarregar). Quando tudo carregar, aparece `Ok, four modules loaded.` (ou semelhante).

Comandos úteis: `:r` recarrega os ficheiros · `:t função` mostra o tipo · `:q` sai.

## 2. O que fazer em relação ao SampleData

O `SampleData.hs` já é o conjunto de dados de teste da Fase 1. Não é preciso criar mais nada.

- **Usar:** os nomes `clientes`, `automoveis` e `alugueres` ficam disponíveis no `ghci` ao carregar o ficheiro.
- **Ver os dados:** escrever `clientes`, `automoveis` ou `alugueres` no `ghci`.
- **Alterar os dados:** editar o ficheiro, gravar e fazer `:r`. Se mudarem valores (tarifas, datas, estados), os resultados esperados abaixo mudam; atualizem a tabela.
- **Testes rápidos sem editar o ficheiro:** criar valores à mão no `ghci`, por exemplo
  `let a = Aluguer 9 1 (head automoveis) (Data 2026 12 1) (Data 2026 12 3) Reservado`
- **Não é preciso** `Main`, `cabal` nem ficheiros extra.

Conteúdo atual: 4 clientes (Ana, Bruno, Carla, Diogo — este sem alugueres), 4 automóveis (Clio 30 €/dia, 308 SW 45 €/dia, RAV4 70 €/dia, Serie 5 120 €/dia — este sem alugueres) e 4 alugueres:

| Id | Cliente | Carro | Período | Estado |
|---|---|---|---|---|
| 1 | Ana | Clio | 2026/11/1 → 2026/11/4 | Concluido |
| 2 | Ana | RAV4 | 2026/11/10 → 2026/11/20 | Reservado |
| 3 | Bruno | 308 SW | 2026/11/5 → 2026/11/12 | Ativo |
| 4 | Carla | Clio | 2026/11/8 → 2026/11/9 | Cancelado |

## 3. Como se faz cada teste (passo a passo)

Para cada linha: escrever a chamada no `ghci`, ver o resultado, comparar com o esperado e anotar *OK* ou *Falhou* na última coluna.

### 3.1 Pesquisa (Maybe)

| # | Chamada | Esperado | OK? |
|---|---|---|---|
| 1 | `fmap nome (procurarCliente 2 clientes)` | `Just "Bruno Costa"` | |
| 2 | `procurarCliente 99 clientes` | `Nothing` | |
| 3 | `fmap marca (procurarAutomovel 3 automoveis)` | `Just "Toyota"` | |
| 4 | `procurarAutomovel 99 automoveis` | `Nothing` | |

### 3.2 Alugueres de um cliente

| # | Chamada | Esperado | OK? |
|---|---|---|---|
| 5 | `map aluguerId (alugueresDoCliente 1 alugueres)` | `[1,2]` | |
| 6 | `map aluguerId (alugueresDoCliente 2 alugueres)` | `[3]` | |
| 7 | `alugueresDoCliente 99 alugueres` | `[]` (caso limite) | |

### 3.3 Sobreposição de períodos

| # | Chamada | Esperado | OK? |
|---|---|---|---|
| 8 | `sobrepoe (Data 2026 11 1, Data 2026 11 5) (Data 2026 11 4, Data 2026 11 8)` | `True` | |
| 9 | `sobrepoe (Data 2026 11 1, Data 2026 11 5) (Data 2026 11 5, Data 2026 11 8)` | `False` (extremo: devolução = levantamento) | |
| 10 | `sobrepoe (Data 2026 11 1, Data 2026 11 3) (Data 2026 11 8, Data 2026 11 9)` | `False` | |

### 3.4 Disponibilidade

| # | Chamada | Esperado | OK? |
|---|---|---|---|
| 11 | `map autoId (disponiveis automoveis alugueres (Data 2026 11 6) (Data 2026 11 9))` | `[1,3,4]` (o 308 SW está ocupado de 5 a 12; o Serie 5 não tem alugueres) | |
| 12 | `automovelDisponivel alugueres (Data 2026 11 8) (Data 2026 11 9) (head automoveis)` | `True` (o aluguer 4 está cancelado) | |
| 13 | `automovelDisponivel alugueres (Data 2026 11 2) (Data 2026 11 3) (head automoveis)` | `False` (o aluguer 1 ocupa o Clio de 1 a 4) | |
| 14 | `length (disponiveis automoveis [] (Data 2026 11 1) (Data 2026 11 30))` | `4` (sem alugueres, todos livres) | |

### 3.5 Custos

| # | Chamada | Esperado | OK? |
|---|---|---|---|
| 15 | `diferencaDias (Data 2026 11 1) (Data 2026 11 4)` | `3` | |
| 16 | `diferencaDias (Data 2026 11 28) (Data 2026 12 2)` | `4` (30 dias por mês) | |
| 17 | `desconto 2`, `desconto 3`, `desconto 7` | `0.0`, `0.05`, `0.1` | |
| 18 | `map custoAluguer alugueres` | `[85.5,630.0,283.5,30.0]` | |
| 19 | `custoTotalCliente 1 alugueres` | `715.5` | |
| 20 | `custoTotalCliente 3 alugueres` | `0.0` (só tem um aluguer cancelado) | |
| 21 | `custoTotalCliente 99 alugueres` | `0.0` (cliente sem alugueres) | |

Nota: o `custoAluguer` não olha ao estado (por isso o aluguer 4 custa 30.0, 1 dia mínimo); é o `custoTotalCliente` que ignora cancelados. Os valores com casas decimais podem aparecer com pequenas diferenças típicas de `Double` (por exemplo `85.49999999999999`); é normal e não é erro.

## 4. Casos limite cobertos
Lista vazia · cliente ou carro inexistente · cliente sem alugueres · períodos que se tocam no extremo · aluguer cancelado a não bloquear o carro · aluguer de menos de 1 dia (mínimo 1) · cliente só com alugueres cancelados.

## 5. Estrutura do projeto

```
renths/
├── README.md
├── src/
│   ├── Model.hs        tipos de dados
│   ├── Pricing.hs      dias, desconto e custo
│   ├── Domain.hs       pesquisas, disponibilidade, custos
│   └── SampleData.hs   dados de teste
├── docs/
│   ├── testes.md       este relatório
│   ├── FASE1.md        resumo dos entregáveis
│   ├── TAREFAS.md      divisão de tarefas
│   └── ownership.txt   (opcional) permissões por ficheiro
├── data/               vazio (ficheiros na Fase 3)
├── scripts/            (opcional) hook de permissões Git
└── .github/            (opcional) CODEOWNERS e template de PR
```

Dependências: `Model` → `Pricing` → `Domain` → `SampleData`.