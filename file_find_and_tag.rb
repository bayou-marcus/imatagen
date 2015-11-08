# Reads a directory for specified image types, and adds a single specified Finder tag to them per coded scope.
# Requires:
#   Dimensions Gem: https://github.com/sstephenson/dimensions
#   Tags utility: https://github.com/jdberry/tag/

require 'dimensions'

def get_files(root_folder, image_file_types)
  results = []
  image_file_types.each do |t|
    matches = Dir.glob(File.join(root_folder, "*#{t}"))
    matches.each do |m|
      results << {
        :base_name => File.basename(m),
        :width => Dimensions.width(m),
        :height => Dimensions.height(m),
        :file => m
      }
    end
  end
  puts "> Searching #{root_folder} for #{image_file_types.join(', ')}...\n> Matched #{results.size} files..."
  results
end

def tag_results(results)
  results = results.each do |r|
    label = ''

    case
    when r[:width].between?(0,500)
      label = '0-500'
    when r[:width].between?(501,1000)
      label = '501-1000'
    when r[:width].between?(1001,1500)
      label = '1001-1500'
    when r[:width].between?(1501,2000)
      label = '1501-2000'
    when r[:width].between?(2001,2500)
      label = '2001-2500'
    when r[:width].between?(2501,2800)
      label = '2501-2800'
    when r[:width].between?(2801,3200)
      label = '2801-3200'
    when r[:width].between?(3201,3400)
      label = '3201-3400'
    when r[:width].between?(3401,3600)
      label = '3401-3600'
    when r[:width].between?(3601,3800)
      label = '3601-3800'
    when r[:width].between?(3801,4000)
      label = '3801-4000'
    when r[:width].between?(4001,4200)
      label = '4001-4200'
    when r[:width] > 4201
      label = '4201-N'
    end

    system("tag -a \"Width: #{label}\" \"#{r[:file]}\"")
  end
  puts "> Tagged #{results.size} files..."
  results
end

def print_results(results)
  puts "> Tagging complete.\n"
end

# Configure parameters here
results = get_files( '/Users/jwagener/Pictures/', %w(.jpg .jpeg .png) )
results = tag_results(results)
print_results(results)
