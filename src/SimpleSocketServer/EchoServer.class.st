"
""I am a Simple Socket server to show example of using socket.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.

    Instance Variables
	connectionSocket:		<Object>
	isRunning:		<Object>
	isRunningLock:		<Object>


    Implementation Points
"
Class {
	#name : #EchoServer,
	#superclass : #SimpleTCPServer,
	#classInstVars : [
		'singleton'
	],
	#category : #SimpleSocketServer
}

{ #category : #examples }
EchoServer class >> example [
	"self start; example"

	| clientSocket serverAddress echoString |
	serverAddress := NetNameResolver addressForName: '127.0.0.1'.
	clientSocket := Socket newTCP.
	[[ 
	clientSocket
		connectTo: serverAddress port: 9999;
		waitForConnectionFor: 10.
	10 timesRepeat: [ 
		clientSocket sendData: 'Hello, Pharo!'.
		echoString := clientSocket receiveDataTimeout: 5.
		echoString crTrace.
		(Delay forMilliseconds: 100) wait ] ] ensure: [ 
		Transcript crTrace: 'ClientSocket closed'.
		clientSocket closeAndDestroy ]] fork
]

{ #category : #'class initialization' }
EchoServer class >> initialize [
	
	"self initialize"
	singleton := nil.

]

{ #category : #accessing }
EchoServer class >> start [

	"self start"
	
	singleton ifNil: [ singleton := self new. ].
	singleton start.
]

{ #category : #accessing }
EchoServer class >> stop [
	
	"self stop"
	singleton ifNotNil: [ singleton stop ]

]

{ #category : #initialization }
EchoServer >> initialize [ 
	
	super initialize.
	self onDataReceive: [ :socket :receivedData | socket sendData: 'ECHO: ', receivedData  ].
]
