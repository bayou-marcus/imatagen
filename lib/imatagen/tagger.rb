require 'shellwords'

class Tagger
  def self.tag(file, tags) # Accepts multiple tags
    tag_via_xattr(file, tags)
  end

    def self.tag_via_xattr(file, tags)
      tags = Array.new.push(tags) unless tags.kind_of?(Array)

      batch_result = true
      tags.each do |t|
        result = system("xattr -w com.apple.metadata:_kMDItemUserTags '(\"#{t}\")' #{Shellwords.escape(file)} >> #{IMATAGEN_LOG} 2>&1")
        if result == true
          batch_result = true
        else
          batch_result = false
        end
      end
      batch_result
    end

  def self.untag(file)
    untag_via_xattr(file)
  end

    # Removes all tags
    def self.untag_via_xattr(file)
      system("xattr -d com.apple.metadata:_kMDItemUserTags #{Shellwords.escape(file)} >> #{IMATAGEN_LOG} 2>&1") # NOTE this returns false with no tags applied, and is logged: "xattr: /Users/jwagener/Desktop/yo/5921.jpg: No such xattr: com.apple.metadata:_kMDItemUserTags"
    end
end
