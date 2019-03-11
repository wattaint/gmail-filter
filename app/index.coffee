labelName = 'acm-dp-logging'
logLabel = GmailApp.getUserLabelByName labelName
regExpFilters = [
  /.*\s»\s.*Build\s#\s\d+\s/
  /^[A-Z]*-[A-Z]* : .*\sstatus\sfor\s\d{4}-\d{2}-\d{2}$/
]

applyJenkinsLabel = ->
  testSubject = (subject) ->
    for regex in regExpFilters
      return true if (subject + "").match regex
    false

  threads = GmailApp.search "in:inbox AND NOT label:#{labelName}", 0, 25
  return false if threads.length <= 0

  for thread, idx in threads
    messages = thread.getMessages()
    
    foundSubject = false
    for eachMessage in messages
      subject = eachMessage.getSubject()
      foundSubject = testSubject subject
      continue if foundSubject

    if foundSubject
      console.log 'Tag label > ', subject
      thread.addLabel logLabel

  console.log ' == done =='
  true
