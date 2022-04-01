#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'image_cropper'
  s.version          = '0.0.4'
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
  s.dependency 'TOCropViewController', '~> 2.6.1'
  
  s.ios.deployment_target = '9.0'
end

