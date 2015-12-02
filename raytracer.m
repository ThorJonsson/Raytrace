close all	% Lokum öllum opnum myndum
clear all	% Hreinsum allar breytur
clc		% Hreinsum Octave skipana gluggan

%------------------------------------------------------------Upplýsingar------------------------------------------------------------------------------------
fprintf(stderr, 'VELKOMINN I BOLTALAND!!! \n')
pause(3);
fprintf(stderr,'Tetta er verkefni i tolvustaerdfraedi a voronn i Menntaskolanum a Akureyri 2012.') 
pause(0);
fprintf(stderr,'Hofundar eru Hrolfur Asmundsson 4.T & Thorsteinn Hjortur Jonsson 4.X \n')
pause(0);
fprintf(stderr,'Tetta forrit framkallar kulur i 3D (raytracer) \n')
pause(0);
fprintf(stderr,'Tu getur valid upplausn myndarinnar. \n')
pause(4);

resolution = input('Veldu upplausn fyrir myndina: ');			% Hér velur notandi upplausn - Upplausn á mynd resolution x resolution 


%
% Setjum upp módelið okkar í 3D
% Ímyndaður gluggi samsíða y-z sléttunni með efra vinstra horn í (x,y,z) = (1,-1,3)
my_window_upper_left = [1 -1 3];

% Myndavél
my_camera.position = [2 0 2];									% Staðsett í (x,y,z) = (2,0,2)
my_camera.direction = [-1 0 0];									% Miðað niður eftir x-ás

% Ljósgjafi
my_light_source.position = [-9 -5 17];							% Staðsetning ljósgjafa

%-------------------------------------------------------------My_Objects-------------------------------------------------------------------------------------

% Eftirfarandi hlutir (slétta og kúlur) eru stök í menginu my_objects. Hlutirnir verða að hafa sama fjölda sömu eiginleika, af þeim orsökum búum við til eiginleika sem að koma ekki endilega til með að nýtast. 
% xy slétta

my_plane.type = "plane";
my_plane.position = [0 0 0];									% Plan í gegnum (x,y,z) = (0,0,0)
my_plane.normal = [0 0 1];										% Þverill á sléttuna í stefnu z-áss
my_plane.color = [0.9765 1 0.03529];							% Litur sléttunnar - gulur
my_plane.radius  = 0;											% Þetta verður aldrei notað en er nauðsynlegt sökum ofangreindra ástæðna



% Byrjum á því að láta kúluna hafa staðsetningu beint undir ljósgjafa með radíus 1

my_sphere.type = "sphere";										
my_sphere.position = [-9 -1 5];									% Miðja kúlunnar 
my_sphere.radius = 2;											% Radíus kúlunnar
my_sphere.color = [0.78 0.78 0.78];								% Litur kúlunnar - Silfur
my_sphere.normal = [0 0 1];										% Þetta verður aldrei notað


%Bætum við annari kúlu

my_sphere2.type = "sphere";
my_sphere2.position = [-9 2 8];									% Miðja kúlunnar
my_sphere2.radius = 1.5; 										% Radíus kúlunnar
my_sphere2.color = [0.392 0 0];									% Litur kúlunnar - Vínrauður
my_sphere2.normal = [0 0 1];									% Þetta verður aldrei notað

% Bætum við þriðju kúlu

my_sphere3.type = "sphere";
my_sphere3.position = [-9 -5 4];								% Miðja kúlunnar
my_sphere3.radius = 0.55; 										% Radíus kúlunnar
my_sphere3.color = [0 0.392 0];									% Litur kúlunnar - Dökkgrænn
my_sphere3.normal = [0 0 1];									% Þetta verður aldrei notað


% Bætum við fjórðu kúlu

my_sphere4.type = "sphere";
my_sphere4.position = [-1.5 2 3.5];								% Miðja kúlunnar
my_sphere4.radius = 0.55; 										% Radíus kúlunnar
my_sphere4.color = [0 0 0.78];									% Litur kúlunnar - Blár
my_sphere4.normal = [0 0 1];									% Þetta verður aldrei notað


my_objects = [my_sphere, my_plane, my_sphere2, my_sphere3, my_sphere4];		% Listi með öllum hlutum í módelinu

%-----------------------------------------------------------------Framköllun----------------------------------------------------------------------------------

my_image = zeros(resolution, resolution);										% Fylki sem táknar myndina - núllvigur í byrjun
																				% Myndin verður resolution^2 margir pixlar
					
% Myndavélin er föst á  x-ás og ef við bætum við dx þá færist sjónsvið myndavélarinnar framar

dy = [0 2/resolution 0];														% Breyting í stefnu y-áss fyrir hvern pixel

% Myndavélin byrjar á því að mynda efsta glugga til vinstri og færist til hægri eftir y-ás. 

dz = [0 0 -2/resolution];														% Breyting í stefnu z-áss fyrir hvern pixel

% Myndavélin byrjar á því að mynda efsta glugga til vinstri og færist niður eftir z-ás.

cam_to_upper_left = my_window_upper_left - my_camera.position;					% Vigur frá myndavél að efra vinstra horni "myndar"

tic() 																			% Hér hefst tímamæling á því hversu langan tíma það tekur að framkalla myndina

% Þessi lykkja býr til geisla og skýtur honum í gegnum hvern reit (pixel) í módelinu.
% Lykkjan samanstendur af tveimur forlykkjum sem gera það að verkum að myndavélin skannar umhverfi sitt kerfisbundið frá vinstri til hægri, línu fyrir línu.
																				
																				% r fyrir línur
litaspjald = [];																% litaspjald - Upphafsstilling: núllvigur
																				
for r=1:resolution
																				% s fyrir dálka
	for s=1:resolution
																				% Ný stefna búin til
		new_dir = cam_to_upper_left + (r-1)*dz + (s-1)*dy;						
		new_dir = new_dir/norm(new_dir);										% Til að segja til um stefnu þarf vigurinn að vera einingavigur.
		
		% Norm(Vigur) - lengd vigurs - með því að deila vigri með lengd sinni fæst einingavigur.
		
																				% Nýr geisli búinn til með nýrri stefnu
		my_ray.origin = my_camera.position;										% Við "myndum" með því að skjóta geislum úr myndavélinni.
		my_ray.direction = new_dir;												
		% Geislar myndavélarinnar beinast að reitum (pixlum) þeim er myndin er samsett úr
		
		% Inntak litaspjaldsins er fallið intersect sem að skilar upplýsingum um það sem verður fyrir geislum myndavélarinnar, litur mótast skv. fallinu. 
		litaspjald = [litaspjald; intersect(my_ray, my_objects, my_light_source)];
		
																				% Reitur litaður samkvæmt fyrsta skurðpunkti
		my_image(r,s) = size(litaspjald)(1);								%Hér er stærð litaspjaldssins okkar ákveðin. Litaspjaldið hefur fjölda reita(pixla)
	endfor
endfor
timi = toc() 																			% Hér lýkur tímamælingu  
printf('Framkollun tok %f sekundur \n', timi)											% Tímaupplýsingar að lokinni framköllun
printf('Minnkadu upplausnina naest ef thu varst orðin/nn treyttur a ad bida! \n')		%Notendaviðmót!

colormap(litaspjald)
image(my_image)
axis equal
axis off
