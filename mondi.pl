﻿:- dynamic(size/1).
:- dynamic(mondo/1).

section(generazione).
% Generazione random del mondo

% Genera un mondo casuale, di dimensione Dim
genera_mondo(Dim) :-
	not(between(2,10,Dim)), !,
	writeln("Errore, inserisci un valore della dimensione compreso tra 2 e 10")
	;
	retractall(size(_)),
	retractall(mondo(_)),
	assert(size(Dim)),
	assert(mondo(p(1,1,agente,vuoto))),
	forall(between(2,Dim,X1),
	       (
	           casella_random(T,O),
		   assert(mondo(p(1,X1,T,O)))
	       )
	      ),
	Dim2 is Dim-1,
	forall(between(2,Dim2,X2),
	       (
	       forall(between(1,Dim,X3),
		      (
			  casella_random(T,O),
			  assert(mondo(p(X2,X3,T,O)))
		      )
		     )
	       )),
	forall(between(1,Dim2,X4),
	       (
	           casella_random(T,O),
		   assert(mondo(p(Dim,X4,T,O)))
	       )
	      ),
	assert(mondo(p(Dim,Dim,goal,vuoto))).

% Stampa il mondo come elenco di caselle
get_mondo(X) :- mondo(X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(random).
% Generazione random delle caselle

% Genera una casella casuale
casella_random(T,O) :-
	terreno_random(T),
	(
	    (
	        T = cielo;
	        T = mare
	    ), !,
	    O = vuoto
	    ;
	    T = deserto, !,
	    oggetto_d_random(O)
	    ;
	    oggetto_random(O)
	).

% Genera un terreno casuale
terreno_random(R) :-
	random(1,7,X),
	associa_t(X,R).

associa_t(1,mare) :- !.
associa_t(2,cielo) :- !.
associa_t(X,foresta) :-
	between(3,4,X), !.
associa_t(Y,deserto) :-
	between(5,6,Y).

% Genera un oggetto casuale (foresta)
oggetto_random(O) :-
	random(1,11,X),
	associa_o(X,O).

associa_o(1,carro) :- !.
associa_o(2,barca) :- !.
associa_o(3,aereo) :- !.
associa_o(4,magnete) :- !.
associa_o(X,vuoto) :-
	between(5,10,X).

% Genera un oggetto casuale (deserto)
oggetto_d_random(O) :-
	random(1,10,X),
	associa_o_d(X,O).

associa_o_d(1, barca) :- !.
associa_o_d(2, aereo) :- !.
associa_o_d(3, magnete) :- !.
associa_o_d(X, vuoto) :-
	between(4,9,X).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

section(visualizzazione).
% Visualizzazione di un mondo

% Associa ad ogni terreno/oggetto un simbolo
significa(1,cielo).
significa(2,mare).
significa(3,foresta).
significa(4,deserto).
significa('A',aereo).
significa('B',barca).
significa('C',carro).
significa('M',magnete).
significa('R',agente).
significa('G',goal).
significa(-,vuoto).

% Stampa il mondo caricato in base dati dinamica
stampa_mondo :-
	size(D),

	write('|'),
	forall(between(1,D,K1),
	       (
		   K1 is D, !,
		   writeln('----|')
		   ;
		   write('----|')
	       )
	      ),

	forall(between(1,D,Row),
	       (
		   write('|'),
		   forall(between(1,D,Col),
			  (
			      mondo(p(Row,Col,T,O)),
			      significa(T1,T),
			      significa(O1,O),
			      write(' '),
			      write(T1),
			      write(O1),
			      write(' '),
			      (
			      Col is D, !,
			      writeln('|')
			      ;
			      write('|')
			      )
			  )
			 ),

		   write('|'),
		   forall(between(1,D,K2),
			  (
			      K2 is D, !,
			      writeln('----|')
			      ;
			      write('----|')
			  )
			 )
	       )
	      ).