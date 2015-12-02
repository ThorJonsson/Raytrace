function [does_intersect t n p c] = intersect_sphere(ray, sphere);
% Notkun: [does_intersect t n p c] = intersect_sphere(ray, sphere);
% Inntak: ray er geisli með upphafspunkt og stefnu
%         sphere er kúla með staðsetningu, radíus og lit
% Úttak:  does_intersect = true ef geisli sker kúlu annars false
%         t - stiki, fjarlægð frá upphafspunkti geisla að skurðpunkti, t=-1 ef enginn skurðpunktur
%         n - þverill hlutar í skurðpunkti
%         p - skurðpunkturinn
%         c - litur í skurðpunkti
	
A = dot(ray.direction,ray.direction); 									% Innfeldi einingavigra gefur alltaf 1, þarna gæti því allt eins staðið 1.
B = 2*dot((ray.origin-sphere.position),ray.direction);							
C = dot((ray.origin-sphere.position),(ray.origin-sphere.position))-sphere.radius^2;

% Hér athugum við hversu langt er frá myndavél að kúlu

x = solve_equation(A,B,C);

% Hér finnum við skurðpunkta geislans og kúlunnar.

if length(x)==0
	% Engin lausn => engin skurðpunktur
	does_intersect = false;
	t = -1;
	n = [];
	p = [];
	c = [];																
else
	% Skurðpunktur
	does_intersect = true;
	t = min(x);															
	% min(x) gefur fjarlægðina að fremri hlutar kúlunnar, max(x) gefur fjarlægðina að bakhluta kúlunnnar
	c = sphere.color;
	p = ray.origin+t*ray.direction;
	n = p-sphere.position;
	n = n/norm(n);
endif


endfunction
