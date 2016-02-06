secode
=======

[![NPM version][npm-image]][npm-url]
[![npm download][download-image]][download-url]

[npm-image]: https://img.shields.io/npm/v/secode.svg?style=flat-square
[npm-url]: https://npmjs.org/package/secode
[download-image]: https://img.shields.io/npm/dm/secode.svg?style=flat-square
[download-url]: https://npmjs.org/package/secode

Manipulating security codes, for China market only for now.


## Install

```bash
$ npm install secode
```

## Usage

'sina' is the same as 1.

```js
var secode = require('secode');

secode.restring('159915,600663','sina');
secode.recode('sz159915',0);
secode.recode('159915','1');
secode.recode('sz159915',2);
secode.recode('159915','3');
```
return:
```
'sz159915,sh600663'
'159915'
'sz159915'
'159915sz'
'159915.sz'
```

## License

[MIT](LICENSE.txt)
