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
# subclass those methods to add the logic for your game

class Window < Gosu::Window
  def initialize(width:, height:, full: false)
    super(width, height, full)
    self.caption = "Nyan Cat!"
    Gosu::Song.new(self, "sounds/nyan.wav").play

    @background = Background.new(self)
    @sweet = Sweet.new(self)
    @cat = NyanCat.new(self)
    @score = 0
    @score_text = Gosu::Font.new(70)
  end

  def draw
    @background.draw
    @cat.draw
    @sweet.draw
    @score_text.draw("#{@score}", 0, 0, 1)
  end

  def update
    @cat.move_up   if button_down? Gosu::KbUp
    @cat.move_down if button_down? Gosu::KbDown
    @sweet.move

    # reset if cat gets it or if it leaves screen
    @sweet.reset(self) if @sweet.x < 0
    if @cat.bumped_into? @sweet
      @score += 1
      @sweet.reset(self)
    end
    # @background.scroll
  end

end

Window.new(width: 895, height: 550, full: false).show
