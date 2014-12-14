'use strict'

var fs = require('fs'),
    test = require('tape');

var parser = require('../');
    
    
function testFor(basename) {
  return function(t) {
    var result = parser.parse(fs.readFileSync(require.resolve('./'+basename+'.txt'), {encoding: 'utf8'}));
    var expected = JSON.parse(fs.readFileSync(require.resolve('./'+basename+'.json'), {encoding: 'utf8'}));
    t.same(result, expected);
    t.end();
  }
}    

test('parsing point declarations', testFor('point'));
test.only('parsing circle declarations', testFor('circle'));
test('parsing line declrataions', testFor('line'));
test('parsing line segment declarations', testFor('segment'));
test('parsing intersection declarations', testFor('intersection'));
test('parsing comments and skipping blank lines', testFor('comment'));
