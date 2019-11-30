#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'image_cropper'
  s.version          = '0.0.2'
  s.summary          = 'A Flutter plugin supports cropping images'
  s.description      = <<-DESC
A Flutter plugin supports cropping images
                       DESC
  s.homepage         = 'https://github.com/hnvn/flutter_image_cropper'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'HungHD' => 'hunghd.yb@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  s.dependency 'TOCropViewController', '~> 2.5.2'
  
  s.ios.deployment_target = '8.0'
end

