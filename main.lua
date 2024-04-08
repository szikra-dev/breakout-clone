require 'src.Dependencies'

function love.load()
    -- filter
    love.graphics.setDefaultFilter('nearest', 'nearest')

    -- seed 
    math.randomseed(os.time())

    -- app bar title
    love.window.setTitle('Breakout')

    -- load gFonts
    gFonts = {
        ['small'] = love.graphics.newFont('fonts/font.ttf', 8),
        ['medium'] = love.graphics.newFont('fonts/font.ttf', 16),
        ['large'] = love.graphics.newFont('fonts/font.ttf', 32)
     }
    love.graphics.setFont(gFonts['small'])

    -- load graphics
    gTextures = {
        ['background'] = love.graphics.newImage('graphics/background.png'),
        ['main'] = love.graphics.newImage('graphics/breakout.png'),
        ['arrows'] = love.graphics.newImage('graphics/arrows.png'),
        ['hearts'] = love.graphics.newImage('graphics/hearts.png'),
        ['particle'] = love.graphics.newImage('graphics/particle.png')
     }

    -- init our VRes 
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
     })

    -- load sounds
    gSounds = {
        ['paddle-hit'] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ['score'] = love.audio.newSource('sounds/score.wav', 'static'),
        ['wall-hit'] = love.audio.newSource('sounds/wall_hit.wav', 'static'),
        ['confirm'] = love.audio.newSource('sounds/confirm.wav', 'static'),
        ['select'] = love.audio.newSource('sounds/select.wav', 'static'),
        ['no-select'] = love.audio.newSource('sounds/no-select.wav', 'static'),
        ['brick-hit-1'] = love.audio.newSource('sounds/brick-hit-1.wav', 'static'),
        ['brick-hit-2'] = love.audio.newSource('sounds/brick-hit-2.wav', 'static'),
        ['hurt'] = love.audio.newSource('sounds/hurt.wav', 'static'),
        ['victory'] = love.audio.newSource('sounds/victory.wav', 'static'),
        ['recover'] = love.audio.newSource('sounds/recover.wav', 'static'),
        ['high-score'] = love.audio.newSource('sounds/high_score.wav', 'static'),
        ['pause'] = love.audio.newSource('sounds/pause.wav', 'static'),

        ['music'] = love.audio.newSource('sounds/music.wav', 'static')
     }

    -- init the state machine
    -- our current game state can be any of the following:
    -- 1. 'start' (the beginning of the game, where we're told to press Enter)
    -- 2. 'paddle-select' (where we get to choose the color of our paddle)
    -- 3. 'serve' (waiting on a key press to serve the ball)
    -- 4. 'play' (the ball is in play, bouncing between paddles)
    -- 5. 'victory' (the current level is over, with a victory jingle)
    -- 6. 'game-over' (the player has lost; display score and allow restart)
    gStateMachine = StateMachine {
        ['start'] = function() return StartState() end
     }
    gStateMachine:change('start')

    -- init our keys table
    love.keyboard.keysPressed = {}
end

function love.resize(w, h) push:resize(w, h) end

function love.update(dt)
    gStateMachine:update(dt)
    -- reset the keys table
    love.keyboard.keysPressed = {}
end

function love.keypressed(key) love.keyboard.keysPressed[key] = true end

function love.keyboard.wasPressed(key) return love.keyboard.keysPressed[key] end

function love.draw()
    -- begin drwaing
    push:start()

    local backgroundWidth = gTextures['background']:getWidth()
    local backgroundHeight = gTextures['background']:getHeight()

    love.graphics.draw(gTextures['background'], -- draw at coordinates 0, 0
    0, 0, -- no rotation
    0, -- scale factors on X and Y axis so it fills the screen
    VIRTUAL_WIDTH / (backgroundWidth - 1), VIRTUAL_HEIGHT / (backgroundHeight - 1))

    gStateMachine:render()

    dispayFPS()

    push:finish()
end

function dispayFPS()
    love.graphics.setFont(gFonts['small'])
    love.graphics.setColor(0, 1, 0, 1)
    love.graphics.print('FPS: ' .. tostring(love.timer.getFPS()), 5, 5)
end
