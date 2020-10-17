# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'SOKOL-M' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

	pod 'Hero'
	pod 'SteviaLayout'
	pod "ESTabBarController-swift"
	pod "RAMAnimatedTabBarController"
	pod 'lottie-ios'
	pod 'FSCalendar'
	pod 'HorizonCalendar'
	pod 'BottomPopup'
	pod 'NVActivityIndicatorView'
	pod 'RealmSwift'
	pod 'MXSegmentedControl'
	pod 'UIDrawer', :git => 'https://github.com/Que20/UIDrawer.git', :tag => '1.0'
	pod 'AdvancedPageControl'
	pod 'Charts'
	pod 'FittedSheets'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
    end
  end
end


