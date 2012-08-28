# Program takes file_name.asm from the command line, generates Hack machine code
# and writes it into file_name.hack. It doesn't check for errors (it was one
# of the simplifications in this project).
# Usage: ruby assembler.rb file.asm

%w{parser symbol_table code}.each { |f| require f }

parser = Parser.new(ARGV[0])
output_file_path = ARGV[0].gsub('.asm', '.hack')
File.open(output_file_path, 'w') { |f| f.write(parser.get_machine_code) }
puts output_file_path + " generated."
