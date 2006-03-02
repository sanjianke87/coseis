
figure
set( gcf, ...
  'Name', 'Rupture Time', ...
  'DefaultLineLinewidth', .2 );
v = 0:0.5:7;

cwd = pwd;
srcdir
cd dalguer

if 0
  n = [ 601 301 ];
  dx = .05;
  fid = fopen( 'DFM005paper' );
  t = fscanf( fid,'%g', n )';
  fclose( fid );
  x = dx * ( 0:n(1)-1 );  x = x - .5 * x(end);
  y = dx * ( 0:n(2)-1 );  y = y - .5 * y(end);
  [ c, h ] = contour( x, y, t, v );
  delete( h );
  i  = 1;
  while i < size( c, 2 )
    n  = c(2,i);
    c(:,i) = NaN;
    i  = i + n + 1;
  end
  plot( c(1,:), c(2,:), 'b' )
  hold on
end

if 1
  n = [ 301 151 ];
  dx = .1;
  fid = fopen( 'DFM01paper' );
  t = fscanf( fid,'%g', n )';
  fclose( fid );
  x = dx * ( 0:n(1)-1 );  x = x - .5 * x(end);
  y = dx * ( 0:n(2)-1 );  y = y - .5 * y(end);
  [ c, h ] = contour( x, y, t, v );
  delete( h );
  i  = 1;
  while i < size( c, 2 )
    n  = c(2,i);
    c(:,i) = NaN;
    i  = i + n + 1;
  end
  plot( c(1,:), c(2,:), 'k' )
  hold on
end

if 0
  n = [ 300 150 ];
  dx = .1;
  fid = fopen( 'BI01paper' );
  t = fscanf( fid,'%g', n )';
  fclose( fid );
  x = dx * ( 0:n(1)-1 );  x = x - .5 * x(end);
  y = dx * ( 0:n(2)-1 );  y = y - .5 * y(end);
  [ c, h ] = contour( x, y, t, v );
  delete( h );
  i  = 1;
  while i < size( c, 2 )
    n  = c(2,i);
    c(:,i) = NaN;
    i  = i + n + 1;
  end
  plot( c(1,:), c(2,:), 'g' )
  hold on
end

cd( cwd )
meta
currentstep
for i = 1 : length( out ) + 1
  if strcmp( out{i}{2}, 'trup' ), break, end
end
it = it - mod( it, out{i}{3} );
i1 = [ out{i}{4:6} it ];
i2 = [ out{i}{7:9} it ];
l = abs( faultnormal );
j = max( 1, 3 - l );
k = 6 - j - l;
i1(l) = ihypo(l);
i2(l) = ihypo(l);
[ msg, t ] = read4d( 'trup', i1, i2 );
t = squeeze( t ) + 1.5 * dt;
i1(4) = 1;
i2(4) = 1;
[ msg, x ] = read4d( 'x', i1, i2 );
x = squeeze( x(:,:,:,[j k]) ) / 1000.;
n = size( t );
[ c, h ] = contour( x(:,:,1), x(:,:,2), t, v );
delete( h );
%clabel( c, h )
%set( h, 'Visible', 'off' )
i  = 1;
while i < size( c, 2 )
  n  = c(2,i);
  c(:,i) = NaN;
  i  = i + n + 1;
end
plot( c(1,:), c(2,:), 'r' )

axis equal;
axis ij
xylim = [ -15 15 -7.5 7.5 ];
if ( abs( bc1(j) ) > 1 ), xylim(1) = 0; end
if ( abs( bc2(j) ) > 1 ), xylim(2) = 0; end
if ( abs( bc1(k) ) > 1 ), xylim(3) = 0; end
if ( abs( bc2(k) ) > 1 ), xylim(4) = 0; end
axis( xylim )
plot( 0, 0, 'p', 'MarkerEdgeColor', 'k', 'MarkerFaceColor', 'w', 'MarkerSize', 11 )
title( 'Rupture Time' )
xlabel( 'X (km)' )
ylabel( 'Y (km)' )
hold on

drawnow
%print -depsc2 trup

