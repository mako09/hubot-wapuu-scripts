# Description
#   A Hubot script that calls the docomo knowledge QA API
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_DOCOMO_DIALOGUE_API_KEY
#
# Commands:
#   hubot 教えて <question> - 知識Q&A(docomo API)に質問を投げ、回答を得る
#
# Author:
#   Mako N
#
module.exports = (robot) ->
  robot.respond /(?:(?:(?:、)?(?:教|おし)えて(?:、|。)?)|(?:teach me))\s*(.*)/, (res) ->
    message = res.match[1]
    return if message is ''
    res
      .http("https://api.apigw.smt.docomo.ne.jp/knowledgeQA/v1/ask")
      .query(APIKEY: process.env.HUBOT_DOCOMO_DIALOGUE_API_KEY)
      .query(q: message)
      .get() (err, response, body) ->
        if err
          res.send "Encountered an error #{err}"
        else

          res.send JSON.parse(body).message.textForDisplay

          for key, answers of JSON.parse(body).answers
            text = "     ☞ #{answers.answerText}"
            text += " --- [#{answers.linkText}]" unless answers.linkText is null
            text += "( #{answers.linkUrl} )" unless answers.linkUrl is null or answers.linkUrl is answers.answerText

            res.send text

    res.finish()
