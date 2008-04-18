# GNU Octave code to solve a simple two-state two-action dynamic discrete
# choice model via value function iteration.
#
# Jason Blevins <jrblevin@sdf.lonestar.org>
# Carrboro, April 14, 2008

clear;

# Applies the Bellman operator for the choice-specific value function V(a, s).
function V = func(Vold, u, P, beta)
  maxval = zeros(size(Vold,1));
  maxval(1) = max(Vold(:,1));
  maxval(2) = max(Vold(:,2));

  # Fix scaling, state-wise.
  Vold(:,1) = Vold(:,1) - maxval(1);
  Vold(:,2) = Vold(:,2) - maxval(2);

  # Apply the Bellman operator.
  for a = 1:2
    for s = 1:2
      V(a, s) = u(a, s) \
          + beta * log(exp(Vold(1,1)) + exp(Vold(2,1))) * P(1, s, a) \
          + beta * log(exp(Vold(1,2)) + exp(Vold(2,2))) * P(2, s, a) \
          - beta * maxval(1) * P(1, s, a) \
          - beta * maxval(2) * P(2, s, a);
    endfor
  endfor
endfunction


# Find the CCPs corresponding to P and the given u.
function ccp(u, P, beta)
  u

  V = [ 1, 2 ;
        1, 2 ];
  norm = 1;
  while (norm > 1e-6)
    Vold = V;
    V = func(Vold, u, P, beta);
    norm = max( abs(V - Vold) ) / max( abs(Vold) );
  endwhile
  norm
  V

  # Choice-specific value function
#   csvf(1,1) = u(1,1) + beta * ( P(1,1) * v(1) + P(1,2) * v(2) );
#   csvf(1,2) = u(1,2) + beta * ( P(1,1) * v(1) + P(1,2) * v(2) );
#   csvf(2,1) = u(2,1) + beta * ( P(2,1) * v(1) + P(2,2) * v(2) );
#   csvf(2,2) = u(2,2) + beta * ( P(2,1) * v(1) + P(2,2) * v(2) );

#   # Scaling
#   maxval(1) = max(csvf(1,:));
#   maxval(2) = max(csvf(2,:));
#   csvf(1,:) = csvf(1,:) - maxval(1);
#   csvf(2,:) = csvf(2,:) - maxval(2);

  # Pr(smoke | health)
  ccp(1) = exp(V(1,1)) / ( exp(V(1,1)) + exp(V(2,1)) );
  ccp(2) = exp(V(1,2)) / ( exp(V(1,2)) + exp(V(2,2)) );
  ccp
endfunction


# Discount rate
beta = 0.95;

# u(a, x) is the payoff from choosing action a in ( smoke, not )
# while being in state x \in ( bad, good ).
u = [ 0   0 ;
      3   5 ];

# State transition matrix, conditional on smoking and not smoking respectively:
# Pr(x' | x, a) for [ bad, good ] x [ bad, good ] x [ smoke, not ]
P = zeros(2,2,2);

P(:,:,1) = [ 0.8  0.2 ;
             0.5  0.5 ];

P(:,:,2) = [ 0.5  0.5 ;
             0.2  0.8 ];

# Find the conditional choice probabilities for the given beta, u, and P.
ccp(u, P, beta)
