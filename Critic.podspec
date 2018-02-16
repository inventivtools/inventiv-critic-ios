#
# Be sure to run `pod lib lint Critic.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Critic'
  s.version          = '0.0.1'
  s.summary          = 'iOS Library for accepting actionable customer feedback via Inventiv Critic.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
iOS Library for accepting actionable customer feedback via Inventiv Critic. You can read more about Critic here: https://inventiv.io/critic/
                       DESC

  s.homepage         = 'https://github.com/inventiv-llc/inventiv-critic-ios'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Dave Lane' => 'dave.lane@inventiv.io' }
  s.source           = { :git => 'https://github.com/inventiv-llc/inventiv-critic-ios.git', :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/inventiv_llc'

  s.ios.deployment_target = '9.0'

  s.source_files = 'Critic/Classes/**/*'
  
  # s.resource_bundles = {
  #   'Critic' => ['Critic/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
