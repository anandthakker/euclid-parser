{
  // preprocess: 
  // normalize whitespace to single space / single newline
  
  function named(obj, name) {
    obj.name = name;
    return obj;
  }
  
  /* annotate the given object with source info */
  function o(obj) {
    obj.source = {
      text: text(),
      line: line(),
      column: column()
    }
    return obj;
  }
}

start = r:declaration_list [\n ]* { return r; }

/*
Delcarations are the top-level items -- the 'sentences' of
the grammar.
*/
declaration_list = head:declaration tail:([\n ]+ d:declaration {return d;})*
{ return [head].concat(tail) } 
declaration =
comment
/
('let'i _)? name:variable _ ('be'i/'equal'i/'=') _ obj:object_literal 
{ return named(obj, name) }
/
'draw'i _ obj:object_literal name:(_ name:called {return name;})?
{ return named(obj, name) }

comment = '#' s? val:$([^\n]*) { return {type: 'comment', value: val} }


/* Objects are the 'nouns' for declarations. */
object_literal = point_literal / object_2d_literal / intersection
object_2d_literal = circle_literal / line_literal
object_2d_reference = circle_reference / line_reference


/* Points */
point = point_reference / point_literal / intersection
point_reference 'the name of a point' = 
(athe 'point'i s*)? name:variable
{ return {type: 'point', name:name} }
point_literal '(x,y)' = 
(athe 'point'i s*)?
'('s? x:number s?','s? y:number s?')'
{ return o({type: 'point',x: x,y: y}) }


/* Circles */
circle = circle_reference / circle_literal
circle_reference 'name of a circle' =
'circle'i _ name:variable
{ return {type: 'circle', name: name} }
circle_literal 'circle definition' =
athe 'circle'i _
c1:circle_criterion _ ('and'i _)? c2:circle_criterion
{
  if(c1.type === c2.type) { expected('a center and a point contained by the circle') }
  var ret = o({type: 'circle'});
  ret[c1.type] = c1.point;
  ret[c2.type] = c2.point;
  return ret;
}

circle_criterion =
centeredat _ center:point { return {type: 'center', point: center} }
/
through _ point:point { return {type: 'boundaryPoint', point: point } }


/* Lines & Segments */
line = line_reference / line_literal
line_reference 'the name of a line or segment' =
// line p1-p2
athe type:lineorseg _ p1:point_reference '-' p2:point_reference
{ return {type: 'line', points: [p1, p2]} }
/
type:lineorseg _ name:variable
{ return {type: type, name: name} }
line_literal 'line definition' =
athe type:lineorseg _
points:two_points
{ return o({type: type, points: points}) }

lineorseg = 'line segment'i/'segment'i/line:'line'i
{return (line === 'line') ? 'line' : 'segment' }
two_points =
'from'i _ p1:point _ 'to'i _ p2:point { return [p1,p2]; }
/
(through/'determined by'i/'between'i) _
p1:point ((_ 'and'i _)/(s*','s*)) p2:point { return [p1, p2]; }



/* Intersection points */


intersection =
athe 'intersection of'i _
objects:intersection_objects
which:(_ c:intersection_condition { return c;} )?
{return o({type: 'intersection', objects:objects, which: which});}

intersection_objects =
o1:object_2d_reference ((_ 'and'i _)/(s*','s*)) o2:object_2d_reference
{ return [o1, o2] }
/
o1:variable ((_ 'and'i _)/(s*','s*)) o2:variable
{ return [{type:'unknown',name:o1},{type:'unknown',name:o2}]; }


intersection_condition = 
'that'i _ isnt _ name: variable { return {op:'not', args:[name]} }
/
'that is on'i _ obj:object_2d_reference { return {op: 'on', args:[obj]} }



/* Synonyms */
called = ('and call it'i/'called'i/'named'i) _ name:variable
{ return name; }
centeredat = 'with center'i/'centered at'i
article = ('a'/'an'/'the')
through = ('through'i/'containing'i)
isnt = ("isn't"i/'isnt'i/'is not'i)

/* Shorthand */
athe = (article _)?
s 'whitespace character' = ' '
_ 'whitespace' = s+

/* Primitives */
number 'number' = digits:[0-9\.\-]+ { return parseInt(digits.join(""), 10); }
variable 'variable name' = chars:[a-zA-Z0-9]+ { return chars.join(''); }
