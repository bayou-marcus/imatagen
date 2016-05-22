require 'benchmark'
require_relative 'imatagen/patches'
require_relative 'imatagen/trollop'
require_relative 'imatagen/sizer'
require_relative 'imatagen/tagger'
require_relative 'imatagen/bucketeer'

# Create data structure (index) containing matching files
def build_index_for(directory, formats)
  raise "> Exiting, #{directory} not found" unless File.directory?(directory)
  print "> Inspecting #{directory} for #{formats.join(', ')} "

  index = []
  formats.each do |t|
    if @opts[:recurse]
      matches = Dir.glob(File.join(directory, "**", "*#{t}")) # http://stackoverflow.com/questions/11798994/ruby-iterate-thought-all-rb-including-subfolders-files-in-the-folder
    else
      matches = Dir.glob(File.join(directory, "*#{t}"))
    end

    matches.each do |m|
      xy = Sizer.size(m)
      index << {
        :file => m,
        :width => xy[0],
        :height => xy[1]
      }
      print '.'
    end
  end
  puts "\n" if !@opts[:verbose]

  raise '> Exiting, no matches found' if index.empty?
  puts "\n> Index contains #{index.size} files" if @opts[:verbose]
  index.sort_by!{|file| file[:file]}
end

# Add tags to files in index
def tag_files(index)
  print '> Tagging files '

  buckets = Bucketeer.create_buckets() # Initialize buckets with defaults
  buckets_counts = buckets.map{|b| [b, 0]}.to_h # to_h requires Ruby 2.x

  successes, failures = 0, 0

  index.each do |f|
    bucket = Bucketeer.get_bucket_for(f[:width])
    label = "Width #{bucket.min}-#{bucket.max}"

    if @opts[:dryrun]
      result = FileTest.writable?(f[:file]) ? true : false # Note benchmarking showed that per file, this dryrun test is nearly 8k times faster than actually tagging with the tag binary
    else
      result = Tagger.tag(f[:file], label)
    end

    if result == true
      buckets_counts[bucket] += 1
      successes += 1
      print '+'
    else
      failures += 1
      print '-'
    end
  end

  {:successes => successes, :failures => failures, :buckets_counts => buckets_counts.reject{|k, v| v == 0}}
end

def untag_files(index)
  print '> Untagging files '

  successes, failures = 0, 0

  index.each do |f|
    if @opts[:dryrun]
      result = FileTest.writable?(f[:file]) ? true : false
    else
      result = Tagger.untag(f[:file])
    end

    if result == true
      successes += 1
      print '+'
    else
      failures += 1
      print '-'
    end
  end

  {:successes => successes, :failures => failures}
end

# Report results
def print_results(result=nil)
  puts "\n> Success #{result[:successes]}, Failure #{result[:failures]}"
  puts("> Buckets results #{result[:buckets_counts].to_neat_s}") if @opts[:verbose] && !@opts[:untag]
  puts('> Exiting dry run') if @opts[:dryrun]
end

# Herr Director!
@opts = Trollop::options do
  banner "Usage: imatagen [options]\nOptions:\n"
  version 'Imatagen v1.0.0'

  opt :directory, 'Search directory', :default => File.join(Dir.home, 'Pictures')
  opt :recurse, 'Recurse directory during search'
  opt :formats, 'Formats', :default => %w(.jpg .jpeg .png)
  opt :tag, 'Add width tags', :default => true
  opt :untag, 'Remove all tags'
  opt :verbose, 'Use verbose mode'
  opt :dryrun, 'No alterations, verbose output'
  opt :log, 'Show last session\'s log'
end

time = Benchmark.measure do
  IMATAGEN_LOG = File.join(Dir.home, '.imatagen_log')

  # Go!
  begin
    if @opts[:log]
      log = File.open(IMATAGEN_LOG, 'r').read
      puts "> Last log (#{IMATAGEN_LOG}), #{log.lines.count} lines"
      log.lines.each_with_index{|l, i| puts " #{(i+1).to_s.rjust(4)}: #{l}"}
      exit

    elsif @opts[:untag] or @opts[:tag]
      File.truncate(IMATAGEN_LOG, 0)

      @opts[:verbose] = true if @opts[:dryrun]
      puts('> Beginning dry run (no alterations)') if @opts[:dryrun]
      puts("> Options #{@opts.reject{|k,v| k =~ /given|help|log|^tag|version/}.to_neat_s}") if @opts[:verbose]

      index = build_index_for(@opts[:directory], @opts[:formats])

      if @opts[:untag]
        puts('> Beginning untag mode') if @opts[:verbose]
        tagging_results = untag_files(index)
      else
        puts('> Beginning tag mode') if @opts[:verbose]
        tagging_results = tag_files(index)
      end

      print_results(tagging_results)
    end
  rescue RuntimeError => e # Catch all raised errors
    puts e.message
  end
end

puts("> Time #{time.real}") if @opts[:verbose]
