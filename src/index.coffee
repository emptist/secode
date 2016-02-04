convertcode =  (acode,aprefix=1)->
  ###prefix:
    0: '000001'
    1: 'sh000001'
    2: '000001sh'
    3: '000001.sh'
  ###
  if aprefix in ['sina','ht']
    prefix = 1
  else
    prefix = aprefix
    
  code = acode.trim()
  if code[0] is 's'
    return switch prefix
      when 0 then code[2..]
      when 1 then code
      when 2 then "#{code[2..]}#{code[..1]}"
      when 3 then "#{code[2..]}.#{code[..1]}"
  else if code.length > 6
    return convertcode(code[..5],prefix)
  else if code[0] in ['5','6','9']
    return switch prefix
      when 0 then code
      when 1 then "sh#{code}"
      when 2 then "#{code}sh"
      when 3 then "#{code}.sh"
  else
    return switch prefix
      when 0 then code
      when 1 then "sz#{code}"
      when 2 then "#{code}sz"
      when 3 then "#{code}.sz"

convertcodes = (string, prefix)->
  ("#{convertcode cd, prefix}" for cd in string.split(',')).join(',')

module.exports =
  recode: convertcode
  restring: convertcodes
