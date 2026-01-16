pico-8 cartridge // http://www.pico-8.com
version 35
__lua__
-- circus tycoon
-- by onoz

-- data structures
tents = {
  {
    name = "small tent",
    level = 1,
    slots = 2,    -- max acts that can perform
    seats = 100,  -- max audience capacity
    cost = 0      -- initial tent (free)
  },
  {
    name = "medium tent",
    level = 2,
    slots = 4,
    seats = 250,
    cost = 1000    -- upgrade price
  },
  {
    name = "large tent",
    level = 3,
    slots = 6,
    seats = 500,
    cost = 2000
  }
}

acts = {
  {
    id = "clown",
    name = "clown troupe", 
    type = "comedy",
    upkeep = 50,     -- weekly upkeep
    cost = 500,      -- price to hire (10x upkeep)
    size = 1         -- slots required
  },
  {
    id = "juggler",
    name = "fire juggler",
    type = "danger", 
    upkeep = 80,
    cost = 800,
    size = 1
  },
  {
    id = "elephants",
    name = "elephant show",
    type = "animal",
    upkeep = 150,
    cost = 1500,
    size = 2
  },
  {
    id = "acrobats",
    name = "acrobat team",
    type = "skill",
    upkeep = 120,
    cost = 1200,
    size = 2
  },
  {
    id = "lion",
    name = "lion tamer",
    type = "animal",
    upkeep = 200,
    cost = 2000,
    size = 2
  },
  {
    id = "magician",
    name = "magician",
    type = "skill",
    upkeep = 100,
    cost = 1000,
    size = 1
  },
  {
    id = "trapeze",
    name = "trapeze",
    type = "danger",
    upkeep = 180,
    cost = 1800,
    size = 2
  },
  {
    id = "contortionist",
    name = "contortionist",
    type = "skill",
    upkeep = 90,
    cost = 900,
    size = 1
  },
  {
    id = "strongman",
    name = "strongman",
    type = "danger",
    upkeep = 110,
    cost = 1100,
    size = 1
  }
}

-- Random events data structure
random_events = {
  {
    id = "storm",
    name = "tent damage",
    description = "a storm damaged your tent!",
    effect_type = "money",
    effect_value = -200,
    is_positive = false
  },
  {
    id = "celebrity",
    name = "celebrity visit",
    description = "a famous actor attended your show and posted about it!",
    effect_type = "demand",
    effect_value = 30,
    is_positive = true
  },
  {
    id = "theft",
    name = "equipment theft",
    description = "thieves stole some of your equipment!",
    effect_type = "money",
    effect_value = -150,
    is_positive = false
  },
  {
    id = "review",
    name = "glowing review",
    description = "local newspaper gave you a glowing review!",
    effect_type = "demand",
    effect_value = 20,
    is_positive = true
  },
  {
    id = "fire",
    name = "small fire",
    description = "a small fire damaged some property.",
    effect_type = "money",
    effect_value = -200,
    is_positive = false
  },
  {
    id = "contest",
    name = "act wins contest",
    description = "one of your acts won a regional contest!",
    effect_type = "both",
    effect_value_money = 100,
    effect_value_demand = 15,
    is_positive = true
  },
  {
    id = "inspection",
    name = "safety inspection",
    description = "failed a safety inspection! paid fine and repairs.",
    effect_type = "money",
    effect_value = -175,
    is_positive = false
  },
  {
    id = "viral",
    name = "viral video",
    description = "your show went viral on social media!",
    effect_type = "both",
    effect_value_money = 50,
    effect_value_demand = 25,
    is_positive = true
  }
}

cities = {
  {
    id = "frisco",
    name = "frisco",
    population = 1400,
    base_cost = 100,  -- weekly rental fee
    favorites = {"comedy", "animal"}, -- 20% attendance bonus
    demand = 100,      -- starts at 100%, decays per 50w
    price_sensitivity = 0.9,  -- less sensitive to high prices (smaller town)
    region = "central"
  },
  {
    id = "austin",
    name = "austin", 
    population = 2000,
    base_cost = 200,  -- increased from 150
    favorites = {"danger", "skill"},
    demand = 50,
    price_sensitivity = 1.0,  -- standard sensitivity
    region = "central"
  },
  {
    id = "chicago",
    name = "chicago",
    population = 5000,
    base_cost = 500,  -- increased from 300
    favorites = {"skill", "comedy"},
    demand = 50,
    price_sensitivity = 1.2,  -- more sensitive to high prices (big city)
    region = "central"
  },
  {
    id = "denver",
    name = "denver",
    population = 1800,
    base_cost = 180,  -- kept same
    favorites = {"animal", "danger"},
    demand = 50,
    price_sensitivity = 0.95,  -- slightly less sensitive
    region = "west"
  },
  {
    id = "seattle",
    name = "seattle",
    population = 3500,
    base_cost = 350,
    favorites = {"skill", "comedy"},
    demand = 50,
    price_sensitivity = 1.1,  -- somewhat sensitive to prices
    region = "west"
  },
  {
    id = "miami",
    name = "miami",
    population = 2800,
    base_cost = 250,
    favorites = {"danger", "comedy"},
    demand = 50,
    price_sensitivity = 1.05,  -- slightly more sensitive
    region = "east"
  },
  {
    id = "boston",
    name = "boston",
    population = 3000,
    base_cost = 300,
    favorites = {"skill", "animal"},
    demand = 50,
    price_sensitivity = 1.15,  -- more sensitive to prices
    region = "east"
  }
}

player = {
  week = 1,
  money = 500,
  current_city = "frisco",
  reputation = 0,    -- unlocks new cities/acts at thresholds
  tent_level = 1,
  ticket_price = 5,  -- default ticket price
  owned_acts = {
    {
      id = "clown",  -- starting act
      skill = 1      -- all acts start with skill 1
    }
  },
  previously_owned_acts = {"clown"}, -- Track acts that were ever owned
  selected_act_id = nil, -- Added to track selected act
  selected_city_id = nil -- Added to track selected city
}

-- helper functions
function tbl_has(tbl, val)
  for i=1,#tbl do
    if tbl[i] == val then
      return true
    end
  end
  return false
end

function get_act_by_id(id)
 for i=1,#acts do
  if acts[i].id == id then
   return acts[i]
  end
 end
 return nil
end

function get_player_act(id)
  for i=1,#player.owned_acts do
    if player.owned_acts[i].id == id then
      return player.owned_acts[i]
    end
  end
  return nil
end

function get_city_by_id(id)
  for i=1,#cities do
    if cities[i].id == id then
      return cities[i]
    end
  end
  return nil
end

-- New helper function for menu navigation
function handle_menu_navigation(num_options, current_selection)
  local new_selection = current_selection
  if btnp(2) then -- up
    new_selection = max(1, current_selection - 1)
  end
  if btnp(3) then -- down
    new_selection = min(num_options, current_selection + 1)
  end
  return new_selection
end

-- Check if saved game exists
function has_saved_game()
  return dget(0) != 0 -- Check week value, 0 means no saved game
end

-- Check if high scores exist
function has_high_scores()
  return dget(41) > 0 -- Check first high score slot
end

-- game state
game_state = "splash_screen" -- "splash_screen", "main_menu", "manage_acts", "hire_acts", "act_details", "hire_act_details", "confirm_fire", "confirm_hire", "manage_tent", "upgrade_tent", "confirm_upgrade", "run_show", "confirm_show", "show_results", "cities_list", "city_details", "confirm_travel", "random_event", "act_level_up", "high_scores"
game_state_prev = nil -- Track previous state for transitions

-- menu system
menu_items = {
  "run show",
  "manage acts",
  "manage tent",
  "cities",
  "save game",
  "exit"
}
menu_selection,splash_selection,manage_acts_selection,act_details_selection,confirm_fire_selection,confirm_train_selection,manage_tent_selection,upgrade_tent_selection,confirm_upgrade_selection,cities_selection,city_details_selection,confirm_travel_selection=1,1,1,1,1,1,1,1,1,1,1,1
run_show_selection = 1 -- Added for run show screen, defaulting to "Ticket Price"

-- High scores system
high_scores = {}
current_score_is_high = false
high_score_selection = 1 -- Default to "Continue"

-- Run show variables
show_stats = {
  total_cost = 0,
  attendance = 0,
  revenue = 0,
  profit = 0,
  -- Added for feedback:
  pre_show_demand = 100,
  price_factor = 1,
  quality_score = 1,
  fav_bonus = 1,
  num_fav_matches = 0,
  target_price = 5,
  audience_feedback = {} -- Added to store generated reactions
}
confirm_show_selection = 1 -- Default to "Yes"
show_results_page = 1 -- Added for results screen pagination
current_event = nil -- Variable to store the current random event
leveled_up_acts = {} -- Track acts that gained a skill star
current_level_up_index = 1 -- Track which act we're currently showing

-- Function to draw the player's money in the top right corner
function draw_player_money()
  local money_str = "$"..player.money
  local money_x = 128 - #money_str * 4 -- Estimate width (4px/char)
  print(money_str, money_x - 2, 5, 11) -- Position slightly offset
  
  -- Check for game over condition (money < 0)
  if player.money < 0 and game_state != "game_over" and game_state != "season_end" then
    game_state = "game_over"
  end
  
  -- Check for season end (week 30)
  if player.week >= 30 and game_state != "game_over" and game_state != "season_end" then
    game_state = "season_end"
  end
end

function _init()
  -- initialize game
  cartdata("circus_tycoon_save")
  -- Load high scores on game start
  high_scores={}
  for i=1,5 do
    local s=dget(40+i)
    if s>0 then add(high_scores,s) end
  end
  music(0) -- Play music pattern 0 in a loop (0b0011 flag enables looping)
end

function _update()
  handle_states()
end

function _draw()
  cls(1) -- Change background to dark blue instead of black (0)
  handle_states(true)
end

