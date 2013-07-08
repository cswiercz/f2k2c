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
function init(rows,cols)                                                   !
!--------------------------------------------------------------------------!
    implicit none
    type(matrix) :: init
    integer, intent(in) :: rows,cols

    init%rows = rows
    init%cols = cols

    allocate(init%vals(rows,cols))
    init%vals = 0.d0

end function init



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
function c_init(rows,cols) bind(c)                                         !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr) :: c_init
    integer(c_int), intent(in), value :: rows,cols
    type(matrix), pointer :: A

    allocate(A)
    A = init(rows,cols)
    c_init = c_loc(A)

end function c_init



!--------------------------------------------------------------------------!
subroutine c_get_val(val,a_ptr,i,j) bind(c)                                !
!--------------------------------------------------------------------------!
    implicit none
    real(c_double), intent(out) :: val
    type(c_ptr), intent(in) :: a_ptr
    integer(c_int), intent(in), value :: i,j
    type(matrix), pointer :: a_fptr

    allocate(a_fptr)
    call c_f_pointer(a_ptr,a_fptr)
    val = a_fptr%get_val(i+1,j+1)

end subroutine c_get_val



!--------------------------------------------------------------------------!
subroutine c_set_val(a_ptr,val,i,j) bind(c)                                !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr), intent(in) :: a_ptr
    real(c_double), intent(in), value :: val
    integer(c_int), intent(in), value :: i,j
    type(matrix), pointer :: a_fptr

    allocate(a_fptr)
    call c_f_pointer(a_ptr,a_fptr)
    call a_fptr%set_val(i+1,j+1,val)

end subroutine c_set_val



!--------------------------------------------------------------------------!
subroutine c_add_val(a_ptr,val,i,j) bind(c)                                !
!--------------------------------------------------------------------------!
    implicit none
    type(c_ptr), intent(in) :: a_ptr
    real(c_double), intent(in), value :: val
    integer(c_int), intent(in), value :: i,j
    type(matrix), pointer :: a_fptr

    allocate(a_fptr)
    call c_f_pointer(a_ptr,a_fptr)
    call a_fptr%add_val(i+1,j+1,val)

end subroutine c_add_val




end module matrices
