
function [b, r, tstats, adjusted_R2] = linregAdjust(Y, X)

% LINREGADJUST:
%   Multiple linear regression 
%
% USAGE:
%   Y -- Independent variable. 
%   X -- Dependent variable including constant
% 
% OUTPUT:
%   b --  OLS estimator b, Residual r and R-square.

[T, N] = size(X);
b      = (inv (X'*X) )*X'*Y;
r      = Y - X * b;
% tstats
covm   = (r'*r /(T - N)) * inv(X'*X);
tstats = b ./sqrt(diag(covm));

% Adjusted R2
SST    = cov(Y); 
SSE    = cov(r);
R2     = 1 - SSE/SST;
adjusted_R2 = 1 - ((T - 1)/(T - N)) * (1 - R2);


