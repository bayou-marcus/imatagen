Gem::Specification.new do |s|
  s.name        = 'imatagen'
  s.version     = '1.0'
  s.date        = '2016-04-20'
  s.summary     = 'Imatagen adds pixel-width Finder tags to your images on OS X.'
  s.description = 'An OS X-only, command-line utility which inspects a directory for specified image types and adds Finder tags which describe their width dimension (ex: "Width: 1501-2000").'
  s.authors     = ['Joel Wagener']
  s.email       = 'bayou.marcus@gmail.com'
  s.executables = ['imatagen']
  s.files       = FileList['**/**/*']
  s.homepage    = 'https://github.com/bayou-marcus/imatagen'
  s.license     = 'The MIT License.' # http://choosealicense.com
  s.required_ruby_version = '>= 2.0.0'
  s.platform = Gem::Platform.local # Ie: require OS X (http://guides.rubygems.org/specification-reference/ ?)
end
