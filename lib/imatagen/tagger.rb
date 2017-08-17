require 'shellwords'

class Tagger

  @tag_bin = File.join(File.dirname(__FILE__), '..', '..', 'bin', 'tag') # https://github.com/jdberry/tag/

  def self.tags(file)
    tags_via_tag(file)
  end
    def self.tags_via_tag(file)
      result = `tag -N #{Shellwords.escape(file)}`.chomp("\n").split(',') # FIXME Add error logging
    end

  def self.tag(file, tags) # Accepts multiple tags
    tag_via_tag(file, tags)
  end
    def self.tag_via_tag(file, tags)
      tags = Array.new.push(tags) unless tags.kind_of?(Array)
      result = system("#{@tag_bin} --add \"#{tags.join(',').to_s}\" #{Shellwords.escape(file)} >> #{IMATAGEN_LOG} 2>&1") # 'system' returns true or false
      result
    end

  def self.untag(file)
    untag_via_tag(file)
  end
    def self.untag_via_tag(file)
      system("#{@tag_bin} --remove '\*' #{Shellwords.escape(file)} >> #{IMATAGEN_LOG} 2>&1")
    end

end
