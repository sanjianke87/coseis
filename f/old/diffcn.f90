! Difference operator, cell to node
module m_diffcn
implicit none
contains

subroutine diffcn( df, oper, f, x, dx, i, a, i1, i2 )
real, intent(out) :: df(:,:,:)
real, intent(in) :: f(:,:,:,:), x(:,:,:,:), dx
integer, intent(in) :: oper, i, a, i1(3), i2(3)
real :: h
integer :: j, k, l, j1, k1, l1, j2, k2, l2, b, c

if ( any( i2 < i1 ) ) return

j1 = i1(1); j2 = i2(1)
k1 = i1(2); k2 = i2(2)
l1 = i1(3); l2 = i2(3)

select case( oper )

! Constant grid, flops: 1* 7+
case( 1 )
h = 0.25 * dx * dx
select case( a )
case( 1 )
  forall( j=j1:j2, k=k1:k2, l=l1:l2 )
    df(j,k,l) = h * &
    ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
    - f(j-1,k,l,i) + f(j,k-1,l-1,i) &
    + f(j,k-1,l,i) - f(j-1,k,l-1,i) &
    + f(j,k,l-1,i) - f(j-1,k-1,l,i) )
  end forall
case( 2 )
  forall( j=j1:j2, k=k1:k2, l=l1:l2 )
    df(j,k,l) = h * &
    ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
    + f(j-1,k,l,i) - f(j,k-1,l-1,i) &
    - f(j,k-1,l,i) + f(j-1,k,l-1,i) &
    + f(j,k,l-1,i) - f(j-1,k-1,l,i) )
  end forall
case( 3 )
  forall( j=j1:j2, k=k1:k2, l=l1:l2 )
    df(j,k,l) = h * &
    ( f(j,k,l,i) - f(j-1,k-1,l-1,i) &
    + f(j-1,k,l,i) - f(j,k-1,l-1,i) &
    + f(j,k-1,l,i) - f(j-1,k,l-1,i) &
    - f(j,k,l-1,i) + f(j-1,k-1,l,i) )
  end forall
end select

! Rectangular grid, flops: 7* 13+
case( 2 )
select case( a )
case( 1 )
  forall( j=j1:j2, k=k1:k2, l=l1:l2 )
    df(j,k,l) = 0.25 * &
    ( ( x(j,k,l+1,3) - x(j,k,l,3) ) * &
    ( ( x(j,k+1,l,2) - x(j,k,l,2) ) * ( f(j,k,l,i) - f(j-1,k,l,i) ) + &
      ( x(j,k,l,2) - x(j,k-1,l,2) ) * ( f(j,k-1,l,i) - f(j-1,k-1,l,i) ) ) &
    + ( x(j,k,l,3) - x(j,k,l-1,3) ) * &
    ( ( x(j,k+1,l,2) - x(j,k,l,2) ) * ( f(j,k,l-1,i) - f(j-1,k,l-1,i) ) + &
      ( x(j,k,l,2) - x(j,k-1,l,2) ) * ( f(j,k-1,l-1,i) - f(j-1,k-1,l-1,i) ) ) )
  end forall
case( 2 )
  forall( j=j1:j2, k=k1:k2, l=l1:l2 )
    df(j,k,l) = 0.25 * &
    ( ( x(j+1,k,l,1) - x(j,k,l,1) ) * &
    ( ( x(j,k,l+1,3) - x(j,k,l,3) ) * ( f(j,k,l,i) - f(j,k-1,l,i) ) + &
      ( x(j,k,l,3) - x(j,k,l-1,3) ) * ( f(j,k,l-1,i) - f(j,k-1,l-1,i) ) ) &
    + ( x(j,k,l,1) - x(j-1,k,l,1) ) * &
    ( ( x(j,k,l+1,3) - x(j,k,l,3) ) * ( f(j-1,k,l,i) - f(j-1,k-1,l,i) ) + &
      ( x(j,k,l,3) - x(j,k,l-1,3) ) * ( f(j-1,k,l-1,i) - f(j-1,k-1,l-1,i) ) ) )
  end forall
