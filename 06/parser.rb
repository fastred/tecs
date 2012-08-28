# This class parses assembler file (according to
# {Hack assembler specification}[http://www1.idc.ac.il/tecs/book/chapter%2006.pdf]
# and generates machine code.

class Parser

  def initialize(file_path)
    @file = File.new(file_path, 'r')
    @line_number = 0
    @st = SymbolTable.new
    ObjectSpace.define_finalizer(self, proc { @file.close })
    first_pass
  end

  def has_more_commands?
    not @file.eof?
  end

  # Advance one line in input file.
  def advance
    # Remove white spaces and comments
    @command = @file.readline.strip.gsub(' ', '').gsub(/(\/\/.*)/, '')
    if command_type == :A_COMMAND || command_type == :C_COMMAND
      @line_number += 1
    end
  end

  # Match for A-instruction, e.g. @15
  def a_command_match
    /^@([a-zA-Z0-9_\.\$]+)/.match(@command)
  end

  # Match for label. e.g. (JUMP_HERE)
  def l_command_match
    /\(([a-zA-Z0-9_\.\$]+)\)/.match(@command)
  end

  # Match for C-instruction, e.g. D=D+A
  def c_command_match
    /(([A-Z]{1,3})=)?([a-zA-Z0-9\+\-\\!\\&\\|]+)(;)?([A-Z]{3})?/.
    #/(([A-Z]{1,3})=)?([a-zA-Z0-9\\+\\-\\!\\&\\|]+)(;)?([A-Z]{3})?/.
      match(@command)
  end

  # Returns current command type
  def command_type
    if @command.length == 0
      :NOTHING
    elsif a_command_match
      :A_COMMAND
    elsif l_command_match
      :L_COMMAND
    else
      :C_COMMAND
    end
  end

  # Returns the symbol or decimal value of current command
  def symbol
    if command_type == :A_COMMAND
      symbol = a_command_match.captures.first
      decimal_value = if symbol == symbol.to_i.to_s
        symbol
      elsif @st.contains?(symbol)
        @st.get_address(symbol)
      else
        @st.add_ram_entry(symbol)
        @st.get_address(symbol)
      end
      Code.convert_to_binary(decimal_value)
    elsif command_type == :L_COMMAND
      l_command_match.captures.first
    end
  end

  def dest
    raise 'Can\'t be called for non C_COMMAND' if command_type != :C_COMMAND
    Code.dest(c_command_match.captures[0])
  end

  def comp
    raise 'Can\'t be called for non C_COMMAND' if command_type != :C_COMMAND
    Code.comp(c_command_match.captures[2])
  end

  def jump
    raise 'Can\'t be called for non C_COMMAND' if command_type != :C_COMMAND
    Code.jump(c_command_match.captures[4])
  end

  # First pass builds symbol table for labels.
  def first_pass
    while has_more_commands?
      advance
      if command_type == :L_COMMAND
        @st.add_rom_entry(symbol, @line_number)
      end
    end
    @file.rewind
    @line_number = 0
  end

  # Generate machine code for the whole file
  def get_machine_code
    all = []
    while has_more_commands?
      advance
      if command_type == :C_COMMAND
        all << '111' + comp + dest + jump
      elsif command_type == :A_COMMAND
        all << symbol
      end
    end
    return all.join("\n") + "\n"
  end
end

