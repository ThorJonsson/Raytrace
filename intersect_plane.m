function [does_intersect t n p c] = intersect_plane(ray, plane, light)
% Notkun: [does_intersect t n p c] = intersect_plane(ray, plane)
% Inntak: ray er geisli meğ upphafspunkt og stefnu
%         plane er slétta
% Úttak:  does_intersect = true ef geisli sker sléttuna, annars false
%         t - stiki, fjarlægğ frá upphafspunkti geisla ağ skurğpunkti, t=-1 ef enginn skurğpunktur
%         n - şverill hlutar í skurğpunkti
%         p - skurğpunkturinn
%         c - litur í skurğpunkti

	if abs(dot(ray.direction,plane.normal)) < eps
		% eps er mjög smá tala viğ notum eps til ağ koma í veg fyrir námundun ağ núlli.
		% Enginn skurğpunktur,
		does_intersect = false;
		t = -1;
		n = [];
		p = [];
		c = [];
	else
		t=-dot(ray.origin,plane.normal)/dot(ray.direction,plane.normal);	
		
		if t > eps
			% Skurğpunktur fannst
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
