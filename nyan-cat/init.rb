#!/usr/bin/env ruby

APP_ROOT = File.dirname(__FILE__)
$:.unshift( File.join(APP_ROOT, 'lib') ) 

require "gosu"
require "nyan"
require "sweet"
require "background"

# Gosu provides a Window class
# The Window constructor takes:
# width, height, fullscreen arguments

# the Window class calls two methods on itself:
# draw and update - which create a loop
# use those methods to add the logic for your game

class Window < Gosu::Window
  def initialize(width:, height:, full: false)
    super(width, height, full)
    self.caption = "Nyan Cat!"

    @song = Gosu::Song.new(self, "sounds/nyan.wav")
    @background = Background.new(self)
    @sweet = Sweet.new(self)
    @cat = NyanCat.new(self)
    @score = 0
    @font = Gosu::Font.new(64)
    @playing = false
    @start_time = 0
  end

  def draw
    @background.draw
    @cat.draw
    @sweet.draw
    @font.draw("points: #{@score}", 0, 0, 1)
    @font.draw("time: #{@time_left}", 680, 0, 1)
    @font.draw("Hit SPACEBAR to Play", 175, 300, 1) unless @playing
  end

  def update
    @cat.move_up   if button_down? Gosu::KbUp
    @cat.move_down if button_down? Gosu::KbDown
    @background.scroll

    if @playing
      @time_left = (20 - ((Gosu.milliseconds - @start_time) / 1000))
      if @time_left < 0
        @sweet.x = 0
        @playing = false
        @song.stop
      end

      @sweet.move
      # reset if cat gets it or if it leaves screen
      @sweet.reset(self) if @sweet.x < 0
      if @cat.bumped_into? @sweet
        @score += 1
        @sweet.reset(self)
      end
    end
  end

  def button_down(id)
    # start or reset
    if (id == Gosu::KbSpace)
      @score = 0
      @song.play
      @start_time = Gosu.milliseconds
      @playing = true
    end
  end
end

Window.new(width: 895, height: 550, full: false).show
