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

recognizer.onresult = (event) ->
	result = event.results[event.resultIndex]
	transcript = result[0].transcript
	stop = /\b(?:stop|stopp|abbruch|halt|bremsen|brems|bleib|anhalten)\b/i.test(transcript)
	start = /\b(?:go|fahr|weiter|start|los|losfahren)\b/i.test(transcript)
	nach = /\b(?:nach|zum|zu|bis)\b/i.test(transcript)
	if nach
		nachResp = transcript.replace /nach/, "Wir kommen in 5 Minuten an bei "
		sprich(nachResp)
	else if stop
		car.animateStop()
		synth.speak(utterStop)
	else if start
		caranimation.start()
		synth.speak(utterStart)
	return

# Speech Synthesis
synth = window.speechSynthesis
utterStart = new SpeechSynthesisUtterance("OK, es kann losgehen!")
utterStop = new SpeechSynthesisUtterance("Die Fahrt wurde abgebrochen!")
sprich = (spruch) ->
	utterThis = new SpeechSynthesisUtterance(spruch)
	voices = synth.getVoices()
	utterThis.voice = voices[47]
	synth.lang = 'de-DE'
	synth.speak(utterThis)
window.speechSynthesis.onvoiceschanged = ->
	voices = synth.getVoices()
	utterStart.voice = voices[47]
	utterStop.voice = voices[47]
	return
synth.lang = 'de-DE'

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

Events.wrap(window).addEventListener "keydown", (event) ->
	recognizer.stop()
	recognizer.start()
	
