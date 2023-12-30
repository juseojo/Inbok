target 'Inbok' do
  use_frameworks!

  pod 'SnapKit'
  pod 'KakaoSDKUser'
  pod 'KakaoSDKAuth'
  pod 'KakaoSDKTalk'
  pod 'Alamofire'
  pod 'RMQClient'
  pod 'RealmSwift'
  target 'InbokTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'InbokUITests' do
    # Pods for testing
  end

end

post_install do |installer|
    installer.generated_projects.each do |project|
        project.targets.each do |target|
            target.build_configurations.each do |config|
                config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
            end
        end
    end
end
