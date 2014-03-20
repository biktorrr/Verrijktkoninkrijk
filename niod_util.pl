
% Find all possibly hierachically related pairs E1, E2 in the
% mappinggraph
%
findall_hier(MappingGraph,List):-
	findall([NarConcept,BroConcept],
		find_hier(MappingGraph, NarConcept, BroConcept),
		List).


% succeeds if source concepts E1 and E11 are mapped to hierarchically
% related target concepts (skos:broader)
%

find_hier(MappingGraph, E1, E11):-
	rdf(Cell,align:entity1,E1,MappingGraph),
	rdf(Cell,align:entity2,E2,MappingGraph),
	rdf(Cell1,align:entity1,E11,MappingGraph),
	rdf(Cell1,align:entity2,E12,MappingGraph),
	Cell\=Cell1,
	rdf_reachable(E2, skos:broader, E12).





% get DBPedia
%
% rdf_db:rdf_file_type(ntriples,turtle).library(rdf_ntriples) http open,
% file dumpen in een .nt file en dan triples laden.
:-use_module(library(rdf_ntriples)).

get_all:-
%	A = 'http://purl.org/collections/nl/niod/entity-Aal',
	open('dbpedia_dump.nt','write',S, [type(binary)]),
	forall(rdf(_A,owl:sameAs, DURI,'http://purl.org/collections/nl/niod/ner_all_to_dbp_nl.ttl'),
	     catch((
		 convert_dbpedia_uri(DURI, DURI2),
		 http_open:http_open(DURI2,T,[]),
		 copy_stream_data(T,S),
		 write('.'),flush,
		 close(T),
		 sleep(1)
	     ),A,print_message(warning,A))
	      ),
	close(S).

convert_dbpedia_uri(DURI, DURI2):-
	atom_concat('http://nl.dbpedia.org/resource/',C,DURI),
	atom_concat('http://nl.dbpedia.org/data/',C,DURI12),
	atom_concat(DURI12,'.ntriples',DURI2).








