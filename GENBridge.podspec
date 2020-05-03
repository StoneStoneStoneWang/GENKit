Pod::Spec.new do |spec|
  
  spec.name         = "GENBridge"
  spec.version      = "0.0.1"
  spec.summary      = "A Lib For bridge."
  spec.description  = <<-DESC
  GENBridge是oc swift 转换的封装呢
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
  
  spec.subspec 'Base' do |base|
    base.source_files = "Code/GENBridge/Base/*.{swift}"
    base.dependency 'RxSwift'
  end
  
  #欢迎界面
  spec.subspec 'Welcome' do |welcome|
    
    welcome.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Welcome/VM/*.{swift}"
      vm.dependency 'WLToolsKit/Common'
      vm.dependency 'GENViewModel'
      vm.dependency 'RxCocoa'
      vm.dependency 'RxSwift'
    end
    
    welcome.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Welcome/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Welcome/VM'
      bridge.dependency 'GENCollection'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'GENCocoa/Button'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 协议
  spec.subspec 'Protocol' do |protocol|
    
    protocol.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Protocol/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'RxSwift'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENSign'
    end
    
    protocol.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Protocol/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Protocol/VM'
      bridge.dependency 'GENInner'
      bridge.dependency 'GENBridge/Base'
    end
  end
  # 协议
  spec.subspec 'Privacy' do |privacy|
    
    privacy.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Privacy/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'RxSwift'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENSign'
    end
    
    privacy.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Privacy/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Privacy/VM'
      bridge.dependency 'GENInner'
      bridge.dependency 'GENBridge/Base'
      
    end
  end
  
  
  
  # 登陆
  spec.subspec 'Login' do |login|
    
    login.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Login/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENCheck'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENObservableMapper'
      vm.dependency 'GENError'
    end
    
    login.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Login/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Login/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENBase'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 注册/登陆
  spec.subspec 'SwiftLogin' do |swiftLogin|
    
    swiftLogin.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/SwiftLogin/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENCheck'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENObservableMapper'
      vm.dependency 'GENError'
    end
    
    swiftLogin.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/SwiftLogin/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/SwiftLogin/VM'
      bridge.dependency 'GENCocoa/Button'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENBase'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 密码
  spec.subspec 'Password' do |password|
    
    password.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Password/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENCheck'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENObservableMapper'
      vm.dependency 'GENError'
    end
    
    password.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Password/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Password/VM'
      bridge.dependency 'GENCocoa/Button'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENBase'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 设置
  spec.subspec 'Setting' do |setting|
    
    setting.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Setting/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENCache/Account'
      vm.dependency 'GENSign'
    end
    
    setting.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Setting/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Setting/VM'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'RxDataSources'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 关于我们
  spec.subspec 'About' do |about|
    
    about.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/About/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'WLToolsKit/String'
    end
    
    about.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/About/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/About/VM'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 昵称
  spec.subspec 'Name' do |name|
    
    name.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/Name/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENCache/User'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENResult'
      vm.dependency 'GENObservableMapper'
      vm.dependency 'GENError'
    end
    
    name.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Name/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Name/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENBase'
      bridge.dependency 'GENBridge/Base'
    end
  end
  # 个性签名
  spec.subspec 'Signature' do |signature|
    
    signature.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Signature/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENCache/User'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENResult'
      vm.dependency 'GENObservableMapper'
      vm.dependency 'GENError'
    end
    
    signature.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Signature/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Signature/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENBase'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 我的资料
  spec.subspec 'UserInfo' do |userinfo|
    
    userinfo.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/UserInfo/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENResult'
      vm.dependency 'GENCache/User'
      vm.dependency 'GENApi'
      vm.dependency 'GENRReq'
      vm.dependency 'GENObservableMapper'
      vm.dependency 'GENError'
    end
    
    userinfo.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/UserInfo/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/UserInfo/VM'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'RxDataSources'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 轮播
  spec.subspec 'Carousel' do |welcome|
    
    welcome.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Carousel/VM/*.{swift}"
      vm.dependency 'WLToolsKit/Common'
      vm.dependency 'GENViewModel'
      vm.dependency 'RxCocoa'
      vm.dependency 'RxSwift'
      vm.dependency 'ObjectMapper'
    end
    
    welcome.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Carousel/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Carousel/VM'
      bridge.dependency 'GENCollection'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'RxDataSources'
    end
  end
  
  # 举报
  spec.subspec 'Report' do |report|
    
    report.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/Report/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'ObjectMapper'
      vm.dependency 'RxDataSources'
      vm.dependency 'GENApi'
      vm.dependency 'GENRReq'
      vm.dependency 'GENResult'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENError'
    end
    
    report.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Report/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Report/VM'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'RxDataSources'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'GENHud'
    end
  end
  
  # 黑名单
  spec.subspec 'Black' do |black|
    
    black.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Black/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENBean/Black'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENResult'
      vm.dependency 'GENError'
      vm.dependency 'GENObservableMapper'
    end
    
    black.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Black/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Black/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCocoa/ASM'
      bridge.dependency 'GENCocoa/Refresh'
      bridge.dependency 'GENBridge/Base'
    end
  end
  # 我的关注
  spec.subspec 'Focus' do |focus|
    
    focus.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/Focus/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENBean/Focus'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENResult'
      vm.dependency 'GENError'
      vm.dependency 'GENObservableMapper'
    end
    
    focus.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Focus/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Focus/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCocoa/ASM'
      bridge.dependency 'GENCocoa/Refresh'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  spec.subspec 'Profile' do |profile|
    
    profile.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/Profile/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENApi'
      vm.dependency 'GENRReq'
      vm.dependency 'GENCache/User'
      vm.dependency 'GENResult'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENObservableMapper'
    end
    
    profile.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Profile/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Profile/VM'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCache/Account'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'RxGesture'
      bridge.dependency 'GENCocoa/SM'
    end
  end
  # 个人中心
  spec.subspec 'UserCenter' do |userCenter|
    
    userCenter.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/UserCenter/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENApi'
      vm.dependency 'GENRReq'
      vm.dependency 'GENCache/User'
      vm.dependency 'GENResult'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENObservableMapper'
    end
    
    userCenter.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/UserCenter/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/UserCenter/VM'
      bridge.dependency 'GENCollection'
      bridge.dependency 'GENCache/Account'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'RxGesture'
      bridge.dependency 'GENCocoa/SM'
    end
  end
  # 个性签名
  spec.subspec 'FeedBack' do |feedBack|
    
    feedBack.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/FeedBack/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENResult'
      vm.dependency 'GENError'
    end
    
    feedBack.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/FeedBack/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/FeedBack/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENBase'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  # 评论 comment
  spec.subspec 'Comment' do |comment|
    
    comment.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Comment/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENBean/Comment'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENResult'
      vm.dependency 'GENError'
      vm.dependency 'GENObservableMapper'
    end
    
    comment.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Comment/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Comment/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENBean/Circle'
      bridge.dependency 'GENCocoa/ASM'
      bridge.dependency 'GENCocoa/Refresh'
      bridge.dependency 'GENBridge/Base'
    end
  end
  
  
  # Collections 列表
  spec.subspec 'Collections' do |collections|
    
    collections.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Collections/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENBean/Circle'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENResult'
      vm.dependency 'GENError'
      vm.dependency 'GENObservableMapper'
    end
    
    collections.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Collections/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Collections/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENCollection'
      bridge.dependency 'GENCocoa/ASM'
      bridge.dependency 'GENCocoa/Refresh'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'GENCache/Account'
    end
  end
  
  # 列表
  spec.subspec 'Tables' do |tables|
    
    tables.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/Tables/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENBean/Circle'
      vm.dependency 'GENRReq'
      vm.dependency 'GENApi'
      vm.dependency 'GENResult'
      vm.dependency 'GENError'
      vm.dependency 'GENObservableMapper'
    end
    
    tables.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Tables/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Tables/VM'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCocoa/ASM'
      bridge.dependency 'GENCocoa/Refresh'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'GENCache/Account'
    end
  end
  
  
  
  # 1
  spec.subspec 'CollectionSection' do |cs|
    
    cs.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/CollectionSection/VM/*.{swift}"
      vm.dependency 'GENViewModel'
      vm.dependency 'RxCocoa'
      vm.dependency 'RxSwift'
    end
    
    cs.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/CollectionSection/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/CollectionSection/VM'
      bridge.dependency 'GENCollection'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'RxDataSources'
    end
  end
  
  # 2
  spec.subspec 'TableSection' do |cs|
    
    cs.subspec 'VM' do |vm|
      vm.source_files = "Code/GENBridge/TableSection/VM/*.{swift}"
      vm.dependency 'GENViewModel'
      vm.dependency 'RxCocoa'
      vm.dependency 'RxSwift'
    end
    
    cs.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/TableSection/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/TableSection/VM'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'RxDataSources'
    end
  end
  
  spec.subspec 'Area' do |area|
    
    area.subspec 'Manager' do |manager|
      
      manager.source_files = "Code/GENBridge/Area/Manager/*.{swift}"
      manager.dependency 'RxCocoa'
      manager.dependency 'GENViewModel'
      manager.dependency 'GENApi'
      manager.dependency 'GENRReq'
      manager.dependency 'GENResult'
      manager.dependency 'GENYY'
      manager.dependency 'GENBean/Area'
      manager.dependency 'GENRReq'
      manager.dependency 'GENError'
      manager.dependency 'GENObservableMapper'
    end
    area.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/Area/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENResult'
      vm.dependency 'GENBean/Area'
    end
    
    area.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Area/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Area/VM'
      bridge.dependency 'GENBridge/Area/Manager'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENCollection'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'GENCocoa/SM'
    end
  end
  
  spec.subspec 'AreaJson' do |areaJson|
    
    areaJson.source_files = "Code/GENBridge/AreaJson/*.{swift}"
    areaJson.dependency 'GENBridge/Area/Manager'
    areaJson.dependency 'GENBridge/Base'
  end
  
  spec.subspec 'Address' do |address|
    
    address.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/Address/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'ObjectMapper'
      vm.dependency 'GENApi'
      vm.dependency 'GENRReq'
      vm.dependency 'GENResult'
      vm.dependency 'GENBean/Area'
      vm.dependency 'GENBean/Address'
      vm.dependency 'WLToolsKit/String'
      vm.dependency 'GENError'
      vm.dependency 'GENObservableMapper'
    end
    
    address.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Address/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Address/VM'
      bridge.dependency 'GENTable'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'GENHud'
      bridge.dependency 'GENCocoa/ASM'
      bridge.dependency 'GENCocoa/SM'
      bridge.dependency 'GENCocoa/Refresh'
    end
  end
  spec.subspec 'Message' do |message|
    
    message.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/Message/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENApi'
      vm.dependency 'GENRReq'
      vm.dependency 'GENResult'
      vm.dependency 'GENBean/Message'
      
    end
    
    message.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Message/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Message/VM'
      bridge.dependency 'GENCollection'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'GENCocoa/ASM'
      bridge.dependency 'GENCocoa/Refresh'
    end
  end
  
  # 翻译
  #  spec.subspec 'Translate' do |translate|
  #
  #    translate.subspec 'VM' do |vm|
  #
  #      vm.source_files = "Code/GENBridge/Translate/VM/*.{swift}"
  #      vm.dependency 'RxCocoa'
  #      vm.dependency 'GENViewModel'
  #      vm.dependency 'ObjectMapper'
  #      vm.dependency 'GENApi'
  #      vm.dependency 'GENRReq'
  #      vm.dependency 'GENResult'
  #    end
  #
  #    translate.subspec 'Bridge' do |bridge|
  #      bridge.source_files = "Code/GENBridge/Translate/Bridge/*.{swift}"
  #      bridge.dependency 'GENBridge/Translate/VM'
  #      bridge.dependency 'GENTransition'
  #      bridge.dependency 'GENBridge/Base'
  #      bridge.dependency 'GENHud'
  #    end
  #  end
  
  spec.subspec 'Video' do |video|
    
    video.subspec 'VM' do |vm|
      
      vm.source_files = "Code/GENBridge/Video/VM/*.{swift}"
      vm.dependency 'RxCocoa'
      vm.dependency 'GENApi'
      vm.dependency 'GENRReq'
      vm.dependency 'GENResult'
      vm.dependency 'GENViewModel'
      vm.dependency 'GENError'
    end
    
    video.subspec 'Bridge' do |bridge|
      bridge.source_files = "Code/GENBridge/Video/Bridge/*.{swift}"
      bridge.dependency 'GENBridge/Video/VM'
      bridge.dependency 'GENTransition'
      bridge.dependency 'GENCache/Account'
      bridge.dependency 'GENBridge/Base'
      bridge.dependency 'GENHud'
    end
  end
  
end
