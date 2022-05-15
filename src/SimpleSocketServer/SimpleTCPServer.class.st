"
I am a simple socket server for TCP.

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them. 

Public API and Key Messages

- message one   
- message two 
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.
 
Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #SimpleTCPServer,
	#superclass : #Object,
	#instVars : [
		'connectionSocket',
		'isRunning',
		'isRunningLock',
		'onDataReceivedBlock'
	],
	#category : #SimpleSocketServer
}

{ #category : #initialization }
SimpleTCPServer >> initialize [
	
	super initialize.
	isRunningLock := Mutex new.
	self isRunning: false.
	onDataReceivedBlock := [].
]

{ #category : #private }
SimpleTCPServer >> interactOnConnection [
	
	| interactionSocket |
	interactionSocket := connectionSocket waitForAcceptFor: 1 ifTimedOut: [ ^self ].
	[self interactUsing: interactionSocket] fork

]

{ #category : #private }
SimpleTCPServer >> interactUsing: interactionSocket [
	
	| receivedData |
	[ | connected |
	connected := true.
	[connected] whileTrue: [
		receivedData := interactionSocket receiveDataTimeout: 5.
		receivedData =  ''
			ifTrue: [ connected := false ]
			ifFalse: [ 
				onDataReceivedBlock cull: interactionSocket cull: receivedData]]]
		ensure: [ 
			interactionSocket closeAndDestroy  ]
]

{ #category : #testing }
SimpleTCPServer >> isRunning [

	^isRunningLock critical: [ isRunning ].
]

{ #category : #accessing }
SimpleTCPServer >> isRunning: aBoolean [

	^isRunningLock critical: [ isRunning := aBoolean ].
]

{ #category : #accessing }
SimpleTCPServer >> onDataReceive: aBlock [
	
	onDataReceivedBlock := aBlock
]

{ #category : #private }
SimpleTCPServer >> serve [
	
	[ [ self isRunning ]
			whileTrue: [ self interactOnConnection ] ]
		ensure: [ connectionSocket closeAndDestroy  ]
 
]

{ #category : #'changing state' }
SimpleTCPServer >> start [
	
	isRunningLock critical: [
		self isRunning ifTrue: [ ^self ].
		self isRunning: true.  ].
	
	connectionSocket := Socket newTCP.
	connectionSocket listenOn: 9999 backlogSize: 10.
	[ self serve ] fork 
]

{ #category : #'changing state' }
SimpleTCPServer >> stop [
	
	self isRunning: false.
]
