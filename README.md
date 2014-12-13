euclid-parser
=============

Parse geometry proof language for diagram-building instructions.

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

var results = parser.parse('\
let a be the point (1,2)\n\
let b = (3, 4)\n\
let s be the segment from a to b\n\
let t be the line determined by a and b\n\
let o be the circle with center a containing b');

console.log(result);
```

Result:

```javascript
[
  { type: 'point', x: 1, y: 2, name: 'a' },
  { type: 'point', x: 3, y: 4, name: 'b' },
  { type: 'segment', p1: 'a', p2: 'b', name: 's' },
  { type: 'line', p1: 'a', p2: 'b', name: 't'},
  { type: 'circle', center: 'a', boundaryPoint: 'b', name: 'o' }
]
```
