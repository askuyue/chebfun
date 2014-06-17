function w = quadwts(n)
%QUADWTS   Quadrature weights for equally spaced points from [-1,1).
%   QUADWTS(N) returns the N weights for trapezoid rule.
%
% See also FOURPTS, BARYWTS.

% Copyright 2014 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org for Chebfun information.

w = 2/n*ones(1, n);

end