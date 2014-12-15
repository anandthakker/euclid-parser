euclid-parser [![Build Status](https://travis-ci.org/anandthakker/euclid-parser.svg?branch=master)](https://travis-ci.org/anandthakker/euclid-parser)
=============

Parse geometry proof language for diagram-building instructions.  Built using
[PEG.js](http://pegjs.majda.cz/).  Play with the grammar [online here](http://peg.arcanis.fr/3KpPND/1/).

# Install

`npm install euclid-parser`

Or:

```bash
git clone https://github.com/anandthakker/euclid-parser.git
cd euclid-parser
npm install
```

# Usage

```javascript
var parser = require('euclid-parser');

var input = [
  'let a be the point (1,2)',
  'let b = (3, 4)',
  'let s be the segment from a to b',
  'let t be the line determined by a and b',
  'let o be the circle with center a containing b',
  'let x be the intersection of circle o and line t',
  'let y be the intersection of circle o and line t that isn\'t x'
].join('\n');

console.log(parser.parse(input));
```

Result:

```javascript
[{
  "type": "point",
  "x": 1,
  "y": 2,
  "source": {
    "text": "the point (1,2)",
    "line": 1,
    "column": 10
  },
  "name": "a"
}, {
  "type": "point",
  "x": 3,
  "y": 4,
  "source": {
    "text": "(3, 4)",
    "line": 2,
    "column": 9
  },
  "name": "b"
}, {
  "type": "segment",
  "points": [{
    "type": "point",
    "name": "a"
  }, {
    "type": "point",
    "name": "b"
  }],
  "source": {
    "text": "the segment from a to b",
    "line": 3,
    "column": 10
  },
  "name": "s"
}, {
  "type": "line",
  "points": [{
    "type": "point",
    "name": "a"
  }, {
    "type": "point",
    "name": "b"
  }],
  "source": {
    "text": "the line determined by a and b",
    "line": 4,
    "column": 10
  },
  "name": "t"
}, {
  "type": "circle",
  "source": {
    "text": "the circle with center a containing b",
    "line": 5,
    "column": 10
    },
  "center": {
    "type": "point",
    "name": "a"
    },
  "boundaryPoint": {
    "type": "point",
    "name": "b"
  },
  "name": "o"
}, {
  "type": "intersection",
  "objects": [{
    "type": "circle",
    "name": "o"
  }, {
    "type": "line",
    "name": "t"
  }],
  "which": null,
  "source": {
    "text": "the intersection of circle o and line t",
    "line": 6,
    "column": 10
  },
  "name": "x"
}, {
  "type": "intersection",
  "objects": [{
    "type": "circle",
    "name": "o"
  }, {
    "type": "line",
    "name": "t"
  }],
  "which": {
    "op": "not",
    "args": [
    "x"
    ]
  },
  "source": {
    "text": "the intersection of circle o and line t that isn't x",
    "line": 7,
    "column": 10
  },
  "name": "y"
}]

```
