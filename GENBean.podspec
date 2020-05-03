
Pod::Spec.new do |spec|
  
  spec.name         = "GENBean"
  spec.version      = "0.0.1"
  spec.summary      = "A Lib For Bean."
  spec.description  = <<-DESC
  GENBean是所有模型的封装
  DESC
  
  spec.homepage     = "https://github.com/StoneStoneStoneWang/GENKit.git"
  spec.license      = { :type => "MIT", :file => "LICENSE.md" }
  spec.author             = { "StoneStoneStoneWang" => "yuanxingfu1314@163.com" }
  spec.platform     = :ios, "10.0"
  spec.ios.deployment_target = "10.0"
  
  spec.swift_version = '5.0'
  
  spec.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  
  spec.static_framework = true
  
  spec.frameworks = 'UIKit', 'Foundation'
  
  spec.source = { :git => "https://github.com/StoneStoneStoneWang/GENKit.git", :tag => "#{spec.version}" }
  
  spec.dependency 'ObjectMapper'
  
  spec.subspec 'Gender' do |gender|
    gender.source_files = "Code/GENBean/Gender/*.{swift}"
  end
  
  spec.subspec 'Account' do |account|
    account.source_files = "Code/GENBean/Account/*.{swift}"
  end
  
  spec.subspec 'User' do |user|
    user.source_files = "Code/GENBean/User/*.{swift}"
    user.dependency 'GENBean/Gender'
  end
  spec.subspec 'Black' do |black|
    black.source_files = "Code/GENBean/Black/*.{swift}"
    black.dependency 'GENBean/User'
    black.dependency 'RxDataSources'
  end
  spec.subspec 'Focus' do |focus|
    focus.source_files = "Code/GENBean/Focus/*.{swift}"
    focus.dependency 'GENBean/User'
    focus.dependency 'RxDataSources'
  end
  
  spec.subspec 'KeyValue' do |keyValue|
    keyValue.source_files = "Code/GENBean/KeyValue/*.{swift}"
    keyValue.dependency 'RxDataSources'
  end
  
  spec.subspec 'Circle' do |circle|
    circle.source_files = "Code/GENBean/Circle/*.{swift}"
    circle.dependency 'GENBean/KeyValue'
    circle.dependency 'GENBean/User'
    circle.dependency 'WLToolsKit/JsonCast'
  end
  
  spec.subspec 'Comment' do |comment|
    comment.source_files = "Code/GENBean/Comment/*.{swift}"
    comment.dependency 'GENBean/User'
    comment.dependency 'RxDataSources'
  end
  
  spec.subspec 'Area' do |area|
    area.source_files = "Code/GENBean/Area/*.{swift}"
    area.dependency 'RxDataSources'
  end
  
  spec.subspec 'Address' do |address|
    address.source_files = "Code/GENBean/Address/*.{swift}"
    address.dependency 'RxDataSources'
  end
  spec.subspec 'Message' do |message|
     message.source_files = "Code/GENBean/Message/*.{swift}"
     message.dependency 'RxDataSources'
   end
  
end
