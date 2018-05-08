# Description
#   A Hubot script that calls the docomo dialogue API
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_DOCOMO_DIALOGUE_P
#   HUBOT_DOCOMO_DIALOGUE_API_KEY
#   HUBOT_DOCOMO_DIALOGUE_APPID
#
# Commands:
#   hubot 雑談 <message> - 雑談対話(docomo API)
#
# Notes:
#   たまに無視して沈黙します。(確率は HUBOT_DOCOMO_DIALOGUE_P で設定可)
#   
# Author:
#   bouzuya <m@bouzuya.net>
#   Mako N <mako@pasero.net>
#
# License:
#   Copyright (c) 2014-2018 bouzuya, Mako N
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

    d = new Date()
    appSendTime = d.getFullYear() + '-' + ('0' + (d.getMonth() + 1)).slice(-2) + '-' + ('0' + d.getDate()).slice(-2) + ' '\
                   + d.getHours() + ':' + d.getMinutes() + ':' + d.getSeconds()
    param = { language: "ja-JP",\
              botId: "Chatting",\
              appId: process.env.HUBOT_DOCOMO_DIALOGUE_APPID,\
              voiceText: message,\
              clientData: { "option": { "mode": ( status['mode'] ? "dialog" ) } },\
              appRecvTime: status['appRecvTime'],\
              appSendTime: appSendTime }
    res
      .http 'https://api.apigw.smt.docomo.ne.jp/naturalChatting/v1/dialogue'
      .query APIKEY: process.env.HUBOT_DOCOMO_DIALOGUE_API_KEY
      .header 'Content-Type', 'application/json'
      .post(JSON.stringify(param)) (err, response, body) ->
        if err?
          console.log "Encountered an error #{err}"
        else
          res.send JSON.parse(body).systemText['expression']
          option = new Buffer(JSON.parse(body).command, 'base64')
          status =
            "mode": JSON.parse(option.toString()).mode
            "appRecvTime": JSON.parse(body).serverSendTime
