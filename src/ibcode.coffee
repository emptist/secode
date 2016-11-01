moment = require 'moment'

class IBCode
  # [未完成]
  @marketOpen: (證券代碼)->
    return

  # [未完成]
  @marketClose: (證券代碼)->
    return

  # [未完成]
  @timeReady:(證券代碼,delta)->
    return true if delta is 0

    if delta > 0 # 開盤時間之後 delta 分鐘
      return moment().utc()?
    else # 收盤時間之前 delta 分鐘
      return moment().utc()?


  @isForex: (證券代碼)->
    (證券代碼.length is 7) and (/usd/i.test 證券代碼)

  @isHK: (證券代碼)->
    /^[0-9]{5}$/.test 證券代碼
  @isHKIOPT:(證券代碼)->
    @isHK(證券代碼) and (證券代碼[0] is '6')
  @isHKWAR:(證券代碼)->
    @isHK(證券代碼) and (證券代碼[0] in ['1','2'])   
  @isHKIOPTWAR:(證券代碼)->
    @isHKIOPT(證券代碼) or @isHKWAR(證券代碼)

  @isABC: (證券代碼)->
    /^[a-z]+$/i.test 證券代碼

  # [臨時] 粗略定義ib的最小交易單位
  @volBase: (證券代碼, contract)->
    {secType, exchange} = contract
    if 證券代碼 in ['00700']
      100
    # 外匯不一定,25000是優惠門檻而已
    #else if secType is 'CASH'
    #  25000
    else if secType is 'IOPT'
      10000
    # 美股/期權都是1為最小單位
    else if (secType in ['OPT','CASH']) or (exchange is 'SMART')
      1
    else
      500
  
  @priceBase:(證券代碼,contract)->
    if @isForex(證券代碼)
      0.005
    else if @isHKIOPTWAR(證券代碼)
      0.001
    else
      0.01

  @priceVol: (證券代碼, contract, price, vol)->
    {secType, exchange} = contract
    priceBase = 0.0001
    volBase = 1
    if 證券代碼 in ['00700']
      volBase = 100
    # 外匯不一定,25000是優惠門檻而已
    else if secType is 'CASH'
      priceBase = 0.005
    else if secType is 'IOPT'
      volBase = 10000
    # 美股/期權都是1為最小單位
    else if (secType in ['OPT','CASH']) or (exchange is 'SMART')
      volBase = 1
    else
      volBase = 500

    fix = if secType is 'STK' then 2 else 3
    if price?
      p = (price//priceBase*priceBase).toFixed(fix)
    else
      p = null

    obj =
      cleanPrice: if p? then Number(p) else null
      cleanVol: (vol // volBase * volBase)

    return obj


  @tooClose:(證券代碼,price1,price2,times=1)->
    delta = @priceBase(證券代碼)*times
    t = delta > Math.abs(price2 - price1)
    return
      t: t 
      m: (delta + price1)/price1

  @tooFar:(證券代碼,price1,price2,times=2)->
    delta = @priceBase(證券代碼)*times
    t = delta > Math.abs(price2 - price1)
    #(@priceBase(證券代碼)*times) < Math.abs(price2 - price1)
    return
      t: t
      m: (delta + price1)/price1
  
  constructor:(@證券代碼=null)->
    unless @證券代碼?
      return

    # 如果能確定contract 就不必secTypeName之類了
    if @證券代碼 in ['JPY','GBP','EUR','jpy','gbp','eur']
      # 不應該出現這種情況!
      throw
        message: "@證券代碼不對"
        value: @證券代碼
        toString: "#{value}: #{message}"
    else if @constructor.isHK(@證券代碼) # 港股等證券品種設置如下:
      @localSymbol = Number(@證券代碼).toString()
      @currency = 'HKD'
      @exchange = 'SEHK'

      # [臨時][未完備] 注意此處僅提供恆生指數之渦輪和牛熊證
      # 若需支持所有品種詳情須查網頁
      #
      # 例如渦輪 12748 其交易資料:
      # https://pennies.interactivebrokers.com/cstools/contract_info/v3.9/index.php?action=Conid%20Info&wlId=IB&conid=244214753&lang=en
      @contract ?=
        if @證券代碼[0] in ['1','2']
          currency: @currency
          exchange: @exchange
          secType: "WAR"
          symbol: 'HSI'
          localSymbol: @localSymbol
        else if @證券代碼[0] is '6'
          currency: @currency
          exchange: @exchange
          secType: "IOPT"
          symbol: 'HSI'
          localSymbol: @localSymbol
        else
          currency: @currency
          exchange: @exchange
          secType: "STK"
          symbol: @localSymbol
          localSymbol: @localSymbol
      @secType = @contract.secType
    else
      # 不能確定contract,但能提供localSymbol,secTypeName,currency等信息,由ib接口解決
      @contract = null
      @localSymbol = @證券代碼
      if @constructor.isForex(@證券代碼)  # 外匯設置如下:
        @secType = 'CASH'
        @secTypeName = 'forex'
        @currency = @symbol = @證券代碼.toUpperCase().replace('.','').replace('USD','')
      else
        # 美股等證券設置如下
        # [臨時][未完備] 此處將除了外匯/港股/滬深證券之外的,用英文字母表示的品種,都當成美股
        if @constructor.isABC(@證券代碼)
          @currency = 'USD'
          @secTypeName = 'stock'
          @secType = 'STK'

  setContract: (@contract)->
    {@證券代碼, @exchange,@currency,@localSymbol} = @contract
    return this

  parameters:(options)->
    return options[@secType]

module.exports = IBCode

###
console.log IBCode.priceVol('000700','secType':'STK', 123.333345, 33333.3333)
###
