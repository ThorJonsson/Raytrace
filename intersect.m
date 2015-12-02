function color = intersect(ray, objects, light)
% Notkun: color = intersect(ray, objects, light)
% Inntak: ray er geisli sem hefur sta�setningu og stefnu.
%         objects er vigur sem inniheldur alla hluti � m�delinu
%         light er lj�sgjafi sem hefur stadsetningu
% �ttak:  color er litur � �eim punkti sem er n�stur upphafspunkti geislans

int_t = 100000;														% Max gildi � t
int_n = [0 0 0];													% Upphafsstilling � �verli (aldrei nota�)
int_p = [0 0 0];													% Upphafsstilling � skur�punkti (aldrei nota�)
int_c = [0.4078 0.2392 0.92157];									

% Litur ef enginn skur�punktur finnst, �.e.a.s litur "himins" (eins og � dagsbirtu � fallegum degi � j�r�inni).
																	% L er einingavigur sem stefnir fr� skur�punktinum a� lj�sgjafanum
																	% �verill hlutar � skur�punkti er n � skr�nni intersect_plane
																	% L = 1/abs(a) * a   - einingavigur samstefna a


does_intersect = false;

% Pr�fum alla hluti � listanum
for k=1:length(objects)
	intersect = false;												% Upphafsstilling � fallinu intersect - segir til um skur�punkt
	
	
	
	% Ef hluturinn er sl�tta athugum vi� hvort geislinn skeri sl�ttuna.
	if strcmp(objects(k).type,"plane")
		[intersect t n p c] = intersect_plane(ray, objects(k), light);	
		
	% Ef hluturinn er k�la athugum vi� hvort geislinn skeri k�luna.
	elseif strcmp(objects(k).type, "sphere")
		[intersect t n p c] = intersect_sphere(ray, objects(k), light);
	endif	
	
	% Viljum geyma uppl�singar um �ann skur�punktinn
	if intersect
		does_intersect = true;
		if t < int_t									
				int_t = t;								% H�r vistum vi� uppl�singar um fjarl�g� skur�punktar fr� upphafspunkti geisla 
				int_n = n;								% H�r vistum vi� uppl�singar um �veril � skur�punkt	
				int_p = p;								% H�r vistum vi� uppl�singar um sta�setningu skur�punkts
				int_c = c;								% H�r vistum vi� uppl�singar um lit � skur�punkti
		endif
	endif

endfor

%---------------------------------------------------------------------Skuggi---------------------------------------------------------------------------

% H�r b�tist vi� geislinn shadow_ray sem segir til um hvar skuggi � a� myndast
% Geislinn shadow_ray � s�r upphafspunkt � vistu�um skur�punkti, �.e. skur�punktinum sem er vista�ur h�r fyrir ofan. 

if does_intersect
			
L = abs(int_p - light.position)/norm(int_p - light.position);  		% H�r b�um vi� til einingavigur � stefnu lj�sgjafa fr� skur�punkti
			
shadow_ray.origin = int_p;											% Vistum skur�punkt sem upphafspunkt shadow_ray
shadow_ray.direction = L;											% Vistum stefnu shadow_ray sem einingavigurinn L

shadow = false;														% Upphafsstilling � gildi skugga

% H�r athugum vi� hvort shadow_ray hitti fyrir a�ra hluti � lei� sinni til lj�sgjafa
 
			for k=1:length(objects)									
			
				if strcmp(objects(k).type, "sphere")				% Ef shadow_ray sker k�lu �� skilar falli� uppl�singum um skur�punkt
					[intersect t n p c] = intersect_sphere(shadow_ray, objects(k), light);
				endif
				
				if intersect && t>0					% Ef fjarl�g�in a� lj�sgjafa er st�rri en 0 og skur�punktur er til sta�ar �� viljum vi� skugga 
					shadow = true;					
				endif
		
			endfor
			
	if shadow														
			int_c = int_c*0.3;				% Litur hlutar margfalda�ur me� 0.3 gefur n�lgun � umhverfislj�s � skugga
	elseif dot(int_n, L) < 0 ;				% Innfeldi� ver�ur neikv�tt ef horni� reiknast gleitt, � �eim skur�punktum viljum vi� a� dofnun lits komi fram
			int_c = 0.3*int_c;			
	else 
			int_c = dot(int_n,L)*0.7 + int_c*0.3;	% �etta gefur 70% lj�s fr� lj�sgjafa og 30% umhverfislj�s � lit skur�punktar.
	endif
		
endif	
	


% Athugum hvort a� vigur me� upphafspunkt � skur�punkti skeri k�luna. Ef punkturinn sker k�luna �� ver�ur punkturinn svartur


color = int_c;

endfunction
