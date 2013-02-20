function [values, giveUp] = refine(op, values, pref)
%REFINE Refinement method for FUNCHEB2 construction.
%   VALUES = REFINE(OP, VALUES, PREF) determines the new VALUES of the operator
%   OP to be checked for happiness in the FUNCHEB2 construction process. The
%   exact procedure used is determined by PREF.FUNCHEB2.REFINEMENTFUNCTION.
%
%   [VALUES, GIVEUP] = REFINE(OP, VALUES, PREF) returns also a binary GIVEUP
%   flag where TRUE means the refinement procedure has failed (typically when
%   the maximum number of samples, PREF.FUNCHEB2.MAXSAMPLES, has been reached).
%
%   The two built-in refinement strategies are 'NESTED' and 'RESAMPLING'. The
%   former makes use of the nested property of the 2nd-kind grid by taking N
%   (the interpolation degree) to be 2^(3:16)+1 and doesn't resample previously
%   evaluated values. The latter uses grids of the form 2^(3:6 6:.5:16)+1 and
%   resamples all of the values each time N is increased. The 'RESAMPLING'
%   option should be used for functions which are not sampleable, for example,
%   anything that depends on the length of the input to OP.
%
%   Alternative refinement strategies can be used by pasing a function handle in
%   the pref.funcheb2.refinementStrategy field. The function handle should point
%   to a function with the template [VALUES, GIVEUP] = @(OP, VALUES, PREF) ...
%   which accepts a function handle OP, previously sampled values VALUES of OP
%   at a 2nd-kind Chebyshev grid, and PREF, a preference structure containing
%   FUNCHEB2 preferences. It should return either a new set of VALUES (typically
%   on a finer grid) or set the GIVEUP flag to TRUE.

% Copyright 2013 by The University of Oxford and The Chebfun Developers. 
% See http://www.chebfun.org/ for Chebfun information.

% Obtain some preferences:
if ( nargin < 3 )
    pref = funcheb2.pref;
end
% No values were given:
if ( nargin < 2 )
    values = [];
end

% Grab the refinement function from the preferences:
refFunc = pref.funcheb2.refinementFunction;

% Decide which refinement to use:
if ( strcmpi(refFunc, 'nested') )
    % Single/nested sampling:
    [values, giveUp] = refineNested(op, values, pref);
elseif ( strcmpi(refFunc, 'resampling') )
    % Double sampling:
    [values, giveUp] = refineResampling(op, values, pref);
else
    % User defined refinement function:
    [values, giveUp] = refFunc(op, values, pref);
end
    
end

function [values, giveUp] = refineResampling(op, values, pref)
%REFINERESAMPLING  Default refinement function for resampling scheme.

    if ( isempty(values) )
        % Choose initial n based upon minSamples:
        n = 2^ceil(log2(pref.funcheb2.minSamples) - 1) + 1;
    else
        % (Approximately) powers of sqrt(2):
        pow = log2(size(values, 1) - 1);
        if ( pow == floor(pow) && pow > 5 )
            n = round(2^(floor(pow) + .5)) + 1;
            n = n - mod(n, 2) + 1;
        else
            n = 2^(floor(pow)+1) + 1;
        end
    end
    
    % n is too large!
    if ( n > pref.funcheb2.maxSamples )
        giveUp = true;
        return
    else
        giveUp = false;
    end
   
    % 2nd-kind Chebyshev grid
    x = funcheb2.chebpts(n);

    % Evaluate the operator:
    if ( pref.funcheb2.extrapolate )
        valuesTemp = feval(op, x(2:n-1));
        nans = NaN(1, size(valuesTemp, 2));
        values = [nans ; valuesTemp ; nans];
    else
        values = feval(op, x);
    end

end

function [values, giveUp] = refineNested(op, values, pref)
%REFINENESTED  Default refinement function for single ('nested') sampling.

    if ( isempty(values) )
        % The first time we are called, there are no values and refineSingle is
        % the same as refineDouble.
        [values, giveUp] = refineResampling(op, values, pref);

    else
    
        % Compute new n by doubling (we must do this when not resampling).
        n = 2*size(values, 1) - 1;
        
        % n is too large!
        if ( n > pref.funcheb2.maxSamples )
            giveUp = true;
            return
        else
            giveUp = false;
        end
        
        % 2nd-kind Chebyshev grid:
        x = funcheb2.chebpts(n);
        % Take every 2nd entry:
        x = x(2:2:end-1);

        % Shift the stored values:
        values(1:2:n,:) = values;
        % Compute and insert new ones:
        values(2:2:end-1,:) = feval(op, x);

    end
end
