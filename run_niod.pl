:- module(niod,
	  [ run_niod/0,
	    clean/0,
	    save/0
	  ]).

user:file_search_path(data,      'C:/Users/victor/Verrijkt Koninkrijk/NIOD Thesaurus/cliopatria/data').

:- use_module(library(semweb/rdf_db)).

:- rdf_register_ns(niod, 'http://purl.org/collections/nl/niod/').
:- rdf_register_ns(dcterms, 'http://purl.org/dc/terms/').

:- use_module([ library(xmlrdf/xmlrdf),
		library(semweb/rdf_cache),
		library(semweb/rdf_library),
		library(semweb/rdf_turtle_write)
	      ]).
:- use_module(rewrite_niod).

load_ontologies :-
	rdf_load_library(dc),
	rdf_load_library(skos),
	rdf_load_library(rdfs),
	rdf_load_library(owl).

:- initialization			% run *after* loading this file
	rdf_set_cache_options([ global_directory('cache/rdf'),
				create_global_directory(true)
			      ]),
	load_ontologies.

load_tref:-
        absolute_file_name(data('xml/Trefwoorden.xml'), File,
			   [ access(read)
			   ]),
	write(File),
	load('Trefwoorden', File).

load_rubriek:-
        absolute_file_name(data('xml/Rubrieken.xml'), File,
			   [ access(read)
			   ]),
	write(File),
	load('Rubrieken',File).
load:-
	load_tref,
	load_rubriek.

load(Unit, File) :-
	rdf_current_ns(niod, Prefix),
	load_xml_as_rdf(File,
			[ dialect(xml),
			  unit(Unit),
			  prefix(Prefix),
			  graph(thesaurus)
			]).


run_niod:-
	load,
	addRDF,
	rewrite,
	rewrite, % second time for rule dependencies
	save.

addRDF:-
	rdf_assert(niod:'ConceptScheme', rdf:type, skos:'ConceptScheme', thesaurus),
	rdf_assert(niod:'ConceptScheme', rdfs:label, literal('NIOD ConceptScheme'), thesaurus).


save:-
	absolute_file_name(data('rdf/niod-thesaurus.ttl'), File,
			   [ access(write)
			   ]),
	rdf_save_turtle(File,[graph(thesaurus)]).

clean:-
	rdf_retractall(_,_,_,thesaurus),
	rdf_retractall(_,_,_,user).


rel_to_broader:-
rdf_transaction((
		forall(rdf(S,skos:broader,O,_),
		       (
		       rdf_retractall(S,skos:related,O),
		       rdf_retractall(O,skos:related,S)
		        )
		      )
		)).



load_cornetto:-
	rdf_attach_library('../../../EuropeanaConnect/Econnect/vocs/cornetto/').

load_aatned:-
	rdf_attach_library('../../../EuropeanaConnect/Econnect/vocs/rkd/aatned').







