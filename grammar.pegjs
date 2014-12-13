{
  function withName(obj, name) {
    obj.name = name;
    return obj;
  }
}

start
= decl*

decl
= (let?) name:varname be obj:object [.\n]* { return withName(obj, name); }
  / draw obj:object name:(and call it name:varname {return name;})? [.\n]* { return withName(obj, name); }

object = point / object2d

point
= point_literal / intersection

point_literal = ((the/a)? t_point)? [ ]*"("[ ]* x:number [ ]*","[ ]* y:number [ ]*")"[ ]* 
  { return {type: 'point', x:x, y:y}; }

object2d = circle / line / segment

circle = (the / a) t_circle 
  (centered) center:varname 
  (containing) boundaryPoint:varname
  { return {type: 'circle', center: center, boundaryPoint: boundaryPoint }; }

line = (the / a) t_line
line:(
  (from p1:varname to p2:varname { return {type: 'line', p1: p1, p2: p2 }; })
  / (containing/(determined by) p1:varname and p2:varname { return {type: 'line', p1: p1, p2: p2 }; })
  ) { return line; }
  
segment = (the / a) t_segment
seg:(
  (from p1:varname to p2:varname { return {type: 'segment', p1: p1, p2: p2 }; })
  / (containing/(determined by)/([ ]*"with endpoints"[ ]*) p1:varname and p2:varname { return {type: 'line', p1: p1, p2: p2 }; })
  ) { return seg; }
  

intersection = 
  (a/the) t_intersection of o1:varname (and) o2:varname
  which:condition?
  { return {type: 'intersection', o1: o1, o2: o2, which: which}; }

condition = that is cond:(
    not varname
    / on varname
  ) { return { op: cond[0], args: [cond[1]] } }

/* tokens */
a =   [ ]* r:("a"i/"an"i)[ ]* { return r; }
be =  [ ]* r:("="/"be"i/"equal"i)[ ]* { return r; }
by =  [ ]* r:"by"i[ ]* { return r; }
is =  [ ]* r:"is"i[ ]+ { return r; }
it =  [ ]* r:"it"i[ ]+ { return r; }
of =  [ ]* r:"of"i[ ]* { return r; }
on =  [ ]* r:"on"i[ ]* { return r; }
to =  [ ]* r:"to"i[ ]* { return r; }
and = [ ]* r:"and"i[ ]* { return r; }
let = [ ]* r:("let"i)[ ]* { return r; }
not = [ ]* r:("not"i)[ ]* { return r; }
the = [ ]* r:"the"i[ ]* { return r; }
call = [ ]* r:"call"i[ ]* { return r; }
draw = [ ]* r:"draw"i[ ]* { return r; }
from = [ ]* r:"from"i[ ]* { return r; }
that = [ ]* r:("that"i)[ ]* { return r; }
centered = [ ]* r:("with center"i/"centered at"i)[ ]* { return r; }
containing = [ ]* r:("containing"i)[ ]* { return r; }
determined = [ ]* r:("defined"i/"determined"i) { return r; }

t_intersection = [ ]*"intersection"i[ ]*
t_segment = [ ]*"segment"i[ ]*
t_circle = [ ]*"circle"i[ ]*
t_line = [ ]*"line"i[ ]*
t_point = [ ]*"point"i[ ]*

number "number" = digits:[0-9\.\-]+ { return parseInt(digits.join(""), 10); }
varname "varname" = (the? (t_segment/t_circle/t_line/t_point))? chars:[a-zA-Z0-9]+ { return chars.join(''); }
