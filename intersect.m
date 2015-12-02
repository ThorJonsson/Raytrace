function color = intersect(ray, objects, light)
% Notkun: color = intersect(ray, objects, light)
% Inntak: ray er geisli sem hefur staðsetningu og stefnu.
%         objects er vigur sem inniheldur alla hluti í módelinu
%         light er ljósgjafi sem hefur stadsetningu
% Úttak:  color er litur á þeim punkti sem er næstur upphafspunkti geislans

int_t = 100000;														% Max gildi á t
int_n = [0 0 0];													% Upphafsstilling á þverli (aldrei notað)
int_p = [0 0 0];													% Upphafsstilling á skurðpunkti (aldrei notað)
int_c = [0.4078 0.2392 0.92157];									

% Litur ef enginn skurðpunktur finnst, þ.e.a.s litur "himins" (eins og í dagsbirtu á fallegum degi á jörðinni).
																	% L er einingavigur sem stefnir frá skurðpunktinum að ljósgjafanum
																	% Þverill hlutar í skurðpunkti er n í skránni intersect_plane
																	% L = 1/abs(a) * a   - einingavigur samstefna a


does_intersect = false;

% Prófum alla hluti í listanum
for k=1:length(objects)
	intersect = false;												% Upphafsstilling á fallinu intersect - segir til um skurðpunkt
	
	
	
	% Ef hluturinn er slétta athugum við hvort geislinn skeri sléttuna.
	if strcmp(objects(k).type,"plane")
		[intersect t n p c] = intersect_plane(ray, objects(k), light);	
		
	% Ef hluturinn er kúla athugum við hvort geislinn skeri kúluna.
	elseif strcmp(objects(k).type, "sphere")
		[intersect t n p c] = intersect_sphere(ray, objects(k), light);
	endif	
	
	% Viljum geyma upplýsingar um þann skurðpunktinn
	if intersect
		does_intersect = true;
		if t < int_t									
				int_t = t;								% Hér vistum við upplýsingar um fjarlægð skurðpunktar frá upphafspunkti geisla 
				int_n = n;								% Hér vistum við upplýsingar um þveril á skurðpunkt	
				int_p = p;								% Hér vistum við upplýsingar um staðsetningu skurðpunkts
				int_c = c;								% Hér vistum við upplýsingar um lit í skurðpunkti
		endif
	endif

endfor

%---------------------------------------------------------------------Skuggi---------------------------------------------------------------------------

% Hér bætist við geislinn shadow_ray sem segir til um hvar skuggi á að myndast
% Geislinn shadow_ray á sér upphafspunkt í vistuðum skurðpunkti, þ.e. skurðpunktinum sem er vistaður hér fyrir ofan. 

if does_intersect
			
L = abs(int_p - light.position)/norm(int_p - light.position);  		% Hér búum við til einingavigur í stefnu ljósgjafa frá skurðpunkti
			
shadow_ray.origin = int_p;											% Vistum skurðpunkt sem upphafspunkt shadow_ray
shadow_ray.direction = L;											% Vistum stefnu shadow_ray sem einingavigurinn L

shadow = false;														% Upphafsstilling á gildi skugga

% Hér athugum við hvort shadow_ray hitti fyrir aðra hluti á leið sinni til ljósgjafa
 
			for k=1:length(objects)									
			
				if strcmp(objects(k).type, "sphere")				% Ef shadow_ray sker kúlu þá skilar fallið upplýsingum um skurðpunkt
					[intersect t n p c] = intersect_sphere(shadow_ray, objects(k), light);
				endif
				
				if intersect && t>0					% Ef fjarlægðin að ljósgjafa er stærri en 0 og skurðpunktur er til staðar þá viljum við skugga 
					shadow = true;					
				endif
		
			endfor
			
	if shadow														
			int_c = int_c*0.3;				% Litur hlutar margfaldaður með 0.3 gefur nálgun á umhverfisljós í skugga
	elseif dot(int_n, L) < 0 ;				% Innfeldið verður neikvætt ef hornið reiknast gleitt, í þeim skurðpunktum viljum við að dofnun lits komi fram
			int_c = 0.3*int_c;			
	else 
			int_c = dot(int_n,L)*0.7 + int_c*0.3;	% Þetta gefur 70% ljós frá ljósgjafa og 30% umhverfisljós í lit skurðpunktar.
	endif
		
endif	
	


% Athugum hvort að vigur með upphafspunkt í skurðpunkti skeri kúluna. Ef punkturinn sker kúluna þá verður punkturinn svartur


color = int_c;

endfunction
