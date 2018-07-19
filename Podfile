# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'Referrals' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Referrals
  pod 'GoogleSignIn'
  pod 'Alamofire', '~> 4.7'
  pod 'AlamofireImage', '~> 3.3'
  pod 'PromiseKit', '~> 6.0'
  pod 'ObjectMapper', '~> 3.2'
  pod 'FacebookShare'
  pod 'SVProgressHUD'
  pod 'NotificationBannerSwift'
  pod 'Fabric'
  pod 'Crashlytics'
end

post_install do |installer_representation|
    installer_representation.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['GCC_PREPROCESSOR_DEFINITIONS'] = '$(inherited), PodsDummy_Pods=SomeOtherNamePodsDummy_Pods'
        end
    end
end
