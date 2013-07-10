module simple

implicit none

real(kind(1d0)) function heaviside_func(x,flip)
  implicit none
  real(kind(1d0)), intent(in) :: x
  integer, intent(in)         :: flip

  if (flip*x > 0) then
     heaviside = 1.0
  else if (flip*x < 0) then
     heaviside = 0.0
  else
     heaviside = 0.5
end function heaviside_func


subroutine heaviside_sub(val,x,flip)
  implicit none
  real(kind(1d0)), intent(in)  :: x
  integer, intent(in)          :: flip
  real(kind(1d0)), intent(out) :: val

  if (flip*x > 0) then
     val = 1.0
  else if (flip*x < 0) then
     val = 0.0
  else
     val = 0.5
end subroutine heaviside

end module


