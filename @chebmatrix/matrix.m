function varargout = matrix(A, varargin)
%MATRIX   Discretize a CHEBMATRIX as an ordinary matrix.
%   Important: A CHEBOPPREF object PREFS has to be passed. When this method
%   is called via CHEBOP/MATRIX, PREFS is inherited from the CHEBOP level.
%
%   M = MATRIX(A, DIM, PREFS) discretizes each block in the chebmatrix A using 
%   the dimension vector DIM for all functions. In case the domain of A has
%   breakpoints, the vector DIM must specify the desired discretization
%   dimension for each subinterval.
%
%   MATRIX(A, DIM, DOMAIN, PREFS) replaces the 'native' domain of A with DOMAIN.
%   Usually this would be done to introduce a breakpoint.
%
%   Example:
%     d = [0 1];
%     A = [ operatorBlock.eye(d), operatorBlock.diff(d) ];
%     prefs = cheboppref();
%     prefs.discretization = @chebcolloc2;
%     matrix(A, 5, prefs)
%
% See also CHEBOPPREF, OPDISCRETIZATION, OPDISCRETIZATION/MATRIX. 

% Copyright 2015 by The University of Oxford and The Chebfun Developers.
% See http://www.chebfun.org/ for Chebfun information.

% Any non-numeric argument should be a opDiscretization constructor. 
discType = [];
numericargs = cellfun(@isnumeric, varargin);
for k = find( ~numericargs(:)' )
    discType = varargin{k};
    varargin(k) = [];  % Delete from list.
end

% Get the default discretization type if needed.
if ( isempty(discType) )
    p = cheboppref;
    discType = p.discretization;
end

% Deal with a 'values' or 'coeffs' discType.
if ( ischar(discType) )
    if ( strcmp(discType, 'values') )
        discType = @chebcolloc2;
    elseif ( strcmp(discType, 'coeffs') )
        discType = @ultraS;
    end
end

% Discretize:
d = discType(A, varargin{:});
[varargout{1:nargout}] = matrix(d);

end
