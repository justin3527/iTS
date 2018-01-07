# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

def shared_pods
	pod 'Charts'
end


target 'iTS' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!
  
  shared_pods
  pod 'BATabBarController'
  pod 'CircleMenu', '~> 2.0.1'
  pod 'CSV.swift', '~>2.0'
  
  # Pods for iTS

  target 'iTSTests' do
    inherit! :search_paths
   # Pods for testing
  end

  target 'iTSUITests' do
    inherit! :search_paths
    # Pods for testing
  end

target 'Resource Widget' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  #shared_pods

inherit! :search_paths
  # Pods for Resource Widget

end

end

