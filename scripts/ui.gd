extends CanvasLayer

# --- MENUS ---
@onready var main_menu = $PanelContainer/MarginContainer/MainMenu
@onready var interface_1 = $PanelContainer/MarginContainer/ShopPage
@onready var interface_2 = $PanelContainer/MarginContainer/EmployeePage
@onready var interface_3 = $PanelContainer/MarginContainer/StashPage

# --- BUTTONS ---
@onready var btn_menu_1 = $PanelContainer/MarginContainer/MainMenu/ShopBtn
@onready var btn_menu_2 = $PanelContainer/MarginContainer/MainMenu/EmployeesBtn
@onready var btn_menu_3 = $PanelContainer/MarginContainer/MainMenu/StashBtn

# Grab the navigation buttons (Assuming you named them consistently)
#@onready var back_btns = [
	#$PanelContainer/MarginContainer/Interface1/TopBar/BtnBack,
	#$PanelContainer/MarginContainer/Interface1A/TopBar/BtnBack
#]
@onready var home_btns = [
	$PanelContainer/MarginContainer/ShopPage/TopBar/BtnHome,
	$PanelContainer/MarginContainer/EmployeePage/TopBar/BtnHome,
	$PanelContainer/MarginContainer/StashPage/TopBar/BtnHome
]

# This array keeps track of our breadcrumbs!
var menu_history : Array[Control] = []
var current_menu : Control

@onready var stash_cells = get_tree().get_nodes_in_group("stash_cells")

func _ready():
	
	# 1. Connect Main Menu Buttons
	btn_menu_1.pressed.connect(func(): open_page(interface_1))
	btn_menu_2.pressed.connect(func(): open_page(interface_2))
	btn_menu_3.pressed.connect(func(): open_page(interface_3))
	
	# 2. Connect all Back and Home buttons via loops to save typing
	#for btn in back_btns:
		#btn.pressed.connect(go_back)
	for btn in home_btns:
		btn.pressed.connect(go_home)
		
	# 3. Start the game on the Main Menu
	go_home(true)

# --- NAVIGATION LOGIC ---

func open_page(new_page: Control):
	Globals.menu_sfx.play()
	print("Attempting to open: ", new_page.name) # ADD THIS LINE
	# If we are currently on a menu, add it to our history stack
	if current_menu != null:
		menu_history.append(current_menu)
		current_menu.hide()
		
	# Show the new page
	current_menu = new_page
	current_menu.show()

func go_back():
	# If we have a history to go back to...
	if menu_history.size() > 0:
		current_menu.hide()
		# Pop the last page off the end of the array and show it
		current_menu = menu_history.pop_back()
		current_menu.show()
	else:
		# If no history is left, just go home
		go_home()

func go_home(mute_sound = false):
	
	if mute_sound != true:
		Globals.home_sfx.play()
		
	# Clear the history because we are back at the start
	menu_history.clear()
	
	# Hide all menus
	main_menu.hide()
	interface_1.hide()
	interface_2.hide()
	interface_3.hide()
	
	# Show only the main menu
	current_menu = main_menu
	current_menu.show()


func _exit_tree() -> void:
	pass # Replace with function body.

func _open_stash_ui() -> void:
	for i in stash_cells:
		i.visible = true
		print("made " + str(i) + " visible")
	print("enter")

func _close_stash_ui() -> void:
	for i in stash_cells:
		i.visible = false
	print("close")
	pass # Replace with function body.
