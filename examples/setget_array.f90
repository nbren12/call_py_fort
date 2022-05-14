program example
use callpy_mod
implicit none

real(8) :: a(10)
a = 1.0
call set_state("a", a)
call call_function("builtins", "print")
! read any changes from "a" back into a.
call get_state("a", a)

end program example
