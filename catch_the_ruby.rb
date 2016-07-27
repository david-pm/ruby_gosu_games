require "gosu"

class WackARuby < Gosu::Window

  def initialize(width, height)
    super(width, height)
    self.caption = "Catch 'em all!"

    @ruby  = Gosu::Image.new("ruby.png")
    @dude  = Gosu::Image.new("dude.png")
    @font  = Gosu::Font.new(60)

    @x_offset = @y_offset = @width = @height = 150
    @velocity_x = @velocity_y                = 4
    @visible = @hit = @score                 = 0
    @playing = true
    @start_time = 0
  end

  # draw and update run in a loop

  def draw
    if @visible > 0
      @ruby.draw(@x_offset - @width / 2, @y_offset - @height / 2, 1)
    end
    @dude.draw(mouse_x - 75, mouse_y - 75, 1)

    hitter
    @font.draw("time: #{@time_left.to_s}", 20, 15, 2)
    @font.draw("score: #{@score.to_s}", 560, 15, 2)
    game_over unless @playing
  end

  def update
    if @playing
      @x_offset += @velocity_x
      @y_offset += @velocity_y

      @time_left = (10 - ((Gosu.milliseconds - @start_time) / 1000))
      @playing = false if @time_left < 0

      @velocity_x *= -1 if @x_offset + (@width / 4) > 800  ||
                           @x_offset - (@width / 4) < 0
      @velocity_y *= -1 if @y_offset + (@height / 4) > 600 ||
                           @y_offset - (@height / 4) < 0
      @visible -= 1
      @visible = 30 if @visible < -10 && rand < 0.1
    end
  end

  def hitter
    if @hit == 0
      c = Gosu::Color::FUCHSIA
    elsif @hit == 1
      c = Gosu::Color::RED
    elsif @hit == -1
      c = Gosu::Color::WHITE
    end

    # left_offset, top_offset and a color * 4
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)
    @hit = 0
  end

  def button_down(id)
    if @playing
      hit_or_miss if (id == Gosu::MsLeft)
    else
      reset if (id == Gosu::KbSpace)
    end
  end

  def hit_or_miss
    if check_distance_and_visibility
      @hit = 1
      @score += 10
    else
      @hit = -1
      @score -= 1
    end
  end

  def game_over
    c = Gosu::Color::BLUE
    draw_quad(0, 0, c, 800, 0, c, 800, 600, c, 0, 600, c)

    @font.draw('Game 0ver', 300, 300, 3)
    @font.draw('Press Space Bar to Play Again', 50, 350, 3)
    @visible = 20
  end

  def reset
    @playing = true
    @visible = -10
    @start_time = Gosu.milliseconds
    @score = 0
  end

  def check_distance_and_visibility
    (Gosu.distance(mouse_x, mouse_y, @x_offset, @y_offset) < 50 && 
     @visible >= 0)
  end
end


window = WackARuby.new(800, 600)
window.show
