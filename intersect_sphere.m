function [does_intersect t n p c] = intersect_sphere(ray, sphere);
% Notkun: [does_intersect t n p c] = intersect_sphere(ray, sphere);
% Inntak: ray er geisli me� upphafspunkt og stefnu
%         sphere er k�la me� sta�setningu, rad�us og lit
% �ttak:  does_intersect = true ef geisli sker k�lu annars false
%         t - stiki, fjarl�g� fr� upphafspunkti geisla a� skur�punkti, t=-1 ef enginn skur�punktur
%         n - �verill hlutar � skur�punkti
%         p - skur�punkturinn
%         c - litur � skur�punkti
	
A = dot(ray.direction,ray.direction); 									% Innfeldi einingavigra gefur alltaf 1, �arna g�ti �v� allt eins sta�i� 1.
B = 2*dot((ray.origin-sphere.position),ray.direction);							
C = dot((ray.origin-sphere.position),(ray.origin-sphere.position))-sphere.radius^2;

% H�r athugum vi� hversu langt er fr� myndav�l a� k�lu

x = solve_equation(A,B,C);

% H�r finnum vi� skur�punkta geislans og k�lunnar.

if length(x)==0
	% Engin lausn => engin skur�punktur
	does_intersect = false;
	t = -1;
	n = [];
	p = [];
	c = [];																
else
	% Skur�punktur
	does_intersect = true;
	t = min(x);															
	% min(x) gefur fjarl�g�ina a� fremri hlutar k�lunnar, max(x) gefur fjarl�g�ina a� bakhluta k�lunnnar
	c = sphere.color;
	p = ray.origin+t*ray.direction;
	n = p-sphere.position;
	n = n/norm(n);
endif


endfunction
