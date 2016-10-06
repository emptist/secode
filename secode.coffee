{recode,restring} = require('./src/recode.coffee')
QQCode = require './src/qqcode'

localSymbol = (證券代碼)->
  if /^[0-9]{5}$/.test 證券代碼 # 港股等證券品種設置如下:
    Number(證券代碼).toString()
  else
    證券代碼

specialContract = (證券代碼)->
  localSymbol = localSymbol(證券代碼)
  if 證券代碼 in ['JPY','GBP','EUR','jpy','gbp','eur']
    # 不應該出現這種情況!
    throw
      message: "證券代碼不對"
      value: 證券代碼
      toString: "#{value}: #{message}"
  else if /^[0-9]{5}$/.test 證券代碼 # 港股等證券品種設置如下:
    currency = 'HKD'
    if 證券代碼[0] in ['1','2']
      currency: "HKD"
      exchange: "SEHK"
      secType: "WAR"
      symbol: 'HSI'
      localSymbol: localSymbol
    else if 證券代碼[0] is '6'
      currency: "HKD"
      exchange: "SEHK"
      secType: "IOPT"
      symbol: 'HSI'
      localSymbol: localSymbol
    else
      currency: "HKD"
      exchange: "SEHK"
      secType: "STK"
      symbol: localSymbol
      localSymbol: localSymbol


# 注意 getTime()所取得的是UTC時間印記. 中國時間-8,美國時間+4即utc
# 注意 getTime()所取得的是UTC時間印記. 中國時間-8,美國時間+4即utc
# 須根據時區和市場確定??
# 長期: 應讀取數據源中的市場信息,例如 hs之類的
# QQ數據有此信息
# 注意 ib對於外匯交易日的收盤時間如何規定
# [臨時]
nowTrading = (證券代碼) ->
  d = new Date()
  h = d.getUTCHours()
  m = d.getMinutes()
  switch recode(證券代碼)[0]
    when 's' then return (d.getDay() < 6) and ((15 - 8) > h > (8 - 8))
    when 'h' then return (d.getDay() < 6) and ((16 - 8) > h > (8 - 8))
    when 'g' then return (d.getDay() < 7) and ((16 + 4) > h > (8 + 4))
    when 'f' then return (d.getDay() < 6) and (((h is 17) and (m > 15)) or (h isnt 17))

當日盤後 = (證券代碼) ->
  d = new Date()
  h = d.getUTCHours()
  m = d.getMinutes()
  switch recode(證券代碼)[0]
    when 's' then return (d.getDay() < 6) and ((14 - 8) < h < 24) # 深滬
    when 'h' then return (d.getDay() < 6) and ((15 - 8) < h < 24) # HongKong
    when 'g' then return (d.getDay() < 7) and ((16 + 4) < h < 24) # global
    when 'f' then return (d.getDay() < 6) and (h > 17) and (m < 15) # forex   # 注意 ib對於外匯交易日的收盤17:15-17:00


module.exports =
  QQCode:QQCode
  recode:recode
  restring:restring
  nowTrading:nowTrading
  當日盤後:當日盤後
  localSymbol:localSymbol
  specialContract:specialContract
