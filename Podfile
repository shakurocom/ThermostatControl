platform :ios, '13.0'
use_frameworks!

#ToolboxCommit = 'b3053718eb54fb8e5f39d5a1b54f8b0f82577f44'

target 'Thermostat' do

  pod 'R.swift', '5.2.2'
  pod 'lottie-ios', '2.5.2'
  pod 'Shakuro.CommonTypes'

end

# Post Install "error: IB Designables: Failed to render and update auto layout ..." fix
post_install do |installer|
    installer.pods_project.build_configurations.each do |config|
        config.build_settings.delete('CODE_SIGNING_ALLOWED')
        config.build_settings.delete('CODE_SIGNING_REQUIRED')
    end
    installer.pods_project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'
      end
    end

end
