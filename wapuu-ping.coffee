# Description:
#   Scripts for wapuu.
#
# Notes:
#
# License:
#   Copyright (c) 2014 Mako N <mako@pasero.net>
#   Released under the MIT license
#   http://opensource.org/licenses/mit-license.php
#
module.exports = (robot) ->

  robot.respond /(((い|ゐ|居)(て?))(?!り)|(お|を|居)|((い|居)(て?)は)(?!ま))((る|ん(?=の))|((り?)ます)(?!ん))((の?ん?)(です)?|(んだ)(?!か))?(か(い?な?|よ|ね)?|(よ?)(ね|な))?\s?(\?|？)/i, (msg) ->
    msg.send "はい、ここにいます!"

  robot.respond /(い|生|活|お|起)き(て|と(?=(る|ん)))(((い|ゐ|居)(て?))(?!り)|(お|を|居)|)?((る|ん(?=の))|((り?)ます)(?!ん))((の?ん?)(です)?|(んだ)(?!か))?(か(い?な?|よ|ね)?|(よ?)(ね|な))?/i, (msg) ->
    msg.send "はい、ここにいます。"

  robot.respond /(調子どう|元気)/i, (msg) ->
    msg.send "はい、元気です。"