case( 3 )
  forall( j=j1:j2, k=k1:k2, l=l1:l2 )
    df(j,k,l) = 0.25 * &
    ( ( x(j,k+1,l,2) - x(j,k,l,2) ) * &
    ( ( x(j+1,k,l,1) - x(j,k,l,1) ) * ( f(j,k,l,i) - f(j,k,l-1,i) ) + &
      ( x(j,k,l,1) - x(j-1,k,l,1) ) * ( f(j-1,k,l,i) - f(j-1,k,l-1,i) ) ) &
    + ( x(j,k,l,2) - x(j,k-1,l,2) ) * &
    ( ( x(j+1,k,l,1) - x(j,k,l,1) ) * ( f(j,k-1,l,i) - f(j,k-1,l-1,i) ) + &
      ( x(j,k,l,1) - x(j-1,k,l,1) ) * ( f(j-1,k-1,l,i) - f(j-1,k-1,l-1,i) ) ) )
  end forall
end select

! One-point quadrature, flops: 33* 119+
case( 3 )
b = mod( a, 3 ) + 1
c = mod( a + 1, 3 ) + 1
forall( j=j1:j2, k=k1:k2, l=l1:l2 )
df(j,k,l) = 1. / 16. * &
(f(j,k,l,i)*((x(j,k+1,l+1,b)-x(j+1,k,l,b))*(x(j+1,k,l+1,c)-x(j,k+1,l,c)-x(j+1,k+1,l,c)+x(j,k,l+1,c)) &
      +(x(j+1,k,l+1,b)-x(j,k+1,l,b))*(x(j+1,k+1,l,c)-x(j,k,l+1,c)-x(j,k+1,l+1,c)+x(j+1,k,l,c)) &
      +(x(j+1,k+1,l,b)-x(j,k,l+1,b))*(x(j,k+1,l+1,c)-x(j+1,k,l,c)-x(j+1,k,l+1,c)+x(j,k+1,l,c))) &
-f(j-1,k-1,l-1,i)*((x(j-1,k,l,b)-x(j,k-1,l-1,b))*(x(j,k-1,l,c)-x(j-1,k,l-1,c)-x(j,k,l-1,c)+x(j-1,k-1,l,c)) &
      +(x(j,k-1,l,b)-x(j-1,k,l-1,b))*(x(j,k,l-1,c)-x(j-1,k-1,l,c)-x(j-1,k,l,c)+x(j,k-1,l-1,c)) &
      +(x(j,k,l-1,b)-x(j-1,k-1,l,b))*(x(j-1,k,l,c)-x(j,k-1,l-1,c)-x(j,k-1,l,c)+x(j-1,k,l-1,c))) &
+f(j-1,k,l,i)*((x(j,k+1,l+1,b)-x(j-1,k,l,b))*(x(j,k+1,l,c)-x(j-1,k,l+1,c)-x(j,k,l+1,c)+x(j-1,k+1,l,c)) &
      +(x(j,k,l+1,b)-x(j-1,k+1,l,b))*(x(j,k+1,l+1,c)-x(j-1,k,l,c)+x(j,k+1,l,c)-x(j-1,k,l+1,c)) &
      -(x(j,k+1,l,b)-x(j-1,k,l+1,b))*(x(j,k,l+1,c)-x(j-1,k+1,l,c)+x(j,k+1,l+1,c)-x(j-1,k,l,c))) &
-f(j,k-1,l-1,i)*((x(j+1,k,l,b)-x(j,k-1,l-1,b))*(x(j+1,k,l-1,c)-x(j,k-1,l,c)-x(j+1,k-1,l,c)+x(j,k,l-1,c)) &
      +(x(j+1,k-1,l,b)-x(j,k,l-1,b))*(x(j+1,k,l,c)-x(j,k-1,l-1,c)+x(j+1,k,l-1,c)-x(j,k-1,l,c)) &
      -(x(j+1,k,l-1,b)-x(j,k-1,l,b))*(x(j+1,k-1,l,c)-x(j,k,l-1,c)+x(j+1,k,l,c)-x(j,k-1,l-1,c))) &
+f(j,k-1,l,i)*((x(j+1,k,l+1,b)-x(j,k-1,l,b))*(x(j,k,l+1,c)-x(j+1,k-1,l,c)-x(j+1,k,l,c)+x(j,k-1,l+1,c)) &
      +(x(j+1,k,l,b)-x(j,k-1,l+1,b))*(x(j+1,k,l+1,c)-x(j,k-1,l,c)+x(j,k,l+1,c)-x(j+1,k-1,l,c)) &
      -(x(j,k,l+1,b)-x(j+1,k-1,l,b))*(x(j+1,k,l,c)-x(j,k-1,l+1,c)+x(j+1,k,l+1,c)-x(j,k-1,l,c))) &
-f(j-1,k,l-1,i)*((x(j,k+1,l,b)-x(j-1,k,l-1,b))*(x(j-1,k+1,l,c)-x(j,k,l-1,c)-x(j,k+1,l-1,c)+x(j-1,k,l,c)) &
      +(x(j,k+1,l-1,b)-x(j-1,k,l,b))*(x(j,k+1,l,c)-x(j-1,k,l-1,c)+x(j-1,k+1,l,c)-x(j,k,l-1,c)) &
      -(x(j-1,k+1,l,b)-x(j,k,l-1,b))*(x(j,k+1,l-1,c)-x(j-1,k,l,c)+x(j,k+1,l,c)-x(j-1,k,l-1,c))) &
+f(j,k,l-1,i)*((x(j+1,k+1,l,b)-x(j,k,l-1,b))*(x(j+1,k,l,c)-x(j,k+1,l-1,c)-x(j,k+1,l,c)+x(j+1,k,l-1,c)) &
      +(x(j,k+1,l,b)-x(j+1,k,l-1,b))*(x(j+1,k+1,l,c)-x(j,k,l-1,c)+x(j+1,k,l,c)-x(j,k+1,l-1,c)) &
      -(x(j+1,k,l,b)-x(j,k+1,l-1,b))*(x(j,k+1,l,c)-x(j+1,k,l-1,c)+x(j+1,k+1,l,c)-x(j,k,l-1,c))) &
-f(j-1,k-1,l,i)*((x(j,k,l+1,b)-x(j-1,k-1,l,b))*(x(j,k-1,l+1,c)-x(j-1,k,l,c)-x(j-1,k,l+1,c)+x(j,k-1,l,c)) &
      +(x(j-1,k,l+1,b)-x(j,k-1,l,b))*(x(j,k,l+1,c)-x(j-1,k-1,l,c)+x(j,k-1,l+1,c)-x(j-1,k,l,c)) &
      -(x(j,k-1,l+1,b)-x(j-1,k,l,b))*(x(j-1,k,l+1,c)-x(j,k-1,l,c)+x(j,k,l+1,c)-x(j-1,k-1,l,c)))) 
