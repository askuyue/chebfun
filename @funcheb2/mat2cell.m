function g = mat2cell(f, M, N)
%MAT2CELL  Convert a vector-valued FUNCHEB2 into an ARRAY of FUNCHEB2 objects.
%
%   G = MAT2CELL(F, C) breaks up the vector-valued FUNCHEB2 F into a single row
%   cell array G of FUNCHEB2 objects. C is the vector of column sizes, and if F
%   has COL columns this must sum to COL. The elements of C determine the size
%   of each cell in G, subject to the following formula for I = 1:LENGTH(C),
%               SIZE(C{I},2) == C(I).
%
%   G = MAT2CELL(F) will assume that C = ones(1, COL).
%
%   G = MAT2CELL(F, M, N) is similar to above, but allows three input arguments
%   so as to be consistent with the built in MAT2CELL function. Here N takes the
%   role of C above, and M should be either the scalar value 1.
%
% Example:
%   f = funcheb2(@(x) [sin(x), cos(x), exp(x), x])
%   g = mat2cell(f, 1, [1 2 1])
%
% See also CELL2MAT.
%
% Copyright 2013 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Return an empty result:
if ( isempty(f) )
    g = f;
    return
end

% Get the size of the values matrix:
[n, m] = size(f.values);

% Parse the inputs:
if ( nargin == 1 )
    M = 1;
    N = ones(1, m);
elseif ( nargin == 2) 
    N = M;
    M = 1;
end

if ( ~isscalar(M) || M ~= 1)
    error('CHEBFUN:FUNCHEB2:mat2cell:size', ...
        ['Input arguments, D1 through D2, must sum to each dimension of the', ...
        ' input matrix size, [1,%d].'], size(f.values, 2));
end

% Split the values and the coeffs into cells of the correct size:
values = mat2cell(f.values, n*M, N);
coeffs = mat2cell(f.coeffs, n*M, N);

% Initialise the funcheb2 array:
g(numel(M),numel(N)) = funcheb2();

% Append the data to the new entries in the array:
for k = 1:numel(N)
    g(k).epslevel = f.epslevel;
    g(k).ishappy = f.ishappy;
    g(k).vscale = f.vscale;
    g(k).values = values{k};
    g(k).coeffs = coeffs{k};
end

end