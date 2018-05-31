SpeechRecognition = window.SpeechRecognition or window.webkitSpeechRecognition
# Create a new recognizer
recognizer = new SpeechRecognition
# Start producing results before the person has finished speaking
recognizer.interimResults = true
# Set the language of the recognizer

#
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

whereto = null
rstop = null
rstart = null
rnach = null
toVocab = null
toUni = null
toK = null
toSE = null
toOffice = null
noComp = null
rcancel = null
rbegin = null
rsorry = null
rsorrycont = null

sprache = "en"
#sprache = "de"
setSprache = (s) ->
	sprache = s
	if s == "en"
		recognizer.lang = 'en-US'
		synth.lang = 'en-US'
		toVocab = ['to', 'towards', 'till', 'into', 'in']
		rstop = /\b(?:stop|stopp|cancel|break|stay|)\b/i
		rstart = /\b(?:go|drive|ride|continue|start|resume|keep)\b/i
		rnach = /\b(?:to|towards|till|into|in)\b/i
		whereto = 'Welcome! Where would you like to go today?'
		toUni = 'Ok, starting the ride towards the Communication design building!'
		toK = /\b(?:Communication|Design|building)\b/i
		toSE = /\b(?:sehen|ernten|office|offices|bureau|and)\b/i
		toOffice = 'Ok, lets go to the sehen und Ernten Offices!'
		noComp = "I'm sorry, I didn't quite get that!"
		rcancel = "The car has stopped!"
		rbegin = "OK, let's get started!"
		rsorry = "I'm afraid we don't have a tour that includes"
		rsorrycont = 'Please choose from the communication design building or the sehen and ernten offices'
	else if s == "de"
		recognizer.lang = 'de-DE'
		synth.lang = 'de-DE'
		toVocab = ['nach', 'zum', 'zu', 'bis', 'in']
		rstop = /\b(?:stop|stopp|abbruch|halt|bremsen|brems|bleib|anhalten)\b/i
		rstart = /\b(?:phallus|go|fahr|weiter|start|los|losfahren)\b/i
		rnach = /\b(?:nach|zum|zu|bis|in)\b/i
		whereto = 'Guten Tag! Wohin würden Sie gerne Fahren?'
		nach = /\b(?:nach|zum|zu|bis|in)\b/i
		toUni = 'Ok, es kann Losgehen zum H.T.W. Kommunikationsdesign Gebäude!'
		toK = /\b(?:Kommunikationsdesign)\b/i
		toSE = /\b(?:sehen|ernten|Büro)\b/i
		toOffice = 'Ok, es kann Losgehen zum sehen und Ernten Büro!'
		noComp = 'das hab ich leider nicht verstanden'
		rcancel = "Die Fahrt wurde abgebrochen!"
		rbegin = "OK, es kann losgehen!"
		rsorry = 'Leider haben wir für'
		rsorrycont = 'keine Tour im Angebot. Bitte wählen Sie aus Kommunikationsdesign oder dem sehen und ernten Büro'

setSprache(sprache)


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

#Utils.delay 0.4, ->
	

Events.wrap(window).addEventListener "keydown", (event) ->
	if event.keyCode is 32
		sprich(whereto, true)
	#recognizer.stop()
	#recognizer.start()

recognizer.onresult = (event) ->
	result = event.results[event.resultIndex]
	transcript = result[0].transcript
	print transcript
	start = rstart.test(transcript)
	stop = rstop.test(transcript)
	nach = rnach.test(transcript)
	validDestK = toK.test(transcript)
	validDestSE = toSE.test(transcript)
	de = /\b(?:deutsch|german)\b/i.test(transcript)
	en = /\b(?:english|Englisch)\b/i.test(transcript)
	nachInvalidDest = nach && !validDestK && !validDestSE
	grade = switch
		when validDestK then sprich(toUni, false)
		when de then setSprache("de"); sprich("OK, die sprache wurde auf deutsch gewechselt", false)
		when en then setSprache("en"); sprich("OK, the language has been set to english", false)
		when validDestSE then sprich(toOffice, false)
		when nachInvalidDest then sprich((rsorry + checkIndex(toVocab,transcript) + rsorrycont), true)
		#transcript.replace /nach/, "Wir kommen in 5 Minuten an bei "
		when stop then sprich(rcancel, true); car.animateStop()
		when start then sprich(rbegin, false); caranimation.start()
		else sprich(noComp, true)
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

#helpers
sprich = (spruch, listen) ->
	utterThis = new SpeechSynthesisUtterance(spruch)
	voices = synth.getVoices()
	if sprache == "de"
		utterThis.voice = voices[47]
	else if sprache == "en"
		utterThis.voice = voices[48]
	console.log("utterance", utterThis)
	synth.speak(utterThis)
	utterThis.onend = (event) ->
		#print 'stopped'
		if listen
			recognizer.stop()
			recognizer.start()
	return


# String to array of words:
sta = (str) ->
  str.toLowerCase().trim().split ' '

# On animation end restart the animation 
caranimation.on Events.AnimationEnd, ->
	#caranimation.restart()

