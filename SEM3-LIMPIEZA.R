install.packages("stringr")
library(stringr)
linkCIA_urb = "https://www.cia.gov/library/publications/resources/the-world-factbook/fields/349.html"
linkPath_urb='//*[@id="fieldListing"]'
install.packages("htmltab")
library(htmltab)
urban = htmltab(doc = linkCIA_urb, 
                which =linkPath_urb)


# me trae cada numero
str_extract_all('25.3%,0% y 23.5% 13 34 hola',"\\d")
# me trae numeros adyacentes:
str_extract_all('25.3%,0% y 23.5% 13 34 hola',"\\d+")
# numero entero, seguido opcionalmente de punto y mas numero de una o mas cifras.
str_extract_all('25.3%,0% y 23.5% 13 34 hola',"\\d+\\.*\\d*")
# numero entero, seguido opcionalmente de punto y mas numero de una o mas cifras y %.
str_extract_all('25.3%,0% y 23.5% 13 34 hola', "\\d+\\.*\\d*\\%")
# porcentaje sin el simbolo

#  \\-

str_extract_all('25.3%,0% y 23.5% 13 34 hola', "(\\d+\\.*\\d*)(?=\\%)")
# porcentaje sin el simbolo

str_extract_all('25.3%,0% y -23.5% 13 34 hola', "(\\d+\\.*\\d*)(?=\\%)")
# porcentaje sin el simbolo hasta negativos

str_extract_all('25.3%,0% y -23.5% 13 34 hola', "(\\-*\\d+\\.*\\d*)(?=\\%)")

# con [[1]] recien accedemos al elemento:
str_extract_all('25.3%, 0%y 23%', "(\\-*\\d+\\.*\\d*)(?=\\%)")[[1]]
# primer valor es
str_extract_all('25%, 0% y 23.5%', "(\\-*\\d+\\.*\\d*)(?=\\%)")[[1]][1]
# segundo valor es
str_extract_all('25%, 0% y 23.5%', "(\\-*\\d+\\.*\\d*)(?=\\%)")[[1]][2]
# tercer valor es
str_extract_all('25%, 0% y 23.5%', "(\\-*\\d+\\.*\\d*)(?=\\%)")[[1]][3]

### Apliquemoslo a la columna: #####
  
str_extract_all(urban$Urbanization,pattern="(\\-*\\d+\\.*\\d*)(?=\\%)")
str_extract_all(urban$Urbanization,pattern="(\\-*\\d+\\.*\\d*)(?=\\%)",simplify = T)

PATRON="(\\-*\\d+\\.*\\d*)(?=\\%)"
COLSUCIA=urban$Urbanization

# UNA COLUMNA
urban$pop_urb=str_extract_all(string = COLSUCIA,pattern=PATRON,simplify = T)[,1]

# OTRA COLUMNA
urban$rate_urb=str_extract_all(string = COLSUCIA,pattern=PATRON,simplify = T)[,2]

head(urban[,-2]) # sin mostrar la columna 'sucia'

#####2. USO DE PARTICIONES #####
# recuerda:
test=urban[1,2]
test
#mirar el texto, y donde encuentre RATE OF URBANIZATION, partelo o SPLIT
str_split(test,pattern = 'rate of urbanization:')
urban$pop_urb2=str_split(urban$Urbanization,
                         pattern = 'rate of urbanization:',
                         simplify = T)[,1]

urban$rate_urb2=str_split(urban$Urbanization,
                          pattern = 'rate of urbanization:',
                          simplify = T)[,2]
urban$pop_urb2[1]
urban$pop_urb2=str_split(urban$pop_urb2,
                         pattern = '% of total',
                         simplify = T)[,1]
urban$pop_urb2[1]
urban$pop_urb2=str_split(urban$pop_urb2,pattern = ':',simplify = T)[,2]
##PARTE 2
urban$pop_urb2
urban$rate_urb2[1]
urban$rate_urb2=str_split(urban$rate_urb2,pattern = '%',simplify = T)[,1]
head(urban[,-2])

#####3. USO DE PARSERS #####
install.packages("readr")
library(readr)
parse_number(urban$Urbanization)
#combinado con seperaciòn
library(magrittr) # para %>% ESTO ES PARA UNIR FUNCINOES
str_split(urban$Urbanization,pattern = 'rate of urbanization:',simplify = T)[,1]%>%parse_number()
str_split(urban$Urbanization,pattern = 'rate of urbanization:',simplify = T)[,2]%>%parse_number()

#### 4. Otras funciones ##### reemplazo
porcentajes=c('13%','33%','55%')
gsub('%',"",porcentajes) # lo reemplaza por nada OSE COMILLAS SIN NADA''
str(urban) #Una vez que la data está limpia hay que verificar el tipo de datos con str():
urban[,c(2,5,6)]=NULL #Eliminemos las columnas repetidas y la original sucia usando NULL:

#Y ahora sí llevemosla a número, usando lapplyque permite aplicar una funcion a varias columnas:
urban[,-1]=lapply(urban[,-1], as.numeric) #A toda urban menos la columna 1

#VER FILAS DONDE HAY VALORES PERDIDOS
urban[!complete.cases(urban),]


#BORRAR ESPACIOS EN BLANCO DELANTE O DETRAS DE TEXTO,EXEMPLO
textos=c(' abc','pqr ', ' xyz ')
trimws(textos,whitespace = "[\\h\\v]")

#THIS 
urban$Country=trimws(urban$Country,whitespace = "[\\h\\v]")
Ahora si:
str(urban)

