# file plugin_build.py
import sys
import os
import cffi

ffibuilder = cffi.FFI()

header = """
extern int set_state_py(char *, double *, int*, int*, int*);
extern int set_state_char(char *, char *);
extern int get_state_char(char *, char *, int *);
extern int get_state_py(char *, double *, int*);
extern int set_state_1d(char *, double *, int*);
extern int set_state_scalar(char *, double *);
extern int call_function(char *, char *);
"""

with open("plugin.h", "w") as f:
    f.write(header)

ffibuilder.embedding_api(header)

ffibuilder.set_source(
    "my_plugin",
    r"""
    #include "plugin.h"
""",
)

with open(sys.argv[1]) as f:
    ffibuilder.embedding_init_code(f.read())

ffibuilder.emit_c_code("plugin.c")
# ffibuilder.compile(target="libplugin.so", verbose=True)
