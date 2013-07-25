! wrapper module has "c_" prepended to module name
module c_matrices

implicit none

! add iso_c_binding module
use iso_c_binding

! use the module that is being wrapped
use matrices



! Custom type handling: 
!
! For each "type" we need a c-side type constructor. All it should do is (1)
! create a pointer to an instance of the type and (2) create a c pointer to
! this type pointer.
!
!--------------------------------------------------------------------------!
subroutine c_matrix(ptr) bind(c)                                           !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr), intent(out) :: ptr
    type(matrix), pointer :: A

    allocate(A)
    ptr = c_loc(A)

end subroutine c_matrix



! for each subroutine, prepend "c_" and append "bind(c)"
!--------------------------------------------------------------------------!
subroutine c_setup(a_ptr,rows,cols) bind(c)                                !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr), intent(in) :: a_ptr
    integer(c_int), intent(in), value :: rows,cols
    type(matrix), pointer :: A

    allocate(A)
    call c_f_pointer(a_ptr,A)
    call setup(A,rows,cols)

end subroutine c_setup



!--------------------------------------------------------------------------!
subroutine c_get_val(val,a_ptr,i,j) bind(c)                                !
!--------------------------------------------------------------------------!
    implicit none
    real(c_double), intent(out) :: val
    type(c_ptr), intent(in) :: a_ptr
    integer(c_int), intent(in), value :: i,j
    type(matrix), pointer :: A

    allocate(A)
    call c_f_pointer(a_ptr,A)
    val = A%get_val(i+1,j+1)

end subroutine c_get_val



!--------------------------------------------------------------------------!
subroutine c_set_val(a_ptr,val,i,j) bind(c)                                !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr), intent(in) :: a_ptr
    real(c_double), intent(in), value :: val
    integer(c_int), intent(in), value :: i,j
    type(matrix), pointer :: A

    allocate(A)
    call c_f_pointer(a_ptr,A)
    call A%set_val(i+1,j+1,val)

end subroutine c_set_val



!--------------------------------------------------------------------------!
subroutine c_add_val(a_ptr,val,i,j) bind(c)                                !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr), intent(in) :: a_ptr
    real(c_double), intent(in), value :: val
    integer(c_int), intent(in), value :: i,j
    type(matrix), pointer :: A

    allocate(A)
    call c_f_pointer(a_ptr,A)
    call A%add_val(i+1,j+1,val)

end subroutine c_add_val

end module c_matrices
