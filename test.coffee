secode = require('./src/recode.coffee')

console.log secode.restring('159915,600663,USDJPY,yhoo,ibm','sina');
for each in ['sz159915','159902','sh600000','150153.sz']
  console.log secode.recode each,0
  console.log secode.recode each,1
  console.log secode.recode each,2
  console.log secode.recode each,3
  console.log secode.recode each,6
