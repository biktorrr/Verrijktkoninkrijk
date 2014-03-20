library(SPARQL)

endpoint <- 'http://semanticweb.cs.vu.nl/verrijktkoninkrijk/sparql/'
#endpoint <- 'http://localhost:3020/sparql/'

options <- NULL
#options <- "output=xml"

prefix <- c("niod","http://purl.org/collections/nl/niod/")

sparql_prefix <- "PREFIX dcterms: <http://purl.org/dc/terms/>
                  PREFIX niod: <http://purl.org/collections/nl/niod/>
                  PREFIX skos: <http://www.w3.org/2004/02/skos/core#>
                  PREFIX dbp-prop: <http://nl.dbpedia.org/property/>
                  PREFIX dbp-res: <http://nl.dbpedia.org/resource/>
"
 query1 ="SELECT * WHERE {
              ?entity niod:nerClass niod:nerclass-per;
              owl:sameAs ?dbpedia_entry;
              niod:pRef ?pref.
              ?dbpedia_entry dbp-prop:functie dbp-res:Minister-president_van_Nederland.
              ?dbpedia_entry rdfs:label ?label.
              }"


q <- paste(sparql_prefix, query1)



res1 <- SPARQL(url=endpoint,query=q,ns=prefix)$results
res1

entity <- table(res1$label)
sorted_counts <- sort(entity)
sorted_counts
lbls<-paste(names(sorted_counts)," (",sorted_counts, ")", sep="")
pie(sorted_counts, labels=lbls, col=rainbow(12))

