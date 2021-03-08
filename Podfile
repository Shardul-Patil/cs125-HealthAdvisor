# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NutrioUs' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NutrioUs
pod 'Firebase/Core'
pod 'Firebase/Database'
pod 'Firebase/Crashlytics'
pod 'Firebase/Auth'
pod 'Firebase/Firestore'
pod 'FirebaseFirestoreSwift'


  target 'NutrioUsTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'NutrioUsUITests' do
    # Pods for testing
  end

end

post_install do |pi|
   pi.pods_project.targets.each do |t|
       t.build_configurations.each do |bc|
           if bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] == '8.0'
             bc.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '9.0'
           end
       end
   end
end
