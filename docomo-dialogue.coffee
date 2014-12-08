# Description
#   A Hubot script that calls the docomo dialogue API
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_DOCOMO_DIALOGUE_P
#   HUBOT_DOCOMO_DIALOGUE_API_KEY
#
# Commands:
#   hubot 雑談 <message> - 雑談対話(docomo API)
#
# Notes:
#   たまに無視して沈黙します。
#   会話の継続。context, mode を保存。ただし一定時間(2分ほど)経過したら破棄
#   
# Author:
#   bouzuya <m@bouzuya.net>
#   Mako N <mako@pasero.net>
#
# License:
#   Copyright (c) 2014 bouzuya, Mako N
#   Released under the MIT license
#   http://opensource.org/licenses/mit-license.php
#
module.exports = (robot) ->
  status  = {}

  robot.respond /(?:雑談\s+|(?:(?:(様|さま|サマ|殿|どの|さん|サン|はん|どん|やん|ちゃん|チャン|氏|君|くん|クン|たん|タン|先生|せんせ(?:い|ー))(?:、|。|!|！)?))|(?:(?:、|。|!|！)\s*))(.*)/, (res) ->
    p = parseFloat(process.env.HUBOT_DOCOMO_DIALOGUE_P ? '0.3')
    return unless Math.random() < p
    message = res.match[2]
    return if message is ''

    d = new Date
    now = d.getTime()
    if now - status['time'] > 2 * 60 * 1000
      status =
        "id": ''
        "mode": ''

    if /(たん|タン)/.test(res.match[1])
      status = "t": 30
    else if /(はん|どん|やん)/.test(res.match[1])
      status = "t": 20
    else if d.getDay() is 2
    # 火曜日は関西弁
      status = "t": 20
    else
      status = "t": ''

    res
      .http 'https://api.apigw.smt.docomo.ne.jp/dialogue/v1/dialogue'
      .query APIKEY: process.env.HUBOT_DOCOMO_DIALOGUE_API_KEY
      .header 'Content-Type', 'application/json'
      .post(JSON.stringify({ utt: message, context: status['id'], mode: status['mode'], t: status['t'] })) (err, response, body) ->
        if err?
          console.log "Encountered an error #{err}"
        else
          res.send JSON.parse(body).utt
          status =
            "time": now
            "id": JSON.parse(body).context
            "mode": JSON.parse(body).mode
