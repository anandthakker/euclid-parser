'use strict'

var test = require('tape');

var parser = require('../');
    
    
test('parsing point, segment, line, and circle literals', function(t) {
  var result = parser.parse('\
  let a be the point (1,2)\n\
  let b be the point (3, 4)\n\
  let s be the segment from a to b\n\
  let t be the line determined by a and b\n\
  let o be the circle with center a containing b\n\
  '.trim());
  
  t.same(result, [
    { type: 'point', x: 1, y: 2, name: 'a' },
    { type: 'point', x: 3, y: 4, name: 'b' },
    { type: 'segment', p1: 'a', p2: 'b', name: 's' },
    { type: 'line', p1: 'a', p2: 'b', name: 't'},
    { type: 'circle', center: 'a', boundaryPoint: 'b', name: 'o' } ]
  );

  t.end();
});

test('"draw a ____"', function(t) {
  var result = parser.parse('draw a circle centered at a containing b');
  t.same(result, [ { type: 'circle', center: 'a', boundaryPoint: 'b', 'name': null } ]);
  result = parser.parse('draw a circle centered at a containing b and call it x');
  t.same(result, [ { type: 'circle', center: 'a', boundaryPoint: 'b', 'name': 'x' } ]);
  t.end();
})

test('parsing intersections', function(t) {
  try {
    var result = parser.parse('\
      let i be the intersection of s and o\n\
      let k be the intersection of s and o that is not i\n\
      let l be the intersection of s and o that is on s\n\
      '.trim());
    
    t.same(result, [ 
      { which: null, name: 'i', o1: 's', o2: 'o', type: 'intersection' },
      { which: { op: 'not', args: ['i'] }, name: 'k', o1: 's', o2: 'o', type: 'intersection' },
      { which: { op: 'on', args: ['s'] }, name: 'l', o1: 's', o2: 'o', type: 'intersection' } ]
    );
    
    t.end();
  } catch(e) {
    console.log(e);
  }
})
