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


```coffee-script

    secode = require('./src/secode.coffee')

    console.log secode.restring('159915,600663','sina');
    for each in ['sz159915','159902','sh600000','150153.sz']
      console.log secode.recode each,0
      console.log secode.recode each,1
      console.log secode.recode each,2
      console.log secode.recode each,3
      console.log secode.recode each,6
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
