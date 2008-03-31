# ou_sim.py
#
# Simulates an Ornstein-Uhlenbeck process.
#
# Jason Blevins <jrblevin@sdf.lonestar.org>
# Durham, March 24, 2008 09:16 EDT

import numpy
from numpy import exp, sqrt

def ou_sim(T, sigma=1.0, eta=1.0, mu=0.0):
    """Ornstein-Uhlenbeck Simulator

    Parameters
    ----------

    T -- number of periods to simulate

    sigma -- standard deviation of the Brownian Motion
    eta -- speed of mean reversion
    mu -- mean

    Returns
    -------

    x -- an array containing the realization of the process
    """
    x = numpy.ones((T)) * mu                  # Initialize storage for x

    # Store a series of independent Normal(0,1) draws
    omega = numpy.random.normal(size=T)

    for t in numpy.arange(1,T):
        x[t] = x[t-1] * exp(-eta) + mu * (1 - exp(-eta)) \
            + sigma * sqrt((1 - exp(-2*eta))/(2*eta)) * omega[t]

    return x

if __name__ == '__main__':
    import pylab

    sigma = 0.01
    eta = 0.03
    mu = 0.0

    x = ou_sim(250, sigma, eta, mu)

    pylab.plot(x, label = ("eta = %0.2f, sigma=%0.2f" % (eta, sigma)))
    pylab.title('Ornstein-Uhlenbeck process')
    pylab.legend(loc='upper left')
    pylab.show()
