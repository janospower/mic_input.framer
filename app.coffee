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
	if start
		caranimation.start()
	if result.isFinal
		textBox.html = transcript
	#interim:
	else
		textBox.html = transcript
	return

# Start listening...
record = new Layer
	backgroundColor: "none"
	color: "#000"
	html: "record"

record.onClick (event, layer) ->
	recognizer.start()

textBox = new Layer
	backgroundColor: "none"
	color: "#000"
	y: 50
	html: "output"

car = new Layer
	backgroundColor: "none"
	color: "#000"
	y: 100
	x: 500
	html: "🚗 "
 
caranimation = new Animation car,
	x: 0
	options:
		curve: "ease"
		time: 10


# On animation end restart the animation 
caranimation.on Events.AnimationEnd, ->
	#caranimation.restart()