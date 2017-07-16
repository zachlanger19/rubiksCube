#!/usr/bin/env ruby

#white = ['w','w','w','w','w','w','w','w','w']
#blue = ['b','b','b','b','b','b','b','b','b']
#red = ['r','r','r','r','r','r','r','r','r']
#green = ['g','g','g','g','g','g','g','g','g']
#orange = ['o','o','o','o','o','o','o','o','o']
#yellow = ['y','y','y','y','y','y','y','y','y']

white = ['w', 'w', 'w', 'w', 'w', 'w', 'w', 'w', 'w']
blue = ['y', 'y', 'b', 'b', 'b', 'b', 'b', 'b', 'b']
red = ['y', 'y', 'r', 'r', 'r', 'r', 'r', 'r', 'r']
green = ['g', 'y', 'g', 'g', 'g', 'g', 'g', 'g', 'g']
orange = ['y', 'y', 'o', 'o', 'o', 'o', 'o', 'o', 'o']
yellow = ['w', 'w', 'y', 'w', 'y', 'w', 'w', 'w', 'w']

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
              'Orientating yellow cross',
              'Orientating yellow corners',
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
    # puts "#{face_color}, inverted = #{inverted}"
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
          if @cube['b'][0..1] == ['y', 'y'] && @cube['r'][0] = 'y' && @cube['r'][2] = 'y' && @cube['g'][1..2] == ['y', 'y']
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
          elsif @cube['b'][1] == 'y' && @cube['r'][0] = 'y' && @cube['r'][2] = 'y' && @cube['g'][1] == 'y' && @cube['o'][0] = 'y' && @cube['o'][2] = 'y'
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
        rotate('r', false)
        rotate('y', false)
        rotate('b', false)

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

          #U
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
    orientate_yellow
    show
    return_instructions
  end
end

cube = Solver.new(rubiks_cube)
cube.solve


puts