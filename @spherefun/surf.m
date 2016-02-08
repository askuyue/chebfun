function varargout = surf( f, varargin )
%SURF  Surface plot of a SPHEREFUN.
%   SURF( F ) plots F on the surface of a sphere.
%
%   SURF(X, Y, F, ...) calls separableApprox/SURF.  See this function for
%   details.
%
%   SURF(..., 'PropertyName', PropertyValue,...) sets the value of the specified
%   surface property. Multiple property values can be set with a single
%   statement.
%
%   SURF(..., 'earth') includes the outline of the landmasses of earth on
%   the surface plot.
%
%   H = SURF(...) returns a handle to a surface plot object.
%
% See also SEPARABLEAPPROX/SURF, PLOT.

% Empty check:
if ( isempty(f) )
    h = surf([]);
    if ( nargout == 1 )
        varargout = {h};
    end
    return
end

% How dense to make the samples.
minPlotNum = 200;
defaultOpts = {'facecolor', 'interp', 'edgealpha', .5, 'edgecolor', 'none'};
% Plot the land masses of earth
plotEarth = false;

% Number of points to plot
j = 1; argin = {};
while ( ~isempty(varargin) )
    if strcmpi(varargin{1}, 'numpts')
        minPlotNum = varargin{2};
        varargin(1:2) = [];
    elseif strcmpi(varargin{1}, 'earth')
        plotEarth = true;
        varargin(1) = [];
    else
        argin{j} = varargin{1};
        varargin(1) = [];
        j = j+1;
    end
end

if ( isempty(argin) )
    argin = {};
end

if ( isa(f,'spherefun') )
    
    if ( (nargin == 1) || ...
            ( (nargin > 1) && ~isempty(argin) && ~isa(argin{1}, 'separableApprox') ) || ...
            ( (nargin == 3) && isempty(argin)) ) || ...
            ( (nargin == 2) && plotEarth == true )
        % surf(f,...)
        
        dom = f.domain;
        l = linspace(dom(1), dom(2), minPlotNum);
        t = linspace(dom(3), dom(4), minPlotNum);
        C = fevalm(f, l, t); 
        [ll, tt] = meshgrid(l, t);
        % Adjust tt if the domain is colatitude
        if iscolat( f )
            tt = pi/2 - tt;
        end
        [xx,yy,zz] = sph2cart(ll,tt,ones(size(ll)));
        % Make some corrections to C for prettier plotting.
        if ( norm(C - C(1,1),inf) < 1e-10 )
            % If vals are very close up to round off then the color scale is
            % hugely distorted. This fixes that.
            [n, m] = size(C);
            C = C(1,1)*ones(n, m);
        end
        h = surf(xx, yy, zz, C, defaultOpts{:}, argin{:});
        xlim([-1 1]), ylim([-1 1]), zlim([-1 1])
        % Make the aspect ratio equal if the plot is not currently being
        % held.
        if ( ~ishold )
            daspect([1 1 1]);
        end
        
        if ( plotEarth )
            % Land masses are stored in the data file CoastData.mat
            x = load('CoastData.mat','coast');
            if ( ~ishold )
                hold on;
                plot3(x.coast(:,1),x.coast(:,2),x.coast(:,3),'k-');
                hold off
            end
        end
    else
        % Pass this along to the surf function in separableApprox.
        h = surf@separableApprox( f, varargin{:} );
    end
end

if ( nargout > 0 )
    varargout = {h};
end

end