{fetchUrl} = require 'fetch'

# 查奇葩的騰訊代碼
class QQCode
  constructor:(con={})->
    @symbol = con.symbol
    @region = con.region ? 'all'
    @options = con.options ? method: 'GET'
    #@fetchUrl = con.fetchUrl

  url: ->
    "http://smartbox.gtimg.cn/s3/?v=2&q=#{@symbol}&t=#{@region}"

  recode: (callback)=>
    fetchUrl @url(), @options, (err,meta,body)=>
      if err?
        callback err, null
        return


      result = ''
      e = null
      try
        eval body.toString()
        hint = v_hint.split(@symbol.toLowerCase())

        #console.log "[debugging] qqdata >> recode: ", @symbol,hint

        result1 = hint[0].split('~')[0]
        result2 = @symbol.toUpperCase()
        result3 = hint[1].split('~')[0].toUpperCase()
        result =  "#{result1}#{result2}#{result3}"
      catch error
        console.error "[debugging] qqdata >> recode: @symbol", error, hint
        e = error

      callback e, result


module.exports = QQCode
