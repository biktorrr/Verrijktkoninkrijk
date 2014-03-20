:- module(rewrite_niod,
	  [ rewrite/0,
	    rewrite/1,
	    rewrite/2,
	    list_rules/0
	  ]).
:- use_module(library(semweb/rdf_db)).
:- use_module(library(xmlrdf/rdf_convert_util)).
:- use_module(library(xmlrdf/cvt_vocabulary)).
:- use_module(library(xmlrdf/rdf_rewrite)).

:- debug(rdf_rewrite).

%%	rewrite
%
%	Apply all rules on the graph =data=

rewrite :-
	rdf_rewrite(thesaurus).

%%	rewrite(+Rule)
%
%	Apply the given rule on the graph =data=

rewrite(Rule) :-
	rdf_rewrite(thesaurus, Rule).

%%	rewrite(+Graph, +Rule)
%
%	Apply the given rule on the given graph.

rewrite(Graph, Rule) :-
	rdf_rewrite(Graph, Rule).

%%	list_rules
%
%	List the available rules to the console.

list_rules :-
	rdf_rewrite_rules.

:- discontiguous
	rdf_mapping_rule/5.



rubrieken_to_uri @@
{S, rdf:type, niod:'Rubrieken'},
{S, niod:rubrieksomschrijving, Lit}\
{S}
<=>
literal_to_id(['rubriek-',Lit],niod, URI),
{URI}.

rubrieken_to_conceptscheme @@
{S, rdf:type, niod:'Rubrieken'},
{S, niod:rubrieksaanduiding, Nr},
{S, niod:rubrieksomschrijving, Lit}
<=>
{S, rdf:type, skos:'ConceptScheme'},
{S, rdfs:label, Lit},
{S, dcterms:identifier, Nr}.


trefwoord_to_uri @@
{S, rdf:type, niod:'Trefwoorden'},
{S, niod:trefwoord, Trefwoord}\
{S}
<=>
literal_to_id([Trefwoord],niod, URI),
	{URI}.



trefwoord_to_concept @@
{S, rdf:type, niod:'Trefwoorden'},
{S, niod:trefwoord, literal(Trefwoord)}
<=>
clean_literal(Trefwoord, Trefwoord1),
{S, rdf:type, skos:'Concept'},
{S, skos:inScheme, niod:'ConceptScheme'},
{S, skos:prefLabel, literal(Trefwoord1)}.

rubrieken @@
{S1, dcterms:identifier, Literal},
{S1, rdf:type, skos:'ConceptScheme'}\
{S2, niod:rubriek, Literal}
<=>
{S2, skos:inScheme, S1}.



% --- Zie ook

zieook_to_related @@
{S1, skos:prefLabel, literal(Lit)}\
{S1}
<=>
split_zie_ook(Lit, FirstPart, _LastPart),
literal_to_id([FirstPart],niod, URI),
{URI}.

%intermediary step
zieook_to_related @@
{S1, skos:prefLabel, literal(Lit)}
<=>
split_zie_ook(Lit, FirstPart, LastPart),
{S1, skos:prefLabel, literal(FirstPart)},
{S1, niod:myrelated, literal(LastPart)}.


%For weird literals
zieook_to_related @@
{S2, skos:prefLabel, literal(CleanLit)}\
{S1, niod:myrelated, literal(Lit)}
<=>
clean_literal(Lit,CleanLit), %for weird literals
{S1, skos:related, S2}.


%For comma-separated relations
zieook_to_related @@
{S2, skos:prefLabel, literal(OneLit)}\
{S1, niod:myrelated, literal(Lit)}
<=>
one_relation(Lit,OneLit),
{S1, skos:related, S2}.


% --- Zie

zie_to_altLabel @@
{S1, skos:prefLabel, literal(Lit)}\
{S1}
<=>
split_zie(Lit, FirstPart, _LastPart),
literal_to_id([FirstPart],niod, URI),
{URI}.


zie_to_altLabel @@
{S1, skos:prefLabel, literal(Lit)}
<=>
split_zie(Lit, FirstPart, LastPart),
{S1, skos:prefLabel, literal(FirstPart)},
{S1, niod:zie, literal(LastPart)}.

