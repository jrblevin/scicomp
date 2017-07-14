module model_mod
  implicit none

  type :: model
     real, dimension(2) :: theta
  end type model

contains

  subroutine model_init(self, theta)
    type(model), intent(inout) :: self
    real, dimension(2), intent(in) :: theta
    self%theta = theta
  end subroutine model_init

  subroutine model_obj(self, x, y)
    type(model), intent(inout) :: self
    real, dimension(:), intent(in) :: x
    real, intent(out) :: y
    y = (x(1) - self%theta(1))**2 + (x(2) - self%theta(2))**2
  end subroutine model_obj

  subroutine model_obj_wrapper(x, y, param)
    real, dimension(:), intent(in) :: x
    real, intent(out) :: y
    class(*), intent(inout), optional :: param

    call model_obj(param, x, y)

    if (present(param)) then
       select type(param)
       type is (model)
          call model_obj(param, x, y)
       end select
    end if
  end subroutine model_obj_wrapper

end module model_mod

module optimizer
  implicit none

contains

  subroutine optimize(func, x, param)
    real, dimension(:), intent(in) :: x
    class(*), intent(inout), optional :: param
    real :: y

    interface
       subroutine func(x, y, param)
         real, dimension(:), intent(in) :: x
         real, intent(out) :: y
         class(*), intent(inout), optional :: param
       end subroutine func
    end interface

    call func(x, y, param)
    print *, 'y = ', y

  end subroutine optimize

end module optimizer


program test_model
  use model_mod
  use optimizer
  implicit none

  type(model) :: mod
  real, dimension(2) :: theta = (/ 2.0d0, 1.0d0 /)
  real, dimension(2) :: x = (/ -1.0d0, 3.0d0 /)

  call model_init(mod, theta)

  call optimize(model_obj_wrapper, x, mod)

end program test_model
