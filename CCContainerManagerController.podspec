Pod::Spec.new do |s|
  s.name         = "CCContainerManagerController"
  s.version      = "1.0"
  s.summary      = "Simple container for viewController."
  s.homepage     = "https://github.com/Fourni-j/CCContainerManagerController"

  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Charles-Adrien Fournier" => "charladfr@me.com" }
  s.source       = { 
  :git => "https://github.com/Fourni-j/CCContainerManagerController.git",
  }

  s.platform     = :ios, '7.0'
  s.source_files = 'Classes/**/*.{h,m}'
  s.requires_arc = true

  s.dependency "Masonry", "~> 0.6.1"
end
