#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'image_cropper'
  s.version          = '0.0.1'
  s.summary          = 'A Flutter plugin supports cropping images'
  s.description      = <<-DESC
A Flutter plugin supports cropping images
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'TOCropViewController', '~> 2.3.6'
  s.static_framework = true
  
  s.ios.deployment_target = '8.0'
end

