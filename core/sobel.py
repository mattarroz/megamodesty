from scipy.ndimage import convolve
from scipy.ndimage import binary_dilation, binary_erosion
from scipy.ndimage import convolve
from scipy.ndimage import generate_binary_structure
import numpy as np

# stolen from Cell Profiler's source code

def sobel(image, mask=None):
    '''Calculate the absolute magnitude Sobel to find the edges
    
    image - image to process
    mask - mask of relevant points
    
    Take the square root of the sum of the squares of the horizontal and
    vertical Sobels to get a magnitude that's somewhat insensitive to
    direction.
    
    Note that scipy's Sobel returns a directional Sobel which isn't
    useful for edge detection in its raw form.
    '''
    return np.sqrt(hsobel(image,mask)**2 + vsobel(image,mask)**2)

def hsobel(image, mask=None):
    '''Find the horizontal edges of an image using the Sobel transform
    
    image - image to process
    mask  - mask of relevant points
    
    We use the following kernel and return the absolute value of the
    result at each point:
     1   2   1
     0   0   0
    -1  -2  -1
    '''
    if mask == None:
        mask = np.ones(image.shape, bool)
    big_mask = binary_erosion(mask,
                              generate_binary_structure(2,2),
                              border_value = 0)
    result = np.abs(convolve(image, np.array([[ 1, 2, 1],
                                              [ 0, 0, 0],
                                              [-1,-2,-1]]).astype(float)/4.0))
    result[big_mask==False] = 0
    return result

def vsobel(image, mask=None):
    '''Find the vertical edges of an image using the Sobel transform
    
    image - image to process
    mask  - mask of relevant points
    
    We use the following kernel and return the absolute value of the
    result at each point:
     1   0  -1
     2   0  -2
     1   0  -1
    '''
    if mask == None:
        mask = np.ones(image.shape, bool)
    big_mask = binary_erosion(mask,
                              generate_binary_structure(2,2),
                              border_value = 0)
    result = np.abs(convolve(image, np.array([[ 1, 0,-1],
                                              [ 2, 0,-2],
                                              [ 1, 0,-1]]).astype(float)/4.0))
    result[big_mask==False] = 0
    return result
