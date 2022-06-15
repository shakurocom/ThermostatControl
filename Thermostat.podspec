 1234#
#
#

Pod::Spec.new do |s|
    s.name             = 'Thermostat'
    s.version          = '1.0.0'
    s.summary          = 'UI component for iOS'
    s.homepage         = 'https://github.com/shakurocom/ThermostatControl'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.authors          = {'Vlad Onipchenko' => 'vonipchenko@shakuro.com'}
    s.source           = { :git => 'https://github.com/shakurocom/ThermostatControl.git', :tag => s.version }
    s.source_files     = 'Thermostat/UI/**/*'
    s.resource_bundles = {
    'Assets' => ['Thermostat/Resources/ThermostatAssets.*/**/*'],
    'Xib' => ['Thermostat/Resources/UI/ThermostatViewController.xib']
    }

    s.swift_version    = '5.0'
    s.ios.deployment_target = '13.0'
    s.dependency 'Shakuro.CommonTypes', '1.1.0'

end
