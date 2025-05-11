countdown_active = false
countdown_timer = 0
countdown_images = {}
countdown_index = 1  -- 1=3, 2=2, 3=1
countdown_duration = 1  
countdown_start_time = 3  -- total countdown (3 seconds)
countdown_step = 1  -- used only for sound logic




transition_offset = 0 -- ranges from 0 to 1 over transition_duration
gallery_active = false
gallery_index = 1
gallery_transition_active = false
gallery_transition_timer = 0
gallery_transition_duration = 0.3 -- seconds
gallery_transition_dir = 1 
previous_gallery_index = 1
gallery_buttons_pressed = { back = false, forward = false }
gallery_button_scale = { back = 1.0, forward = 1.0 }
gallery_button_target_scale = { back = 1.0, forward = 1.0 }
gallery_button_press_duration = 0.1  
gallery_button_timer = { back = 0, forward = 0 }
gallery_anim_timer = 0
gallery_anim_frame = 1
gallery_anim_speed = 0.1 




gallery_images = {}
gallery_descriptions = {
   [1] = [[
Memorabilia From 
Errors Cycling 
Team's Victorious 
1979 Grand Tour From 
Antibes To Geneva
Soft Acrylic/Nylon Yarn
Multi-Layered 
Knit Construction
YKK Zip
Embroidered Badge
Embroidered Type
]],
   [2] = [[
Memorabilia From 
Errors Cycling 
Team's Victorious 
1979 Grand Tour From 
Antibes To Geneva
Soft Acrylic/Nylon Yarn
Multi-Layered 
Knit Construction
YKK Zip
Embroidered Badge
Embroidered Type
]],
   [3] = [[
Memorabilia From 
Errors Cycling 
Team's Victorious 
1973 Grand Tour From Salerno 
To Como
Soft Acrylic/Nylon Yarn
Heavy Multi-Layered Knit 
Construction
Chain-Stitched Embroidered 
'Squadra Ciclistica'
2 Embroidered Badges
Zipped Collar Closure
Oversized Rib-Knit Collar
]],
   [4] = [[
Memorabilia From Errors 
Cycling Team's Victorious 
1982 Grand Tour 
From Salerno 
To Como
100% Polyester Sports Jersey
Crafted From 
Heavyweight Technical 
Jersey Fabric, 
Designed To Preserve The 
Structure Of The Garment's 
Relaxed Silhouette
Knitted Collar
Embroidered Badge
All-Over Print
Errors Sponsorship Patches
]],
   [5] = [[
100% Polyester Sports Jacket 
Inspired By Fiorentina's 
1992/93 Away Kit, 
But With A Slight, 
And Very Necessary Change
Made From A Woven 
Technical Fabric
Designed For Comfort
Embroidered Errors F.C Badge
Knitted Funnel Collar
2-Way YKK Zip With Zip Cover
x2 Welt Pockets
Knitted Ribbing 
On Hem And Sleeves
]],
   [6] = [[
Knitted Polo Sweater 
With Skier Motif
Features 18 Embroidered 
Patches Of Postcards From 
Various Ski-Resorts 
Around The World
Soft Acrylic/Nylon Yarn
Heavy Multi-Layered 
Knit Construction
Over 300,000 
Embroider Stitches
Knitted Buttons
Thick Knitted Ribbing
]],
   [7] = [[
Panelled Jacket From 
Italian Lambskin Leather, 
Constructed In Our 
London Atelier
Many Layers Of 
Leather Create A 
Target Motif
Each Jacket Takes 
3 Days To Make
2-Way Riri Zip
x2 Side Seam Pockets
Fully Lined
HANDMADE IN LONDON
]],
   [8] = [[
Loose-Fit Jeans From 
Heavy Cotton Denim
Faded Wash
All-Over Quilting And 
Intricate Patchwork 
Creates A 
Motocross-Inspired Motif
All-Seeing Knee Pads
Zip And Button Fastening
Oversized Moto Zip Guard
x2 Padded Side Pockets
Curved Waistband
x2 Quilted Back Pockets
Quilted Yoke
Errors Moto Leather Patch
]]
}



button_forward = nil
button_back = nil
gallery_bg = nil


function z_dist(Y_screen)
   return Y_world / (Y_screen - (screen_h / 2))
end

function z_to_y(z)
   if z < 0 then
      return -1000
   else
      return (Y_world / -z) + (screen_h / 2)
   end
end

function seg(pos, target_x, hilly)
   return {pos = pos,
           target_x = target_x,
           hilly = hilly}   
end

function collides(x1, z1, x2, z2, size_x, size_z)
   return x1 < x2 + size_x
      and x1 + size_x >= x2
      and z1 < z2 + size_z
      and z1 + size_z >= z2
end


timerrr = 0

function enemy_bike(x, z, speed, sprite, base_speed)
   return {
      x = x,
      z = z,
      speed = speed,
      base_speed = base_speed or speed,
      acc = 0.00002,
      max_speed = speed + 0.02,
      sprite = sprite,
      w = 30,
      h = 0.003,
      dir = 1,
      x_timer = math.random(1, 3),
      boosted = false
   }
