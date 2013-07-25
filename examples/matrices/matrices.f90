module matrices

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

end module matrices
