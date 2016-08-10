convertcode =  (acode,aprefix=1)->
  ###prefix:
    0: '000001'
    1: 'sh000001'
    2: '000001sh'
    3: '000001.sh'
    6: '0600663','1159915' # 126.net, 163.com
    'ib': ib broker
  ###
  ###
  新浪即時行情代碼特點:
    道指 gb_$dji
    納指 gb_ixic
    美股 gb_小寫字母公司代碼 gb_yhoo
    NYMEX原油 hf_CL
    外匯 全部大寫字母 USDJPY等等
    富時 b_UKX
    道瓊斯歐元區指數 b_SX5E
  ###
  if aprefix in ['sina','ht']
    prefix = 1
  else
    prefix = aprefix

  code = acode.trim()
  if /^[0-9]{5}$/.test code
    return switch prefix
      when 0 then code
      when 1 then "hk#{code}"
      
  else if (/usd/i.test code) and ((/^[A-Z]{6}$/i.test code) or (/^[A-Z]{3}\.[A-Z]{3}$/i.test code)) # 當作外匯
    return switch prefix
      when 0 then code
      when 1 then "fx_s#{code.toLowerCase()}"

  else if (/^[a-z]{3}/i.test code) or (/^[a-z]{2}$/i.test code) or (/^[a-z]$/i.test code) # 當作國外股票
    return switch prefix
      when 0 then code#.toLowerCase()?
      when 1 then "gb_#{code.toLowerCase().replace('.','$')}"

  else if /^gb_[a-z]{1}/i.test code # 當作國外股票
    return switch prefix
      when 0 then code.replace('$','.')[3..]#.toLowerCase()?
      when 1 then code.toLowerCase().replace('$','.')

  else if /^fx_s[a-z]{2}/i.test code # 新浪外匯
    return switch prefix
      when 0 then code[4..]
      when 1 then code.toLowerCase()


  else if /^s[h|z]\d{6}$/i.test code
    return switch prefix
      when 0 then code[2..]
      when 1 then code
      when 2 then "#{code[2..]}#{code[..1]}"
      when 3 then "#{code[2..]}.#{code[..1]}"
      when 6
        if code[1] is 'h'
          "0#{code[2..]}"
        else if code[1] is 'z'
          "1#{code[2..]}"
        else throw "secode >> 未知代碼:/^s[h|z]\d{6}$/i.test code #{code}"

  else if code.length > 6
    if /^\d{7}$/.test code
      return switch prefix
        when 0 then code[1..]
        when 1
          if code[0] is '0' then "sh#{code[1..]}" else "sz#{code[1..]}"
        when 2
          if code[0] is '0' then "#{code[1..]}sh" else "#{code[1..]}sz"
        when 3
          if code[0] is '0' then "#{code[1..]}.sh" else "#{code[1..]}.sz"
        when 6 then code
    else if /^\d{6}/.test code
      return convertcode(code[..5],prefix)
    else throw "secode >> 未知代碼 code.length > 6 #{code}"

  else if /^\d{6}$/.test code #code.length is 6
    if /^(5|6|9|11|13)/.test code #code[0] in ['5','6','9']
      return switch prefix
        when 0 then code
        when 1 then "sh#{code}"
        when 2 then "#{code}sh"
        when 3 then "#{code}.sh"
        when 6 then "0#{code}"
    else
      return switch prefix
        when 0 then code
        when 1 then "sz#{code}"
        when 2 then "#{code}sz"
        when 3 then "#{code}.sz"
        when 6 then "1#{code}"
  else
    throw "secode >> 未知代碼 #{code}"

convertcodes = (string, prefix)->
  ("#{convertcode cd, prefix}" for cd in string.split(',')).join(',')




module.exports =
  recode: convertcode
  restring: convertcodes
#console.log convertcodes 'gb_ibm,yhoo'#'110038'