-- Central state management function
function handle_states(is_draw)
  if is_draw == nil then is_draw = false end
  
  -- Reset act_details_selection when state changes to act_details
  if not is_draw and game_state_prev != "act_details" and game_state == "act_details" then
    act_details_selection = 1
  end
  
  if game_state == "splash_screen" then
    if not is_draw then update_splash_screen() else draw_splash_screen() end
  elseif game_state == "main_menu" then
    if not is_draw then update_main_menu() else draw_main_menu() end
  elseif game_state == "manage_acts" then
    if not is_draw then update_manage_acts() else draw_manage_acts() end
  elseif game_state == "act_details" then
    if not is_draw then update_act_details() else draw_act_details() end
  elseif game_state == "confirm_fire" then
    if not is_draw then update_confirm_fire() else draw_confirm_fire() end
  elseif game_state == "confirm_train" then
    if not is_draw then update_confirm_train() else draw_confirm_train() end
  elseif game_state == "act_trained" then
    if not is_draw then update_act_trained() else draw_act_trained() end
  elseif game_state == "hire_acts" then
    if not is_draw then update_hire_acts() else draw_hire_acts() end
  elseif game_state == "hire_act_details" then
    if not is_draw then update_hire_act_details() else draw_hire_act_details() end
  elseif game_state == "confirm_hire" then
    if not is_draw then update_confirm_hire() else draw_confirm_hire() end
  elseif game_state == "manage_tent" then
    if not is_draw then update_manage_tent() else draw_manage_tent() end
  elseif game_state == "upgrade_tent" then
    if not is_draw then update_upgrade_tent() else draw_upgrade_tent() end
  elseif game_state == "confirm_upgrade" then
    if not is_draw then update_confirm_upgrade() else draw_confirm_upgrade() end
  elseif game_state == "run_show" then
    if not is_draw then 
      update_run_show() 
    else 
      draw_run_show()
    end
  elseif game_state == "confirm_show" then
    if not is_draw then update_confirm_show() else draw_confirm_show() end
  elseif game_state == "show_results" then
    if not is_draw then update_show_results() else draw_show_results() end
  elseif game_state == "cities_list" then
    if not is_draw then update_cities_list() else draw_cities_list() end
  elseif game_state == "city_details" then
    if not is_draw then update_city_details() else draw_city_details() end
  elseif game_state == "confirm_travel" then
    if not is_draw then update_confirm_travel() else draw_confirm_travel() end
  elseif game_state == "random_event" then
    if not is_draw then update_random_event() else draw_random_event() end
  elseif game_state == "act_level_up" then
    if not is_draw then update_act_level_up() else draw_act_level_up() end
  elseif game_state == "save_complete" then
    if not is_draw then update_save_complete() else draw_save_complete() end
  elseif game_state == "game_over" then
    if not is_draw then update_game_over() else draw_game_over() end
  elseif game_state == "season_end" then
    if not is_draw then update_season_end() else draw_season_end() end
  elseif game_state == "high_scores" then
    if not is_draw then update_high_scores() else draw_high_scores() end
  end
  
  -- Track previous state
  if not is_draw then
    game_state_prev = game_state
  end
end

-- Splash screen update function
function update_splash_screen()
  -- Count options: new game + optional resume game + optional high scores
  local num_options = 1
  if has_saved_game() then num_options += 1 end
  if has_high_scores() then num_options += 1 end
  
  -- Handle navigation
  splash_selection = handle_menu_navigation(num_options, splash_selection)
  
  -- Handle selection
  if btnp(4) then
    if has_saved_game() and splash_selection == 1 then
      -- Resume game
      load_game()
      game_state = "main_menu"
    elseif has_saved_game() and has_high_scores() and splash_selection == 3 then
      -- View high scores (last option when both saved game and high scores exist)
      game_state = "high_scores"
      high_score_selection = 1
    elseif has_high_scores() and not has_saved_game() and splash_selection == 2 then
      -- View high scores (second option when only high scores exist)
      game_state = "high_scores" 
      high_score_selection = 1
    else
      -- Create new game
      -- Reset player data to default values
      player = {
        week = 1,
        money = 500,
        current_city = "frisco",
        reputation = 0,
        tent_level = 1,
        ticket_price = 5,
        owned_acts = {
          {
            id = "clown",
            skill = 1
          }
        },
        previously_owned_acts = {"clown"},
        selected_act_id = nil,
        selected_city_id = nil
      }
      
      -- Reset city demand values
      for i=1,#cities do
        cities[i].demand = cities[i].id == player.current_city and 100 or 50
      end
      
      save_game() -- Save the new game
      menu_selection = 1 -- Default to "run show"
      game_state = "main_menu"
    end
  end
end

-- Splash screen draw function
function draw_splash_screen()
  map(0,0,0,0,16,16)
  spr(128, 32, 8, 8, 8)

  -- Calculate options
  local num_options = 1
  local lines_height = 0
  
  if has_saved_game() then num_options,lines_height = num_options+1,lines_height+10 end
  if has_high_scores() then num_options,lines_height = num_options+1,lines_height+10 end
  
  -- Draw options box
  local x,y = 25,70
  local w,h = 78,lines_height+15 -- 5px top padding + lines + 10px first line
  
  rectfill(x, y, x+w, y+h, 0)
  rect(x, y, x+w, y+h, 5)
  
  -- Draw options
  local y_pos = y+5
  local x_indent = x+15
  local opt_idx = 1
  
  -- Helper function to draw an option
  local function draw_opt(text)
    local color = splash_selection == opt_idx and 10 or 7
    if splash_selection == opt_idx then 
      print(">", x_indent-10, y_pos, color)
    end
    print(text, x_indent, y_pos, color)
    y_pos += 10
    opt_idx += 1
  end
  
  if has_saved_game() then draw_opt("resume game") end
  draw_opt("new game")
  if has_high_scores() then draw_opt("high scores") end
  
  print("press 🅾️ to select", 32, 115, 5)
end

