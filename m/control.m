% GUI Control

keypress = get( gcf, 'CurrentKey' );
keymod   = get( gcf, 'CurrentMod' );
km = length( keymod );
msg = '';
action = 1;
anim = 0;
cursormove = 0;

switch keypress
case { 'h', 'f1' }
  if length( get( hmsg(5), 'String' ) )
    set( hmsg(5), 'String', '' )
  else
    set( hmsg(5), 'String', ...
      { 'Field             F   XY-Cursor    Arrows   Zoom            < >'
        'Magnitude         0   Z-Cursor  PgUp PgDn   Zoom Out          /'
        'Component       1-6   T-Cursor        ; ''   Reset View    Alt-/'
        'Volumes/Slices    V   Hypocenter     Home   Perspective       P'
        'Slice         J K L   Extremum        End   Color Scale     [ ]'
        'Glyphs            G   Render        Enter   Round CS          \\'
        'Isosurfaces       I   Render next   Space   Auto CS       Alt-\\'
        'Surfaces          S   Save snapshot   Ins   Fold CS           C'
        'Mesh              M   Save movie        R   Color scheme  Alt-C'
        'Outline           O   Clean     Backspace   Time Series       T'
        'Axes              A   Restart       Alt-Q   Filtered TS   Alt-T'
      } )
  end
case 'f'
  list = fields;
  for i = 1:length( fields )
    list{i} = [ ' ' list{i} ' ' ];
  end
  i = find( strcmp( field, fields ) );
  i = mod( i, length( fields ) ) + 1;
  field = fields{i};
  list{i}([1 end]) = '[]';
  msg = [ 'Field: ' list{:} ];
case '0', icomp = 0; colorscale
case '1', icomp = 1; colorscale
case '2', icomp = 2; colorscale
case '3', icomp = 3; colorscale
case '4', icomp = 4; colorscale
case '5', icomp = 5; colorscale
case '6', icomp = 6; colorscale
case 'j', islice = 1; msg = 'j slice';
case 'k', islice = 2; msg = 'k slice';
case 'l', islice = 3; msg = 'l slice';
case 'q',          if km, sdx, return, end
case 'leftarrow',  dicursor = [ -10^km 0 0 0 ]; cursor
case 'rightarrow', dicursor = [  10^km 0 0 0 ]; cursor
case 'downarrow',  dicursor = [ 0 -10^km 0 0 ]; cursor
case 'uparrow',    dicursor = [ 0  10^km 0 0 ]; cursor
case 'pagedown',   dicursor = [ 0 0 -10^km 0 ]; cursor
case 'pageup',     dicursor = [ 0 0  10^km 0 ]; cursor
case 'semicolon',  dicursor = [ 0 0 0 -10^km ]; cursor
case 'quote',      dicursor = [ 0 0 0  10^km ]; cursor
case 'home', dicursor = 0; icursor(1:3) = ihypo; cursor; msg = 'Hypocenter';
case 'end',  dicursor = 0; icursor(1:3) = fmaxi; cursor; msg = 'Extreme value';
case 'return',     render
case 'insert',     snap
case 'space'
  rehash
  currentstep
  istep = dit * 10 ^ km;
  if icursor(4) + istep <= it
    icursor(4) = icursor(4) + istep;
    render
    while length( msg ) && icursor(4) < it
      icursor(4) = icursor(4) + 1;
      render
    end
  end
case 'r'
  anim = 1;
  rehash
  currentstep
  istep = dit * 10 ^ km;
  icursorhold = icursor;
  if export && ~exist( 'movie', 'dir' ), mkdir( 'movie' ), end
  while anim && icursor(4) + istep <= it
    icursor(4) = icursor(4) + istep;
    render
    drawnow
    if export && ~length( msg )
      snap( sprintf( 'movie/frame%06d.png', icursor(4) ) )
    end
    rehash
    currentstep
  end
case 'backspace'
  delete( hhud )
  hhud = [];
  set( hmsg, 'String', '' )
case 'comma'
  msg = 'Zoom out';
  if ~km, camva( 1.25 * camva )
  else    camva( 4 * camva )
  end
  panviz = 0;
case 'period'
  msg = 'Zoom In';
  if ~km, camva( .8 * camva )
  else    camva( .25 * camva )
  end
  if length( hhud )
    campos( campos + xcursor - camtarget )
    camtarget( xcursor )
  end
  panviz = 1;
case 'p'
  if strcmp( camproj, 'orthographic' )
    msg  = 'Perspective';
    camproj perspective
    camva( 1.25 * camva )
  else
    msg  = 'Orthographic';
    camproj orthographic
    camva( .8 * camva )
    v1 = camup;
    v2 = campos - camtarget;
    upvec = [ 0 0 0 ];
    pos = [ 0 0 0 ];
    [ tmp, i1 ] = max( abs( v1 ) );
    [ tmp, i2 ] = max( abs( v2 ) );
    upvec(i1) = sign( v1(i1) );
    pos(i2) = sign( v2(i2) ) * norm( v2 );
    camup( upvec )
    campos( camtarget + pos )
  end
