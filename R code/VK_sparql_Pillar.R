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

 query1 ="
      SELECT DISTINCT *
      WHERE {
         ?s1 skos:inScheme niod:PillarConcepts. 
      	 ?s1 niod:pillarlink ?botb1. 
      	 ?botb1 niod:pageRef ?page1.
         ?page1 niod:parRef ?par.
         	 ?s2 skos:inScheme niod:PillarConcepts. 
      	 ?s2 niod:pillarlink ?botb2. 
      	 ?botb2 niod:pageRef ?page2.
         ?page2 niod:parRef ?par.
         FILTER (?botb1 != ?botb2).
}
"





q <- paste(sparql_prefix, query1)



res1 <- SPARQL(url=endpoint,query=q,ns=prefix)$results
res1

table <- table(res1$s1,res$s2)
table
sorted_counts <- sort(table)
sorted_counts
res1

