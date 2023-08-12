# frozen_string_literal: true

class ListPeopleCommand < Dry::CLI::Command
  extend Dry::Initializer

  option :options, default: -> { { headers: true, col_sep: "\t", liberal_parsing: true, header_converters: :symbol } }
  option :people, default: -> { CSV.parse(File.read('test.tab'), **options) }

  desc 'List of people'
  def call
    puts people.to_a.to_table
  end
end

class Array
  def to_table(header: true)
    column_sizes = self.reduce([]) do |lengths, row|
      row.each_with_index.map{|iterand, index| [lengths[index] || 0, iterand.to_s.length].max}
    end
    head = '+' + column_sizes.map{|column_size| '-' * (column_size + 2) }.join('+') + '+'
    puts head

    to_print = self.clone
    if (header == true)
      header = to_print.shift
      print_table_data_row(column_sizes, header)
      puts head
    end
    to_print.each{ |row| print_table_data_row(column_sizes, row) }
    puts head
  end

  private
  def print_table_data_row(column_sizes, row)
    row = row.fill(nil, row.size..(column_sizes.size - 1))
    row = row.each_with_index.map{|v, i| v = v.to_s + ' ' * (column_sizes[i] - v.to_s.length)}
    puts '| ' + row.join(' | ') + ' |'
  end
end
