# Symbol table for Hack assembler.

class SymbolTable

  def initialize
    # load defaults
    @table = {
      'SP' => 0,
      'LCL' => 1,
      'ARG' => 2,
      'THIS' => 3,
      'THAT' => 4,
      'SCREEN' => 16384,
      'KBD' => 24576
    }
    0.upto(15) {|i| @table["R#{i}"] = i}
    @next_free_memory = 16
  end

  # add symbol at the given address in ROM memory
  def add_rom_entry(symbol, address)
    @table[symbol] = address
  end

  # add symbol at the next free space in RAM
  def add_ram_entry(symbol)
    @table[symbol] = @next_free_memory
    @next_free_memory += 1
  end

  def contains?(symbol)
    @table.include?(symbol)
  end

  def get_address(symbol)
    @table[symbol]
  end
end

