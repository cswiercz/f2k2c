module matrices

use iso_c_binding

implicit none



!--------------------------------------------------------------------------!
! Matrix data type                                                         !
!--------------------------------------------------------------------------!
type :: matrix
    integer :: rows,cols
    real(kind(1d0)), allocatable :: vals(:,:)
contains
    procedure :: get_val
    procedure :: set_val,add_val
    procedure :: matvec
!    procedure :: transpose
end type matrix




contains


!--------------------------------------------------------------------------!
subroutine setup(A,rows,cols)                                              !
!--------------------------------------------------------------------------!
    implicit none
    type(matrix), intent(inout) :: A
    integer, intent(in) :: rows,cols

    A%rows = rows
    A%cols = cols

    allocate(A%vals(rows,cols))
    A%vals = 0.d0

end subroutine setup



!--------------------------------------------------------------------------!
function get_val(A,row,col)                                                !
!--------------------------------------------------------------------------!
    implicit none
    class(matrix), intent(in) :: A
    integer, intent(in) :: row,col
    real(kind(1d0)) :: get_val

    get_val = A%vals(row,col)

end function get_val



!--------------------------------------------------------------------------!
subroutine set_val(A,row,col,val)                                          !
!--------------------------------------------------------------------------!
    implicit none
    class(matrix), intent(inout) :: A
    integer, intent(in) :: row,col
    real(kind(1d0)), intent(in) :: val

    A%vals(row,col) = val

end subroutine set_val



!--------------------------------------------------------------------------!
subroutine add_val(A,row,col,val)                                          !
!--------------------------------------------------------------------------!
    implicit none
    class(matrix), intent(inout) :: A
    integer, intent(in) :: row,col
    real(kind(1d0)), intent(in) :: val

    A%vals(row,col) = A%vals(row,col)+val

end subroutine add_val



!--------------------------------------------------------------------------!
subroutine matvec(A,x,y)                                                   !
!--------------------------------------------------------------------------!
    implicit none
    class(matrix), intent(in) :: A
    real(kind(1d0)), intent(in) :: x(:)
    real(kind(1d0)), intent(out) :: y(:)
    integer :: i,j

    y = 0.d0
    do j=1,A%cols
        do i=1,A%rows
            y(i) = y(i)+A%vals(i,j)*x(j)
        enddo
    enddo

end subroutine matvec



!--------------------------------------------------------------------------!
subroutine c_matrix(ptr) bind(c)                                           !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr), intent(out) :: ptr
    type(matrix), pointer :: A

    allocate(A)
    ptr = c_loc(A)

end subroutine c_matrix



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



!--------------------------------------------------------------------------!
subroutine c_matvec(a_ptr,x,y,m,n) bind(c)                                 !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr), intent(in) :: a_ptr
    real(c_double), intent(in) :: x(n)
    real(c_double), intent(out) :: y(m)
    integer(c_int), intent(in), value :: m,n
    type(matrix), pointer :: A

    allocate(A)
    call c_f_pointer(a_ptr,A)
    call A%matvec(x,y)


end subroutine c_matvec




end module matrices