function update_main_menu()
  -- handle menu navigation
  menu_selection = handle_menu_navigation(#menu_items, menu_selection)

  -- handle selection (O button)
  if btnp(4) then
    local selected_item = menu_items[menu_selection]
    if selected_item == "exit" then
      -- Go back to splash screen instead of exiting
      game_state = "splash_screen"
      splash_selection = 1 -- Reset selection on splash screen
    elseif selected_item == "run show" then
      game_state = "run_show"
    elseif selected_item == "manage acts" then
      game_state = "manage_acts"
      manage_acts_selection = 1 -- reset selection
    elseif selected_item == "manage tent" then
      game_state = "manage_tent"
      manage_tent_selection = 1 -- reset selection
    elseif selected_item == "cities" then
      game_state = "cities_list"
      cities_selection = 1 -- reset selection
    elseif selected_item == "save game" then
      save_game()
      game_state = "save_complete"
    end
    -- other menu options will be implemented later
  end
end

function update_manage_acts()
  local num_options = #player.owned_acts + 1 -- acts + "Hire Acts"

  -- handle navigation
  manage_acts_selection = handle_menu_navigation(num_options, manage_acts_selection)

  -- handle selection (O button)
  if btnp(4) then
    if manage_acts_selection <= #player.owned_acts then
      -- selected an existing act
      local selected_act_id = player.owned_acts[manage_acts_selection].id
      player.selected_act_id = selected_act_id -- Store the selected act ID
      game_state = "act_details" -- Change state
      act_details_selection = 1 -- Reset selection for the details screen
    else
      -- selected "Hire Acts"
      game_state = "hire_acts"
      hire_acts_selection = 1 -- Reset selection
    end
  end

  -- handle back (X button)
  if btnp(5) then
    game_state = "main_menu"
  end
end

-- Function to handle updates in the act details screen
function update_act_details()
  -- Handle back (X button)
  if btnp(5) then
    player.selected_act_id = nil -- Clear selected act
    game_state = "manage_acts"   -- Go back to manage acts screen
    return
  end

  -- Two selectable items: "Train Act" and "Fire Act" 
  act_details_selection = handle_menu_navigation(2, act_details_selection) -- 2 options now

  -- Handle selection (O button)
  if btnp(4) then
    if act_details_selection == 1 then -- If "Train Act" is selected
      -- Check if player can afford training
      local act = get_act_by_id(player.selected_act_id)
      local train_cost = act.upkeep * 2
      
      if player.money >= train_cost then
        -- Show training confirmation dialog only if can afford
        game_state = "confirm_train"
        confirm_train_selection = 1 -- Default to "Yes"
        return
      end
      -- If can't afford, do nothing (stay on the same screen)
    elseif act_details_selection == 2 then -- If "Fire Act" is selected
      -- Show confirmation dialog
      game_state = "confirm_fire"
      confirm_fire_selection = 1 -- Default to "Yes"
      return
    end
  end
end

-- Function to handle the fire confirmation dialog
function update_confirm_fire()
  local fire_act = function()
    local act_id_to_remove = player.selected_act_id
    -- Remove the act from player's owned acts
    for i=1,#player.owned_acts do
      if player.owned_acts[i].id == act_id_to_remove then
        deli(player.owned_acts, i)
        break
      end
    end
    player.selected_act_id = nil
    game_state = "manage_acts"
  end
  
  local go_back = function()
    game_state = "act_details"
  end
  
  confirm_fire_selection = handle_confirmation(fire_act, go_back, confirm_fire_selection)
end

-- Function to handle the training confirmation dialog
function update_confirm_train()
  local train_act = function()
    local act_id = player.selected_act_id
    local act = get_act_by_id(act_id)
    local player_act = get_player_act(act_id)
    
    -- Calculate training cost (2x upkeep)
    local train_cost = act.upkeep * 2
    
    -- Check if player can afford training
    if player.money >= train_cost and player_act then
      -- Deduct cost
      player.money -= train_cost
      
      -- Apply skill increase (same as show formula)
      local skill_increase_per_show = 0.15  -- Same value used in calculate_show_results
      local max_skill = 5
      local old_skill = flr(player_act.skill)
      player_act.skill = min(max_skill, player_act.skill + skill_increase_per_show)
      local new_skill = flr(player_act.skill)
      
      -- Check if level up occurred
      local leveled_up = new_skill > old_skill
      if leveled_up then
        -- Clear leveled_up_acts and add this act
        leveled_up_acts = {}
        add(leveled_up_acts, player_act)
        -- Move to level up screen
        current_level_up_index = 1
        game_state = "act_level_up"
      else
        -- Show training result screen
        game_state = "act_trained"
      end
    else
      -- Not enough money, go back to act details
      game_state = "act_details"
    end
  end
  
  local go_back = function()
    game_state = "act_details"
  end
  
  confirm_train_selection = handle_confirmation(train_act, go_back, confirm_train_selection)
end

-- Function to handle the act trained screen
function update_act_trained()
  -- Exit on any button press
  if btnp(5) or btnp(4) then
    game_state = "act_details"
  end
end

-- Helper function to draw a banner with title and optional subtitle
function draw_banner(title_text, subtitle_text, height)
  -- Default height if not specified
  height = height or 22
  
  -- Calculate banner height based on content
  local min_height = subtitle_text and 22 or 12
  if height < min_height then
    height = min_height
  end
  
  -- Draw a simple banner for the title
  rectfill(0, 12, 127, 12 + height, 8) -- Red banner
  rectfill(0, 13, 127, 11 + height, 12) -- Blue inner banner
  
  -- Draw title (centered)
  local title_width = #title_text * 4
  local title_x = 64 - (title_width / 2)
  print(title_text, title_x, 16, 7) -- White text
  
  -- Draw subtitle if provided (centered)
  if subtitle_text then
    local subtitle_width = #subtitle_text * 4
    local subtitle_x = 64 - (subtitle_width / 2)
    print(subtitle_text, subtitle_x, 26, 10) -- Yellow text
  end
  
  return 12 + height -- Return the y position where content should start after the banner
end

-- Function to draw the main menu screen
function draw_main_menu()
  -- Use the banner helper
  local content_y = draw_banner("circus tycoon", "week "..player.week.."/30", 22)
  
  -- Draw money top-right
  draw_player_money()

  -- draw menu, starting after the banner
  local menu_start_y = content_y + 10
  for i=1,#menu_items do
    local y = menu_start_y + (i-1) * 10
    local color = 6 -- Light gray for non-selected
    if i == menu_selection then
      color = 10 -- Yellow for selected
      print(">", 25, y, color)
    end
    print(menu_items[i], 35, y, color)
  end
end

function draw_manage_acts()
  -- Draw money top-right
  draw_player_money()

  -- Use the banner helper
  local content_y = draw_banner("manage acts", nil, 12)

  local y_start = content_y + 10
  local line_height = 8
  local x_indent_cursor = 5
  local x_indent_text = 15

  -- draw owned acts
  for i=1,#player.owned_acts do
    local owned_act = player.owned_acts[i]
    local act = get_act_by_id(owned_act.id)
    local y = y_start + (i-1) * line_height
    local color = 7 -- White for act name
    local upkeep_color = 6 -- Light gray for upkeep
    if i == manage_acts_selection then
      color = 10 -- Yellow for selected act name
      upkeep_color = 10 -- Yellow for selected upkeep
      print(">", x_indent_cursor, y, color)
    end
    print(act.name.." ", x_indent_text, y, color)
    -- Print upkeep separately to color it
    local upkeep_text = "(upkeep:$"..act.upkeep..")"
    local name_width = #act.name * 4 -- Approx width
    print(upkeep_text, x_indent_text + name_width + 4, y, upkeep_color)
  end

  -- draw "Hire Acts" option
  local hire_acts_y = y_start + #player.owned_acts * line_height + (line_height / 2)
  local hire_acts_color = 7 -- White
  if manage_acts_selection == #player.owned_acts + 1 then
    hire_acts_color = 10 -- Yellow
    print(">", x_indent_cursor, hire_acts_y, hire_acts_color)
  end
  print("hire new acts", x_indent_text, hire_acts_y, hire_acts_color)
end

-- Helper function to get star rating string
function get_skill_stars(skill)
  local star_str = ""
  for i=1,5 do
    -- Use PICO-8 compatible characters for stars
    if i <= skill then
      star_str = star_str.."●" -- Filled circle for PICO-8
    else
      star_str = star_str.."○" -- Empty circle for PICO-8
    end
  end
  return star_str
end

-- Function to draw the act details screen
function draw_act_details()
  if player.selected_act_id == nil then return end -- Safety check

  local act = get_act_by_id(player.selected_act_id)
  local player_act = get_player_act(player.selected_act_id)
  if act == nil or player_act == nil then return end -- Safety check

  -- Draw money top-right
  draw_player_money()

  -- Use the banner helper
  local content_y = draw_banner("act details", nil, 12)

  local y_start = content_y + 10
  local line_height = 8
  local x_indent = 10

  -- Draw Act Info (use light gray for labels, white for values)
  print("name:", x_indent, y_start, 6)
  print(act.name, x_indent + 28, y_start, 7)
  print("type:", x_indent, y_start + line_height * 1, 6)
  print(act.type, x_indent + 28, y_start + line_height * 1, 7)
  print("skill level:", x_indent, y_start + line_height * 2, 6)
  print(get_skill_stars(player_act.skill), x_indent + 52, y_start + line_height * 2, 10) -- Yellow stars
  print("upkeep:", x_indent, y_start + line_height * 3, 6)
  print("$"..act.upkeep.."/week", x_indent + 36, y_start + line_height * 3, 7)
  print("size:", x_indent, y_start + line_height * 4, 6)
  print(act.size.." slot(s)", x_indent + 28, y_start + line_height * 4, 7)

  -- Draw "Train Act" Button/Option
  local train_y = y_start + line_height * 6
  local train_cost = act.upkeep * 2
  local can_afford = player.money >= train_cost
  local train_text_color = can_afford and 7 or 5 -- White if affordable, dark gray if not
  local train_highlight_color = can_afford and 10 or 6 -- Yellow if affordable, light gray if not

  if act_details_selection == 1 then
    print(">", x_indent - 10, train_y, train_highlight_color)
    train_text_color = train_highlight_color
  end
  print("train act ($"..train_cost..")", x_indent, train_y, train_text_color)

  -- Draw "Fire Act" Button/Option
  local fire_y = y_start + line_height * 8
  local fire_color = 7 -- White
  local fire_highlight_color = 10 -- Yellow
  if act_details_selection == 2 then
    fire_color = fire_highlight_color
    print(">", x_indent - 10, fire_y, fire_highlight_color)
  end
  print("fire act", x_indent, fire_y, fire_color)
end

-- Function to draw the fire confirmation screen
function draw_confirm_fire()
  if player.selected_act_id == nil then return end
  
  local act = get_act_by_id(player.selected_act_id)
  if act == nil then return end
  
  draw_confirmation("fire "..act.name.."?", nil, confirm_fire_selection, 65)
end

-- Function to draw the training confirmation screen
function draw_confirm_train()
  if player.selected_act_id == nil then return end
  
  local act = get_act_by_id(player.selected_act_id)
  if act == nil then return end
  
  -- Calculate training cost
  local train_cost = act.upkeep * 2
  
  -- Draw money top-right
  draw_player_money()
  
  draw_confirmation("train "..act.name.."?", "cost: $"..train_cost, confirm_train_selection, 65)
end

-- Function to handle the act trained screen
function draw_act_trained()
  if player.selected_act_id == nil then return end
  
  local act = get_act_by_id(player.selected_act_id)
  local player_act = get_player_act(player.selected_act_id)
  if act == nil or player_act == nil then return end
  
  -- Get current skill level
  local skill_level = flr(player_act.skill)
  
  -- Draw money top-right
  draw_player_money()
  
  -- Training messages
  local messages = {
    "looking better!",
    "improving steadily!",
    "technique is better!",
  }
  
  -- Get a consistent message based on act id and skill
  local msg_index = ((skill_level * 5) + #act.id) % #messages + 1
  local message = messages[msg_index]
  
  -- Use the helper function to draw the main box
  draw_festive_box("★ training complete! ★", act.name, skill_level, message)
  
  -- Instruction at bottom (already included in draw_festive_box)
  -- print("press 🅾️ or ❎ to continue", 13, 115, 5) -- This line is now handled by draw_festive_box
end

-- Helper functions for hiring acts
function is_act_owned(act_id)
  for i=1,#player.owned_acts do
    if player.owned_acts[i].id == act_id then
      return true
    end
  end
  return false
end

function get_current_tent()
  return tents[player.tent_level]
end

function get_used_slots()
  local used = 0
  for i=1,#player.owned_acts do
    local act = get_act_by_id(player.owned_acts[i].id)
    used += act.size
  end
  return used
end

function can_afford_act(act)
  return player.money >= act.cost
end

function has_tent_space(act)
  local current_tent = get_current_tent()
  local used_slots = get_used_slots()
  return (used_slots + act.size) <= current_tent.slots
end

function can_hire_act(act)
  return can_afford_act(act) and has_tent_space(act) and not is_act_owned(act.id)
end

-- Hire acts screen variables
hire_acts_selection = 1
hire_act_details_selection = 1
confirm_hire_selection = 1

-- Function to handle updates in the hire acts screen
function update_hire_acts()
  local available_acts = {}
  for i=1,#acts do
    if not is_act_owned(acts[i].id) then
      add(available_acts, acts[i])
    end
  end
  
  local num_options = #available_acts
  
  -- handle navigation
  if num_options > 0 then -- Only allow navigation if there are options
      hire_acts_selection = handle_menu_navigation(num_options, hire_acts_selection)
  end
  
  -- handle selection (O button)
  if btnp(4) and num_options > 0 then
    player.selected_act_id = available_acts[hire_acts_selection].id
    game_state = "hire_act_details"
    hire_act_details_selection = 1
  end
  
  -- handle back (X button)
  if btnp(5) then
    game_state = "manage_acts"
  end
end

-- Function to handle updates in the hire act details screen
function update_hire_act_details()
  if btnp(5) then
    player.selected_act_id = nil
    game_state = "hire_acts"
    return
  end
  
  -- Only one selectable item: "Hire Act"
  if btnp(4) then
    local act = get_act_by_id(player.selected_act_id)
    if act and can_hire_act(act) then
      game_state = "confirm_hire"
      confirm_hire_selection = 1 -- Default to "Yes"
    end
  end
end

-- Function to handle the hire confirmation dialog
function update_confirm_hire()
  local hire_act = function()
    local act_id = player.selected_act_id
    local act = get_act_by_id(act_id)
    
    -- Hire the act
    if act and can_hire_act(act) then
      player.money -= act.cost
      add(player.owned_acts, {
        id = act_id,
        skill = 1
      })
      
      -- Check if this is a first-time hire (never owned before)
      local is_first_time = true
      for i=1,#player.previously_owned_acts do
        if player.previously_owned_acts[i] == act_id then
          is_first_time = false
          break
        end
      end
      
      -- If first time, increase demand in all cities by 20%
      if is_first_time then
        for i=1,#cities do
          cities[i].demand = min(100, cities[i].demand + 20)
        end
        -- Add to previously owned acts to prevent future demand increases
        add(player.previously_owned_acts, act_id)
      end
    end
    
    player.selected_act_id = nil
    game_state = "manage_acts"
  end
  
  local go_back = function()
    game_state = "hire_act_details"
  end
  
  confirm_hire_selection = handle_confirmation(hire_act, go_back, confirm_hire_selection)
end

-- Function to draw the hire acts screen
function draw_hire_acts()
  -- Draw money top-right
  draw_player_money()
  
  -- Use the banner helper
  local content_y = draw_banner("hire new acts", nil, 12)
  
  local current_tent = get_current_tent()
  local used_slots = get_used_slots()
  print("tent slots: "..used_slots.."/"..current_tent.slots, 10, content_y + 5, 7)
  
  local available_acts = {}
  for i=1,#acts do
    if not is_act_owned(acts[i].id) then
      add(available_acts, acts[i])
    end
  end
  
  -- Increased vertical spacing to prevent overlap with tent slots info
  local y_start = content_y + 20 -- Changed from content_y + 10 to content_y + 20
  local line_height = 10
  local x_indent_cursor = 5
  local x_indent_text = 15
  
  if #available_acts == 0 then
    print("no available acts", x_indent_text, y_start, 7)
  else
    -- draw available acts
    for i=1,#available_acts do
      local act = available_acts[i]
      local y = y_start + (i-1) * line_height
      local can_hire = can_hire_act(act)
      local color = can_hire and 7 or 5 -- Grey out if can't hire
      
      if i == hire_acts_selection then
        color = can_hire and 10 or 6 -- Highlight but still dim if can't hire
        print(">", x_indent_cursor, y, color)
      end
      
      print(act.name.." ($"..act.cost..", "..act.size.." slot)", x_indent_text, y, color)
    end
  end
end

-- Function to draw the hire act details screen
function draw_hire_act_details()
  if player.selected_act_id == nil then return end

  local act = get_act_by_id(player.selected_act_id)
  if act == nil then return end
  
  local can_hire = can_hire_act(act)
  local current_tent = get_current_tent()
  local used_slots = get_used_slots()
  
  -- Draw money top-right
  draw_player_money()
  
  -- Use the banner helper
  local content_y = draw_banner("hire: "..act.name, nil, 12)
  
  local y_start = content_y + 10
  local line_height = 8
  local x_indent = 10
  
  -- Draw Act Info
  print("type: "..act.type, x_indent, y_start, 7)
  print("upkeep: $"..act.upkeep.."/week", x_indent, y_start + line_height * 1, 7)
  print("size: "..act.size.." slot(s)", x_indent, y_start + line_height * 2, 7)
  print("starting skill: "..get_skill_stars(1), x_indent, y_start + line_height * 3, 7)
  
  -- Draw tent space info
  local space_color = (used_slots + act.size) <= current_tent.slots and 7 or 8
  print("tent space: "..act.size.. " (current: "..used_slots.."/"..current_tent.slots..")", x_indent, y_start + line_height * 5, space_color)
  
  -- Draw money check
  local money_color = player.money >= act.cost and 7 or 8
  print("hiring cost: $"..act.cost, x_indent, y_start + line_height * 7, money_color)
  
  -- Draw "Hire Act" Button/Option
  local hire_y = y_start + line_height * 9
  local hire_color = can_hire and 7 or 5 -- Grey out if can't hire
  
  if hire_act_details_selection == 1 then
    hire_color = can_hire and 10 or 6 -- Highlighted but still dim if can't hire
    print(">", x_indent - 10, hire_y, hire_color)
  end
  
  print("hire act", x_indent, hire_y, hire_color)
  
  -- If can't hire, show reason
  if not can_hire then
    local reason_y = hire_y + line_height * 1.5
    if not has_tent_space(act) then
      print("need larger tent for this act", x_indent, reason_y, 8)
    elseif not can_afford_act(act) then
      print("not enough money to hire", x_indent, reason_y, 8)
    end
  end
  
  -- instructions
  local instruction_y = 128 - 2 * 10
  local instruction_color = can_hire and 5 or 6
end

-- Function to draw the hire confirmation screen
function draw_confirm_hire()
  if player.selected_act_id == nil then return end
  
  local act = get_act_by_id(player.selected_act_id)
  if act == nil then return end
  
  draw_confirmation("hire "..act.name.."?", "cost: $"..act.cost, confirm_hire_selection, 70)
end

-- Function to handle updates in the manage tent screen
function update_manage_tent()
  local num_options = 1 -- Only upgrade tent option
  
  -- handle navigation
  manage_tent_selection = handle_menu_navigation(num_options, manage_tent_selection)
  
  -- handle selection (O button)
  if btnp(4) then
    if manage_tent_selection == 1 then
      -- Upgrade tent selected
      game_state = "upgrade_tent"
      upgrade_tent_selection = 1
    end
  end
  
  -- handle back (X button)
  if btnp(5) then
    game_state = "main_menu"
  end
end

-- Function to handle updates in the upgrade tent screen
function update_upgrade_tent()
  local next_tent_level = player.tent_level + 1
  local can_upgrade = next_tent_level <= #tents
  
  -- handle selection (O button)
  if btnp(4) and can_upgrade then
    local next_tent = tents[next_tent_level]
    if player.money >= next_tent.cost then
      -- Can afford upgrade, show confirmation
      game_state = "confirm_upgrade"
      confirm_upgrade_selection = 1 -- Default to "Yes"
    end
  end
  
  -- handle back (X button)
  if btnp(5) then
    game_state = "manage_tent"
  end
end

-- Function to handle the upgrade confirmation dialog
function update_confirm_upgrade()
  local upgrade_tent = function()
    local next_tent_level = player.tent_level + 1
    if next_tent_level <= #tents then
      local next_tent = tents[next_tent_level]
      -- Upgrade the tent (with final affordability check)
      if player.money >= next_tent.cost then
        player.money -= next_tent.cost
        player.tent_level = next_tent_level
        -- Success message could be added here
      end
    end
    game_state = "manage_tent"
  end
  
  local go_back = function()
    game_state = "upgrade_tent"
  end
  
  confirm_upgrade_selection = handle_confirmation(upgrade_tent, go_back, confirm_upgrade_selection)
end

-- Function to draw the manage tent screen
function draw_manage_tent()
  -- Draw money top-right
  draw_player_money()
  
  -- Use the banner helper
  local content_y = draw_banner("manage tent", nil, 12)
  
  local current_tent = tents[player.tent_level]
  local y_start = content_y + 10
  local line_height = 10
  local x_indent = 10
  local x_indent_cursor = 5
  
  -- Draw current tent info
  print("current tent: "..current_tent.name, x_indent, y_start, 7)
  print("capacity: "..current_tent.seats.." seats", x_indent, y_start + line_height * 1, 7)
  
  local used_slots = get_used_slots()
  local slots_color = used_slots == current_tent.slots and 8 or 7 -- Red if full
  print("act slots: "..used_slots.."/"..current_tent.slots, x_indent, y_start + line_height * 2, slots_color)
  
  -- Draw upgrade tent option (selectable)
  local upgrade_y = y_start + line_height * 4
  local can_upgrade = player.tent_level < #tents
  local upgrade_color = can_upgrade and 7 or 5
  
  if manage_tent_selection == 1 then
    upgrade_color = can_upgrade and 10 or 6
    print(">", x_indent_cursor, upgrade_y, upgrade_color)
  end
  
  print("upgrade tent", x_indent, upgrade_y, upgrade_color)
  
  -- If can't upgrade, show reason
  if not can_upgrade then
    print("maximum tent level reached", x_indent, upgrade_y + line_height, 5)
  end
  
  -- Instructions
  local instruction_y = 128 - 2 * 11  
  print("🅾️: select", x_indent, instruction_y, 5)
  print("❎: back", 80, instruction_y, 5)
end

-- Function to draw the upgrade tent screen
function draw_upgrade_tent()
  -- Draw money top-right
  draw_player_money()
  
  -- Use the banner helper
  local content_y = draw_banner("upgrade tent", nil, 12)
  
  local current_tent = tents[player.tent_level]
  local next_tent_level = player.tent_level + 1
  local x_indent = 10
  local y_start = content_y + 10
  local line_height = 8
  
  if next_tent_level <= #tents then
    local next_tent = tents[next_tent_level]
    
    -- Draw current tent info
    print("current: "..current_tent.name, x_indent, y_start, 7)
    print("capacity: "..current_tent.seats.." seats", x_indent, y_start + line_height * 1, 7)
    print("act slots: "..current_tent.slots, x_indent, y_start + line_height * 2, 7)
    
    -- Draw next tent info
    print("next: "..next_tent.name, x_indent, y_start + line_height * 4, 11)
    print("capacity: "..next_tent.seats.." seats", x_indent, y_start + line_height * 5, 11)
    print("act slots: "..next_tent.slots, x_indent, y_start + line_height * 6, 11)
    print("cost: $"..next_tent.cost, x_indent, y_start + line_height * 7, 11)
    
    -- Draw upgrade button
    local upgrade_y = y_start + line_height * 9
    local can_afford = player.money >= next_tent.cost
    local upgrade_color = can_afford and 10 or 5  -- Changed to 10 (yellow) for selected state
    local instruction_color = can_afford and 5 or 6
    
    print("> purchase upgrade", x_indent, upgrade_y, upgrade_color)
    
    -- If can't afford, show reason
    if not can_afford then
      print("not enough money (need $"..next_tent.cost..")", x_indent, upgrade_y + line_height * 1.5, 8)
    end
    
  else
    -- Should not happen, but just in case
    print("maximum tent level reached", x_indent, y_start + 20, 7)
    print("❎: back", x_indent, 110, 5)
  end
end

-- Function to draw the upgrade confirmation screen
function draw_confirm_upgrade()
  local next_tent_level = player.tent_level + 1
  if next_tent_level > #tents then return end
  
  local next_tent = tents[next_tent_level]
  
  -- Draw money top-right
  draw_player_money()
  
  draw_confirmation("upgrade to "..next_tent.name.."?", "cost: $"..next_tent.cost, confirm_upgrade_selection, 70)
end

-- Function to calculate the total weekly cost of all acts
function calculate_act_costs()
  return calculate_total_act_upkeep()
end

-- Function to calculate the total upkeep of all acts
function calculate_total_act_upkeep()
  local total = 0
  for i=1,#player.owned_acts do
    local act_id = player.owned_acts[i].id
    local act = get_act_by_id(act_id)
    total += act.upkeep
  end
  return total
end

-- Function to handle the run show screen
function update_run_show()
  -- Navigation between ticket price and start button
  local num_options = 2 -- ticket price and start show
  
  run_show_selection = handle_menu_navigation(num_options, run_show_selection)
  
  -- Handle ticket price adjustment when selected
  if run_show_selection == 1 then
    if btnp(0) then -- left
      player.ticket_price = max(1, player.ticket_price - 1)
    elseif btnp(1) then -- right
      player.ticket_price = min(30, player.ticket_price + 1)
    end
  end
  
  -- Handle selection (O button)
  if btnp(4) and run_show_selection == 2 then
    -- Prepare for confirmation
    game_state = "confirm_show"
    confirm_show_selection = 1 -- Default to "Yes"
  end

  -- Handle back (X button)
  if btnp(5) then
    game_state = "main_menu"
    return
  end
end

-- Function to handle the confirm show dialog
function update_confirm_show()
  local run_show = function()
    -- Calculate show results
    calculate_show_results()
    game_state = "show_results"
  end
  
  local go_back = function()
    game_state = "run_show"
  end
  
  confirm_show_selection = handle_confirmation(run_show, go_back, confirm_show_selection)
end

-- Function to calculate show results
function calculate_show_results()
  local city = get_city_by_id(player.current_city)
  local city_cost = city.base_cost
  local act_costs = calculate_act_costs()
  
  -- Store total costs
  show_stats.total_cost = city_cost + act_costs
  
  -- Store pre-show demand for feedback
  show_stats.pre_show_demand = city.demand

  -- Calculate attendance and store intermediate results
  local attendance_details = calculate_attendance() -- Now returns a table
  local attendance = attendance_details.attendance

  -- Store results in show_stats
  show_stats.attendance = attendance
  show_stats.revenue = attendance * player.ticket_price
  show_stats.profit = show_stats.revenue - show_stats.total_cost
  show_stats.price_factor = attendance_details.price_factor -- Store for feedback
  show_stats.quality_score = attendance_details.quality_score -- Store for feedback
  show_stats.fav_bonus = attendance_details.fav_bonus -- Store for feedback
  show_stats.num_fav_matches = attendance_details.num_fav_matches -- Store for feedback
  show_stats.target_price = attendance_details.target_price -- Store for feedback

  -- Update player money
  player.money += show_stats.profit
  
  -- Clear level up tracking
  leveled_up_acts = {}
  
  -- Increase act skills after show and track level ups
  local skill_increase_per_show = 0.15
  local max_skill = 5
  for i=1,#player.owned_acts do
    local p_act = player.owned_acts[i]
    if p_act.skill < max_skill then
      local old_skill = flr(p_act.skill)
      p_act.skill = min(max_skill, p_act.skill + skill_increase_per_show)
      local new_skill = flr(p_act.skill)
      
      -- If the integer value increased (gained a star)
      if new_skill > old_skill then
        add(leveled_up_acts, p_act)
      end
    end
  end
  
  -- Reduce city demand after show
  local demand_drop = 30 -- Base demand drop
  -- Higher drop for very high attendance relative to population
  local population_ratio = show_stats.attendance / max(1, city.population/10)
  if population_ratio > 0.5 then
    demand_drop = demand_drop + 10 -- Extra drop if high % of potential audience attended
  end
  
  -- Additional penalty for low demand - accelerating decay
  if city.demand < 50 then
    demand_drop = demand_drop + (50 - city.demand) / 2 -- Up to +25% extra drop when demand is very low
  end
  
  -- Allow demand to fall all the way to 0% (removed the minimum floor)
  city.demand = max(0, city.demand - demand_drop)
  
  -- Increase demand in other cities (where circus is not)
  for i=1,#cities do
    if cities[i].id != player.current_city then
      -- Random increase between 3-12%
      local demand_increase = 3 + flr(rnd(10))
      cities[i].demand = min(100, cities[i].demand + demand_increase)
    end
  end
  
  -- Increment week
  player.week += 1
  
  -- Check for season end (after 30 weeks)
  if player.week >= 30 and game_state != "season_end" then
    game_state = "season_end"
    return -- Skip the rest of the function
  end

  -- Generate and store audience feedback
  show_stats.audience_feedback = get_audience_reactions()

  -- Reset results page view
  show_results_page = 1
  
  -- Reset level up index
  current_level_up_index = 1
end

-- Function to calculate attendance (revised formula, returns table)
function calculate_attendance()
  local city = get_city_by_id(player.current_city)
  local current_tent = get_current_tent()
  local results = {} -- Table to store intermediate results

  -- Ensure there are acts to perform
  if #player.owned_acts == 0 then
    results.attendance = 0
    results.price_factor = 1
    results.quality_score = 0
    results.fav_bonus = 1
    results.num_fav_matches = 0
    results.target_price = 1
    return results
  end

  -- 1. Base Potential Audience
  -- More balanced interest rate
  local base_interest = 0.15
  -- Less aggressive diminishing returns for population
  local population_factor
  if city.population < 2000 then
    -- More linear scaling for small cities
    population_factor = city.population
  else
    -- Diminishing returns for larger cities only
    population_factor = 2000 + ((city.population - 2000)^0.8)
  end
  
  -- Early game bonus - novelty effect (toned down)
  local novelty_bonus = 1.0
  if player.week <= 3 then
    novelty_bonus = 1.15 -- 15% boost in first 3 weeks
  elseif player.week <= 6 then
    novelty_bonus = 1.05 -- 5% boost in weeks 4-6
  end
  
  -- Make demand even more impactful on attendance - using cubic formula for very low demand
  local demand_factor
  if city.demand < 20 then
    -- Cubic curve for very low demand - drops off dramatically
    demand_factor = (city.demand / 100)^3
  else
    -- Normal exponential decay for moderate to high demand
    demand_factor = (city.demand / 100)^1.2
  end
  
  local potential_audience = population_factor * base_interest * demand_factor * novelty_bonus

  -- 2. Show Quality Score
  -- Calculate average skill
  local total_skill = 0
  local num_fav_matches = 0
  for i=1,#player.owned_acts do
    local p_act = player.owned_acts[i]
    local act_def = get_act_by_id(p_act.id)
    total_skill += p_act.skill
    -- Count favorite matches here too
    if tbl_has(city.favorites, act_def.type) then
      num_fav_matches += 1
    end
  end
  local avg_skill = total_skill / #player.owned_acts

  -- Act variety bonus (more moderate impact)
  local variety_bonus = min(1.3, 0.8 + (#player.owned_acts * 0.1))

  -- Combine skill and variety into a quality score
  local quality_score = (0.45 + (avg_skill / 6)) * variety_bonus  -- Slightly reduced base quality
  
  -- Higher expectations in bigger cities
  local city_expectations = 1.0 + (city.population / 15000)
  local expected_quality = 0.5 * city_expectations
  
  -- Quality penalty for failing to meet city expectations
  if quality_score < expected_quality and city.population > 2000 then
    -- Only apply penalty in bigger cities
    quality_score = quality_score * 0.9
  end
  
  results.quality_score = quality_score -- Store
  results.num_fav_matches = num_fav_matches -- Store

  -- 3. Favorite Bonus
  -- More reasonable bonus for matching city's favorite act types
  local fav_bonus = min(1.4, 1.0 + (num_fav_matches * 0.15)) -- Reduced to max 40% bonus
  results.fav_bonus = fav_bonus -- Store

  -- 4. Target Ticket Price Calculation
  -- What price is "reasonable" for this show quality in this city?
  local base_target_price = 4 + (avg_skill * 1.2)
  -- Factor in city wealth/expectations (using rent as proxy)
  local city_price_factor = 1 + (city.base_cost / 1200)
  local target_price = max(1, base_target_price * city_price_factor) -- Ensure target is at least $1
  results.target_price = target_price -- Store

  -- 5. Price Sensitivity Factor with city-specific sensitivity
  -- How does the player's price compare to the target?
  local price_ratio = player.ticket_price / target_price
  local price_factor
  local city_sensitivity = city.price_sensitivity or 1.0 -- Get city sensitivity or default to 1.0
  
  -- Early game price sensitivity adjustment (reduced)
  if player.week <= 4 then
    city_sensitivity = city_sensitivity * 0.8 -- Less sensitive in first 4 weeks (reduced from 0.7)
  end

  if price_ratio <= 1 then
    -- Bonus for pricing at or below target
    price_factor = 1 + (1 - price_ratio) * 0.2  -- Reduced bonus back to original
  else
    -- Penalty for pricing above target
    price_factor = 1 / (price_ratio ^ (1.6 * city_sensitivity))  -- Slightly increased exponent
  end
  results.price_factor = price_factor -- Store

  -- 6. Combine Factors
  -- Multiply base potential by all calculated modifiers
  local calculated_attendance = potential_audience * quality_score * fav_bonus * price_factor

  -- 7. Randomness & Final Capping
  -- Apply a smaller random fluctuation
  local random_factor = 0.9 + rnd(0.2) -- Range 0.9 to 1.1
  calculated_attendance = calculated_attendance * random_factor

  -- Ensure non-negative and integer value
  calculated_attendance = max(0, flr(calculated_attendance))

  -- Set minimum attendance for early game (first 2 weeks only)
  if player.week <= 2 then
    calculated_attendance = max(calculated_attendance, 30)  -- Reduced minimum attendance
  end

  -- Cap attendance at tent capacity
  calculated_attendance = min(calculated_attendance, current_tent.seats)
  results.attendance = calculated_attendance -- Store final attendance

  return results -- Return the table
end

-- Function to generate audience feedback strings
function get_audience_reactions()
  local reactions = {}
  local city = get_city_by_id(player.current_city)
  local current_tent = get_current_tent()
  local capacity_pct = (show_stats.attendance / max(1, current_tent.seats)) * 100

  -- Price feedback
  if show_stats.price_factor < 0.75 then
    add(reactions, "tickets felt too expensive.")
  elseif show_stats.price_factor > 1.15 then
    add(reactions, "such a bargain for the show!")
  elseif player.ticket_price > show_stats.target_price * 1.5 then
      add(reactions, "that ticket price was way too high!")
  elseif player.ticket_price < show_stats.target_price * 0.5 then
      add(reactions, "could have charged more!")
  end

  -- Demand feedback
  if show_stats.pre_show_demand < 10 then
    add(reactions, "nobody cares about this show anymore.")
  elseif show_stats.pre_show_demand < 20 then
    add(reactions, "everyone's seen this already.")
  elseif show_stats.pre_show_demand < 65 then
    add(reactions, "felt like i just saw this...")
  elseif show_stats.pre_show_demand > 95 then
    add(reactions, "the town was buzzing!")
  end

  -- Favorite acts feedback
  if show_stats.num_fav_matches == 0 and #city.favorites > 0 and #reactions < 3 then
     local fav_type = city.favorites[flr(rnd(#city.favorites)) + 1]
     add(reactions, "wish there were "..fav_type.." acts.")
  end

  -- Quality feedback (simplified)
  if show_stats.quality_score < 0.6 and #reactions < 3 then
      add(reactions, "the performance felt flat.")
  elseif show_stats.quality_score > 1.1 and #reactions < 3 then
      add(reactions, "what an incredible show!")
  end

  -- Capacity feedback
  if capacity_pct >= 98 and #reactions < 3 then
    add(reactions, "it was totally packed!")
  elseif capacity_pct < 30 and #reactions < 3 then
    add(reactions, "seemed pretty empty.")
  end

  -- Generic fallback if few reactions generated
  if #reactions == 0 then
      add(reactions, "a decent show overall.")
  end

  -- Ensure we have 2-3 reactions max (pick randomly if too many)
  local final_reactions = {}
  local count = min(#reactions, 3)
  local shuffled_indices = {}
  for i=1,#reactions do add(shuffled_indices, i) end

  -- Simple shuffle (Fisher-Yates-like)
  for i=#shuffled_indices, 2, -1 do
    local j = flr(rnd(i)) + 1
    shuffled_indices[i], shuffled_indices[j] = shuffled_indices[j], shuffled_indices[i]
  end

  for i=1, count do
    add(final_reactions, reactions[shuffled_indices[i]])
  end

  return final_reactions
end

-- Function to handle the show results screen
function update_show_results()
  -- Handle page switching or exiting
  if show_results_page == 1 then
    if btnp(4) then -- O button
      show_results_page = 2 -- Go to page 2
    elseif btnp(5) then -- X button
      -- Check for level ups
      if #leveled_up_acts > 0 then
        game_state = "act_level_up"
      -- Otherwise check random events
      elseif check_random_event() then
        game_state = "random_event"
      else
        game_state = "main_menu"
      end
    end
  elseif show_results_page == 2 then
    if btnp(4) or btnp(5) then -- O or X button
      -- Check for level ups
      if #leveled_up_acts > 0 then
        game_state = "act_level_up"
      -- Otherwise check random events
      elseif check_random_event() then
        game_state = "random_event"
      else
        game_state = "main_menu"
      end
    end
  end
end

-- Function to check if a random event should occur
function check_random_event()
  -- No events in the first 3 weeks
  if player.week <= 3 then
    return false
  end
  
  --  15-25% chance for an event (randomized each time)
  local event_chance = 15 + flr(rnd(11)) -- 15-25%
  
  -- Roll for event
  if flr(rnd(100)) < event_chance then
    -- Choose a random event
    local event_id = flr(rnd(#random_events)) + 1
    current_event = random_events[event_id]
    
    -- Apply event effects
    apply_event_effects(current_event)
    
    return true
  end
  
  return false
end

-- Function to apply effects from random events
function apply_event_effects(event)
  -- Apply effect based on type
  if event.effect_type == "money" then
    player.money += event.effect_value
  elseif event.effect_type == "demand" then
    local city = get_city_by_id(player.current_city)
    city.demand = mid(0, city.demand + event.effect_value, 100)
  elseif event.effect_type == "both" then
    player.money += event.effect_value_money
    local city = get_city_by_id(player.current_city)
    city.demand = mid(0, city.demand + event.effect_value_demand, 100)
  end
end

-- Function to update the random event screen
function update_random_event()
  -- Exit on any button press
  if btnp(5) or btnp(4) then
    current_event = nil
    game_state = "main_menu"
  end
end

-- Function to draw the random event screen
function draw_random_event()
  if current_event == nil then return end

  -- Draw money top-right (Keep this small)
  draw_player_money()

  -- Draw background (Larger box)
  local box_x = 5
  local box_y = 15
  local box_w = 128 - 10
  local box_h = 128 - 30
  rectfill(box_x, box_y, box_x + box_w, box_y + box_h, 0)
  rect(box_x, box_y, box_x + box_w, box_y + box_h, current_event.is_positive and 11 or 8)

  local text_x = box_x + 5
  local current_y = box_y + 5
  local line_height = 7 -- Slightly smaller line height for more text
  local max_chars_per_line = 28 -- Approximate characters per line within the box

  -- Event title
  print("event: "..current_event.name, text_x, current_y, 7)
  current_y += line_height * 2 -- Extra space after title

  -- Print multiline description with wrapping
  local description = current_event.description
  local start_index = 1
  while start_index <= #description do
    local end_index = start_index + max_chars_per_line - 1
    if end_index >= #description then
      -- Last line
      print(sub(description, start_index), text_x, current_y, 7)
      start_index = #description + 1 -- Exit loop
    else
      -- Find last space within the limit
      local last_space = nil
      for i = end_index + 1, start_index, -1 do
        if sub(description, i, i) == " " then
          last_space = i
          break
        end
      end

      if last_space then
        print(sub(description, start_index, last_space - 1), text_x, current_y, 7)
        start_index = last_space + 1
      else
        -- No space found, break the word (or print the whole segment if short)
        print(sub(description, start_index, end_index), text_x, current_y, 7)
        start_index = end_index + 1
      end
    end
    current_y += line_height
    if current_y > box_y + box_h - 30 then break end -- Stop printing if out of space
  end

  current_y += line_height -- Extra space after description

  -- Print effect (ensure it fits below description)
  local effect_str = ""
  local effect_color = current_event.is_positive and 11 or 8
  local effect_y = current_y

  if current_event.effect_type == "money" then
    if current_event.effect_value > 0 then
      effect_str = "money: +$"..current_event.effect_value
    else
      effect_str = "money: $"..current_event.effect_value -- Negative sign is included
    end
    print(effect_str, text_x, effect_y, effect_color)
    effect_y += line_height
  elseif current_event.effect_type == "demand" then
    if current_event.effect_value > 0 then
      effect_str = "demand: +"..current_event.effect_value.."%"
    else
      effect_str = "demand: "..current_event.effect_value.."%"
    end
     print(effect_str, text_x, effect_y, effect_color)
     effect_y += line_height
  elseif current_event.effect_type == "both" then
    local money_effect_str = ""
    if current_event.effect_value_money > 0 then
      money_effect_str = "money: +$"..current_event.effect_value_money
    else
      money_effect_str = "money: $"..current_event.effect_value_money
    end
    print(money_effect_str, text_x, effect_y, effect_color)
    effect_y += line_height

    local demand_effect_str = ""
    if current_event.effect_value_demand > 0 then
      demand_effect_str = "demand: +"..current_event.effect_value_demand.."%"
    else
      demand_effect_str = "demand: "..current_event.effect_value_demand.."%"
    end
     print(demand_effect_str, text_x, effect_y, effect_color)
     effect_y += line_height
  end

end

-- Function to handle the cities list screen
function update_cities_list()
  -- handle navigation
  cities_selection = handle_menu_navigation(#cities, cities_selection)
  
  -- handle selection (O button)
  if btnp(4) then
    player.selected_city_id = cities[cities_selection].id
    game_state = "city_details"
    city_details_selection = 1
  end
  
  -- handle back (X button)
  if btnp(5) then
    game_state = "main_menu"
  end
end

-- Function to handle the city details screen
function update_city_details()
  -- For now, only one option: "Travel" (if not current city)
  -- No up/down navigation needed here.

  -- handle selection (O button)
  if btnp(4) then
    local selected_city_id = player.selected_city_id
    
    -- Only show travel confirmation if not already in this city
    if selected_city_id != player.current_city then
      -- Check if player can afford travel
      local travel_cost = calculate_travel_cost(player.current_city, player.selected_city_id)
      
      if player.money >= travel_cost then
        game_state = "confirm_travel"
        confirm_travel_selection = 1 -- Default to "Yes"
      end
    end
  end
  
  -- handle back (X button)
  if btnp(5) then
    player.selected_city_id = nil
    game_state = "cities_list"
  end
end

-- Function to handle the travel confirmation dialog
function update_confirm_travel()
  local travel_to_city = function()
    -- Calculate travel cost
    local travel_cost, travel_weeks = calculate_travel_cost(player.current_city, player.selected_city_id)
    
    -- Only proceed if player can afford it
    if player.money >= travel_cost then
      -- Deduct the travel cost from player's money
      player.money -= travel_cost
      
      -- Advance game time by the number of weeks taken for travel
      player.week += travel_weeks
      
      -- Check for season end (after 30 weeks)
      if player.week >= 30 and game_state != "season_end" and game_state != "game_over" then
        game_state = "season_end"
        return -- Skip the rest of the function
      end
      
      -- Travel to the selected city
      player.current_city = player.selected_city_id
      player.selected_city_id = nil
      game_state = "main_menu"
    else
      -- If somehow player can't afford it at this point, go back to city details
      game_state = "city_details"
    end
  end
  
  local go_back = function()
    game_state = "city_details"
  end
  
  confirm_travel_selection = handle_confirmation(travel_to_city, go_back, confirm_travel_selection)
end

-- Function to draw the cities list screen
function draw_cities_list()
  -- Draw money top-right
  draw_player_money()

  -- Use the banner helper
  local content_y = draw_banner("travel", nil, 12)
  
  local y_start = content_y + 10
  local line_height = 10
  local x_indent_cursor = 5
  local x_indent_text = 15

  -- draw cities
  for i=1,#cities do
    local city = cities[i]
    local y = y_start + (i-1) * line_height
    local is_current = city.id == player.current_city
    local base_color = is_current and 5 or 7 -- Dark gray if current, white otherwise
    local demand_color = base_color
    local highlight_color = is_current and 6 or 10 -- Light gray if current, yellow otherwise

    -- Color demand based on value
    if city.demand < 10 then demand_color = 8 -- Red
    elseif city.demand < 30 then demand_color = 9 -- Orange
    elseif city.demand > 80 then demand_color = 11 -- Green
    else demand_color = base_color end -- Default color otherwise

    if i == cities_selection then
      base_color = highlight_color
      demand_color = highlight_color -- Highlight demand too when selected
      print(">", x_indent_cursor, y, highlight_color)
    end

    local city_text = city.name.." "
    local demand_text = "("..city.demand.."%)"
    local current_text = is_current and " (current)" or ""

    print(city_text, x_indent_text, y, base_color)
    local name_width = #city_text * 4
    print(demand_text, x_indent_text + name_width, y, demand_color)
    local demand_width = #demand_text * 4
    print(current_text, x_indent_text + name_width + demand_width, y, base_color)
  end

  -- instructions
  local instruction_y = 128 - 2 * 10
  print("⬆️⬇️: navigate", x_indent_text, instruction_y, 5)
  print("🅾️: select city", x_indent_text, instruction_y + 10, 5)
  print("❎: back", 80, instruction_y + 10, 5)
end

-- Function to draw the city details screen
function draw_city_details()
  if player.selected_city_id == nil then return end
  
  -- Draw money top-right
  draw_player_money()
  
  -- Get city info
  local city = get_city_by_id(player.selected_city_id)
  if city == nil then return end
  
  local is_current = city.id == player.current_city
  
  -- Use the banner helper with subtitle for current location
  local subtitle = is_current and "(current location)" or nil
  local content_y = draw_banner("city: "..city.name, subtitle, subtitle and 22 or 12)
  
  -- Start content higher up
  local y_start = content_y + 5
  local line_height = 8
  local x_indent = 10
  
  -- Draw city info
  print("population: "..city.population, x_indent, y_start + line_height * 1, 7)
  print("weekly rent: $"..city.base_cost, x_indent, y_start + line_height * 2, 7)
  print("demand: "..city.demand.."%", x_indent, y_start + line_height * 3, 7)
  print("region: "..city.region, x_indent, y_start + line_height * 4, 7)
   
  -- Draw favorite act types
  local fav_str = "favorites: "
  for i=1,#city.favorites do
    fav_str = fav_str..city.favorites[i]
    if i < #city.favorites then
      fav_str = fav_str..", "
    end
  end
  print(fav_str, x_indent, y_start + line_height * 5, 7)
  
  -- Draw travel option if not current city
  if not is_current then
    -- Calculate travel cost
    local travel_cost, travel_weeks = calculate_travel_cost(player.current_city, city.id)
    local can_afford = player.money >= travel_cost
    
    -- Display travel information
    print("travel time: "..travel_weeks.." week"..(travel_weeks > 1 and "s" or ""), x_indent, y_start + line_height * 6, 7)
    local cost_color = can_afford and 7 or 8  -- Red if can't afford
    print("travel cost: $"..travel_cost, x_indent, y_start + line_height * 7, cost_color)
    
    if not can_afford then
      print("not enough money to travel!", x_indent, y_start + line_height * 8, 8)
    end
    
    local travel_y = y_start + line_height * (can_afford and 9 or 10)
    local travel_color = can_afford and 10 or 5  -- Grey out if can't afford
    print("> travel here", x_indent, travel_y, travel_color)
    
    -- instructions
    local instruction_y = 128 - 2 * 10
    print("🅾️: travel to city", x_indent, instruction_y, can_afford and 5 or 6)
    print("❎: back", x_indent, instruction_y + 10, 5)
  else
    -- instructions if current city
    local instruction_y = 128 - 10
    print("❎: back", x_indent, instruction_y, 5)
  end
end

-- Function to draw the travel confirmation screen
function draw_confirm_travel()
  if player.selected_city_id == nil then return end
  
  local city = get_city_by_id(player.selected_city_id)
  if city == nil then return end
  
  -- Draw money top-right
  draw_player_money()
  
  -- Calculate travel cost
  local travel_cost, travel_weeks = calculate_travel_cost(player.current_city, player.selected_city_id)
  
  -- Build the subtitle with travel cost and time
  local subtitle = "travel cost: $"..travel_cost
  subtitle = subtitle.."\ntravel time: "..travel_weeks.." week"..(travel_weeks > 1 and "s" or "")
  
  draw_confirmation("travel to "..city.name.."?", subtitle, confirm_travel_selection, 80)
end

-- Function to draw the confirm show screen
function draw_confirm_show()
  local city = get_city_by_id(player.current_city)
  local act_costs = calculate_act_costs()
  local total_cost = city.base_cost + act_costs
  
  draw_confirmation("ready to perform in\n"..city.name.."?", "total cost: $"..total_cost, confirm_show_selection, 70)
end

-- Function to draw the show results screen
function draw_show_results()
  local city = get_city_by_id(player.current_city)
  local current_tent = get_current_tent()

  -- Draw money top-right
  draw_player_money()

  -- Draw title
  print("show results", 38, 15, 8)

  local y_start = 35
  local line_height = 10
  local x_indent = 10

  if show_results_page == 1 then
    -- Draw attendance
    print("attendance: "..show_stats.attendance.."/"..current_tent.seats, x_indent, y_start, 7)

    -- Calculate percentage of capacity
    local capacity_pct = 0
    if current_tent.seats > 0 then -- Avoid division by zero
      capacity_pct = flr((show_stats.attendance / current_tent.seats) * 100)
    end
    local capacity_color = 7
    if capacity_pct >= 90 then
      capacity_color = 11 -- Green if nearly full
    elseif capacity_pct <= 30 then
      capacity_color = 8 -- Red if nearly empty
    end

    print("capacity: "..capacity_pct.."%", x_indent, y_start + line_height, capacity_color)

    -- Draw financial results
    print("ticket revenue: $"..show_stats.revenue, x_indent, y_start + line_height * 3, 7)
    print("total costs: $"..show_stats.total_cost, x_indent, y_start + line_height * 4, 8)

    -- Draw profit/loss
    local profit_str = "profit: $"..show_stats.profit
    local profit_color = 11

    if show_stats.profit < 0 then
      profit_str = "loss: $"..abs(show_stats.profit)
      profit_color = 8
    elseif show_stats.profit < 50 then
      profit_color = 10  -- Yellow for small profits
    end

    print(profit_str, x_indent, y_start + line_height * 6, profit_color)

    -- Instructions for page 1
    print("press 🅾️ for feedback", 15, 115, 5)
    print("press ❎ to continue", 15, 122, 5)

  elseif show_results_page == 2 then
    -- Draw audience feedback
    print("audience reactions:", x_indent, y_start - 5, 7)

    -- Use pre-generated reactions from show_stats
    local reactions = show_stats.audience_feedback
    for i=1,#reactions do
      print("- "..reactions[i], 4, y_start + 5 + (i * line_height), 6)
    end

    -- Instructions for page 2
    print("press 🅾️ or ❎ to continue", 15, 115, 5)
  end
end

-- Function to draw the run show screen
function draw_run_show()
  local city = get_city_by_id(player.current_city)
  local act_costs = calculate_act_costs()
  local total_cost = city.base_cost + act_costs
  
  -- Draw money top-right
  draw_player_money()
  
  -- Use the banner helper
  local content_y = draw_banner("run show", nil, 12)
  
  local y_start = content_y + 10
  local line_height = 8
  local x_indent = 10
  
  -- Draw city info
  print("location: "..city.name, x_indent, y_start, 7)
  print("population: "..city.population, x_indent, y_start + line_height, 7)
  
  -- Use color to indicate demand levels
  local demand_color = 7 -- Default color
  if city.demand < 10 then
    demand_color = 8 -- Red for critically low
  elseif city.demand < 30 then
    demand_color = 9 -- Orange for low
  elseif city.demand > 80 then
    demand_color = 11 -- Green for high
  end
  print("demand: "..city.demand.."%", x_indent, y_start + line_height * 2, demand_color)
  
  -- Add warning for very low demand
  if city.demand < 15 then
    print("demand too low! travel soon!", x_indent, y_start + line_height * 3, 8)
  end
  
  -- Draw favorite act types
  local fav_str = "favorites: "
  for i=1,#city.favorites do
    fav_str = fav_str..city.favorites[i]
    if i < #city.favorites then
      fav_str = fav_str..", "
    end
  end
  print(fav_str, x_indent, y_start + line_height * 4, 7)
  
  -- Draw cost breakdown
  print("city rental: $"..city.base_cost, x_indent, y_start + line_height * 5, 7)
  print("act costs: $"..act_costs, x_indent, y_start + line_height * 6, 7)
  print("total cost: $"..total_cost, x_indent, y_start + line_height * 7, 11)
  -- Draw ticket price with selector
  local ticket_y = y_start + line_height * 9
  local ticket_color = 7
  
  if run_show_selection == 1 then
    ticket_color = 10
    print(">", x_indent - 5, ticket_y, ticket_color)
    -- Add adjustment indicators when selected
    print("◀", x_indent + 3, ticket_y, ticket_color)
    print("▶", x_indent + 100, ticket_y, ticket_color)
  end
  
  print("  ticket price: $"..player.ticket_price, x_indent, ticket_y, ticket_color)
  
  -- Draw run show button
  local run_y = y_start + line_height * 10 -- Changed from 11 to 10 to move it higher
  local run_color = 7
  
  if run_show_selection == 2 then
    run_color = 10
    print(">", x_indent - 5, run_y, run_color)
  end
  
  print("start the show", x_indent, run_y, run_color)
end 

-- Add new functions for act level up screen
function update_act_level_up()
  -- Exit on any button press
  if btnp(5) or btnp(4) then
    current_level_up_index += 1
    
    -- Move to next level up or continue to next state
    if current_level_up_index <= #leveled_up_acts then
      -- Stay on level up screen, just increment the index
    else
      -- No more level ups, check for random event
      if check_random_event() then
        game_state = "random_event"
      else
        game_state = "main_menu"
      end
    end
  end
end

function draw_act_level_up()
  if current_level_up_index > #leveled_up_acts then return end
  
  local act_data = leveled_up_acts[current_level_up_index]
  local act = get_act_by_id(act_data.id)
  if act == nil then return end
  
  -- Get current skill level
  local skill_level = flr(act_data.skill)
  
  -- Upbeat messages
  local messages = {
    "practice makes perfect!",
    "what talent!",
    "standing ovation!",
    "spectacular skills!",
    "true professionals!"
  }
  
  -- Get a consistent message based on act id and skill
  local msg_index = ((skill_level * 3) + #act.id) % #messages + 1
  
  draw_festive_box("★ skill increase! ★", act.name, skill_level, messages[msg_index])
end

-- Save game function
function save_game()
  -- Save player data
  dset(0, player.week)
  dset(1, player.money)
  dset(2, player.tent_level)
  dset(3, player.ticket_price)
  dset(4, player.reputation)
  
  -- Save current city as a number (position in cities array)
  local city_index = 1
  for i=1,#cities do
    if cities[i].id == player.current_city then
      city_index = i
      break
    end
  end
  dset(5, city_index)
  
  -- Save owned acts (up to 10 acts)
  -- Format: act_id * 10 + skill_level
  -- We multiply by 10 to store both values in a single number
  for i=1,10 do
    if i <= #player.owned_acts then
      local act = player.owned_acts[i]
      local act_index = 0
      -- Find the act index in the acts array
      for j=1,#acts do
        if acts[j].id == act.id then
          act_index = j
          break
        end
      end
      -- Store act_index * 10 + skill_level
      dset(10 + i, act_index * 10 + flr(act.skill))
    else
      dset(10 + i, 0) -- No act in this slot
    end
  end
  
  -- Save previously_owned_acts (up to 10 acts)
  for i=1,10 do
    if i <= #player.previously_owned_acts then
      local act_id = player.previously_owned_acts[i]
      local act_index = 0
      -- Find the act index in the acts array
      for j=1,#acts do
        if acts[j].id == act_id then
          act_index = j
          break
        end
      end
      dset(20 + i, act_index)
    else
      dset(20 + i, 0) -- No act in this slot
    end
  end
  
  -- Save city demand values (up to 10 cities)
  for i=1,10 do
    if i <= #cities then
      dset(30 + i, cities[i].demand)
    end
  end
  
  -- Save high scores directly
  for i=1,5 do
    dset(40+i,i<=#high_scores and high_scores[i] or 0)
  end
end

-- Load game function
function load_game()
  -- Check if save data exists
  if dget(0) == 0 then return end
  
  -- Check if saved game was a finished season
  local w=dget(0)
  if w >= 30 then return end
  
  -- Load player data
  player.week=w
  player.money=dget(1)
  player.tent_level=dget(2)
  player.ticket_price=dget(3)
  player.reputation=dget(4)
  
  -- Load current city
  local city_index = dget(5)
  if city_index > 0 and city_index <= #cities then
    player.current_city = cities[city_index].id
  end
  
  -- Load owned acts
  player.owned_acts = {}
  for i=1,10 do
    local act_data = dget(10 + i)
    if act_data > 0 then
      local act_index = flr(act_data / 10)
      local skill_level = act_data % 10
      
      if act_index > 0 and act_index <= #acts then
        local act_id = acts[act_index].id
        add(player.owned_acts, {
          id = act_id,
          skill = skill_level
        })
      end
    end
  end
  
  -- Load previously_owned_acts
  player.previously_owned_acts = {}
  for i=1,10 do
    local act_index = dget(20 + i)
    if act_index > 0 and act_index <= #acts then
      add(player.previously_owned_acts, acts[act_index].id)
    end
  end
  
  -- Load city demand values
  for i=1,10 do
    if i <= #cities then
      cities[i].demand = dget(30 + i)
    end
  end
  
  -- Load high scores
  high_scores = {}
  for i=1,5 do
    local score = dget(40 + i)
    if score > 0 then
      add(high_scores, score)
    end
  end
end

-- Handle save complete screen
function update_save_complete()
  -- Exit on any button press
  if btnp(5) or btnp(4) then
    game_state = "main_menu"
  end
end

function draw_save_complete()
  -- Draw a notification box
  draw_notification("game saved!")
end

-- Generic notification function
function draw_notification(message, box_x, box_y, box_w, box_h, color)
  box_x = box_x or 24
  box_y = box_y or 45
  box_w = box_w or 80
  box_h = box_h or 30
  color = color or 11
  
  rectfill(box_x, box_y, box_x + box_w, box_y + box_h, 0)
  rect(box_x, box_y, box_x + box_w, box_y + box_h, 7)
  
  -- Draw message
  print(message, box_x + (box_w - #message * 4)/2, box_y + 12, color)
  
  -- Instruction
  print("press 🅾️ or ❎", box_x + 15, box_y + 22, 5)
end

-- Generic confirmation dialog function
function draw_confirmation(title, subtitle, selection, cursor_y)
  cursor_y = cursor_y or 80 -- Default vertical position for yes/no

  -- Background box
  local box_x = 8
  local box_y = 25
  local box_w = 112
  local box_h = 85
  rectfill(box_x, box_y, box_x + box_w, box_y + box_h, 4) -- Brown background
  rect(box_x, box_y, box_x + box_w, box_y + box_h, 8) -- Red border

  -- Title handling (multi-line support)
  local current_y = box_y + 8 -- Start drawing title lower
  if title and title ~= "" then
    local start = 1
    while start <= #title do
      local nl_pos = nil
      for i=start,#title do if sub(title,i,i) == "\n" then nl_pos=i break end end

      local line_end = nl_pos and (nl_pos-1) or #title
      local line = sub(title, start, line_end)
      print(line, box_x + (box_w - #line*4)/2, current_y, 7) -- Centered white text
      current_y = current_y + 10
      start = nl_pos and (nl_pos+1) or (#title + 1)
    end
  end

  -- Subtitle handling (multi-line support)
  current_y = current_y + 4 -- Add space before subtitle
  if subtitle then
     local start = 1
     while start <= #subtitle do
       local nl_pos = nil
       for i=start,#subtitle do if sub(subtitle,i,i) == "\n" then nl_pos=i break end end

       local line_end = nl_pos and (nl_pos-1) or #subtitle
       local line = sub(subtitle, start, line_end)
       print(line, box_x + (box_w - #line*4)/2, current_y, 10) -- Centered yellow text
       current_y = current_y + 8
       start = nl_pos and (nl_pos+1) or (#subtitle + 1)
     end
  end

  -- Options - position relative to cursor_y
  local yes_color = selection == 1 and 10 or 7 -- Yellow or white
  local no_color = selection == 2 and 10 or 7 -- Yellow or white
  local options_y = box_y + cursor_y - 25 -- Base y for options

  print("yes", box_x + 30, options_y, yes_color)
  print("no", box_x + 70, options_y, no_color)

  -- Draw selection cursor
  local cursor_x = selection == 1 and box_x + 20 or box_x + 60
  print(">", cursor_x, options_y, 10) -- Yellow cursor

  -- Instructions - positioned relative to box bottom
  print("⬅️➡️: change", box_x + 10, box_y + box_h - 17, 5) -- Dark gray
  print("🅾️: select", box_x + 70, box_y + box_h - 17, 5) -- Dark gray
  print("❎: cancel", box_x + 40, box_y + box_h - 7, 5) -- Dark gray
end

-- Draw festive box with decorative stars
function draw_festive_box(title, name, skill_level, message)
  -- Draw a festive background
  local box_x = 10
  local box_y = 25
  local box_w = 108
  local box_h = 80
  rectfill(box_x, box_y, box_x + box_w, box_y + box_h, 8) -- Red background
  rect(box_x, box_y, box_x + box_w, box_y + box_h, 7) -- White border

  -- Draw stars at the corners for decoration
  print("★", box_x + 5, box_y + 5, 10) -- Yellow star top-left
  print("★", box_x + box_w - 10, box_y + 5, 10) -- Yellow star top-right
  print("★", box_x + 5, box_y + box_h - 10, 10) -- Yellow star bottom-left
  print("★", box_x + box_w - 10, box_y + box_h - 10, 10) -- Yellow star bottom-right

  -- Title (centered)
  print(title, box_x + (box_w - #title * 4)/2, box_y + 15, 7) -- White

  -- Act name (centered)
  print(name, box_x + (box_w - #name * 4)/2, box_y + 30, 11) -- Green

  -- Show skill level with stars
  if skill_level != nil then
    local skill_text = "skill level: "
    local stars = get_skill_stars(skill_level)
    local total_width = (#skill_text + #stars) * 4
    local start_x = box_x + (box_w - total_width)/2
    print(skill_text, start_x, box_y + 45, 7) -- White label
    print(stars, start_x + #skill_text * 4, box_y + 45, 10) -- Yellow stars
  end

  -- Display message (centered)
  print(message, box_x + (box_w - #message * 4)/2, box_y + 60, 15) -- Peach message

  -- Instruction at bottom
  print("press 🅾️ or ❎ to continue", 13, 115, 5) -- Dark gray

  return box_x, box_y, box_w, box_h
end

-- Helper function to handle confirmation screen navigation and selection
function handle_confirmation(yes_action, no_action, selection_value)
  -- Handle navigation between Yes/No
  if btnp(0) or btnp(1) then -- left/right
    selection_value = 3 - selection_value -- Toggle between 1 and 2
  end
  
  -- Handle selection (O button)
  if btnp(4) then
    if selection_value == 1 then -- "Yes" selected
      yes_action()
    else -- "No" selected
      no_action()
    end
  end
  
  -- Handle back (X button)
  if btnp(5) then
    no_action()
  end
  
  return selection_value
end

-- Function to calculate travel cost between cities
function calculate_travel_cost(current_city_id, destination_city_id)
  local current_city = get_city_by_id(current_city_id)
  local destination_city = get_city_by_id(destination_city_id)
  
  if current_city == nil or destination_city == nil then 
    return 0
  end
  
  -- Get the regions
  local current_region = current_city.region
  local destination_region = destination_city.region
  
  -- Calculate travel weeks based on regions
  local travel_weeks = 1  -- Default for same region
  
  if current_region != destination_region then
    if (current_region == "central" and (destination_region == "east" or destination_region == "west")) or
       ((current_region == "east" or current_region == "west") and destination_region == "central") then
      travel_weeks = 2  -- Adjacent regions
    elseif (current_region == "east" and destination_region == "west") or
           (current_region == "west" and destination_region == "east") then
      travel_weeks = 3  -- Opposite regions
    end
  end
  
  -- Calculate cost: act upkeep * travel weeks instead of destination city base cost
  local act_upkeep = calculate_total_act_upkeep()
  local travel_cost = act_upkeep * travel_weeks
  
  return travel_cost, travel_weeks
end

-- Function to handle the game over screen
function update_game_over()
  if btnp(4) or btnp(5) then
    check_add_high_score(player.money)
    dset(0,0)
    game_state="high_scores"
    high_score_selection=1
  end
end

-- Function to draw the game over screen
function draw_game_over()
  -- Using draw_festive_box with custom parameters for game over
  -- Parameters: title, name, skill_level, message
  draw_festive_box("game over", "bankruptcy!", nil, "you ran out of money!")
end

-- Function to update season end screen
function update_season_end()
  if btnp(4) or btnp(5) then
    check_add_high_score(player.money)
    dset(0,0)
    game_state="high_scores"
    high_score_selection=1
  end
end

-- Function to draw season end screen
function draw_season_end()
  -- Using draw_festive_box with custom parameters for season end
  local title = "season end!"
  local subtitle = "congratulations!"
  local message = "your score: $" .. player.money

  -- Using draw_festive_box parameters: title, name, skill_level, message
  draw_festive_box(title, subtitle, nil, message)
end

-- Function to add a score to high scores (if it qualifies)
function check_add_high_score(score)
  current_score_is_high=false
  
  if #high_scores<5 or score>high_scores[#high_scores] then
    add(high_scores,score)
    
    -- Sort scores
    for i=1,#high_scores do
      for j=i+1,#high_scores do
        if high_scores[i]<high_scores[j] then
          high_scores[i],high_scores[j]=high_scores[j],high_scores[i]
        end
      end
    end
    
    -- Keep only top 5
    while #high_scores>5 do
      deli(high_scores,#high_scores)
    end
    
    current_score_is_high=true
    
    -- Save high scores
    for i=1,5 do
      dset(40+i,i<=#high_scores and high_scores[i] or 0)
    end
    
    return true
  end
  
  return false
end

-- Function to update high scores screen
function update_high_scores()
  -- Any button press returns to splash screen
  if btnp(4) or btnp(5) then
    game_state = "splash_screen"
    splash_selection = 1 -- Reset selection on splash screen
  end
end

-- Function to draw high scores screen
function draw_high_scores()
  -- Draw the background map
  map(0,0,0,0,16,16)

  -- Draw decorative frame (removed the outer black rectfill)
  -- rectfill(10, 10, 118, 118, 0) -- Removed this line
  rect(10, 10, 118, 118, 7)

  -- Draw inner frame (changed color from 1 (dark blue) to 0 (black) for better contrast)
  rectfill(15, 15, 113, 105, 0)
  rect(15, 15, 113, 105, 5)

  -- Draw title with fancy style
  print("★ top 5 scores ★", 28, 20, 10)
  
  -- Draw header
  print("rank", 26, 35, 7)
  print("score", 56, 35, 7)
  line(25, 42, 105, 42, 5)
  
  -- Draw scores
  for i=1,5 do
    local y = 48 + (i-1) * 10
    local rank_color = 7  -- Default color
    local score_color = 7 -- Default color
    
    -- Check if this is the current score
    if i <= #high_scores and current_score_is_high and i == get_current_score_rank() then
      rank_color = 10  -- Highlight color
      score_color = 10 -- Highlight color
      -- Indicate it's a new entry
      print("new!", 90, y, 10)
    end
    
    -- Draw rank
    print(i..".", 26, y, rank_color)
    
    -- Draw score
    if i <= #high_scores then
      print("$"..high_scores[i], 56, y, score_color)
    else
      print("---", 56, y, 6)
    end
  end
  
  -- Draw continue button
  print("press 🅾️ to continue", 25, 110, 5)
end

-- Helper function to find the rank of the current score
function get_current_score_rank()
  for i=1,#high_scores do
    if current_score_is_high and high_scores[i] == player.money then
      return i
    end
  end
  return 0
end
