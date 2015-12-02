function [does_intersect t n p c] = intersect_plane(ray, plane, light)
% Notkun: [does_intersect t n p c] = intersect_plane(ray, plane)
% Inntak: ray er geisli me� upphafspunkt og stefnu
%         plane er sl�tta
% �ttak:  does_intersect = true ef geisli sker sl�ttuna, annars false
%         t - stiki, fjarl�g� fr� upphafspunkti geisla a� skur�punkti, t=-1 ef enginn skur�punktur
%         n - �verill hlutar � skur�punkti
%         p - skur�punkturinn
%         c - litur � skur�punkti

	if abs(dot(ray.direction,plane.normal)) < eps
		% eps er mj�g sm� tala vi� notum eps til a� koma � veg fyrir n�mundun a� n�lli.
		% Enginn skur�punktur,
		does_intersect = false;
		t = -1;
		n = [];
		p = [];
		c = [];
	else
		t=-dot(ray.origin,plane.normal)/dot(ray.direction,plane.normal);	
		
		if t > eps
			% Skur�punktur fannst
			does_intersect = true;
			n = plane.normal;
			p = ray.origin+t*ray.direction;
			c = plane.color;
		else
			does_intersect = false;
			t = -1;
			n = [];
			p = [];
			c = [];
		endif
	endif


endfunction
