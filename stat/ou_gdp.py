# ou-gdp.py
#
# Estimates an Ornstein-Uhlenbeck process using data on U.S. GDP.
#
# Jason Blevins <jrblevin@sdf.lonestar.org>
# Durham, March 24, 2008 09:02 EDT

from numpy import *
from scipy import stats, optimize
from pylab import *


def prt(x):
    print "theta = %f\t%f" % (x[0], x[1])

## Log-likelihood function
def log_likelihood(theta, t, x):
    eta = theta[0]
    sigma = exp(theta[1])                         # sigma >= 0

    result = 0.0

    # Calculate the likelihood, skipping the first observation.
    for i in arange(1, size(t)):

        # Time interval (here, constant)
        dt = t[i] - t[i-1]

        # Standard deviation of x(i)
        sd = sigma * sqrt((1 - exp(-2*eta*dt)) / (2 * eta))

        # Mean of x(i) (x_bar is zero since we de-meaned already)
        mean = x[i-1] * exp(-eta * dt)

        # Accumulate the result
        result += log(stats.norm.pdf(x[i], loc=mean, scale=sd))

    return result / size(t)

# Paths
data_dir = '/home/jrblevin/projects/macro-data'
gdp_file = data_dir + '/us-gdp.dat'
deflator_file = data_dir + '/us-gdp-deflator.dat'

# Load the data
yr, qtr, gdp = loadtxt(gdp_file, unpack=True)
deflator = loadtxt(deflator_file, usecols=[2])
log_gdp = log(gdp)

# Linear regression
t = arange(size(log_gdp))
(alpha, beta) = polyfit(t, log_gdp, 1)
fit = polyval([alpha, beta], t)
resid = log_gdp - alpha * t - beta

# Plot the data and the fitted line
# plot(log_gdp, label="Log Real GDP")
# plot(fit, label="Fitted line")
# title('Log Real GDP Regression')
# show()

# Starting values (a nonnegative transformation is applied to sigma)
eta = 0.1
sigma = 0.1
theta = (eta, log(sigma))

# Define a pure function which returns the negative log-likelihood
# at the given parameter values.
f = lambda theta: -log_likelihood(theta, t, resid)

theta = optimize.fmin(f, theta)

print "eta = %f" % theta[0]
print "sigma = %f" % exp(theta[1])

# Plot the residuals
#plot(resid)
#title('GDP Residuals')
#show()
