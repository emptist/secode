{recode,restring} = require('./src/recode.coffee')
QQCode = require './src/qqcode'

# 注意 getTime()所取得的是UTC時間印記. 中國時間-8,美國時間+4即utc
# 注意 getTime()所取得的是UTC時間印記. 中國時間-8,美國時間+4即utc
# 須根據時區和市場確定??
# 長期: 應讀取數據源中的市場信息,例如 hs之類的
# QQ數據有此信息
# 注意 ib對於外匯交易日的收盤時間如何規定
# [臨時]
nowTrading:(證券代碼) ->
  d = new Date()
  h = d.getUTCHours()
  m = d.getMinutes()
  switch recode(證券代碼)[0]
    when 's' then return (d.getDay() < 6) and ((15 - 8) > h > (8 - 8))
    when 'h' then return (d.getDay() < 6) and ((16 - 8) > h > (8 - 8))
    when 'g' then return (d.getDay() < 7) and ((16 + 4) > h > (8 + 4))
    when 'f' then return (d.getDay() < 6) and (((h is 17) and (m > 15)) or (h isnt 17))

module.exports =
  QQCode:QQCode
  recode:recode
  restring:restring
  nowTrading:nowTrading