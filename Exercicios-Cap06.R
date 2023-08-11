# Solução Lista de Exercícios - Capítulo 6

# Obs: Caso tenha problemas com a acentuação, consulte este link:
# https://support.rstudio.com/hc/en-us/articles/200532197-Character-Encoding

# Configurando o diretório de trabalho
# Coloque entre aspas o diretório de trabalho que você está usando no seu computador
# Não use diretórios com espaço no nome
setwd("C:/FCD/BigDataRAzure/Cap06")
getwd()


# Exercicio 1 - Instale a carregue os pacotes necessários para trabalhar com SQLite e R
??sqlite
# com essa pergunta R me retorna sobre o pacote DBI
library(RSQLite) #carreguei a library do curso
library(dbplyr)
library(dplyr) #faltou

# Exercicio 2 - Crie a conexão para o arquivo mamiferos.sqlite em anexo a este script
#solução professor
mamiferos <- dbConnect(SQLite(), "mamiferos.sqlite")

#minha sol.
drv = dbDriver("SQLite")
con = dbConnect(drv, dbname = "mamiferos.sqlite")


# Exercicio 3 - Qual a versão do SQLite usada no banco de dados?
# Dica: Consulte o help da função src_dbi()
#aqui precisei do dplyr
src_dbi(con)


# Exercicio 4 - Execute a query abaixo no banco de dados e grave em um objero em R:
# SELECT year, species_id, plot_id FROM surveys
query <- "SELECT year, species_id, plot_id FROM surveys"
rs <- dbSendQuery(con, query)
dados <- fetch(rs)

# resolução professor
?tbl #do pct dplyr , serve para qlq fonte de dados
dados <- tbl(mamiferos, sql("SELECT year, species_id, plot_id FROM surveys"))


# Exercicio 5 - Qual o tipo de objeto criado no item anterior?
class(rs) #SQLiteResult --- esse aqui o correto
class(dados) #dataframe


# Exercicio 6 - Já carregamos a tabela abaixo para você. Selecione as colunas species_id, sex e weight com a seguinte condição:
# Condição: weight < 5
pesquisas <- con %>%
             tbl("surveys") %>%
             select(species_id, sex, weight) %>%
             filter(weight < 5) %>%
             collect()

head(pesquisas) #tibble


# Exercicio 7 - Grave o resultado do item anterior em um objeto R. O objeto final deve ser um dataframe
dfPesq <- as.data.frame(pesquisas)
class(dfPesq)

# Exercicio 8 - Liste as tabelas do banco de dados carregado
dbListTables(con)


# Exercicio 9 - A partir do dataframe criado no item 7, crie uma tabela no banco de dados
dbWriteTable(con, "pesquisas", dfPesq, row.names = TRUE)
dbListTables(con)


# Exercicio 10 - Imprima os dados da tabela criada no item anterior
dbReadTable(con, "pesquisas")

