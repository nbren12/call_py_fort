import importlib

import numpy as np
import logging

logging.basicConfig(level=logging.INFO)

# Global state array
STATE = {}

# Create the dictionary mapping ctypes to np dtypes.
ctype2dtype = {}

# Integer types
for prefix in ('int', 'uint'):
    for log_bytes in range(4):
        ctype = '%s%d_t' % (prefix, 8 * (2**log_bytes))
        dtype = '%s%d' % (prefix[0], 2**log_bytes)
        # print( ctype )
        # print( dtype )
        ctype2dtype[ctype] = np.dtype(dtype)

# Floating point types
ctype2dtype['float'] = np.dtype('f4')
ctype2dtype['double'] = np.dtype('f8')


def asarray(ffi, ptr, shape, **kwargs):
    length = np.prod(shape)
    # Get the canonical C type of the elements of ptr as a string.
    T = ffi.getctype(ffi.typeof(ptr).item)
    # print( T )
    # print( ffi.sizeof( T ) )

    if T not in ctype2dtype:
        raise RuntimeError("Cannot create an array for element type: %s" % T)

    a = np.frombuffer(ffi.buffer(ptr, length * ffi.sizeof(T)), ctype2dtype[T])\
          .reshape(shape, **kwargs)
    return a


def set_state(args, ffi=None):
    tag, t, nx, ny, nz = args
    shape = (nz[0], ny[0], nx[0])
    shape = [n for n in shape if n != -1]

    tag = ffi.string(tag).decode('UTF-8')
    arr = asarray(ffi, t, shape).copy()
    STATE[tag] = arr


def set_state_scalar(args, ffi=None):
    tag, t = args
    tag = ffi.string(tag).decode('UTF-8')
    STATE[tag] = t[0]


def set_state_char(args, ffi=None):
    tag, chr = [ffi.string(x).decode('UTF-8') for x in args]
    STATE[tag] = chr


def get_state(args, ffi=None):
    tag, t, n = args
    tag = ffi.string(tag).decode('UTF-8')
    arr = asarray(ffi, t, (n[0], ))

    src = STATE.get(tag, np.zeros(n[0]))
    arr[:] = src.ravel()


def call_function(module_name, function_name):
    """Call a python function by name"""

    # import the python module
    mod = importlib.import_module(module_name)

    # the function we want to call
    fun = getattr(mod, function_name)

    # call the function
    # this function can edit STATE inplace
    fun(STATE)
