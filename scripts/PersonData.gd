extends Resource
class_name PersonData

@export var name: String = "N/A"
@export_multiline var correct_verdict = "Yes! Good job!"
@export_multiline var wrong_verdict = "So close! Actually a sinner."
@export var portrait: Texture2D = null
@export var verdict_sinner: bool = false
@export var person_documents: Array[PackedScene] = []
