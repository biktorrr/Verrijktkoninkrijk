library(SPARQL)

endpoint <- 'http://semanticweb.cs.vu.nl/verrijktkoninkrijk/sparql/'

#endpoint <- 'http://eculture.cs.vu.nl:1914/sparql/'
#endpoint <- 'http://localhost:3020/sparql/'

options <- NULL
#options <- "output=xml"

prefix <- c("niod","http://purl.org/collections/nl/niod/")

sparql_prefix <- "PREFIX niod: <http://purl.org/collections/nl/niod/>
                  PREFIX skos: <http://www.w3.org/2004/02/skos/core#>"

 query0 ="
          SELECT ?pl ?provname ?pref
          WHERE
          {
          ?s skos:inScheme niod:BotBScheme.
          ?s skos:prefLabel ?pl.
          ?s skos:exactMatch ?geo.
          ?geo <http://www.geonames.org/ontology#parentADM1> ?prov.
          ?prov <http://www.geonames.org/ontology%23name> ?provname.
          ?s niod:pageRef ?pref.
          }"
# 
# query1 ="
#           SELECT ?pl ?provname ?pref
#           WHERE
#           {
#           ?s skos:inScheme niod:EntityScheme.
#           ?s skos:prefLabel ?pl.
#           ?s skos:exactMatch ?geo.
#           ?geo <http://www.geonames.org/ontology#parentADM1> ?prov.
#           ?prov <http://www.geonames.org/ontology%23name> ?provname.
#           ?s niod:pRef ?pref.
#           }"




q <- paste(sparql_prefix, query0)



res1 <- SPARQL(url=endpoint,query=q,ns=prefix)$results
res1

count_per_prov <- table(res1$prov)
sorted_counts <- sort(count_per_prov)
sorted_counts
lbls<-paste(names(sorted_counts)," (",sorted_counts, ")", sep="")
pie(sorted_counts, labels=lbls, col=rainbow(12))