zie_to_altLabel @@
{S2, skos:prefLabel, literal(LastPart)}\
{S1, niod:zie, literal(LastPart)},
{S1,_,_},
{S1, skos:prefLabel, literal(FirstPart)}
 <=>
{S2, skos:altLabel, literal(FirstPart)}.

zie_to_altLabel @@
{S2, skos:prefLabel, literal(LastPart)}\
{S1, niod:zie, literal(Lit)},
{S1,_,_},
{S1, skos:prefLabel, literal(FirstPart)}
 <=>
one_relation(Lit,LastPart),
{S2, skos:altLabel, literal(FirstPart)}.



% Exceptions
%

exceptions @@
{S,skos:prefLabel, literal('Ponten\nPonten')}
<=>
{S, skos:prefLabel, literal('Ponten')}.

exceptions @@
{niod:'Ponten_Ponten',X,Y}
<=>
{niod:'Ponten',X,Y}.

% zie ook exceptions

exceptions @@
{niod:'Armoede', niod:myrelated, _}
<=>
{niod:'Armoede', skos:related, niod:'Schaarste'}.

exceptions @@
{niod:'Beeldende_kunst', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Beeldende_kunst', skos:note, literal(X1)}.

exceptions @@
{niod:'Egodocumenten', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Egodocumenten', skos:note, literal(X1)}.

exceptions @@
{niod:'Erediensten', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Erediensten', skos:note, literal(X1)}.

exceptions @@
{niod:'Ideologieen', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Ideologieen', skos:note, literal(X1)}.

exceptions @@
{niod:'Kampen', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Kampen', skos:note, literal(X1)}.

exceptions @@
{niod:'Militarisering', niod:myrelated, literal(_)}
<=>
{niod:'Militarisering', skos:related, niod:'Demilitarisering'}.

exceptions @@
{niod:'Religie', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Religie', skos:note, literal(X1)}.

exceptions @@
{niod:'Schepen', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Schepen', skos:note, literal(X1)}.

exceptions @@
{niod:'Sport', niod:myrelated, _}
<=>
{niod:'Sport', skos:related, niod:'Olympische_Spelen'}.

exceptions @@
{niod:'Strijdkrachten', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Strijdkrachten', skos:note, literal(X1)}.

exceptions @@
{niod:'Troostmeisjes', niod:myrelated, _}
<=>
{niod:'Troostmeisjes', skos:related, niod:'Gedwongen_prostitutie'}.

exceptions @@
{niod:'Vervoermiddelen', niod:myrelated, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Vervoermiddelen', skos:note, literal(X1)}.

exceptions @@
{niod:'Verwerking', niod:myrelated, _}
<=>
{niod:'Verwerking', skos:related, niod:'Oorlogstrauma_s'}.

% zie exceptions
%
exceptions @@
{niod:'Annexatie', niod:zie, _},
{niod:'Annexatie',_ , _}
<=>
{niod:'Gebiedsuitbreiding', skos:altLabel, literal('Annexatie')}.

exceptions @@
{niod:'Ereschulden', niod:zie, _},
{niod:'Ereschulden',_ , _}
<=>
{niod:'Schadeloosstelling', skos:altLabel, literal('Ereschulden')}.

exceptions @@
{niod:'Gifgassen', niod:zie, _},
{niod:'Gifgassen',_ , _}
<=>
{niod:'Chemische_oorlogvoering', skos:altLabel, literal('Gifgassen')}.

exceptions @@
{niod:'Mosterdgas', niod:zie, _},
{niod:'Mosterdgas',_ , _}
<=>
{niod:'Chemische_oorlogvoering', skos:altLabel, literal('Mosterdgas')}.

exceptions @@
{niod:'KZ-syndroom', niod:zie, _},
{niod:'KZ-syndroom',_ , _}
<=>
{niod:'Oorlogstrauma_s', skos:altLabel, literal('KZ-syndroom')}.

exceptions @@
{niod:'Trauma_s', niod:zie, _},
{niod:'Trauma_s',_ , _}
<=>
{niod:'Oorlogstrauma_s', skos:altLabel, literal('Trauma\'s')}.

exceptions @@
{niod:'Landmijnen', niod:zie, _},
{niod:'Landmijnen',_ , _}
<=>
{niod:'Mijnen (wapens)', skos:altLabel, literal('Landmijnen')}.


exceptions @@
{niod:'Armoede', niod:zie, _}
<=>
{niod:'Armoede', skos:related, niod:'Schaarste'}.


exceptions @@
{niod:'Illustraties', niod:zie, literal(X)}
<=>
concat_atom(['Zie ook ',X], X1),
{niod:'Illustraties', skos:note, literal(X1)}.

% ----
%

altlabelfix @@
{S, skos:altLabel, literal('Wereldoorlogen')}
<=>
literal_to_id(['Wereldoorlogen'],niod, URI),
{URI, rdf:type, skos:'Concept'},
{URI, skos:prefLabel, literal('Wereldoorlogen')},
{S, skos:broader, URI}.

/* also in ttl file
rel_to_broader @@
{_, skos:prefLabel, literal('Aanslagen')} % eenmalig
==>
{niod:'Aardolie', skos:broader, niod:'Brandstoffen'},
{niod:'Kolen', skos:broader, niod:'Brandstoffen'},
{niod:'Alcoholische_dranken', skos:broader, niod:'Dranken'},
{niod:'Wapendroppings', skos:broader, niod:'Droppings'},
{niod:'Voedseldroppings', skos:broader, niod:'Droppings'},
{niod:'Massa-executies', skos:broader, niod:'Executies'},
{niod:'Oostfront', skos:broader, niod:'Frontlinies'},
{niod:'Westfront', skos:broader, niod:'Frontlinies'},
{niod:'Alcoholische_dranken', skos:broader, niod:'Gebouwen'},
{niod:'Stadhuizen', skos:broader, niod:'Gebouwen'},
{niod:'Predikanten', skos:broader, niod:'Geestelijken'},
{niod:'Priesers', skos:broader, niod:'Geestelijken'},
{niod:'Bankbiljetten', skos:broader, niod:'Geld'},
{niod:'Muntgeld', skos:broader, niod:'Geld'},
{niod:'Noodgeld', skos:broader, niod:'Geld'},
{niod:'Massagraven', skos:broader, niod:'Graven'},
{niod:'Oorlogsgraven', skos:broader, niod:'Graven'},
{niod:'Dodenherdenking', skos:broader, niod:'Herdenkingen'},
{niod:'Noodwoningen', skos:broader, niod:'Huisvesting'},
{niod:'Volkshuisvesting', skos:broader, niod:'Huisvesting'},
{niod:'Waterwegen', skos:broader, niod:'Infrastructuur'},
{niod:'Wegen', skos:broader, niod:'Infrastructuur'},
{niod:'Gijzelaarskampen', skos:broader, niod:'Interneringskampen'},
{niod:'Mannenkampen', skos:broader, niod:'Interneringskampen'},
{niod:'Vrouwenkampen', skos:broader, niod:'Interneringskampen'},
{niod:'Stafkaarten', skos:broader, niod:'Kaartmateriaal'},
{niod:'Plattegronden', skos:broader, niod:'Kaartmateriaal'},
{niod:'Atlassen', skos:broader, niod:'Kaartmateriaal'},
{niod:'Variete', skos:broader, niod:'Kleinkunst'},
{niod:'Cabaret', skos:broader, niod:'Kleinkunst'},
{niod:'Kampkranten', skos:broader, niod:'Kranten'},
{niod:'Levensmiddelen', skos:broader, niod:'Zuivelproducten'},
{niod:'Emigratie', skos:broader, niod:'Migratie'},
{niod:'Immigratie', skos:broader, niod:'Migratie'},
{niod:'Soldaten', skos:broader, niod:'Militairen'},
{niod:'Officieren', skos:broader, niod:'Militairen'},
{niod:'Ministers', skos:broader, niod:'Kabinetten'},
{niod:'Oorlogsmonumenten', skos:broader, niod:'Monumenten'},
{niod:'Gedenkplaatsen', skos:broader, niod:'Monumenten'},
{niod:'Jazz', skos:broader, niod:'Muziek'},
{niod:'Opera', skos:broader, niod:'Muziek'},
{niod:'Bacteriologische_oorlogvoering', skos:broader, niod:'Oorlogvoering'},
{niod:'Psychologische_oorlogvoering', skos:broader, niod:'Oorlogvoering'},
{niod:'Gevechtshandelingen', skos:broader, niod:'Oorlogvoering'},
{niod:'Kranten', skos:broader, niod:'Periodieken'},
{niod:'Brochures', skos:broader, niod:''},
{niod:'Groepsportretten', skos:broader, niod:'Portretten'},
{niod:'Straatpropaganda', skos:broader, niod:'Propaganda'},
{niod:'Staatsrecht', skos:broader, niod:'Recht'},
{niod:'Strafrecht', skos:broader, niod:'Recht'},
{niod:'Aftocht', skos:broader, niod:'Troepenbewegingen'},
{niod:'Intocht', skos:broader, niod:'Troepenbewegingen'},
{niod:'Opmars', skos:broader, niod:'Troepenbewegingen'},
{niod:'Georganiseerd_verzet', skos:broader, niod:'Verzet'},
{niod:'Gevechtsvliegtuigen', skos:broader, niod:'Vliegtuigen'},
{niod:'Transportvliegtuigen', skos:broader, niod:'Vliegtuigen'},
{niod:'Zweefvliegtuigen', skos:broader, niod:'Vliegtuigen'},
{niod:'Interbellum', skos:broader, niod:'Vooroorlogse_periode'},
{niod:'Oorlogsvrijwilligers', skos:broader, niod:'Vrijwilligers'},
{niod:'Atoomwapens', skos:broader, niod:'Wapens'},
{niod:'Geschut', skos:broader, niod:'Wapens'},
{niod:'Grondwet', skos:broader, niod:'Wetgeving'},
{niod:'Koninklijke_besluiten', skos:broader, niod:'Wetgeving'},
{niod:'Verordeningen', skos:broader, niod:'Wetgeving'},
{niod:'Radiozenders', skos:broader, niod:'Zenders'}.


rel_to_broader
@@
{S,skos:broader,O}\
{S,skos:related,O}
<=>
true.
*/

% --- UTILS ---
%
split_zie_ook_atom(' - Zie ook: ').
split_zie_ook_atom(' - Zie ook ').
split_zie_ook_atom(' -  Zie ook: ').
split_zie_ook_atom(': Zie ook:').
split_zie_ook_atom(' - Zie: ook:').


split_zie_ook(Lit, FirstPart, LastPart):-
	split_zie_ook_atom(Atom),
	sub_atom(Lit, Before, Len, _, Atom),

	sub_atom(Lit, 0, Before, _ , FirstPart),
	SecStart is Before + Len,
	sub_atom(Lit, SecStart, _, 0, LastPart).

split_zie_atom(' - Zie ').
split_zie_atom(' - Zie: ').
split_zie_atom(' -  Zie: ').
split_zie_atom(': Zie: ').
split_zie_atom(' - Zie:  ').


split_zie(Lit, FirstPart, LastPart):-
	split_zie_atom(Atom),
	sub_atom(Lit, Before, Len, _, Atom),
	sub_atom(Lit, 0, Before, _ , FirstPart),
	SecStart is Before + Len,
	sub_atom(Lit, SecStart, _, 0, LastPart).



clean_literal(Lit, CleanLit):-
	atom_chars(Lit,Chars),
	append(Rest,[' '],Chars),
	atom_chars(CleanLit1,Rest),
	clean_literal(CleanLit1,CleanLit).

clean_literal(Lit, CleanLit):-
	atom_chars(Lit,[' '|Rest]),
	atom_chars(CleanLit1,Rest),
	clean_literal(CleanLit1,CleanLit).


/* VIC TODO
clean_literal(Lit, CleanLit):-
	atom_chars(Lit,List),
	append(Pre,[' ',' '|Rest], List),
	append(Pre,[' '|Rest],CleanList),
	atom_chars(CleanLit1, CleanList),
	clean_literal(CleanLit1, CleanLit).
*/
clean_literal(Lit, Lit).


one_relation(Lit,OneLit):-
	atomic_list_concat(List, ',', Lit),
	member(Mem, List),
	clean_literal(Mem,OneLit).










