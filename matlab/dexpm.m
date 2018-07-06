function [F,dF]=dexpm(M,dM)

% Lubomir Brancik (2008)
% Matlab programs for matrix exponential function derivative evaluation
% Technical Computing Prague 2008, 16th Annual Conference Proceedings

% Scale M by power of 2 so that its norm is < 1/2
[f, e] = log2(norm(M, 'inf'));
r = max(0, e + 1);
M = M/2^r; dM = dM/2^r;
% Pade approximation of exp(M) and diff[exp(M)]
X = M; Y = dM;
c = 1/2;
F = eye(size(M)) + c*M; dF = c*dM;
D = eye(size(M)) - c*M; dD = -c*dM;
q = 6;
p = 1;
for k = 2:q
    c = c*(q - k + 1)/(k*(2*q - k + 1));
    Y = dM*X + M*Y;
    X = M*X;
    cX = c*X; cY = c*Y;
    F = F + cX; dF = dF + cY;
    if p
        D = D + cX; dD = dD + cY;
    else
        D = D - cX; dD = dD - cY;
    end
    p = ~p;
end
F = D\F;
dF = D\(dF - dD*F);
% Undo scaling by repeated squaring
for k = 1:r
    dF = dF*F + F*dF;
    F = F*F;
end