case 'slash'
  panviz = 0;
  if km
    msg = 'Reset View';
    if strcmp( camproj, 'orthographic' )
      lookat( islice, upvector, xcenter, camdist )
    else
      lookat( 0, upvector, xcenter, camdist )
    end
    [ tmp, l ] = max( abs( upvector ) );
    tmp = 'xyz';
    cameratoolbar( 'SetMode', 'orbit' )
    cameratoolbar( 'SetCoordSys', tmp(l) )
    set( 1, 'KeyPressFcn', 'control' )
  else
    msg = 'Zoom Out';
    if strcmp( camproj, 'orthographic' )
      v1 = camup;
      v2 = campos - camtarget;
      upvec = [ 0 0 0 ];
      pos = [ 0 0 0 ];
      [ tmp, i1 ] = max( abs( v1 ) );
      [ tmp, i2 ] = max( abs( v2 ) );
      upvec(i1) = sign( v1(i1) );
      pos(i2) = sign( v2(i2) ) * camdist;
      camup( upvec )
      camtarget( xcenter )
      campos( camtarget + pos )
      camva( 22 )
    else
      v2 = campos - camtarget;
      pos = camdist * v2 / norm( v2 );
      camtarget( xcenter )
      campos( camtarget + pos )
      camva( 27.5 )
    end
  end
case 'leftbracket'
  msg = 'Decrease Color Scale';
  if ~km, clim = .8 * get( gca, 'CLim' );
  else    clim = .5 * get( gca, 'CLim' );
  end
  lim = clim(2);
  set( gca, 'CLim', clim )
  if ~icomp, clim(1) = 0; end
  set( htxt(1), 'String', sprintf( '%g', clim(1) ) )
  set( htxt(2), 'String', sprintf( '%g', clim(2) ) )
case 'rightbracket'
  msg = 'Increase Color Scale';
  if ~km, clim = 1.25 * get( gca, 'CLim' );
  else    clim = 2    * get( gca, 'CLim' );
  end
  lim = clim(2);
  set( gca, 'CLim', clim )
  if ~icomp, clim(1) = 0; end
  set( htxt(1), 'String', sprintf( '%g', clim(1) ) )
  set( htxt(2), 'String', sprintf( '%g', clim(2) ) )
case 'backslash'
  if km
    msg = 'Auto Color Scale';
    lim = -1;
    clim = fmax * [ -1 1 ];
    set( gca, 'CLim', clim )
    if ~icomp, clim(1) = 0; end
    set( htxt(1), 'String', sprintf( '%g', clim(1) ) )
    set( htxt(2), 'String', sprintf( '%g', clim(2) ) )
  else
    msg = 'Round Color Scale';
    clim = get( gca, 'CLim' );
    tmp = clim(2);
    exp10 = floor( log10( tmp ) );
    tmp = tmp / 10 ^ exp10;
    exp2 = ceil( log2( tmp ) );
    if exp2 > 2
      exp2 = 0;
      exp10 = exp10 + 1;
    end
    lim = 2 ^ exp2 * 10 ^ exp10;
    clim = lim * [ -1 1 ];
    set( gca, 'CLim', clim )
    if ~icomp, clim(1) = 0; end
    set( htxt(1), 'String', sprintf( '%g', clim(1) ) )
    set( htxt(2), 'String', sprintf( '%g', clim(2) ) )
  end
case 'c'
  switch km
  case 0
    foldcs = ~foldcs;
    if foldcs, msg = 'Folded color scale';
    else       msg = 'Signed color scale';
    end
  case 1
    list = { ' dark ' ' light ' ' b/w ' };
    colorscheme = mod( colorscheme + 1, length( list ) );
    list{colorscheme+1}([1 end]) = '[]';
    msg = [ 'Color scheme: ' list{:} ];
  case 2
    if strcmp( get( hleg(1), 'Visible' ), 'off' )
      set( [hleg htxt], 'Visible', 'on' ),  msg = 'Colorbar on';
      set( haxes(1), 'Position', [ .02 .1 .96 .88 ] );
    else
      set( [hleg htxt], 'Visible', 'off' ), msg = 'Colorbar off';
      set( haxes(1), 'Position', [ .02 .02 .96 .96 ] );
    end
  end
case 'v'
  volviz = ~volviz;
  if volviz, msg = 'Plotting volumes';
  else       msg = 'Plotting slices';
  end
case 'o'
  dooutline = ~dooutline;
  if dooutline, set( houtline, 'Visible', 'on' ),  msg = 'Outline on';
  else          set( houtline, 'Visible', 'off' ), msg = 'Outline off';
  end
case 'g'
  doglyph = ~doglyph * ( 1 + km );
  if doglyph, msg = 'Glyphs on';
  else        msg = 'Glyphs off';
  end
case 'i'
  doisosurf = ~doisosurf;
  if doisosurf, msg = 'Isosurfaces on';
  else          msg = 'Isosurfaces off';
  end
case 'm'
  domesh = ~domesh;
  if domesh, msg = 'Mesh on';
  else       msg = 'Mesh off';
  end
case 's'
  dosurf = ~dosurf;
  if dosurf, msg = 'Surfaces on';
  else       msg = 'Surfaces off';
  end
case 'a'
  if strcmp( get( gca, 'Visible' ), 'off' )
    axis on
    msg = 'Axes On';
  else
    axis off
    msg = 'Axes Off';
  end
case 't'
  sensor = icursor(1:3);
  [ msg, tt, vt, xsensor, tta, vta, labels ] = tsread( field, sensor, km );
  if length( vt )
    tsfigure( colorscheme )
    tsplot
    zoom
    set( gcf, 'KeyPressFcn', 'delete(gcbf)' )
  end
otherwise, return
end

set( hmsg(1), 'String', msg )
