function x = solve_equation(A,B,C)
% Notkun: x = solve_equation(A,B,C)
% Inntak: Stuðlar annars stigs jöfnu A, B og C
% Úttak:  x er tómur vigur ef engar rauntölulausnir fundust
%         x inniheldur eina eða tvær rauntölulausnir ef þær finnast

% Hér finnum við lausnir á annars stigs margliðu - Útskýringar óþarfar.

D = B^2-4*A*C;

if D<0
	x = [];
elseif D==0
	x = -B/(2*A);
else
	x(1) = (-B+sqrt(D))/(2*A);
	x(2) = (-B-sqrt(D))/(2*A);
endif

endfunction
