extends Node

var time_trial : = false
var timer_running : = false
var level : = false
var chapter : = false
var game : = false

var start_time : int
var elapsed_ms : int
var elapsed_time : String = "00:00:00"

func start_time_trial():
	time_trial = true
	start_time = OS.get_ticks_msec()
	timer_running = true

func start_time_trial_with_delay():
	time_trial = true
	yield(get_tree().create_timer(.5, false), "timeout")
	start_time = OS.get_ticks_msec()
	timer_running = true
	
func stop_time_trial():
	time_trial = false
	timer_running = false
	elapsed_time = "00:00:00"

func _process(delta):
	if timer_running:
		elapsed_ms = OS.get_ticks_msec() - start_time
		elapsed_time = convert_ms_to_time(elapsed_ms)
		
func convert_ms_to_time(elapsedms):
	var m : int = elapsedms / 60000
	var s : int = elapsedms / 1000
	var cs : int = elapsedms / 10
		
	cs = cs - (s * 100)
	s = s - (m * 60)
	
	return ("%02d:%02d:%02d" % [m,s,cs])
