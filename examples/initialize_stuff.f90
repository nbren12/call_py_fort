program example
use callpy_mod
implicit none

character(len=*), parameter :: py_module = "initialize_stuff"

call call_function(py_module, "function")
call call_function(py_module, "function")
call call_function(py_module, "function")

end program example
