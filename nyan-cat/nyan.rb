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
    Gosu::Song.new(self, "sounds/nyan.wav").play

    @background = Background.new(self)
    @sweet = Sweet.new(self)
    @cat = NyanCat.new(self)
    @score = 0
    @score_text = Gosu::Font.new(72)
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
    @background.scroll
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

  def bumped_into?(object)
    # calculate the values for the top, bottom, left, right edges 
    # of both the cat and the object it bumps into
    self_top = @y
    self_bottom = @y + @height
    self_left = @x
    self_right = @x + @width

    object_top = object.y
    object_bottom = object.y + object.height
    object_left = object.x
    object_right = object.x + object.width

    # figure out if objects collide
    if self_top > object_bottom
      false
    elsif self_bottom < object_top
      false
    elsif self_left > object_right
      false
    elsif self_right < object_left
      false
    else
      true
    end
  end
end

class Sweet
  attr_accessor :x, :y, :width, :height

  def initialize(window)
    @sprite = Gosu::Image.new(window, 'images/candy.png')
    @width = @sprite.width
    @height = @sprite.height
    reset(window)
  end

  def draw
    @sprite.draw(@x, @y, 1)
  end

  # resetting the sweet will move it to the right hand side of the screen 
  # the right hand side is the width. the maximum value x can take
  def reset(window)
    @y = Random.rand(window.height - @height)
    @x = window.width
  end

  def move
    @x = @x - 15
  end

end

class Background
  def initialize(window)
    @first_image = Gosu::Image.new(window, "images/background.jpg")
    @width = @first_image.width
    @second_image = Gosu::Image.new(window, "images/background.jpg")

    @first_x = 0
    @second_x = @first_x + @width
    @scroll_speed = 2
  end

  def draw
    @first_image.draw(@first_x, 0, 0)
    @second_image.draw(@second_x, 0, 0)
  end

  def scroll
    @first_x = @first_x - @scroll_speed
    @second_x = @second_x - @scroll_speed
    if (@first_x < -@width)
      @first_x = @width
      @second_x = 0
    elsif (@second_x < -@width)
      @second_x = @width
      @first_x = 0
    end
  end
end

Window.new(width: 900, height: 550, full: false).show
