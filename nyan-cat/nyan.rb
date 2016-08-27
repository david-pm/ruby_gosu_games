#!/usr/bin/env ruby

require "gosu"

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

    @cat = NyanCat.new(self)
  end

  def draw
    @cat.draw
  end

  def update
    @cat.move_up   if button_down? Gosu::KbUp
    @cat.move_down if button_down? Gosu::KbDown
  end

end


class NyanCat
  def initialize(window)
    # load the image and split it up into six sprites
    # for animation, specifying its width and height
    # and declaring it non-tileable
    @sprites = Gosu::Image::load_tiles(window,
                                       "images/cat.png",
                                       847/6, 87, false)

    # set initial coordinates, extract widht and height
    @x = 10
    @y = 200
    @width = @sprites.first.width
    @height = @sprites.first.height
  end

  def draw
    sprite = @sprites[Gosu::milliseconds / 75 % @sprites.size]
    sprite.draw(@x, @y, 1)
  end

  # each time the Window calls update and the key is being pressed
  # the cat’s y coordinate will go up or down by 5, so that the next
  # time the window is drawn the cat will appear to have moved 5 pixels
  def move_up
    @y = @y - 5
  end

  def move_down
    @y = @y + 5
  end 
end


Window.new(width: 900, height: 550, full: false).show