end forall

! Mean stress, flops: 55* 107+
case( 4 )
b = modulo( a, 3 ) + 1
c = modulo( a + 1, 3 ) + 1
forall( j=j1:j2, k=k1:k2, l=l1:l2 )
df(j,k,l) = 1. / 12. * &
(x(j+1,k,l,c)*((x(j,k+1,l,b)+x(j+1,k+1,l,b))*(f(j,k,l-1,i)-f(j,k,l,i)) &
              +(x(j,k-1,l,b)+x(j+1,k-1,l,b))*(f(j,k-1,l,i)-f(j,k-1,l-1,i)) &
              +(x(j,k,l+1,b)+x(j+1,k,l+1,b))*(f(j,k,l,i)-f(j,k-1,l,i)) &
              +(x(j,k,l-1,b)+x(j+1,k,l-1,b))*(f(j,k-1,l-1,i)-f(j,k,l-1,i))) &
+x(j-1,k,l,c)*((x(j,k+1,l,b)+x(j-1,k+1,l,b))*(f(j-1,k,l,i)-f(j-1,k,l-1,i)) &
              +(x(j,k-1,l,b)+x(j-1,k-1,l,b))*(f(j-1,k-1,l-1,i)-f(j-1,k-1,l,i)) &
              +(x(j,k,l+1,b)+x(j-1,k,l+1,b))*(f(j-1,k-1,l,i)-f(j-1,k,l,i)) &
              +(x(j,k,l-1,b)+x(j-1,k,l-1,b))*(f(j-1,k,l-1,i)-f(j-1,k-1,l-1,i))) &
+x(j,k+1,l,c)*((x(j+1,k,l,b)+x(j+1,k+1,l,b))*(f(j,k,l,i)-f(j,k,l-1,i)) &
              +(x(j-1,k,l,b)+x(j-1,k+1,l,b))*(f(j-1,k,l-1,i)-f(j-1,k,l,i)) &
              +(x(j,k,l+1,b)+x(j,k+1,l+1,b))*(f(j-1,k,l,i)-f(j,k,l,i)) &
              +(x(j,k,l-1,b)+x(j,k+1,l-1,b))*(f(j,k,l-1,i)-f(j-1,k,l-1,i))) &
+x(j,k-1,l,c)*((x(j+1,k,l,b)+x(j+1,k-1,l,b))*(f(j,k-1,l-1,i)-f(j,k-1,l,i)) &
              +(x(j-1,k,l,b)+x(j-1,k-1,l,b))*(f(j-1,k-1,l,i)-f(j-1,k-1,l-1,i)) &
              +(x(j,k,l+1,b)+x(j,k-1,l+1,b))*(f(j,k-1,l,i)-f(j-1,k-1,l,i)) &
              +(x(j,k,l-1,b)+x(j,k-1,l-1,b))*(f(j-1,k-1,l-1,i)-f(j,k-1,l-1,i))) &
+x(j,k,l+1,c)*((x(j+1,k,l,b)+x(j+1,k,l+1,b))*(f(j,k-1,l,i)-f(j,k,l,i)) &
              +(x(j-1,k,l,b)+x(j-1,k,l+1,b))*(f(j-1,k,l,i)-f(j-1,k-1,l,i)) &
              +(x(j,k+1,l,b)+x(j,k+1,l+1,b))*(f(j,k,l,i)-f(j-1,k,l,i)) &
              +(x(j,k-1,l,b)+x(j,k-1,l+1,b))*(f(j-1,k-1,l,i)-f(j,k-1,l,i))) &
+x(j,k,l-1,c)*((x(j+1,k,l,b)+x(j+1,k,l-1,b))*(f(j,k,l-1,i)-f(j,k-1,l-1,i)) &
              +(x(j-1,k,l,b)+x(j-1,k,l-1,b))*(f(j-1,k-1,l-1,i)-f(j-1,k,l-1,i)) &
              +(x(j,k+1,l,b)+x(j,k+1,l-1,b))*(f(j-1,k,l-1,i)-f(j,k,l-1,i)) &
              +(x(j,k-1,l,b)+x(j,k-1,l-1,b))*(f(j,k-1,l-1,i)-f(j-1,k-1,l-1,i))) &
 +x(j,k+1,l+1,c)*(x(j,k+1,l,b)-x(j,k,l+1,b))*(f(j,k,l,i)-f(j-1,k,l,i)) &
 +x(j,k-1,l-1,c)*(x(j,k-1,l,b)-x(j,k,l-1,b))*(f(j,k-1,l-1,i)-f(j-1,k-1,l-1,i)) &
 +x(j+1,k,l+1,c)*(x(j+1,k,l,b)-x(j,k,l+1,b))*(f(j,k-1,l,i)-f(j,k,l,i)) &
 +x(j-1,k,l-1,c)*(x(j-1,k,l,b)-x(j,k,l-1,b))*(f(j-1,k-1,l-1,i)-f(j-1,k,l-1,i)) &
 +x(j+1,k+1,l,c)*(x(j+1,k,l,b)-x(j,k+1,l,b))*(f(j,k,l,i)-f(j,k,l-1,i)) &
 +x(j-1,k-1,l,c)*(x(j-1,k,l,b)-x(j,k-1,l,b))*(f(j-1,k-1,l,i)-f(j-1,k-1,l-1,i)) &
 +x(j+1,k,l-1,c)*(x(j+1,k,l,b)-x(j,k,l-1,b))*(f(j,k,l-1,i)-f(j,k-1,l-1,i)) &
 +x(j-1,k,l+1,c)*(x(j-1,k,l,b)-x(j,k,l+1,b))*(f(j-1,k,l,i)-f(j-1,k-1,l,i)) &
 +x(j-1,k+1,l,c)*(x(j-1,k,l,b)-x(j,k+1,l,b))*(f(j-1,k,l-1,i)-f(j-1,k,l,i)) &
 +x(j+1,k-1,l,c)*(x(j+1,k,l,b)-x(j,k-1,l,b))*(f(j,k-1,l-1,i)-f(j,k-1,l,i)) &
 +x(j,k-1,l+1,c)*(x(j,k-1,l,b)-x(j,k,l+1,b))*(f(j-1,k-1,l,i)-f(j,k-1,l,i)) &
 +x(j,k+1,l-1,c)*(x(j,k+1,l,b)-x(j,k,l-1,b))*(f(j-1,k,l-1,i)-f(j,k,l-1,i)))
end forall

end select

end subroutine

end module
