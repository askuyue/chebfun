function pass = test_times( pref ) 
% Test contour

if ( nargin == 0) 
    pref = chebfun2pref; 
end

tol = 1000*pref.eps; 
j = 1; 

f = chebfun2(@(x,y) cos(x.*y)); 
h = chebfun2(@(x,y) 2*cos(x.*y)); 
k = chebfun2(@(x,y) cos(x.*y).^2); 

pass(j) = norm( f.*2 - h ) < tol; j = j + 1; 
pass(j) = norm( f*2 - h ) < tol; j = j + 1; 
pass(j) = norm( 2*f - h ) < tol; j = j + 1; 
pass(j) = norm( 2.*f - h ) < tol; j = j + 1; 
pass(j) = norm( f.^2 - k ) < tol; j = j + 1; 
pass(j) = norm( f.*f - k ) < tol; j = j + 1;

D = [-1 1 -1 1; -2 2 -2 2; -1 pi 0 2*pi];
for r = 1:size(D,1)
    f = chebfun2(@(x,y) cos(x.*y), D(r,:));
    g = chebfun2(@(x,y) x + y + x.*y, D(r,:));
    FtimesG = chebfun2(@(x,y) cos(x.*y).*(x + y + x.*y), D(r,:) );
    tolr = norm(D(r,:),inf)*tol;
    pass(j) = ( norm( f.*g - FtimesG ) < 10*tolr ); j = j + 1;
end

end