import numpy
import scipy

def fast_sample(w, M, u):
    """Generates a sample of size M of integers with weights given by w.
    
    Parameters
    ----------
    w : array_like
        A vector of real weights corresponding to each of the integers ``0`` to
        ``(w.size - 1)``.  These weights do not need to be normalized.
    M : integer
        The requested sample size.
    u : real
        A Uniform(0,1) draw, used as an offset to the CDF.
    
    Returns
    -------
    sample : array_like
        An array containing the resulting sample.
    """

    # Normalize the weights so that they sum to 1.
    w = w / sum(w)

    # Initialize storage for the cumulative weight CDF (including the ``u``
    # offset) and the resulting sample.
    c = numpy.empty((M))
    sample = numpy.empty((M), dtype=numpy.int)

    # Draws for the first integer (0).  a and b are the beginning and ending
    # offsets for each integer.
    c[0] = M * w[0] + u
    a = 0
    b = numpy.math.floor(c[0])
    if b > a:
        sample[a:b] = 0

    for j in numpy.arange(1, w.size):
        c[j] = c[j-1] + M * w[j]
        a = b
        b = numpy.math.floor(c[j])
        if b > a:
            sample[a:b] = j
    return sample

def _test():
    seed = 274
    numpy.random.seed(274)

    N = 10
    M = 1000
    u = numpy.random.rand()
    w = numpy.random.rand(N)
    sample = fast_sample(w, M, u)
    num, bins = scipy.histogram(sample, numpy.arange(N))
    u = 0.2
    print 'u = ', u
    print 'w = ', w / sum(w)
    print 'frequency = ', num / float(M)
    print 'w - sample frequency = ', w / sum(w) - num / float(M)

    u = 0.98
    sample = fast_sample(w, M, u)
    num, bins = scipy.histogram(sample, numpy.arange(N))
    print 'u = ', u
    print 'w = ', w / sum(w)
    print 'frequency = ', num / float(M)
    print 'w - sample frequency = ', w / sum(w) - num / float(M)

if __name__ == "__main__":
    _test()
