# Description:
#   ToDoリストの管理
#
# Dependencies:
#   None
#
# Configuration:
#   None
#
# Commands:
#   hubot メモ リスト - やるべき項目の一覧
#   hubot メモ 追加 <item> - 備忘録に項目を追加する
#   hubot メモ 完了 <item> - 備忘録の項目に完了の印を付ける
#   hubot メモ 完了 - 備忘録の項目のうち完了したものの一覧
#   hubot メモ やり直し <item> - 備忘録の完了の項目からその印を消し、未完とする
#   hubot メモ 削除 <item> - 備忘録の項目を削除する
#   hubot メモ 全削除 - 備忘録のすべての項目を削除する
#
# Author:
#   Mako N
#
# License:
#   Copyright (c) 2014 Mako N <mako@pasero.net>
#   Released under the MIT license
#   http://opensource.org/licenses/mit-license.php
#
module.exports = (robot) ->
  
  robot.brain.data.memorandum =
    todo: {},
    done: {}
  memorandum =
    get: ->
      Object.keys(robot.brain.data.memorandum.todo)
    
    getDone: ->
      Object.keys(robot.brain.data.memorandum.done)
      
    add: (item) ->
      robot.brain.data.memorandum.todo[item] = true
      
    remove: (item) ->
      delete robot.brain.data.memorandum.todo[item]
      true

    bought: (item) ->
      delete robot.brain.data.memorandum.todo[item]
      robot.brain.data.memorandum.done[item] = true

    undo: (item) ->
      delete robot.brain.data.memorandum.done[item]
      robot.brain.data.memorandum.todo[item] = true

  robot.respond /(?:備忘録|メモ|memo|todo)(?:(?:の|\s+)(?:リスト|一覧|list))?\s*$/i, (msg) ->
    list = memorandum.get().join("\n") || "備忘録に登録されている項目はありません。"
    msg.send list
  
  robot.respond /(?:備忘録|メモ|memo|todo)(?:に|\s+)(?:追加|登録|add)\s+(.*)/i, (msg) ->
    item = msg.match[1].trim()
    unless item is ""
      memorandum.add item
      msg.send "備忘録に項目「#{item}」を追加しました。"

  robot.respond /(?:備忘録|メモ|memo|todo)\s+(?:完了|チェック|done)\s+(.*)/i, (msg) ->
    item = msg.match[1].trim()
    unless item is ""
      memorandum.bought item
      msg.send "備忘録の項目「#{item}」を【完了】としました。"

  robot.respond /(?:備忘録|メモ|memo|todo)\s+(?:取り消し|やり直し|redo|undo)\s+(.*)/i, (msg) ->
    item = msg.match[1].trim()
    unless item is ""
      memorandum.undo item
      msg.send "備忘録の項目「#{item}」の【完了】を取り消し、未完としました。"

  robot.respond /(?:備忘録|メモ|memo|todo)(?:を|\s+)(?:全削除|全消去|delete all|del all|remove all|rm all)\s*$/i, (msg) ->
    robot.brain.data.memorandum =
      todo: {},
      done: {}
    msg.send "備忘録からすべての項目を削除しました。"
    msg.finish()

  robot.respond /(?:備忘録|メモ|memo|todo)(?:から|\s+)(?:削除|消去|delete|del|remove|rm)\s+(.*)/i, (msg) ->
    item = msg.match[1].trim()
    memorandum.undo item
    memorandum.remove item
    msg.send "備忘録から項目「#{item}」を削除しました。"

  robot.respond /(?:備忘録|メモ|memo|todo)(?:の|\s+)(?:完了|終了|finished\s*)(?:リスト|list)?\s*$/i, (msg) ->
    list = memorandum.getDone().join("\n") || "完了している項目はありません。"
    msg.send list
