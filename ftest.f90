program ftest

    use matrices

    implicit none

    type(matrix) :: A
    integer :: rows,cols,i,j
    real(kind(1d0)) :: val


    rows = 10
    cols = 10
    A = init(rows,cols)

    i = 5
    j = 5
    val = 1.d0
    call A%set_val(i,j,val)

end program ftest
