extends Timer

class_name StageTimer

enum Type {
	WAIT,
	START_STAGE,
	START_PERSON,
	SPAWN_PERSONAL_DOC,
	SPAWN_STAGE_DOC,
	SPAWN_PERSONAL_PIC,
	READY_FOR_VERDICT
	}

class TimerObject:
	var type : Type
	var delay : float
	var object
	func _init(type : Type, delay : float = 1.0, object = null):
		self.type = type
		self.delay = delay
		self.object = object

var queue : Array[TimerObject] = []

var loader : StageLoader

func _ready():
	loader = get_parent()

func _process(delta):
	if is_stopped() and not queue.is_empty():
		start(queue[0].delay)

func _on_timeout():
	var action : TimerObject = queue.pop_front()
	print_debug("STAGETIMER: ", Type.keys()[action.type])
	if action.type == Type.WAIT:
		pass
	if action.type == Type.START_STAGE:
		loader.start_stage()
	if action.type == Type.START_PERSON:
		loader.start_person(action.object)
	elif action.type == Type.SPAWN_STAGE_DOC:
		loader.spawn_stage_doc(action.object)
	elif action.type == Type.SPAWN_PERSONAL_DOC:
		loader.spawn_personal_doc(action.object)
	elif action.type == Type.SPAWN_PERSONAL_PIC:
		loader.spawn_polaroid(action.object)
	elif action.type == Type.READY_FOR_VERDICT:
		loader.person_active = true

func spawn_stage_doc(doc, delay = 0.5):
	queue.append(TimerObject.new(Type.SPAWN_STAGE_DOC, delay, doc))

func spawn_personal_doc(doc, delay = 0.5):
	queue.append(TimerObject.new(Type.SPAWN_PERSONAL_DOC, delay, doc))

func spawn_personal_pic(person, delay = 3):
	queue.append(TimerObject.new(Type.SPAWN_PERSONAL_PIC, delay, person))
	
func add_pause(delay):
	queue.append(TimerObject.new(Type.WAIT, delay))

func start_stage(delay = 1):
	queue.append(TimerObject.new(Type.START_STAGE, delay))
	
func start_person(person, delay = 3):
	queue.append(TimerObject.new(Type.START_PERSON, delay, person))

func ready_for_verdict():
	queue.append(TimerObject.new(Type.READY_FOR_VERDICT, 0))
