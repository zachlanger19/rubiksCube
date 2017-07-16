#!/usr/bin/env ruby

#white = ['a','b','c','d','e','f','g','h','i']
white = ['w', 'w', 'w', 'w', 'w', 'w', 'w', 'w', 'w']
blue = ['b', 'b', 'b', 'b', 'b', 'b', 'b', 'b', 'b']
red = ['r', 'r', 'r', 'r', 'r', 'r', 'r', 'r', 'r']
green = ['g', 'g', 'g', 'g', 'g', 'g', 'g', 'g', 'g']
orange = ['o', 'o', 'o', 'o', 'o', 'o', 'o', 'o', 'o']
yellow = ['y', 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y']

# white = ['w','o','y','g','w','b','b','y','w']
# blue = ['g','g','o','y','b','r','o','w','r']
# red = ['b','o','r','b','r','o','b','w','o']
# green = ['w','r','g','b','g','y','b','o','r']
# orange = ['y','r','y','b','o','r','w','w','g']
# yellow = ['r','g','g','w','y','g','o','y','y']

# white = gets.chomp.split("")
# blue = gets.chomp.split("")
# red = gets.chomp.split("")
# green = gets.chomp.split("")
# orange = gets.chomp.split("")
# yellow = gets.chomp.split("")


rubiks_cube = {'w' => white,
               'b' => blue,
               'r' => red,
               'g' => green,
               'o' => orange,
               'y' => yellow}

class Solver
  def initialize(rubiks_cube)
    @cube = rubiks_cube
    @edges = [1, 5, 7, 3]
    @corners = [0, 2, 8, 6]
    @instructions = []
    @step = 0
    @steps = ['Solve white & blue edge',
              'Solving white & red edge',
              'Solving white & green edge',
              'Solving white & orange edge',
              'Solving white & blue & red corner',
              'Solving white & red & green corner',
              'Solving white & green & orange corner',
              'Solving white & orange & blue corner',
              'Solving blue & red edge',
              'Solving red & green edge',
              'Solving green & orange edge',
              'Solving orange & blue edge',
              'Orientating yellow',
              'Permutating yellow cross',
              'Permutating yellow corners']
  end

  def show
    @cube.each do |face|
      counter = 0
      @cube[face.first].each do |value|
        print value
        counter += 1
        if counter == 3
          puts
          counter = 0
        end
      end
      puts
    end
  end

  def instructions
    return @instructions
  end

  def direction(piece_location)
    if piece_location == 0
      return ['left', 'up']
    elsif piece_location == 1
      return 'up'
    elsif piece_location == 2
      return ['up', 'right']
    elsif piece_location == 3
      return 'left'
    elsif piece_location == 5
      return 'right'
    elsif piece_location == 6
      return ['down', 'left']
    elsif piece_location == 7
      return 'down'
    elsif piece_location == 8
      return ['right', 'down']
    end
  end

  def adjacent_face(face_color, direction)
    if face_color == 'w'
      if direction == 'up'
        return {'b' => [6, 7, 8]}
      elsif direction == 'right'
        return {'r' => [6, 7, 8]}
      elsif direction == 'down'
        return {'g' => [6, 7, 8]}
      elsif direction == 'left'
        return {'o' => [6, 7, 8]}
      end
    elsif face_color == 'b'
      if direction == 'up'
        return {'y' => [6, 7, 8]}
      elsif direction == 'right'
        return {'r' => [0, 3, 6]}
      elsif direction == 'down'
        return {'w' => [2, 1, 0]}
      elsif direction == 'left'
        return {'o' => [8, 5, 2]}
      end
    elsif face_color == 'r'
      if direction == 'up'
        return {'y' => [8, 5, 2]}
      elsif direction == 'right'
        return {'g' => [0, 3, 6]}
      elsif direction == 'down'
        return {'w' => [8, 5, 2]}
      elsif direction == 'left'
        return {'b' => [8, 5, 2]}
      end
    elsif face_color == 'g'
      if direction == 'up'
        return {'y' => [2, 1, 0]}
      elsif direction == 'right'
        return {'o' => [0, 3, 6]}
      elsif direction == 'down'
        return {'w' => [6, 7, 8]}
      elsif direction == 'left'
        return {'r' => [8, 5, 2]}
      end
    elsif face_color == 'o'
      if direction == 'up'
        return {'y' => [0, 3, 6]}
      elsif direction == 'right'
        return {'b' => [0, 3, 6]}
      elsif direction == 'down'
        return {'w' => [0, 3, 6]}
      elsif direction == 'left'
        return {'g' => [8, 5, 2]}
      end
    elsif face_color == 'y'
      if direction == 'up'
        return {'g' => [2, 1, 0]}
      elsif direction == 'right'
        return {'r' => [2, 1, 0]}
      elsif direction == 'down'
        return {'b' => [2, 1, 0]}
      elsif direction == 'left'
        return {'o' => [2, 1, 0]}
      end
    end
  end

  def rotate(face_color, inverted)
    if inverted
      corner_cycle = @corners.reverse
      edge_cycle = @edges.reverse
      direction_cycle = ['up', 'left', 'down', 'right']
    else
      corner_cycle = @corners
      edge_cycle = @edges
      direction_cycle = ['up', 'right', 'down', 'left']
    end


    initial_corner = @cube[face_color][corner_cycle[3]]
    @cube[face_color][corner_cycle[3]] = @cube[face_color][corner_cycle[2]]
    @cube[face_color][corner_cycle[2]] = @cube[face_color][corner_cycle[1]]
    @cube[face_color][corner_cycle[1]] = @cube[face_color][corner_cycle[0]]
    @cube[face_color][corner_cycle[0]] = initial_corner

    initial_edge = @cube[face_color][edge_cycle[3]]
    @cube[face_color][edge_cycle[3]] = @cube[face_color][edge_cycle[2]]
    @cube[face_color][edge_cycle[2]] = @cube[face_color][edge_cycle[1]]
    @cube[face_color][edge_cycle[1]] = @cube[face_color][edge_cycle[0]]
    @cube[face_color][edge_cycle[0]] = initial_edge

    initial_strip = []
    initial_strip[0] = @cube[adjacent_face(face_color, direction_cycle[3]).keys[0]][adjacent_face(face_color, direction_cycle[3]).values[0][0]]
    initial_strip[1] = @cube[adjacent_face(face_color, direction_cycle[3]).keys[0]][adjacent_face(face_color, direction_cycle[3]).values[0][1]]
    initial_strip[2] = @cube[adjacent_face(face_color, direction_cycle[3]).keys[0]][adjacent_face(face_color, direction_cycle[3]).values[0][2]]

    @cube[adjacent_face(face_color, direction_cycle[3]).keys[0]][adjacent_face(face_color, direction_cycle[3]).values[0][0]] = @cube[adjacent_face(face_color, direction_cycle[2]).keys[0]][adjacent_face(face_color, direction_cycle[2]).values[0][0]]
    @cube[adjacent_face(face_color, direction_cycle[3]).keys[0]][adjacent_face(face_color, direction_cycle[3]).values[0][1]] = @cube[adjacent_face(face_color, direction_cycle[2]).keys[0]][adjacent_face(face_color, direction_cycle[2]).values[0][1]]
    @cube[adjacent_face(face_color, direction_cycle[3]).keys[0]][adjacent_face(face_color, direction_cycle[3]).values[0][2]] = @cube[adjacent_face(face_color, direction_cycle[2]).keys[0]][adjacent_face(face_color, direction_cycle[2]).values[0][2]]

    @cube[adjacent_face(face_color, direction_cycle[2]).keys[0]][adjacent_face(face_color, direction_cycle[2]).values[0][0]] = @cube[adjacent_face(face_color, direction_cycle[1]).keys[0]][adjacent_face(face_color, direction_cycle[1]).values[0][0]]
    @cube[adjacent_face(face_color, direction_cycle[2]).keys[0]][adjacent_face(face_color, direction_cycle[2]).values[0][1]] = @cube[adjacent_face(face_color, direction_cycle[1]).keys[0]][adjacent_face(face_color, direction_cycle[1]).values[0][1]]
    @cube[adjacent_face(face_color, direction_cycle[2]).keys[0]][adjacent_face(face_color, direction_cycle[2]).values[0][2]] = @cube[adjacent_face(face_color, direction_cycle[1]).keys[0]][adjacent_face(face_color, direction_cycle[1]).values[0][2]]

    @cube[adjacent_face(face_color, direction_cycle[1]).keys[0]][adjacent_face(face_color, direction_cycle[1]).values[0][0]] = @cube[adjacent_face(face_color, direction_cycle[0]).keys[0]][adjacent_face(face_color, direction_cycle[0]).values[0][0]]
    @cube[adjacent_face(face_color, direction_cycle[1]).keys[0]][adjacent_face(face_color, direction_cycle[1]).values[0][1]] = @cube[adjacent_face(face_color, direction_cycle[0]).keys[0]][adjacent_face(face_color, direction_cycle[0]).values[0][1]]
    @cube[adjacent_face(face_color, direction_cycle[1]).keys[0]][adjacent_face(face_color, direction_cycle[1]).values[0][2]] = @cube[adjacent_face(face_color, direction_cycle[0]).keys[0]][adjacent_face(face_color, direction_cycle[0]).values[0][2]]

    @cube[adjacent_face(face_color, direction_cycle[0]).keys[0]][adjacent_face(face_color, direction_cycle[0]).values[0][0]] = initial_strip[0]
    @cube[adjacent_face(face_color, direction_cycle[0]).keys[0]][adjacent_face(face_color, direction_cycle[0]).values[0][1]] = initial_strip[1]
    @cube[adjacent_face(face_color, direction_cycle[0]).keys[0]][adjacent_face(face_color, direction_cycle[0]).values[0][2]] = initial_strip[2]

    @instructions.push([face_color, "inverted", inverted, @step])
    #puts "#{[face_color, "inverted", inverted, @step]}"
  end

  # Return the face and position of color_one
  def find_edge(color_one, color_two)
    piece_locations = []
    @cube.each do |face|
      if face[1][@edges[0]] == color_one
        piece_locations.push([face[0], @edges[0]])
      end
      if face[1][@edges[1]] == color_one
        piece_locations.push([face[0], @edges[1]])
      end
      if face[1][@edges[2]] == color_one
        piece_locations.push([face[0], @edges[2]])
      end
      if face[1][@edges[3]] == color_one
        piece_locations.push([face[0], @edges[3]])
      end
    end

    piece_locations.each do |piece|
      if @cube[adjacent_face(piece[0], direction(piece[1])).keys[0]][adjacent_face(piece[0], direction(piece[1])).values[0][1]] == color_two
        return piece
      end
    end
  end

  #returns face and position of color_one
  def find_corner(color_one, color_two, color_three)
    piece_locations = []
    @cube.each do |face|
      if face[1][@corners[0]] == color_one
        piece_locations.push([face[0], @corners[0]])
      end
      if face[1][@corners[1]] == color_one
        piece_locations.push([face[0], @corners[1]])
      end
      if face[1][@corners[2]] == color_one
        piece_locations.push([face[0], @corners[2]])
      end
      if face[1][@corners[3]] == color_one
        piece_locations.push([face[0], @corners[3]])
      end
    end

    colors_searched_for = [color_two, color_three]
    piece_locations.each do |piece|
      corner_color_two = @cube[adjacent_face(piece[0], direction(piece[1])[0]).keys[0]][adjacent_face(piece[0], direction(piece[1])[0]).values[0][2]]
      corner_color_three = @cube[adjacent_face(piece[0], direction(piece[1])[1]).keys[0]][adjacent_face(piece[0], direction(piece[1])[1]).values[0][0]]
      if (corner_color_two == color_two || corner_color_two == color_three) && (corner_color_three == color_two || corner_color_three == color_three)
        return piece
      end
    end
  end

  def orientate_white_edge_on_yellow(color_two)
    piece_location = find_edge('w', color_two)
    while (color_two != adjacent_face(piece_location[0], direction(piece_location[1])).keys[0])
      rotate('y', false)
      piece_location = find_edge('w', color_two)
    end
    piece_location = find_edge('w', color_two)
    2.times do
      rotate(adjacent_face(piece_location[0], direction(piece_location[1])).keys[0], false)
    end
  end

  def solve_white_edge(color_two)
    until find_edge('w', color_two)[0] == 'w' && find_edge(color_two, 'w')[0] == color_two
      piece_location = find_edge('w', color_two)
      if piece_location[0] == 'w'
        2.times do
          rotate(adjacent_face(piece_location[0], direction(piece_location[1])).keys[0], false)
        end
      end

      if piece_location[0] == 'b' || piece_location[0] == 'r' || piece_location[0] == 'g' || piece_location[0] == 'o'
        if find_edge('w', color_two)[1] == 1 || find_edge('w', color_two)[1] == 7
          rotate(find_edge('w', color_two)[0], inverted = false)
        end
        piece_location = find_edge('w', color_two)
        direction(piece_location[1]) == 'left' ? inverted = true : inverted = false
        rotating_face = adjacent_face(piece_location[0], direction(piece_location[1])).keys[0]
        rotate(rotating_face, inverted)
        rotate(face = 'y', false)
        rotate(rotating_face, !inverted)
      end

      orientate_white_edge_on_yellow(color_two)
    end
  end

  def corner_is_solved(color_one, color_two, color_three)
    if find_corner(color_one, color_two, color_three)[0] == color_one && find_corner(color_two, color_one, color_three)[0] == color_two && find_corner(color_three, color_two, color_one)[0] == color_three
      return true
    else
      return false
    end
  end

  def orientate_corner(face_color, inverted)
    if !inverted
      rotate(face_color, false)
      rotate('y', false)
      rotate(face_color, true)
      rotate('y', true)
    else
      rotate(face_color, true)
      rotate('y', true)
      rotate(face_color, false)
      rotate('y', false)
    end
  end

  def solve_white_corner(color_two, color_three)
    color_one = 'w'
    # while corner isn't in correct position
    if !corner_is_solved(color_one, color_two, color_three)
      # if corner is in first layer
      if find_corner(color_one, color_two, color_three)[0] == 'w' || find_corner(color_two, color_three, color_one)[0] == 'w' || find_corner(color_three, color_one, color_two)[0] == 'w'
        #face color to the right
        if find_corner(color_one, color_two, color_three)[0] == 'w'
          face_color = find_corner(color_three, color_two, color_one)[0]
        elsif find_corner(color_two, color_one, color_three)[0] == 'w'
          face_color = find_corner(color_one, color_two, color_three)[0]
        elsif find_corner(color_three, color_two, color_one)[0] == 'w'
          face_color = find_corner(color_two, color_one, color_three)[0]
        end
        orientate_corner(face_color, false)
      end

      faces = [find_corner(color_one, color_two, color_three)[0], find_corner(color_two, color_three, color_one)[0], find_corner(color_three, color_one, color_two)[0]]
      corner_colors = ['y', color_two, color_three]
      until faces.uniq.sort == corner_colors.uniq.sort
        rotate(face_color = 'y', inverted = false)
        faces = [find_corner(color_one, color_two, color_three)[0], find_corner(color_two, color_three, color_one)[0], find_corner(color_three, color_one, color_two)[0]]
      end

      until corner_is_solved(color_one, color_two, color_three)
        if find_corner(color_one, color_two, color_three)[0] == 'y'
          face_color = find_corner(color_two, color_one, color_three)[0]
          orientate_corner(face_color, false)
          orientate_corner(face_color, false)
        elsif find_corner(color_two, color_one, color_three)[0] == 'y'
          face_color = find_corner(color_one, color_two, color_three)[0]
          orientate_corner(face_color, true)
        elsif find_corner(color_three, color_two, color_one)[0] == 'y'
          face_color = find_corner(color_one, color_two, color_three)[0]
          orientate_corner(face_color, false)
        end
      end
    end
  end

  def edge_is_solved(color_one, color_two)
    if find_edge(color_one, color_two)[0] == color_one && find_edge(color_two, color_one)[0] == color_two
      return true
    else
      return false
    end
  end

  def orientate_edge(face_one, face_two, inverted)
    if inverted
      rotate('y', true)
      rotate(face_one, true)
      rotate('y', false)
      rotate(face_one, false)
      rotate('y', false)
      rotate(face_two, false)
      rotate('y', true)
      rotate(face_two, true)
    else
      rotate('y', false)
      rotate(face_two, false)
      rotate('y', true)
      rotate(face_two, true)
      rotate('y', true)
      rotate(face_one, true)
      rotate('y', false)
      rotate(face_one, false)
    end
  end

  def solve_colored_edge(color_one, color_two)
    if !edge_is_solved(color_one, color_two)
      if find_edge(color_one, color_two)[0] != 'y' && find_edge(color_two, color_one)[0] != 'y'
        if find_edge(color_one, color_two)[1] == 3
          face_one = find_edge(color_two, color_one)[0]
          face_two = find_edge(color_one, color_two)[0]
        else
          face_one = find_edge(color_one, color_two)[0]
          face_two = find_edge(color_two, color_one)[0]
        end
        orientate_edge(face_one, face_two, false)
      end
      if find_edge(color_one, color_two)[0] == 'y'
        face_color = color_two
      else
        face_color = color_one
      end
      until find_edge(color_one, color_two)[0] == face_color || find_edge(color_two, color_one)[0] == face_color
        rotate('y', false)
      end

      face_color == color_one ? inverted = false : inverted = true
      orientate_edge(color_one, color_two, inverted)
    end
  end

  def orientate_yellow
    until @cube['y'] == ['y', 'y', 'y', 'y', 'y', 'y', 'y', 'y', 'y']
      #Cross
      if @cube['y'][1] == 'y' && @cube['y'][3] == 'y' && @cube['y'][5] == 'y' && @cube['y'][7] == 'y'
        #Cross
        if @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] != 'y'
          if @cube['r'][0] == 'y' && @cube['r'][2] == 'y' && @cube['o'][0] == 'y' && @cube['o'][2] == 'y'
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', false)
            rotate('r', false)
            rotate('y', true)
            rotate('r', true)
            rotate('y', false)
            rotate('r', false)
            rotate('y', false)
            rotate('y', false)
            rotate('r', true)
          elsif @cube['r'][0] == 'y' && @cube['r'][2] == 'y' && @cube['b'][0] == 'y' && @cube['g'][2] == 'y'
            rotate('r', true)
            rotate('o', false)
            rotate('y', true)
            rotate('r', true)
            rotate('y', false)
            rotate('o', true)
            rotate('y', false)
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', false)
            rotate('r', false)
          end

          #Fish
        elsif @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] == 'y'
          if @cube['b'][0] == 'y'
            rotate('o', true)
            rotate('y', false)
            rotate('r', false)
            rotate('y', true)
            rotate('o', false)
            rotate('y', false)
            rotate('r', true)
          else
            rotate('r', true)
            rotate('y', false)
            rotate('y', false)
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', false)
            rotate('r', false)
          end

          #Hammer1
        elsif @cube['y'][0] == 'y' && @cube['y'][2] == 'y' && @cube['y'][6] != 'y' && @cube['y'][8] != 'y'
          if @cube['b'][0] == 'y' && @cube['b'][2] == 'y'
            rotate('r', false)
            rotate('r', false)
            rotate('w', false)
            rotate('r', true)
            rotate('y', false)
            rotate('y', false)
            rotate('r', false)
            rotate('w', true)
            rotate('r', true)
            rotate('y', false)
            rotate('y', false)
            rotate('r', true)
          end

          #Hammer2
        elsif @cube['y'][0] == 'y' && @cube['y'][2] != 'y' && @cube['y'][6] == 'y' && @cube['y'][8] != 'y'
          if @cube['b'][2] == 'y' && @cube['g'][0] == 'y'
            rotate('r', true)
            rotate('b', true)
            rotate('o', false)
            rotate('b', false)
            rotate('r', false)
            rotate('b', true)
            rotate('o', true)
            rotate('b', false)
          end

          #Diagonal
        elsif @cube['y'][0] == 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] == 'y'
          if @cube['g'][0] == 'y' && @cube['o'][2] == 'y'
            rotate('r', true)
            rotate('b', true)
            rotate('o', true)
            rotate('b', false)
            rotate('r', false)
            rotate('b', true)
            rotate('o', false)
            rotate('b', false)
          end
        end

        #Horizontal Line
      elsif @cube['y'][1] != 'y' && @cube['y'][3] == 'y' && @cube['y'][5] == 'y' && @cube['y'][7] != 'y'
        #Line
        if @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] != 'y'
          if @cube['b'][0..1] == ['y', 'y'] && @cube['r'][0] == 'y' && @cube['r'][2] == 'y' && @cube['g'][1..2] == ['y', 'y']
            rotate('b', false)
            rotate('y', false)
            rotate('r', false)
            rotate('y', true)
            rotate('r', true)
            rotate('y', false)
            rotate('r', false)
            rotate('y', true)
            rotate('r', true)
            rotate('b', true)
          elsif @cube['b'][1] == 'y' && @cube['r'][0] == 'y' && @cube['r'][2] == 'y' && @cube['g'][1] == 'y' && @cube['o'][0] = 'y' && @cube['o'][2] = 'y'
            rotate('o', true)
            rotate('g', true)
            rotate('o', false)
            rotate('y', true)
            rotate('r', true)
            rotate('y', false)
            rotate('r', false)
            rotate('y', true)
            rotate('r', true)
            rotate('y', false)
            rotate('r', false)
            rotate('o', true)
            rotate('g', false)
            rotate('o', false)
          end

          #C
        elsif @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] == 'y' && @cube['y'][8] == 'y'
          rotate('r', false)
          rotate('y', false)
          rotate('r', true)
          rotate('y', true)
          rotate('g', true)
          rotate('r', true)
          rotate('b', false)
          rotate('r', false)
          rotate('b', true)
          rotate('g', false)

          #L1 -> v
        elsif @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] == 'y'
          if @cube['b'][0..1] == ['y', 'y'] && @cube['g'][0..1] == ['y', 'y'] && @cube['o'][0] == 'y'
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('b', true)
            rotate('r', false)
            rotate('b', false)
            rotate('y', true)
            rotate('b', true)
          elsif @cube['b'][1] == 'y' && @cube['r'][2] == 'y'&& @cube['g'][1..2] == ['y', 'y'] && @cube['o'][2] == 'y'
            rotate('o', true)
            rotate('g', true)
            rotate('o', false)
            rotate('r', true)
            rotate('y', true)
            rotate('r', false)
            rotate('y', false)
            rotate('o', true)
            rotate('g', false)
            rotate('o', false)
          end

          #L2 v ->
        elsif @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] == 'y' && @cube['y'][8] != 'y'
          if @cube['b'][1..2] == 'y' && @cube['r'][2] == 'y' && @cube['g'][1..2] == ['y', 'y']
            rotate('o', false)
            rotate('b', true)
            rotate('o', true)
            rotate('y', true)
            rotate('o', false)
            rotate('b', false)
            rotate('o', true)
            rotate('b', true)
            rotate('y', false)
            rotate('b', false)
          elsif @cube['b'][1] == 'y' && @cube['r'][0] == 'y' && @cube['g'][0..1] == ['y', 'y'] && @cube['o'][0] == 'y'
            rotate('r', false)
            rotate('g', false)
            rotate('r', true)
            rotate('o', false)
            rotate('y', false)
            rotate('o', true)
            rotate('y', true)
            rotate('r', false)
            rotate('g', true)
            rotate('r', true)
          end

          #T
        elsif @cube['y'][0] != 'y' && @cube['y'][2] == 'y' && @cube['y'][6] != 'y' && @cube['y'][8] == 'y'
          if @cube['b'][0..1] == ['y', 'y'] && @cube['g'][1..2] == ['y', 'y']
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', true)
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('b', true)
          elsif @cube['b'][1] == 'y' && @cube['g'][1] == 'y' && @cube['o'][0] == 'y' && @cube['o'][2] == 'y'
            rotate('b', false)
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', true)
            rotate('b', true)
          end

          #Z1
        elsif @cube['y'][0] == 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] == 'y'
          if @cube['b'][1] == 'y' && @cube['g'][0..1] == ['y', 'y'] && @cube['o'][2] == 'y'
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', true)
            rotate('b', true)
            rotate('y', false)
            rotate('r', false)
          end

          #Z2
        elsif @cube['y'][0] != 'y' && @cube['y'][2] == 'y' && @cube['y'][6] == 'y' && @cube['y'][8] != 'y'
          if @cube['b'][1] == 'y' && @cube['r'][0] == 'y' && @cube['g'][1..2] == ['y', 'y']
            rotate('o', false)
            rotate('b', true)
            rotate('o', true)
            rotate('y', true)
            rotate('o', false)
            rotate('y', false)
            rotate('b', false)
            rotate('y', true)
            rotate('o', true)
          end

          #4 corner
        elsif @cube['y'][0] == 'y' && @cube['y'][2] == 'y' && @cube['y'][6] == 'y' && @cube['y'][8] == 'y'
          rotate('o', true)
          rotate('r', false)
          rotate('y', false)
          rotate('r', true)
          rotate('y', true)
          rotate('o', false)
          rotate('r', true)
          rotate('b', false)
          rotate('r', false)
          rotate('b', true)
        end

        #Vertical Line
      elsif @cube['y'][1] == 'y' && @cube['y'][3] != 'y' && @cube['y'][5] != 'y' && @cube['y'][7] == 'y'
        #Line
        if @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] != 'y'
          if @cube['b'][0] == 'y' && @cube['r'][0..2] == ['y', 'y', 'y'] && @cube['g'][2] == 'y' && @cube['o'][1] == 'y'
            rotate('r', true)
            rotate('y', true)
            rotate('b', true)
            rotate('y', false)
            rotate('b', true)
            rotate('o', false)
            rotate('b', false)
            rotate('o', true)
            rotate('b', false)
            rotate('r', false)
          elsif @cube['r'][0..2] == ['y', 'y', 'y'] && @cube['o'][0..2] == ['y', 'y', 'y']
            rotate('r', false)
            rotate('y', true)
            rotate('g', false)
            rotate('g', false)
            rotate('w', false)
            rotate('g', true)
            rotate('y', false)
            rotate('y', false)
            rotate('g', false)
            rotate('w', true)
            rotate('g', false)
            rotate('g', false)
            rotate('y', false)
            rotate('r', true)
          end

          #C
        elsif @cube['y'][0] == 'y' && @cube['y'][2] != 'y' && @cube['y'][6] == 'y' && @cube['y'][8] != 'y'
          rotate('r', false)
          rotate('y', false)
          rotate('r', false)
          rotate('g', true)
          rotate('r', true)
          rotate('g', false)
          rotate('y', true)
          rotate('r', true)
        end

        #L
      elsif @cube['y'][1] == 'y' && @cube['y'][3] == 'y' && @cube['y'][5] != 'y' && @cube['y'][7] != 'y'
        rotate('b', false)
        rotate('r', false)
        rotate('y', false)
        rotate('r', true)
        rotate('y', true)
        rotate('b', true)

        #Dot
      elsif @cube['y'][1] != 'y' && @cube['y'][3] != 'y' && @cube['y'][5] != 'y' && @cube['y'][7] != 'y'
        #Dot
        if @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] != 'y'
          if @cube['b'][1] == 'y' && @cube['r'][0..2] == ['y', 'y', 'y'] && @cube['g'][1] == 'y' && @cube['o'][0..2] == ['y', 'y', 'y']
            rotate('r', false)
            rotate('y', false)
            rotate('g', true)

            rotate('r', false)

            rotate('g', false)

            rotate('r', false)
            rotate('r', false)

            rotate('y', true)
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('b', true)
          elsif @cube['b'][0..2] == ['y', 'y', 'y'] && @cube['r'][1..2] == ['y', 'y'] && @cube['g'][1] == 'y' && @cube['o'][0..1] == ['y', 'y']
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('b', true)
            rotate('y', false)
            rotate('y', false)
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('b', false)
            rotate('b', false)
            rotate('y', false)
            rotate('y', false)
            rotate('b', false)
          end

          #Tick1
        elsif @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] == 'y'
          if @cube['b'][1] == 'y' && @cube['r'][1..2] == ['y', 'y'] && @cube['g'][1..2] == ['y', 'y'] && @cube['o'][1..2] == ['y', 'y']
            rotate('b', true)
            rotate('g', false)
            rotate('g', false)
            rotate('o', false)
            rotate('g', true)
            rotate('o', false)
            rotate('b', false)
            rotate('y', false)
            rotate('y', false)
            rotate('b', true)
            rotate('o', false)
            rotate('b', false)
            rotate('g', true)
          end

          #Tick2
        elsif @cube['y'][0] != 'y' && @cube['y'][2] == 'y' && @cube['y'][6] != 'y' && @cube['y'][8] != 'y'
          if @cube['b'][0..1] == ['y', 'y'] && @cube['r'][0..1] == ['y', 'y'] && @cube['g'][1] == 'y' && @cube['o'][0..1] == ['y', 'y']
            rotate('r', true)
            rotate('y', false)
            rotate('y', false)
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('b', true)
            rotate('y', true)
            rotate('b', true)
            rotate('y', true)
            rotate('b', false)
            rotate('y', true)
            rotate('r', false)
          end

          #Diagonal
        elsif @cube['y'][0] == 'y' && @cube['y'][2] != 'y' && @cube['y'][6] != 'y' && @cube['y'][8] == 'y'
          if @cube['b'][1] == 'y' && @cube['r'][1] == 'y' && @cube['g'][0..1] == ['y', 'y'] && @cube['o'][1..2] == ['y', 'y']
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', false)
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('b', true)
            rotate('y', false)
            rotate('y', false)
            rotate('r', true)
            rotate('b', false)
            rotate('r', false)
            rotate('b', true)
          end

          #Tri1
        elsif @cube['y'][0] == 'y' && @cube['y'][2] == 'y' && @cube['y'][6] != 'y' && @cube['y'][8] != 'y'
          if @cube['b'][1] == 'y' && @cube['r'][0..1] == ['y', 'y'] && @cube['g'][1] == 'y' && @cube['o'][1..2] == ['y', 'y']
            rotate('r', true)
            rotate('y', false)
            rotate('y', false)
            rotate('b', false)
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', true)
            rotate('b', false)
            rotate('b', false)
            rotate('y', false)
            rotate('y', false)
            rotate('b', false)
            rotate('r', false)
          end

          #Tri2
        elsif @cube['y'][0] != 'y' && @cube['y'][2] != 'y' && @cube['y'][6] == 'y' && @cube['y'][8] == 'y'
          if @cube['b'][1] == 'y' && @cube['r'][1] == 'y' && @cube['g'][0..2] == ['y', 'y', 'y'] && @cube['o'][1] == 'y'
            rotate('b', false)
            rotate('r', false)
            rotate('y', false)
            rotate('r', true)
            rotate('y', false)
            rotate('b', true)
            rotate('y', false)
            rotate('y', false)
            rotate('b', true)
            rotate('o', false)
            rotate('b', false)
            rotate('o', true)
          end

          #checkerd board
        elsif @cube['y'][0] == 'y' && @cube['y'][2] == 'y' && @cube['y'][6] == 'y' && @cube['y'][8] == 'y'
          rotate('r', true)
          rotate('o', false)
          rotate('b', false)
          rotate('b', false)
          rotate('r', false)
          rotate('o', true)
          rotate('y', false)
          rotate('y', false)
          rotate('r', true)
          rotate('o', false)
          rotate('b', false)
          rotate('r', false)
          rotate('o', true)
          rotate('y', false)
          rotate('y', false)
          rotate('r', true)
          rotate('o', false)
          rotate('b', false)
          rotate('b', false)
          rotate('r', false)
          rotate('o', true)
        end

      else
        rotate('y', false)
      end
    end
  end

  def permutate_yellow_edges
    until @cube['g'][1] == 'g'
      rotate('y', false)
    end

    if @cube['b'][1] == 'r' && @cube['o'][1] == 'o'
      rotate('r', false)
      rotate('y', false)
      rotate('r', true)
      rotate('b', true)
      rotate('r', false)
      rotate('y', false)
      rotate('r', true)
      rotate('y', true)
      rotate('r', true)
      rotate('b', false)
      rotate('r', false)
      rotate('r', false)
      rotate('y', true)
      rotate('r', true)
      rotate('y', true)
    elsif @cube['b'][1] == 'o' && @cube['r'][1] == 'r'
      rotate('o', true)
      rotate('y', true)
      rotate('o', false)
      rotate('b', false)

      rotate('o', true)
      rotate('y', true)
      rotate('o', false)
      rotate('y', false)

      rotate('o', false)
      rotate('b', true)

      rotate('o', false)
      rotate('o', false)
      rotate('y', false)

      rotate('o', false)
      rotate('y', false)
    elsif @cube['b'][1] == 'b' && @cube['r'][1] == 'o'
      rotate('b', true)
      rotate('y', true)
      rotate('o', true)

      rotate('b', false)
      rotate('y', false)
      rotate('b', true)
      rotate('y', true)

      rotate('b', true)
      rotate('o', false)
      rotate('b', false)
      rotate('b', false)
      rotate('y', true)

      rotate('b', true)
      rotate('y', true)
      rotate('b', false)
      rotate('y', false)

      rotate('b', true)
      rotate('y', false)
      rotate('b', false)
    elsif @cube['b'][1] == 'r' && @cube['r'][1] == 'o' && @cube['o'][1] == 'b'
      rotate('b', false)
      rotate('b', false)
      rotate('y', true)
      rotate('r', true)
      rotate('o', false)
      rotate('b', false)
      rotate('b', false)
      rotate('r', false)
      rotate('o', true)
      rotate('y', true)
      rotate('b', false)
      rotate('b', false)
    elsif @cube['b'][1] == 'o' && @cube['r'][1] == 'b' && @cube['o'][1] == 'r'
      rotate('b', false)
      rotate('b', false)
      rotate('y', false)
      rotate('r', true)
      rotate('o', false)
      rotate('b', false)
      rotate('b', false)
      rotate('r', false)
      rotate('o', true)
      rotate('y', false)
      rotate('b', false)
      rotate('b', false)
    end
  end

  def permutate_yellow_corners_algorithm
    rotate('r', true)
    rotate('b', false)
    rotate('r', true)
    rotate('g', false)
    rotate('g', false)
    rotate('r', false)
    rotate('b', true)
    rotate('r', true)
    rotate('g', false)
    rotate('g', false)
    rotate('r', false)
    rotate('r', false)
  end

  def permutate_yellow_corners
    if @cube['b'][0] != @cube['b'][1] && @cube['b'][1] != @cube['b'][2]
      if @cube['r'][0] != @cube['r'][1] && @cube['r'][1] != @cube['r'][2]
        if @cube['g'][0] != @cube['g'][1] && @cube['g'][1] != @cube['g'][2]
          if @cube['o'][0] != @cube['o'][1] && @cube['o'][1] != @cube['o'][2]
            permutate_yellow_corners_algorithm
          end
        end
      end
    end

    2.times do
      4.times do
        if @cube['b'][0] == @cube['b'][1] && @cube['b'][1] != @cube['b'][2]
          permutate_yellow_corners_algorithm
        end
        rotate('y', false)
      end
    end
  end

  def refine_instructions
    counter = 0
    while counter < @instructions.length
      if @instructions[counter] == @instructions[counter + 1] && @instructions[counter] == @instructions[counter + 2] && @instructions[counter] == @instructions[counter + 3]
        @instructions.delete_at(counter)
        @instructions.delete_at(counter)
        @instructions.delete_at(counter)
        @instructions.delete_at(counter)
      elsif @instructions[counter] == @instructions[counter + 1] && @instructions[counter] == @instructions[counter + 2]
        @instructions[counter][2] = !@instructions[counter][2]
        @instructions.delete_at(counter + 1)
        @instructions.delete_at(counter + 1)
      elsif @instructions[counter][0] == @instructions[counter - 1][0] && @instructions[counter][2] != @instructions[counter - 1][2]
        @instructions.delete_at(counter - 1)
        @instructions.delete_at(counter - 1)
      else
        counter += 1
      end
    end
  end

  def return_instructions
    puts @steps[0]
    step = 0
    counter = 0
    @instructions.each do |instruction|
      if step != instruction[3]
        step = instruction[3]
        puts
        puts @steps[step]
        counter = 0
      end
      print instruction[0]
      if instruction[2] == true
        print "'"
      else
        print " "
      end
      print "  "
      counter += 1
      if counter == 4
        puts
        counter = 0
      end
    end
  end

  def solve
    solve_white_edge(color_two = 'b')
    @step = 1
    puts "step #{@step}"
    solve_white_edge(color_two = 'r')
    @step = 2
    puts "step #{@step}"
    solve_white_edge(color_two = 'g')
    @step = 3
    puts "step #{@step}"
    solve_white_edge(color_two = 'o')
    @step = 4
    puts "step #{@step}"
    solve_white_corner(color_two = 'b', color_three = 'r')
    @step = 5
    puts "step #{@step}"
    solve_white_corner(color_two = 'r', color_three = 'g')
    @step = 6
    puts "step #{@step}"
    solve_white_corner(color_two = 'g', color_three = 'o')
    @step = 7
    puts "step #{@step}"
    solve_white_corner(color_two = 'o', color_three = 'b')
    @step = 8
    puts "step #{@step}"
    solve_colored_edge(color_one = 'b', color_two = 'r')
    @step = 9
    puts "step #{@step}"
    solve_colored_edge(color_one = 'r', color_two = 'g')
    @step = 10
    puts "step #{@step}"
    solve_colored_edge(color_one = 'g', color_two = 'o')
    @step = 11
    puts "step #{@step}"
    solve_colored_edge(color_one = 'o', color_two = 'b')
    @step = 12
    puts "step #{@step}"
    orientate_yellow
    @step = 13
    puts "step #{@step}"
    permutate_yellow_edges
    @step = 14
    puts "step #{@step}"
    permutate_yellow_corners
    @step = 15
    puts "step #{@step}"

    refine_instructions
    show
    return_instructions
  end
end

cube = Solver.new(rubiks_cube)
cube.rotate('w', false)
cube.solve

puts







