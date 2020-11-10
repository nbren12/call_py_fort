! module for calling python from C
module callpy_mod
  use, intrinsic :: iso_c_binding
  implicit none

  private

  interface
     function set_state_py(tag, t, nx, ny, nz) result(y) bind(c)
       use iso_c_binding
       character(c_char) :: tag
       real(c_double) t(nx, ny, nz)
       integer(c_int) :: nx, ny, nz
       integer(c_int) :: y
     end function set_state_py

    function get_state_py(tag, t, n) result(y) bind(c)
      use iso_c_binding
      character(c_char) :: tag
      real(c_double) t(n)
      integer(c_int) :: n, y
    end function get_state_py
  end interface

  interface set_state
     module procedure set_state_double_3d
     module procedure set_state_float_3d
  end interface

  interface get_state
    module procedure get_state_float_3d
    module procedure get_state_float_2d
    module procedure get_state_float_1d
  end interface

  public :: get_state, set_state, set_state_1d, set_state2d, set_state_char, &
      call_function, set_state_scalar


contains

  subroutine call_function(module_name, function_name)
    interface
       function call_function_py(mod_name_c, fun_name_c) &
            result(y) bind(c, name='call_function')
         use iso_c_binding
         character(kind=c_char) mod_name_c, fun_name_c
         integer(c_int) :: y
       end function call_function_py
    end interface

    character(len=*) :: module_name, function_name
    character(kind=c_char, len=256) :: mod_name_c, fun_name_c

    mod_name_c = trim(module_name)//char(0)
    fun_name_c = trim(function_name)//char(0)

    call check(call_function_py(mod_name_c, fun_name_c))

  end subroutine call_function

  subroutine set_state_double_3d(tag, t)
    character(len=*) :: tag
    real(8) :: t(:,:,:)
    ! work arrays
    real(c_double) :: tmp(size(t, 1), size(t, 2), size(t, 3))
    integer(c_int) :: nx, ny, nz
    character(len=256) :: tag_c


    tag_c = trim(tag)//char(0)

    tmp = t

    nx = size(tmp, 1)
    ny = size(tmp, 2)
    nz = size(tmp, 3)

    call check(set_state_py(tag_c, tmp, nx, ny, nz))

  end subroutine set_state_double_3d

  subroutine set_state_float_3d(tag, t)
    character(len=*) :: tag
    real :: t(:,:,:)
    ! work arrays
    real(c_double) :: tmp(size(t, 1), size(t, 2), size(t, 3))
    integer(c_int) :: nx, ny, nz
    character(len=256) :: tag_c


    tag_c = trim(tag)//char(0)

    tmp = t

    nx = size(tmp, 1)
    ny = size(tmp, 2)
    nz = size(tmp, 3)

    call check(set_state_py(tag_c, tmp, nx, ny, nz))

  end subroutine set_state_float_3d

  subroutine set_state2d(tag, t)
    character(len=*) :: tag
    real :: t(:,:)
    ! work arrays
    real:: tmp(size(t, 1), size(t, 2), 1)
    tmp(:,:,1) = t
    call set_state(tag, tmp)
  end subroutine set_state2d

  subroutine set_state_1d(tag, t)
    character(len=*) :: tag
    real :: t(:)
    real(c_double) :: t_(size(t))
    character(len=256) :: tag_c
    interface
       function set_state_1d_py(tag, t, n) result(y)&
            bind(c, name='set_state_1d')
         use iso_c_binding
         character(c_char) :: tag
         real(c_double) t(n)
         integer(c_int) :: n
         integer(c_int) :: y
       end function set_state_1d_py
    end interface

    t_ = t
    tag_c = trim(tag)//char(0)
    call check(set_state_1d_py(tag_c, t_, size(t)))
  end subroutine set_state_1d

  subroutine set_state_scalar(tag, t)
    character(len=*) :: tag
    real :: t
    real(c_double) :: t_
    character(len=256) :: tag_c
    interface
       function set_state_scalar_py(tag, t) result(y)&
            bind(c, name='set_state_scalar')
         use iso_c_binding
         character(c_char) :: tag
         real(c_double) t
         integer(c_int) :: y
       end function set_state_scalar_py
    end interface

    t_ = t
    tag_c = trim(tag)//char(0)
    call check(set_state_scalar_py(tag_c, t_))
  end subroutine set_state_scalar

  subroutine get_state_float_3d(tag, t)
    character(len=*) :: tag
    real :: t(:, :, :)
    real(c_double) :: t_(size(t, 1), size(t, 2), size(t, 3))
    character(len=256) :: tag_c

    integer(c_int) :: n
    n  = size(t)
    tag_c = trim(tag)//char(0)
    call check(get_state_py(tag_c, t_, n))
    t = real(t_)
  end subroutine get_state_float_3d


  subroutine get_state_float_2d(tag, t)
    character(len=*) :: tag
    real :: t(:, :)
    real(c_double) :: t_(size(t, 1), size(t, 2))
    character(len=256) :: tag_c

    integer(c_int) :: n
    n  = size(t)
    tag_c = trim(tag)//char(0)
    call check(get_state_py(tag_c, t_, n))
    t = real(t_)
  end subroutine get_state_float_2d

  subroutine get_state_float_1d(tag, t)
    character(len=*) :: tag
    real :: t(:)
    real(c_double) :: t_(size(t, 1))
    character(len=256) :: tag_c

    integer(c_int) :: n
    n  = size(t)
    tag_c = trim(tag)//char(0)
    call check(get_state_py(tag_c, t_, n))
    t = real(t_)
  end subroutine get_state_float_1d

  subroutine set_state_char(tag, chr)
    interface
       function set_state_char_py(tag, chr) result(y)&
            bind(c, name='set_state_char')
         use iso_c_binding
         implicit none
         character(c_char) :: tag
         character(c_char) :: chr
         integer(c_int) :: y
       end function set_state_char_py
    end interface
    character(len=*) :: tag, chr
    character(len=256) :: tag_, chr_

    tag_ = trim(tag)//char(0)
    chr_ = trim(chr)//char(0)
    call check(set_state_char_py(tag_, chr_))
  end subroutine set_state_char


  subroutine check(ret)
    integer :: ret
    if (ret /= 0) stop -1
  end subroutine check

end module callpy_mod
