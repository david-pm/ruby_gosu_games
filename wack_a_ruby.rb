require "gosu"

class WackARuby < Gosu::Window

  def initialize(width, height)
    super(width, height)
    self.caption = "Wack A Ruby!"

    @ruby  = Gosu::Image.new("ruby.png")
    @dude  = Gosu::Image.new("dude.png")
    @font  = Gosu::Font.new(60)

    @x_offset, @y_offset     = 150, 150
    @width, @height          = 150, 150
    @velocity_x, @velocity_y = 4, 4
    @visible, @hit, @score   = 0, 0, 0
  end

  # draw and update run in a loop

  def draw
    if @visible > 0
      @ruby.draw(@x_offset - @width / 2, @y_offset - @height / 2, 1)
    end
    @dude.draw(mouse_x - 75, mouse_y - 75, 1)

    hitter
    @font.draw(@score.to_s, 700, 20, 2)
  end

  def update
    @x_offset += @velocity_x
    @y_offset += @velocity_y

    @velocity_x *= -1 if @x_offset + (@width / 4) > 800  || 
                         @x_offset - (@width / 4) < 0
    @velocity_y *= -1 if @y_offset + (@height / 4) > 600 || 
                         @y_offset - (@height / 4) < 0
    @visible -= 1
    @visible = 30 if @visible < -10 && rand < 0.1
  end

  def hitter
    if @hit == 0
      c = Gosu::Color::YELLOW
    elsif @hit == 1
      c = Gosu::Color::RED
    elsif @hit == -1
      c = Gosu::Color::WHITE
    end

    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
  end

  def button_down(id)
    if (id == Gosu::MsLeft)
      if check_distance_and_visibility
        @hit = 1
        @score += 10
      else
        @hit = -1
        @score -= 1
      end
    end
  end

  def check_distance_and_visibility
    (Gosu.distance(mouse_x, mouse_y, @x_offset, @y_offset) < 50 && @visible >= 0)
  end
end


window = WackARuby.new(800, 600)
window.show
