SpeechRecognition = window.SpeechRecognition or window.webkitSpeechRecognition
# Create a new recognizer
recognizer = new SpeechRecognition
# Start producing results before the person has finished speaking
recognizer.interimResults = true
# Set the language of the recognizer
recognizer.lang = 'de-DE'
#recognizer.lang = 'en-US'
#recognizer.continuous = true
recognizer.interimResults = false

recognizer.onstart = (event) ->
	synthActive.animate
		opacity: 1
		options:
			time: 0.2

recognizer.onend = (event) ->
	synthActive.animate
		opacity: 0
		options:
			time: 0.2


# Speech Synthesis
synth = window.speechSynthesis
sprich = (spruch, listen) ->
	utterThis = new SpeechSynthesisUtterance(spruch)
	voices = synth.getVoices()
	utterThis.voice = voices[47]
	synth.lang = 'de-DE'
	console.log("utterance", utterThis)
	synth.speak(utterThis)
	utterThis.onend = (event) ->
		print 'stopped'
		if listen
			recognizer.stop()
			recognizer.start()
	return
	
synth.lang = 'de-DE'

# String to array of words:
sta = (str) ->
  str.toLowerCase().trim().split ' '

toVocab = ['nach', 'zum', 'zu', 'bis', 'in']
checkIndex = (vocab, trans) ->
	transcriptArray = sta(trans)
	destination = ""
	for xx, i in transcriptArray
		for xx, j in vocab
			if transcriptArray[i] == vocab[j]
				ind = i
		if i > ind
			destination += transcriptArray[i]
	return destination
#for 'stopp', index in stopVocab
#console.log 'stopp', index
#print stopVocab.indexOf('stoppp')

rstop = /\b(?:stop|stopp|abbruch|halt|bremsen|brems|bleib|anhalten)\b/i
rstart = /\b(?:phallus|go|fahr|weiter|start|los|losfahren)\b/i
rnach = /\b(?:nach|zum|zu|bis)\b/i

#Utils.delay 0.4, ->
	

Events.wrap(window).addEventListener "keydown", (event) ->
	if event.keyCode is 32
		sprich('Guten Tag! Wohin würden Sie gerne Fahren?', true)
	#recognizer.stop()
	#recognizer.start()

recognizer.onresult = (event) ->
	result = event.results[event.resultIndex]
	transcript = result[0].transcript
	start = rstart.test(transcript)
	stop = rstop.test(transcript)
	validDest = /\b(?:Kommunikationsdesign|Turm)\b/i.test(transcript)
	nach = /\b(?:nach|zum|zu|bis|in)\b/i.test(transcript)
	nachInvalidDest = nach && !validDest
	nachDest = nach && validDest
	grade = switch
		when nachDest then sprich('Ok, es kann Losgehen!', false)
		when nachInvalidDest then sprich(('Leider haben wir für' + checkIndex(toVocab,transcript) + 'keine Tour im Angebot. Bitte wählen Sie aus Kommunikationsdesign oder dem Peter Behrens Turm'), true)
		#transcript.replace /nach/, "Wir kommen in 5 Minuten an bei "
		when stop then sprich("Die Fahrt wurde abgebrochen!", true); car.animateStop()
		when start then sprich("OK, es kann losgehen!", false); caranimation.start()
		else sprich('das hab ich leider nicht verstanden', false)
	return

synthActive = new Layer
	width: 20
	height: 20
	x: 0
	y: 0
	backgroundColor: "red"
	borderRadius: 25
	opacity: 0

car = new Layer
	backgroundColor: "none"
	color: "#000"
	y: 100
	x: 500
	html: "🚗 "
 
caranimation = new Animation car,
	x: 0
	options:
		curve: "linear"
		time: 10


# On animation end restart the animation 
caranimation.on Events.AnimationEnd, ->
	#caranimation.restart()

