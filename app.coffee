SpeechRecognition = window.SpeechRecognition or window.webkitSpeechRecognition
# Create a new recognizer
recognizer = new SpeechRecognition
# Start producing results before the person has finished speaking
recognizer.interimResults = true
# Set the language of the recognizer
recognizer.lang = 'de-DE'
#recognizer.lang = 'en-US'
#recognizer.continuous = true

recognizer.onresult = (event) ->
	result = event.results[event.resultIndex]
	transcript = result[0].transcript
	stop = /\b(?:stop|stopp|halt|bremsen|brems|bleib|anhalten)\b/i.test(transcript)
	start = /\b(?:go|fahr|weiter|start|los|losfahren)\b/i.test(transcript)
	if stop
		car.animateStop()
		synth.speak(utterStop)
	if start
		caranimation.start()
		synth.speak(utterStart)
	return

# Speech Synthesis
synth = window.speechSynthesis
utterStart = new SpeechSynthesisUtterance("OK, es kann losgehen!")
utterStop = new SpeechSynthesisUtterance("Wir haben angehalten!")
window.speechSynthesis.onvoiceschanged = ->
	voices = synth.getVoices()
	utterStart.voice = voices[47]
	utterStop.voice = voices[47]
	return
synth.lang = 'de-DE'

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
	
