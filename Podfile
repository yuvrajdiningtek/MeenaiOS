# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TiffinApp' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TiffinApp


pod 'SkyFloatingLabelTextField', '~> 3.0'

pod 'IQKeyboardManagerSwift','~> 6.0.4'
pod 'SRCountdownTimer'
pod 'SideMenuController'
pod 'HTHorizontalSelectionList', '~> 0.7.4'
pod 'CountryPickerSwift'

# pods for Alomfire
pod 'Alamofire'

#pods for city
pod 'GooglePlaces'

pod 'FSCalendar'
pod 'SplunkMint'

#pod 'GoogleSignIn'

pod 'SCLAlertView', :git => 'https://github.com/vikmeup/SCLAlertView-Swift.git'
pod 'RealmSwift', '~> 3.19.0'

pod 'NVActivityIndicatorView'
pod 'SDWebImage', '~> 4.0'
pod 'DropDown'
#pod 'iOSDropDown'
pod 'Instabug'

#pods for netwok check
pod 'ReachabilitySwift'

#pods for payment
pod 'Stripe', '~> 14.0.0'

#pods for cardview
pod 'CreditCardForm'
#pod 'MGCollapsingHeader'
#pod 'FSPagerView'

pod 'FSPagerView'
pod 'Hero'
pod 'SwiftMessages'


pod 'Fabric'
pod 'Crashlytics'
pod 'Firebase/Analytics'
pod 'Firebase/Auth'
pod 'Firebase/Messaging'
pod 'Firebase/Firestore'
pod 'Firebase/Crashlytics'

post_install do |installer|

    installer.generated_projects.each do |project|

          project.targets.each do |target|

              target.build_configurations.each do |config|

                  config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '13.0'

               end

          end

   end

end


end
