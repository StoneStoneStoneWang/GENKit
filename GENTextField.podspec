Pod::Spec.new do |spec|
  
  spec.name         = "GENTextField"
  spec.version      = "0.0.1"
  spec.summary      = "A Lib For textfield."
  spec.description  = <<-DESC
  GENTextField是地图
  DESC
  
  spec.homepage     = "https://github.com/StoneStoneStoneWang/ZStoreKit.git"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.author             = { "StoneStoneStoneWang" => "yuanxingfu1314@163.com" }
  spec.platform     = :ios, "10.0"
  spec.ios.deployment_target = "10.0"
  
  spec.swift_version = '5.0'
  
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  
  spec.static_framework = true
  
  spec.frameworks = 'UIKit', 'Foundation'
  
  spec.source = { :git => "https://github.com/StoneStoneStoneWang/ZStoreKit.git", :tag => "#{spec.version}" }
  
  spec.subspec 'Setting' do |setting|
    setting.source_files = "Code/GENTextField/Setting/*.{swift}"
  end
  spec.subspec 'Base' do |base|
    base.source_files = "Code/GENTextField/Base/*.{swift}"
    base.dependency 'WLToolsKit/Then'
    base.dependency 'GENTextField/Setting'
  end
  
  spec.subspec 'LeftTitle' do |leftTitle|
    leftTitle.source_files = "Code/GENTextField/LeftTitle/*.{swift}"
    leftTitle.dependency 'GENTextField/Base'
    leftTitle.dependency 'WLToolsKit/Color'
  end
  spec.subspec 'LeftImage' do |leftImage|
    leftImage.source_files = "Code/GENTextField/LeftImg/*.{swift}"
    leftImage.dependency 'GENTextField/Base'
  end
  spec.subspec 'NickName' do |nickName|
    nickName.source_files = "Code/GENTextField/NickName/*.{swift}"
    nickName.dependency 'GENTextField/Base'
  end
  
  spec.subspec 'Password' do |password|
    password.source_files = "Code/GENTextField/Password/*.{swift}"
    password.dependency 'GENTextField/LeftImage'
    password.dependency 'GENTextField/LeftTitle'
  end
  
  spec.subspec 'Vcode' do |vcode|
    vcode.source_files = "Code/GENTextField/Vcode/*.{swift}"
    vcode.dependency 'GENTextField/LeftImage'
    vcode.dependency 'GENTextField/LeftTitle'
  end
  
end
