# GNU Octave code to solve a simple two-state two-action dynamic discrete
# choice model via value function iteration.
#
# Jason Blevins <jrblevin@sdf.lonestar.org>
# Carrboro, April 14, 2008

# Applies the Bellman operator.
function v = func(vold, u, P, beta)
  # Bad health
  v(1) = u(1,2) + beta * ( P(1,1) * vold(1) + P(1,2) * vold(2) );

  # Good health
  v(2) = u(2,2) + beta * ( P(2,1) * vold(1) + P(2,2) * vold(2) );
endfunction


# Find the CCPs corresponding to P and the given u.
function ccp(u, P, beta)
  u

  v = [ 1 2 ];
  norm = 1;
  while (norm > 1e-6)
    vold = v;
    v = func(vold, u, P, beta);
    norm = max(abs(v - vold) / abs(vold));
  endwhile
  v

  # Choice-specific value function
  csvf(1,1) = u(1,1) + beta * ( P(1,1) * v(1) + P(1,2) * v(2) );
  csvf(1,2) = u(1,2) + beta * ( P(1,1) * v(1) + P(1,2) * v(2) );
  csvf(2,1) = u(2,1) + beta * ( P(2,1) * v(1) + P(2,2) * v(2) );
  csvf(2,2) = u(2,2) + beta * ( P(2,1) * v(1) + P(2,2) * v(2) );

  # Scaling
  maxval(1) = max(csvf(1,:));
  maxval(2) = max(csvf(2,:));
  csvf(1,:) = csvf(1,:) - maxval(1);
  csvf(2,:) = csvf(2,:) - maxval(2);

  # Pr(smoke | health)
  ccp(1) = exp(csvf(1,1)) / (exp(csvf(1,1)) + exp(csvf(1,2)));
  ccp(2) = exp(csvf(2,1)) / (exp(csvf(2,1)) + exp(csvf(2,2)));
  ccp
endfunction


# Discount rate
beta = 0.95;

# u is the payoff matrix: [ bad, good ] x [ smoke, not ]
u = [ 0  3; 1 4 ];

# State transition matrix, conditional on smoking behavior:
# Pr(health | smoking) for [ bad, good ] x [ smoke, not ]
P = [ 0.8  0.2 ;
      0.1  0.9 ];

# Find the conditional choice probabilities for the given beta, u, and P.
ccp(u, P, beta)