end



clicked_to_start = false
race_over = false
final_rank = nil


music_start = false
you_win = false



-- Menu state
menu_active = true
menu_timer = 0

gallery_timer = 0

transition_active = false
transition_to = nil  
transition_timer = 0
transition_frame = 1
transition_frames = {}
transition_duration = 1.5  -- total time for the transition (seconds)

-- Menu assets
menu_buttons = {
   {name = "play",   x = 0, y = 0, w = 0, h = 0, img = nil, pressed = false},
   {name = "gallery",x = 0, y = 0, w = 0, h = 0, img = nil, pressed = false},
   {name = "quit",   x = 0, y = 0, w = 0, h = 0, img = nil, pressed = false}
}

menu_title = nil


src2 = love.audio.newSource("bgm.mp3", "static")
src2:setVolume(0.4)
src2:setLooping(true)  --loop background music

function love.load()
   finish_left_img = love.graphics.newImage("assets/sprites/finish_left.png")
   finish_right_img = love.graphics.newImage("assets/sprites/finish_right.png")  

   beep1 = love.audio.newSource("assets/sfx/beep1.mp3", "static")
   beep2 = love.audio.newSource("assets/sfx/beep2.mp3", "static")
   beep1:setVolume(0.5)
   beep2:setVolume(0.5)

   button_sfx = love.audio.newSource("assets/sfx/button.mp3", "static")
   button_sfx:setVolume(2)
   countdown_images[1] = love.graphics.newImage("assets/sprites/3.png")
   countdown_images[2] = love.graphics.newImage("assets/sprites/2.png")
   countdown_images[3] = love.graphics.newImage("assets/sprites/1.png")

   pixelFont = love.graphics.newFont("assets/fonts/Pixelpurl-0vBPP.ttf", 16) 
   love.graphics.setFont(pixelFont)

   bike_x_vel = 0
   bike_x_acc = 30
   bike_x_friction = love.keyboard.isDown("a") or love.keyboard.isDown("d") and 6 or 3

   
   love.graphics.setDefaultFilter("nearest", "nearest")
   
   segments = {
      seg(0.5, 0, 0), seg(0.8, 10, 0), seg(1, 5, 0), seg(1.5, 20, 0), seg(1.7, 40, 0), seg(2.0, 20, 0),
      seg(2.1, 10, 0), seg(2.15, 5, 0), seg(2.2, 0, 0), seg(2.5, 5, 0), seg(2.55, 10, 0), seg(2.6, 20, 0),
      seg(2.65, 40, 0), seg(3, 30, 0), seg(3.2, 40, 0), seg(3.4, 20, 0), seg(3.5, 5, 0), seg(3.55, 10, 0),
      seg(3.6, 20, 0), seg(3.7, 10, 0), seg(4.0, 5, 0), seg(4.5, 0, 0), seg(4.5, 20, 0), seg(4.8, 10, 0),
      seg(5.15, 5, 0), seg(5.2, 0, 0), seg(5.65, 40, 0), seg(6, 30, 0)
   }


   win_z = 4
   
   Y_world = -5
   
   image = love.graphics.newImage("assets/sprites/bild.png")
   image2 = love.graphics.newImage("assets/sprites/bild2.png")
   bg = love.graphics.newImage("assets/sprites/bg.png")
   bike = love.graphics.newImage("assets/sprites/player.png")

   
   racer_images = {
      love.graphics.newImage("assets/sprites/racer1.png"),
      love.graphics.newImage("assets/sprites/racer2.png"),
      love.graphics.newImage("assets/sprites/racer3.png")
   }



   multi = 2
   screen_w, screen_h = image:getDimensions()
   screen_w = multi * screen_w
   screen_h = multi * screen_h
   love.window.setMode(screen_w, screen_h, {resizable=true})
   

   
   bike_w, bike_h = bike:getDimensions()
   bike_w = bike_w * 4
   bike_h = bike_h * 4
   bike_quad = love.graphics.newQuad(0, 0, bike_w * 0.5, bike_h * 0.5, bike_w, bike_h)


   bike_x = 0
   bike_x_speed = 8
   bike_y_speed = 0.00
   bike_y_max_speed = 0.0005
   bike_y_acc = 0.001
   bike_z = 0.023
   
   horizon_y = screen_h - 262
   
   last_off = nil
   
   quads = {}
   
   enemies = spawn_enemies()

   
   x = 0
   dx = 0
   ddx = 4
   for y=0, screen_h do
      dx = x + ddx
      x = x + dx * 0.04
      table.insert(quads, love.graphics.newQuad(-500, screen_h-y, screen_w + 1000, 1, screen_w, screen_h))
   end
   
   segment = segments[1]
   
   offset = 0
   seg_i = 1



   -- Load menu assets
   menu_title = love.graphics.newImage("assets/sprites/title.png")

   local btn_names = {"play", "gallery", "quit"}
   local spacing = 20
   local button_width, button_height = 100, 32

   -- Position title at top center
   local title_y = screen_h / 2 - 100  

   -- Position buttons centered horizontally below title
   local total_height = 0
   for _, name in ipairs(btn_names) do
      local temp_img = love.graphics.newImage("assets/sprites/" .. name .. ".png")
      local _, h = temp_img:getDimensions()
      total_height = total_height + h
   end
   total_height = total_height + spacing * (#btn_names - 1)

   local start_y = screen_h / 2 - total_height / 2 + 50 -- +50 for spacing below title


   for i, name in ipairs(btn_names) do
      local img = love.graphics.newImage("assets/sprites/" .. name .. ".png")
      local img_w, img_h = img:getDimensions()
      local x = screen_w / 2 - img_w / 2
      local y = start_y + (i - 1) * (img_h + spacing)

      menu_buttons[i].x = x
      menu_buttons[i].y = y
      menu_buttons[i].w = img_w
      menu_buttons[i].h = img_h
      menu_buttons[i].img = img
   end

   if not src2:isPlaying() then
      src2:play()
   end

   gallery_animations = {}

   for i = 1, 8 do
      gallery_animations[i] = {}
      for j = 1, 8 do
         local frame_path = string.format("assets/gif/gal%d/gal%d%d.png", i, i, j)
         gallery_animations[i][j] = love.graphics.newImage(frame_path)
      end
   end


      button_forward = love.graphics.newImage("assets/sprites/ButtonForward.png")
      button_back = love.graphics.newImage("assets/sprites/ButtonBack.png")
      gallery_bg = love.graphics.newImage("assets/sprites/galGUI.png")

   for i = 1, 30 do
      local frame_num = string.format("%02d", i)
      transition_frames[i] = love.graphics.newImage("assets/gif/frame_apngframe" .. frame_num .. ".png")
   end

end

function love.resize(w, h)
   quad = love.graphics.newQuad(0, 0, w, h, w, h)
end

function love.update(dt)
   if transition_active then
      transition_timer = transition_timer + dt
      local progress = math.min(transition_timer / transition_duration, 1)
      transition_offset = progress

      local frame_count = #transition_frames
      transition_frame = math.min(frame_count, math.floor(progress * frame_count) + 1)

      if transition_timer >= transition_duration then
         transition_active = false
         if transition_to == "gallery" then
            gallery_active = true
            menu_active = false
         elseif transition_to == "menu" then
            gallery_active = false
            menu_active = true
         end
      end
      return
   end

   if countdown_active then
      countdown_timer = countdown_timer + dt

      if countdown_step == 1 and countdown_timer >= 0 then
         beep1:stop()
         beep1:play()
         countdown_step = 2
      elseif countdown_step == 2 and countdown_timer >= 1 then
         beep1:stop()
         beep1:play()
         countdown_step = 3
      elseif countdown_step == 3 and countdown_timer >= 2 then
         beep2:stop()
         beep2:play()
         countdown_step = 4
      elseif countdown_step == 4 and countdown_timer >= 3 then
         countdown_active = false
         clicked_to_start = true
      end

      -- Update which number to show
      countdown_index = math.floor(countdown_timer) + 1
   end





   if menu_active or gallery_active then
      if menu_active then
         menu_timer = menu_timer + dt
      end
      if gallery_active then
         gallery_timer = gallery_timer + dt
         gallery_anim_timer = gallery_anim_timer + dt
         if gallery_anim_timer >= gallery_anim_speed then
            gallery_anim_timer = gallery_anim_timer - gallery_anim_speed
            gallery_anim_frame = gallery_anim_frame % 8 + 1
         end
         for k, pressed in pairs(gallery_buttons_pressed) do
            if pressed then
               gallery_button_target_scale[k] = 0.95
               gallery_button_timer[k] = gallery_button_press_duration
            elseif gallery_button_timer[k] > 0 then
               gallery_button_timer[k] = gallery_button_timer[k] - dt
               if gallery_button_timer[k] <= 0 then
                  gallery_button_target_scale[k] = 1.0
               end
            end

            -- Smooth scale interpolation
            gallery_button_scale[k] = gallery_button_scale[k] + (gallery_button_target_scale[k] - gallery_button_scale[k]) * dt * 10
         end

         if gallery_transition_active then
            gallery_transition_timer = gallery_transition_timer + dt
            if gallery_transition_timer >= gallery_transition_duration then
               gallery_transition_active = false
               gallery_transition_timer = 0
               previous_gallery_index = gallery_index
            end
         end
      end

      return
   end

   if not clicked_to_start or race_over then return end

   timerrr = timerrr + dt

   local player_z = bike_z + offset

   for _, enemy in ipairs(enemies) do
      -- Smooth catch-up
      local dz = player_z - enemy.z
      if dz > 0 then
         -- Aggressive boost based on distance, up to 0.12 speed increase
         local catch_up_boost = math.min(math.pow(dz, 1.1) * 0.4, 0.12)
         local target_speed = enemy.base_speed + catch_up_boost
         enemy.speed = enemy.speed + (target_speed - enemy.speed) * dt * 6  -- faster acceleration toward target
      else
         -- Ease back down smoothly when ahead
         local target_speed = enemy.base_speed
         enemy.speed = enemy.speed + (target_speed - enemy.speed) * dt * 3
      end


      -- Move forward
      enemy.z = enemy.z + enemy.speed * dt

      -- Weave and drift
      enemy.x = enemy.x + enemy.dir * dt * 0.1
      enemy.x_timer = enemy.x_timer - dt
      if enemy.x > 0.85 or enemy.x < 0.15 then
         enemy.dir = -enemy.dir
      end
      if enemy.x_timer <= 0 then
         enemy.dir = -enemy.dir
         enemy.x_timer = math.random(1, 3)
      end
   end




-- Avoid overlap with other enemies
   for a = 1, #enemies do
      local enemy = enemies[a]
      for b = 1, #enemies do
         local other = enemies[b]
         if a ~= b then
            local dz = math.abs(enemy.z - other.z)
            local dx = math.abs(enemy.x - other.x)

            if dz < 0.05 and dx < 0.15 then  -- increased separation thresholds
               -- Push them apart more aggressively
               local push_strength = 0.002

               if enemy.z < other.z then
                  enemy.speed = math.max(enemy.speed - push_strength, 0.02)
               elseif enemy.z > other.z then
                  enemy.speed = math.min(enemy.speed + push_strength, enemy.max_speed)
               end

               -- Horizontal separation
               local horizontal_push = 0.1
               if enemy.x < other.x then
                  enemy.x = enemy.x - horizontal_push * dt
                  other.x = other.x + horizontal_push * dt
               else
                  enemy.x = enemy.x + horizontal_push * dt
                  other.x = other.x - horizontal_push * dt
               end
            end
         end
      end



   end



   local acceleration = bike_y_acc
   local deceleration = bike_y_acc * 0.5  -- slower decel for smoother easing

   if love.keyboard.isDown("w") then
      bike_y_speed = bike_y_speed + dt * acceleration
   elseif love.keyboard.isDown("s") then
      bike_y_speed = bike_y_speed - dt * acceleration * 2
   else
      -- No key: slow down gradually
      if bike_y_speed > 0 then
         bike_y_speed = bike_y_speed - dt * deceleration
         if bike_y_speed < 0 then bike_y_speed = 0 end
      elseif bike_y_speed < 0 then
         bike_y_speed = bike_y_speed + dt * deceleration
         if bike_y_speed > 0 then bike_y_speed = 0 end
      end
   end

   if love.keyboard.isDown("a") then
      bike_x_vel = bike_x_vel - dt * bike_x_acc
   end
   if love.keyboard.isDown("d") then
      bike_x_vel = bike_x_vel + dt * bike_x_acc
   end

   -- Apply friction
   bike_x_vel = bike_x_vel * (1 - dt * bike_x_friction)

   -- Update position
   bike_x = bike_x + bike_x_vel * dt

   -- Slight speed drag while turning
   if love.keyboard.isDown("a") or love.keyboard.isDown("d") then
      bike_y_speed = bike_y_speed - dt * bike_y_acc * 1.2
   end


   if bike_y_speed > bike_y_max_speed then
      bike_y_speed = bike_y_max_speed
   end
   if bike_y_speed < 0 then
      bike_y_speed = 0
   end




end



function calc_world_x(last_x, last_z, target_x, target_z, cur_z, ppp, y_pos)
   delta_x = (target_x - last_x)
   percentage = (cur_z - last_z) / (target_z - last_z) -- 1.5 / 2
   

   
   return last_x + delta_x * percentage
end

function get_x(i, z)
   if segments[i-1] then               
      last_x = segments[i-1].target_x               
      last_z = segments[i-1].pos               
   else               
      last_x = 0
      last_z = 0               
   end      
   
   if segments[i] ~= nil and z <= segments[i].pos then
      target_x = segments[i].target_x               
      target_z = segments[i].pos      
   else
      target_x = 0
      target_z = z
   end
   
   return calc_world_x(last_x, last_z, target_x, target_z, z)
end

function seg_i_at_z(z)
   for i, seg in pairs(segments) do
      if seg.pos > z then
         return i
      end
   end
   return 10000000000
end

function road_width_at_y(y)
   min_w = 27 * multi
   min_y = 262
   
   max_w = 320 * multi
   max_y = screen_h
   
   return (max_w - min_w) * ((y - min_y) / (max_y - min_y)) + min_w
end

function screen_x(camera_x, world_x, z, ppp, y)
   horizon_dist_from_center = 0.5 * ((get_x(seg_i_at_z(offset), offset) - camera_x) +
         (get_x(seg_i_at_z(z_dist(horizon_y)+offset), z_dist(horizon_y)+offset) - camera_x)) * 25
   dist_from_center = (world_x - camera_x) * 25
   calc_z = 1

   calc_z2 = 0

   dist_from_center = (1 * dist_from_center) * calc_z


   return dist_from_center
end

function love.draw()




   
   if transition_active then
      -- Slide menus upward
      local y_offset = -screen_h * transition_offset
      local new_y_offset = screen_h * (1 - transition_offset)

      -- Draw current screen (sliding up)
      if menu_active then
         draw_menu(y_offset)
      elseif gallery_active then
         draw_gallery(y_offset)
      end

      -- Draw target screen (sliding in from bottom)
      if transition_to == "gallery" then
         draw_gallery(new_y_offset)
      elseif transition_to == "menu" then
         draw_menu(new_y_offset)
      end

      -- Overlay bubble frame
      local frame = transition_frames[transition_frame]
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.draw(frame, 0, 0, 0, screen_w / 500, screen_h / 375)
      return
   end




      -- Pre-start message
   if menu_active or gallery_active then
      love.graphics.draw(image, 0, 0, 0, multi, multi)
      if menu_active then
         -- draw menu
         local bob = math.sin(menu_timer * 2) * 5
         local tilt = math.sin(menu_timer) * 0.05

         local tw, th = menu_title:getDimensions()
         love.graphics.draw(menu_title, screen_w / 2, 80 + bob, 0, 1, 1, tw / 2, th / 2)

         for _, btn in ipairs(menu_buttons) do
            love.graphics.draw(btn.img, btn.x, btn.y + bob, tilt)
         end
      end

-- Gallery screen drawing
      if gallery_active then
         love.graphics.draw(gallery_bg, 0, 0, 0, multi, multi)
         local sprite = gallery_animations[gallery_index][gallery_anim_frame]
         local sprite_w, sprite_h = sprite:getDimensions()
         local scale = 3

         -- Adjust sprite position to better center it in the left panel
         local draw_x = screen_w * 0.315  -- manually fine-tuned for better visual center
         local draw_y = screen_h * 0.53   

         love.graphics.draw(
            sprite,
            draw_x,
            draw_y,
            0,
            scale,
            scale,
            sprite_w / 2,
            sprite_h / 2
         )

         local desc = gallery_descriptions[gallery_index]
         desc_font = love.graphics.newFont("assets/fonts/Pixelpurl-0vBPP.ttf", 7)

         love.graphics.setFont(pixelFont)
         love.graphics.setColor(150/255, 2/255, 28/255)  
         local panel_x = screen_w * 0.525 
         local panel_y = screen_h * 0.29
         local panel_w = screen_w * 0.33
         local panel_h = screen_h * 0.45


         local _, wrapped = pixelFont:getWrap(desc, panel_w)
         local line_height = pixelFont:getHeight()
         local text_height = #wrapped * line_height
         local desc_y = panel_y + (panel_h - text_height) / 2

         love.graphics.printf(desc, panel_x, desc_y, panel_w, "center")

         love.graphics.setColor(1, 1, 1, 1)  -- reset to white


         -- New Y position with comfortable bottom margin
         local button_y = screen_h - 60  

         -- New X positions (relative to panel center)
         local back_x = screen_w * 0.25 - button_back:getWidth() / 2 - 20
         local forward_x = screen_w * 0.75 - button_forward:getWidth() / 2 + 20

         local gallery_bob = math.sin(gallery_timer * 2) * 5
         local gallery_tilt = math.sin(gallery_timer) * 0.05

         love.graphics.draw(button_back, back_x, button_y + gallery_bob, gallery_tilt)
         love.graphics.draw(button_forward, forward_x, button_y + gallery_bob, -gallery_tilt)


      end


      return
   end



   -- End-of-race message
   if race_over then
      love.graphics.draw(bg, 0, -80, 0, multi, multi)

      local all_racers = {
         {name = "Player", z = bike_z + offset}
      }
      for i, enemy in ipairs(enemies) do
         table.insert(all_racers, {name = "Enemy" .. i, z = enemy.z})
      end
      table.sort(all_racers, function(a, b) return a.z > b.z end)

      local rank = 1
      for i, racer in ipairs(all_racers) do
         if racer.name == "Player" then
            rank = i
            break
         end
      end

      local suffix = {"st", "nd", "rd", "th"}
      local suffix_index = math.min(rank, 4)
      local msg = (rank == 1) and "You Win!" or "You Lose!"

      love.graphics.printf(msg .. "\nYou finished " .. rank .. suffix[suffix_index] .. "\nClick to Restart", 0, screen_h/2, screen_w, "center")
      return
   end
   love.graphics.draw(bg, 0, -80, 0, multi, multi)
   while segment ~= nil and offset + z_dist(0) > segment.pos do
      seg_i = seg_i + 1
      segment = segments[seg_i]
   end
   
   
   camera_x = bike_x

   
   if segment ~= nil and last_off ~= nil then
      lul_offset = last_off - screen_x(0, get_x(seg_i, offset + z_dist(0)), z_dist(0))
   end
   
   if last_off ~= nil then
      last_off = screen_x(0, get_x(seg_i, offset + z_dist(0)), z_dist(0))
   else
      last_off = screen_x(0, get_x(seg_i, offset + z_dist(0)), z_dist(0))
   end
   
   temp_seg_i = seg_i
   
   ddz = 8 * multi
   dz = 0
   z = 0
   mod = 0
   offset = offset + bike_y_speed

   
   modv = 0.05
   base = 0.95
   
   calced_x = screen_w / 2
   dx = 0
   ddx = 0
   
   
   
   push = bike_x / (screen_h / 2 * 0.037)
   
   --   y = 1
   --   dy = 1
   --   ddy = 0
   all = 0
   
   
   m_x, m_y = love.mouse.getPosition()

   
   for i, quad in pairs(quads) do
      all = all + 1
   end

   for i=1,all do

      while segments[temp_seg_i] ~= nil and offset + z_dist(i) > segments[temp_seg_i].pos do
         temp_seg_i = temp_seg_i + 1
      end
      
      if i % 30 == 0 then         
         screen_x(camera_x, world_target_x, z_dist(i), true, z_to_y(z_dist(i)))
    
      end
      
      world_target_x = get_x(temp_seg_i, offset + z_dist(i))
      current_target_x = screen_x(camera_x, world_target_x, z_dist(i))
      
      ddx = ddx + dx
      

      
      mod = (500 * (z_dist(i) + offset)) % 8
      
      if mod > 5 then
         mod = 1
      else
         mod = 0
      end
      
      if i > all/2 then
         mod = 1
      end
      
      love.graphics.setColor(base + mod * modv, base + mod * modv, base + mod * modv)
      
      if i < 220 and i < all and i > 1 then
         quad = quads[math.floor(i)]
         if mod == 1 then
            love.graphics.draw(image, quad, current_target_x - 500, screen_h - (i - 1))
         else
            love.graphics.draw(image2, quad, current_target_x - 500, screen_h - (i - 1))
         end
      end
   end
   
   -- Draw the finish line with distance scaling
   local finish_z = win_z
   local relative_z = finish_z - offset

   if relative_z > 0 then
      local y = z_to_y(relative_z)
      local scale = 8 / ((relative_z) / 0.01)
      local road_w = road_width_at_y(y)

      if y > 0 and y < screen_h and scale > 0 then
         scale = math.min(scale, 2.5)

         -- Get world-space center of road at finish line
         local seg_index = seg_i_at_z(finish_z)
         local world_center_x = get_x(seg_index, finish_z)

         -- Calculate actual screen positions of road edges
         local half_road_world_units = (road_w / screen_w) * 0.5
         local left_world_x = world_center_x - half_road_world_units
         local right_world_x = world_center_x + half_road_world_units

         -- Project to screen space
         local left_x = screen_w / 2 + screen_x(camera_x, left_world_x, relative_z)
         local right_x = screen_w / 2 + screen_x(camera_x, right_world_x, relative_z)

         -- Adjust right flag to draw from bottom-left (instead of top-left)
         love.graphics.draw(finish_left_img, left_x - finish_left_img:getWidth() * scale, y - 64 * scale, 0, scale, scale)
         love.graphics.draw(finish_right_img, right_x, y - 64 * scale, 0, scale, scale)
      end
   end




   
   for i, enemy in pairs(enemies) do
      if enemy.z - offset > 0.01 then

         scale = 8 / ((enemy.z - offset) / 0.01)
         road_w = road_width_at_y(z_to_y(enemy.z - offset))
         enemy_x = road_w * enemy.x - road_w * 0.5 + screen_x(camera_x, get_x(seg_i_at_z(enemy.z), enemy.z), enemy.z - offset, i == 1, z_to_y(enemy.z-offset)) + screen_w * 0.5
         
         if scale > 0.4 then
            local tilt_angle = 0.2 * enemy.dir  -- slight tilt left or right based on direction
            local ew, eh = enemy.sprite:getDimensions()
            love.graphics.draw(enemy.sprite,
                              enemy_x,
                              z_to_y(enemy.z - offset),
                              tilt_angle,
                              scale, scale,
                              ew / 2, eh / 2)

         end
         
         
         my_x = screen_w * 0.5
         --love.graphics.print(enemy_x, enemy_x, 100)
         --love.graphics.print(my_x, my_x, 400)
         
         if collides(enemy_x, enemy.z, my_x, bike_z + offset, enemy.w * 2, enemy.h * 2) then
            bike_y_speed = 0
            --         print "collided"
         end
      end
   end
   
   love.graphics.print(math.floor(bike_y_speed*100000) .. "", 40, screen_h - 20)
   love.graphics.print(math.floor(timerrr) .. " sec", screen_w - 80, screen_h - 20)
   
   local bike_scale_x = 4      -- keep width scale
   local bike_scale_y = 3.2    -- reduce height scale to shorten the sprite visually
   local rotation = 0

   if love.keyboard.isDown("a") or love.keyboard.isDown("left") then
      rotation = -0.2
   elseif love.keyboard.isDown("d") or love.keyboard.isDown("right") then
      rotation = 0.2
   end

   love.graphics.draw(bike, screen_w * 0.5, 398, rotation, bike_scale_x, bike_scale_y, 16, 16)


   -- Progress bar (right side of screen)
local bar_x = screen_w - 30
local bar_y = 50
local bar_w = 10
local bar_h = screen_h - 100

-- Background
love.graphics.setColor(0.2, 0.2, 0.2, 0.6)
love.graphics.rectangle("fill", bar_x, bar_y, bar_w, bar_h)

-- Progress calculation
local progress = math.min(offset / win_z, 1.0) -- clamp to 1.0
local fill_h = bar_h * progress
local fill_y = bar_y + bar_h - fill_h

-- Fill
love.graphics.setColor(0.1, 0.8, 0.3, 1.0)
love.graphics.rectangle("fill", bar_x, fill_y, bar_w, fill_h)

-- Reset color
love.graphics.setColor(1, 1, 1, 1)



   local all_racers = {}

   table.insert(all_racers, {name = "Player", z = bike_z + offset})
   for i, enemy in ipairs(enemies) do
      table.insert(all_racers, {name = "Enemy" .. i, z = enemy.z})
   end

   table.sort(all_racers, function(a, b) return a.z > b.z end)

   local rank = 1
   for i, racer in ipairs(all_racers) do
      if racer.name == "Player" then
         rank = i
         break
      end
   end

   local suffix = {"st", "nd", "rd", "th"}
   local suffix_index = math.min(rank, 4)
   love.graphics.print("Rank: " .. rank .. suffix[suffix_index], 10, 10)

   -- Win condition
   if offset > win_z then
      you_win = true
      race_over = true
      final_rank = rank

      -- Reset to menu
      menu_active = true
      clicked_to_start = false
      race_over = false
      final_rank = nil
      offset = 0
      if not src2:isPlaying() then
         src2:play()
      end
   end

   -- Pre-start message
   if not clicked_to_start and not countdown_active then
      love.graphics.printf("Click to Start the Race", 0, screen_h/2 - 30, screen_w, "center")
      return
   end

   -- End-of-race message
   if race_over then
      local msg = (final_rank == 1) and "You Win!" or "You Lose!"
      love.graphics.printf(msg .. "\nYou finished " .. final_rank .. suffix[suffix_index] .. "\nClick to Restart", 0, screen_h/2, screen_w, "center")
      return
   end

   if countdown_active and countdown_index <= 3 then
      local image = countdown_images[countdown_index]
      if image then
         local elapsed = countdown_timer - ((countdown_index - 1) * countdown_duration)
         local scale = 1 + elapsed * 1.5  -- zoom out effect
         local alpha = 1 - elapsed        -- fade out effect

         love.graphics.setColor(1, 1, 1, alpha)
         local iw, ih = image:getWidth(), image:getHeight()
         love.graphics.draw(image, screen_w / 2, screen_h / 2, 0, scale, scale, iw / 2, ih / 2)
         love.graphics.setColor(1, 1, 1, 1)
      end
   end

end      

function love.mousepressed(x, y, button)
   if button == 1 then
      -- Play click sound once per button press
      if button_sfx then
         button_sfx:seek(0)
         button_sfx:play()
      end

      if menu_active then
         for _, btn in ipairs(menu_buttons) do
            if x > btn.x and x < btn.x + btn.w and y > btn.y and y < btn.y + btn.h then
               btn.pressed = true
               if btn.name == "play" then
                  transition_active = false
                  gallery_active = false
                  menu_active = false

                  clicked_to_start = false
                  race_over = false
                  final_rank = nil
                  offset = 0
                  timerrr = 0
                  seg_i = 1
                  segment = segments[1]
                  bike_y_speed = 0
                  bike_x = 0
                  enemies = spawn_enemies()
                  countdown_active = true
                  countdown_timer = 0
                  countdown_index = 1
                  beep1:stop()
                  beep1:play()

                  if not src2:isPlaying() then
                     src2:play()
                  end
               elseif btn.name == "gallery" then
                  transition_active = true
                  transition_to = "gallery"
                  transition_timer = 0
                  transition_frame = 1
               elseif btn.name == "quit" then
                  love.event.quit()
               end
            end
         end
         return
      end

      if gallery_active then
         local gallery_bob = math.sin(gallery_timer * 2) * 5
         local button_y = screen_h - 60 + gallery_bob
         local back_x = screen_w * 0.25 - button_back:getWidth() / 2 - 20
         local forward_x = screen_w * 0.75 - button_forward:getWidth() / 2 + 20

         if x > forward_x and x < forward_x + button_forward:getWidth()
            and y > button_y and y < button_y + button_forward:getHeight() then
            gallery_buttons_pressed.forward = true
            if not gallery_transition_active then
               previous_gallery_index = gallery_index
               gallery_index = gallery_index % 8 + 1
               gallery_transition_dir = 1
               gallery_transition_active = true
               gallery_transition_timer = 0
            end
         end

         if x > back_x and x < back_x + button_back:getWidth()
            and y > button_y and y < button_y + button_back:getHeight() then
            gallery_buttons_pressed.back = true
            if not gallery_transition_active then
               previous_gallery_index = gallery_index
               gallery_index = (gallery_index - 2) % 8 + 1
               gallery_transition_dir = -1
               gallery_transition_active = true
               gallery_transition_timer = 0
            end
         end
      end

      if not clicked_to_start and not gallery_active then
         clicked_to_start = true
         race_over = false
         final_rank = nil
      elseif race_over then
         src2:stop()
         love.load()
         menu_active = true
         clicked_to_start = false
         race_over = false
         final_rank = nil
         music_start = false
      end
   end
end




function love.keypressed(key)
   if gallery_active and key == "escape" then
      transition_active = true
      transition_to = "menu"
      transition_timer = 0
      transition_frame = 1
   end
end

function love.mousereleased(x, y, button)
   if button == 1 then
      for _, btn in ipairs(menu_buttons) do
         btn.pressed = false
      end
      gallery_buttons_pressed.forward = false
      gallery_buttons_pressed.back = false
   end
end

function draw_menu(y)
   love.graphics.draw(image, 0, y, 0, multi, multi)
   local bob = math.sin(menu_timer * 2) * 5
   local tilt = math.sin(menu_timer) * 0.05
   local tw, th = menu_title:getDimensions()
   love.graphics.draw(menu_title, screen_w / 2, 80 + bob + y, 0, 1, 1, tw / 2, th / 2)
   for _, btn in ipairs(menu_buttons) do
      local scale = btn.pressed and 0.95 or 1.0
      local cx = btn.x + btn.w / 2
      local cy = btn.y + btn.h / 2 + bob + y
      love.graphics.draw(btn.img, cx, cy, tilt, scale, scale, btn.w / 2, btn.h / 2)

   end
end

function draw_gallery(y)
   local sprite = gallery_animations[gallery_index][gallery_anim_frame]


   local sprite_w, sprite_h = sprite:getDimensions()
   local scale = 3
   local draw_x = screen_w * 0.315
   local draw_y = screen_h * 0.53 + y

   -- Animate between previous and current image
   local t = gallery_transition_timer / gallery_transition_duration
   t = math.min(t, 1)

   local sprite_new = gallery_animations[gallery_index][gallery_anim_frame]
   local sprite_old = gallery_animations[previous_gallery_index][gallery_anim_frame]


   local sprite_w, sprite_h = sprite_new:getDimensions()
   local scale = 3
   local center_x = screen_w * 0.315
   local center_y = screen_h * 0.53 + y

   if gallery_transition_active then
      local offset = screen_w * (1 - t) * gallery_transition_dir

      -- Draw old image sliding out
      love.graphics.draw(sprite_old, center_x - offset, center_y, 0, scale, scale, sprite_w / 2, sprite_h / 2)
      -- Draw new image sliding in
      love.graphics.draw(sprite_new, center_x + screen_w * gallery_transition_dir * (1 - t), center_y, 0, scale, scale, sprite_w / 2, sprite_h / 2)
   else
      -- No animation, just draw current image
      love.graphics.draw(sprite_new, center_x, center_y, 0, scale, scale, sprite_w / 2, sprite_h / 2)
   end


   local desc = gallery_descriptions[gallery_index]
   local panel_x = screen_w * 0.525
   local panel_y = screen_h * 0.29 + y
   local panel_w = screen_w * 0.33
   local panel_h = screen_h * 0.45

   local _, wrapped = pixelFont:getWrap(desc, panel_w)
   local line_height = pixelFont:getHeight()
   local text_height = #wrapped * line_height
   local desc_y = panel_y + (panel_h - text_height) / 2

   love.graphics.setColor(150 / 255, 2 / 255, 28 / 255)
   love.graphics.printf(desc, panel_x, desc_y, panel_w, "center")
   love.graphics.setColor(1, 1, 1)

   local gallery_bob = math.sin(gallery_timer * 2) * 5
   local gallery_tilt = math.sin(gallery_timer) * 0.05
   local button_y = screen_h - 60 + gallery_bob + y
   local back_x = screen_w * 0.25 - button_back:getWidth() / 2 - 20
   local forward_x = screen_w * 0.75 - button_forward:getWidth() / 2 + 20
   local back_scale = gallery_button_scale.back
   local forward_scale = gallery_button_scale.forward



   love.graphics.draw(button_back, back_x + button_back:getWidth()/2, button_y + button_back:getHeight()/2, gallery_tilt, back_scale, back_scale, button_back:getWidth()/2, button_back:getHeight()/2)
   love.graphics.draw(button_forward, forward_x + button_forward:getWidth()/2, button_y + button_forward:getHeight()/2, -gallery_tilt, forward_scale, forward_scale, button_forward:getWidth()/2, button_forward:getHeight()/2)

end

function spawn_enemies()
   return {
      enemy_bike(0.2, 0.06, 0.07, racer_images[1], 0.06),
      enemy_bike(0.5, 0.06, 0.07, racer_images[2], 0.06),
      enemy_bike(0.8, 0.06, 0.07, racer_images[3], 0.06)
   }
end