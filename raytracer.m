close all	% Lokum �llum opnum myndum
clear all	% Hreinsum allar breytur
clc		% Hreinsum Octave skipana gluggan

%------------------------------------------------------------Uppl�singar------------------------------------------------------------------------------------
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

resolution = input('Veldu upplausn fyrir myndina: ');			% H�r velur notandi upplausn - Upplausn � mynd resolution x resolution 


%
% Setjum upp m�deli� okkar � 3D
% �mynda�ur gluggi sams��a y-z sl�ttunni me� efra vinstra horn � (x,y,z) = (1,-1,3)
my_window_upper_left = [1 -1 3];

% Myndav�l
my_camera.position = [2 0 2];									% Sta�sett � (x,y,z) = (2,0,2)
my_camera.direction = [-1 0 0];									% Mi�a� ni�ur eftir x-�s

% Lj�sgjafi
my_light_source.position = [-9 -5 17];							% Sta�setning lj�sgjafa

%-------------------------------------------------------------My_Objects-------------------------------------------------------------------------------------

% Eftirfarandi hlutir (sl�tta og k�lur) eru st�k � menginu my_objects. Hlutirnir ver�a a� hafa sama fj�lda s�mu eiginleika, af �eim ors�kum b�um vi� til eiginleika sem a� koma ekki endilega til me� a� n�tast. 
% xy sl�tta

my_plane.type = "plane";
my_plane.position = [0 0 0];									% Plan � gegnum (x,y,z) = (0,0,0)
my_plane.normal = [0 0 1];										% �verill � sl�ttuna � stefnu z-�ss
my_plane.color = [0.9765 1 0.03529];							% Litur sl�ttunnar - gulur
my_plane.radius  = 0;											% �etta ver�ur aldrei nota� en er nau�synlegt s�kum ofangreindra �st��na



% Byrjum � �v� a� l�ta k�luna hafa sta�setningu beint undir lj�sgjafa me� rad�us 1

my_sphere.type = "sphere";										
my_sphere.position = [-9 -1 5];									% Mi�ja k�lunnar 
my_sphere.radius = 2;											% Rad�us k�lunnar
my_sphere.color = [0.78 0.78 0.78];								% Litur k�lunnar - Silfur
my_sphere.normal = [0 0 1];										% �etta ver�ur aldrei nota�


%B�tum vi� annari k�lu

my_sphere2.type = "sphere";
my_sphere2.position = [-9 2 8];									% Mi�ja k�lunnar
my_sphere2.radius = 1.5; 										% Rad�us k�lunnar
my_sphere2.color = [0.392 0 0];									% Litur k�lunnar - V�nrau�ur
my_sphere2.normal = [0 0 1];									% �etta ver�ur aldrei nota�

% B�tum vi� �ri�ju k�lu

my_sphere3.type = "sphere";
my_sphere3.position = [-9 -5 4];								% Mi�ja k�lunnar
my_sphere3.radius = 0.55; 										% Rad�us k�lunnar
my_sphere3.color = [0 0.392 0];									% Litur k�lunnar - D�kkgr�nn
my_sphere3.normal = [0 0 1];									% �etta ver�ur aldrei nota�


% B�tum vi� fj�r�u k�lu

my_sphere4.type = "sphere";
my_sphere4.position = [-1.5 2 3.5];								% Mi�ja k�lunnar
my_sphere4.radius = 0.55; 										% Rad�us k�lunnar
my_sphere4.color = [0 0 0.78];									% Litur k�lunnar - Bl�r
my_sphere4.normal = [0 0 1];									% �etta ver�ur aldrei nota�


my_objects = [my_sphere, my_plane, my_sphere2, my_sphere3, my_sphere4];		% Listi me� �llum hlutum � m�delinu

%-----------------------------------------------------------------Framk�llun----------------------------------------------------------------------------------

my_image = zeros(resolution, resolution);										% Fylki sem t�knar myndina - n�llvigur � byrjun
																				% Myndin ver�ur resolution^2 margir pixlar
					
% Myndav�lin er f�st �  x-�s og ef vi� b�tum vi� dx �� f�rist sj�nsvi� myndav�larinnar framar

dy = [0 2/resolution 0];														% Breyting � stefnu y-�ss fyrir hvern pixel

% Myndav�lin byrjar � �v� a� mynda efsta glugga til vinstri og f�rist til h�gri eftir y-�s. 

dz = [0 0 -2/resolution];														% Breyting � stefnu z-�ss fyrir hvern pixel

% Myndav�lin byrjar � �v� a� mynda efsta glugga til vinstri og f�rist ni�ur eftir z-�s.

cam_to_upper_left = my_window_upper_left - my_camera.position;					% Vigur fr� myndav�l a� efra vinstra horni "myndar"

tic() 																			% H�r hefst t�mam�ling � �v� hversu langan t�ma �a� tekur a� framkalla myndina

% �essi lykkja b�r til geisla og sk�tur honum � gegnum hvern reit (pixel) � m�delinu.
% Lykkjan samanstendur af tveimur forlykkjum sem gera �a� a� verkum a� myndav�lin skannar umhverfi sitt kerfisbundi� fr� vinstri til h�gri, l�nu fyrir l�nu.
																				
																				% r fyrir l�nur
litaspjald = [];																% litaspjald - Upphafsstilling: n�llvigur
																				
for r=1:resolution
																				% s fyrir d�lka
	for s=1:resolution
																				% N� stefna b�in til
		new_dir = cam_to_upper_left + (r-1)*dz + (s-1)*dy;						
		new_dir = new_dir/norm(new_dir);										% Til a� segja til um stefnu �arf vigurinn a� vera einingavigur.
		
		% Norm(Vigur) - lengd vigurs - me� �v� a� deila vigri me� lengd sinni f�st einingavigur.
		
																				% N�r geisli b�inn til me� n�rri stefnu
		my_ray.origin = my_camera.position;										% Vi� "myndum" me� �v� a� skj�ta geislum �r myndav�linni.
		my_ray.direction = new_dir;												
		% Geislar myndav�larinnar beinast a� reitum (pixlum) �eim er myndin er samsett �r
		
		% Inntak litaspjaldsins er falli� intersect sem a� skilar uppl�singum um �a� sem ver�ur fyrir geislum myndav�larinnar, litur m�tast skv. fallinu. 
		litaspjald = [litaspjald; intersect(my_ray, my_objects, my_light_source)];
		
																				% Reitur lita�ur samkv�mt fyrsta skur�punkti
		my_image(r,s) = size(litaspjald)(1);								%H�r er st�r� litaspjaldssins okkar �kve�in. Litaspjaldi� hefur fj�lda reita(pixla)
	endfor
endfor
timi = toc() 																			% H�r l�kur t�mam�lingu  
printf('Framkollun tok %f sekundur \n', timi)											% T�mauppl�singar a� lokinni framk�llun
printf('Minnkadu upplausnina naest ef thu varst or�in/nn treyttur a ad bida! \n')		%Notendavi�m�t!

colormap(litaspjald)
image(my_image)
axis equal
axis off
