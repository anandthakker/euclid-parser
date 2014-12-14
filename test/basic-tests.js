'use strict'

var fs = require('fs'),
    test = require('tape');

var parser = require('../');
    
    
function testFor(basename) {
  return function(t) {
    var result = parser.parse(fs.readFileSync(require.resolve('./'+basename+'.txt'), {encoding: 'utf8'}));
    var expected = JSON.parse(fs.readFileSync(require.resolve('./'+basename+'.json'), {encoding: 'utf8'}));
    t.plan(expected.length);
    for(var i = 0; i < expected.length; i++) {
      t.same(result[i], expected[i]);
    }
  }
}    

test('parsing point declarations', testFor('point'));
test('parsing circle declarations', testFor('circle'));
test('parsing line declrataions', testFor('line'));
test('parsing line segment declarations', testFor('segment'));
test('parsing intersection declarations', testFor('intersection'));
test('parsing comments and skipping blank lines', testFor('comment'));

test('declarations can end with a period', function(t) {
  t.doesNotThrow(function() {parser.parse('let a = (1,0).');})
  t.end();
});
