library(SPARQL)


endpoint <- 'http://eculture.cs.vu.nl:1914/sparql/'
#endpoint <- 'http://localhost:3020/sparql/'

options <- NULL
#options <- "output=xml"

prefix <- c("niod","http://purl.org/collections/nl/niod/")

sparql_prefix <- "PREFIX niod: <http://purl.org/collections/nl/niod/>
                  PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
"

 query0 =" SELECT DISTINCT ?s ?page ?botb WHERE { 
                            ?s skos:inScheme niod:PillarConcepts. 
                            ?s niod:pillarlink ?botb. 
                            ?botb niod:pageRef ?page.}"
# query1 = " SELECT * WHERE {}   ?pillar niod:pillarlink ?pil_concept. ?pil_concept niod:pageRef ?bn. ?bn niod:parRef ?paragraph. ?other_concept niod:pageRef ?bn2. ?bn2 niod:parRef ?paragraph. ?niod_thes skos:exactMatch ?other_concept.}"


q <- paste(sparql_prefix, 
           query0)



res <- SPARQL(url=endpoint,query=q,ns=prefix)$results
res

count_per_pillar <- table(res$s)
sorted_counts <- sort(count_per_pillar)
sorted_counts
pie(sorted_counts, col=rainbow(8))



# QUERY 1

 query1 = " SELECT ?pillar ?niod_thes WHERE { 
?pillar niod:pillarlink ?pil_concept. 
?pil_concept niod:pageRef ?bn. 
?bn niod:parRef ?paragraph. 
?other_concept niod:pageRef ?bn2. 
?bn2 niod:parRef ?paragraph. 
?niod_thes skos:exactMatch ?other_concept.
} LIMIT 10" 


q1 <- paste(sparql_prefix,  query1)



res1 <- SPARQL(url=endpoint,query=q1,ns=prefix)$results
res1

count_per_pillar1 <- table(res1$entity)
sorted_counts1 <- sort(count_per_pillar1)
sorted_counts1
pie(sorted_counts1, col=rainbow(8))



query1 = "  SELECT * WHERE { 
   niod:Voertuigen
  skos:exactMatch ?entity.
   ?entity niod:pRef ?paragraph.
  
   ?zuil niod:pillarlink ?botb.
   ?botb niod:pageRef ?page.
   ?page niod:parRef ?paragraph.}"


query1 = "  SELECT * WHERE {
niod:Verzuiling niod:parRef ?par.
?page niod:parRef ?par.
?pillarconcept niod:pageRef ?page.
?pillar niod:pillarlink ?pillarconcept.}"

query1 = "  SELECT * WHERE {
niod:Verzuiling niod:parRef ?par.
?entity niod:pRef ?par.}"
