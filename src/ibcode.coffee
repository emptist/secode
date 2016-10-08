class IBCode
  @isForex: (證券代碼)->
    (證券代碼.length is 7) and (/usd/i.test 證券代碼)

  @isHK: (證券代碼)->
    /^[0-9]{5}$/.test 證券代碼

  @isABC: (證券代碼)->
    /^[a-z]+$/i.test 證券代碼

  @recodePosition: (position)->
    position.證券代碼 ?= @contract(position.contract)
    return position

  # change contract, and return 證券代碼
  @contract: (contract)->
    證券代碼 = contract.localSymbol
    if contract.primaryExch is 'SEHK'
      證券代碼 = "0000#{證券代碼}"[-5..]
    # [未完備]
    {primaryExch} = contract
    if primaryExch in ['NASDAQ'] # 還有哪些?
      contract.exchange ?= 'SMART'
    else
      contract.exchange ?= primaryExch

    return 證券代碼


  constructor:(@證券代碼=null)->

  # read, modify position from portfolio db and
  # return contract
  # 存在問題: 美股的options,node-ib接口的localSymbol中間有空格,不知是否特意,須進一步研究
  contractDB: (position)->
    {@contract} = @constructor.recodePosition(position)
    {@exchange,@currency,@localSymbol} = @contract

    return @contract

  setContract: (@contract)->
    @證券代碼 ?= @constructor.contract(@contract)
    {@exchange,@currency,@localSymbol} = @contract

    return this

  securityCode:(@證券代碼)->
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
    else
      # 不能確定contract,但能提供localSymbol,secTypeName,currency等信息,由ib接口解決
      @contract = null
      @localSymbol = @證券代碼
      if @constructor.isForex(@證券代碼)  # 外匯設置如下:
        @secTypeName = 'forex'
        @currency = @symbol = @證券代碼.toUpperCase().replace('.','').replace('USD','')
      else
        # 美股等證券設置如下
        # [臨時][未完備] 此處將除了外匯/港股/滬深證券之外的,用英文字母表示的品種,都當成美股
        if @constructor.isABC(@證券代碼)
          @currency = 'USD'
          @secTypeName = 'stock'

    return this





module.exports = IBCode
