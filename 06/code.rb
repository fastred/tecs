# This class generates binary representation of parts of the
# C-instruction (according to Hack assembler specification).

class Code

  @@comp_translation = {
    '0'  => '0101010',
    '1'  => '0111111',
    '-1' => '0111010',
    'D'  => '0001100',
    'A'  => '0110000',
    '!D' => '0001101',
    '!A' => '0110001',
    '-D' => '0001111',
    '-A' => '0110011',
    'D+1'=> '0011111',
    'A+1'=> '0110111',
    'D-1'=> '0001110',
    'A-1'=> '0110010',
    'D+A'=> '0000010',
    'D-A'=> '0010011',
    'A-D'=> '0000111',
    'D&A'=> '0000000',
    'D|A'=> '0010101',
    'M'  => '1110000',
    '!M' => '1110001',
    '-M' => '1110011',
    'M+1'=> '1110111',
    'M-1'=> '1110010',
    'D+M'=> '1000010',
    'D-M'=> '1010011',
    'M-D'=> '1000111',
    'D&M'=> '1000000',
    'D|M'=> '1010101'
  }

  @@jump_translation = {
    'JGT' => '001',
    'JEQ' => '010',
    'JGE' => '011',
    'JLT' => '100',
    'JNE' => '101',
    'JLE' => '110',
    'JMP' => '111'
  }

  # Returns binary representation of destination
  def self.dest(mnemonic)
    if mnemonic
      result = ''
      result << (mnemonic.include?('A') ? '1' : '0')
      result << (mnemonic.include?('D') ? '1' : '0')
      result << (mnemonic.include?('M') ? '1' : '0')
      result
    else
      '000'
    end
  end

  # Returns binary representation of computation
  def self.comp(mnemonic)
    @@comp_translation[mnemonic] || '0000000'
  end

  # Returns binary representation of jump part
  def self.jump(mnemonic)
    @@jump_translation[mnemonic] || '000'
  end

  # Convert decimal number to 16-bit binary
  def self.convert_to_binary(decimal)
    decimal.to_i.to_s(2).rjust(16).gsub(' ', '0')
  end
end

