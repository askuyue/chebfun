function out = points(f)
%POINTS  Return the points used by a FUNCHEB.
%
%   POINTS(F) or F.POINTS() returns the Chebyshev points used by F. This is
%   equivalent to F.chebpts(length(F)).
%
% See also CHEBPTS, LENGTH.
%
% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

out = f.chebpts(length(f));