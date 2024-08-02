Pod::Spec.new do |s|
  s.name             = 'KhipuClientIOS'
  s.version          = '2.7.3'
  s.summary          = 'A Client for iOS Apps written in Swift for Khipu'

  s.description      = <<-DESC
  Khipu is a payment method operating in Chile, Argentina, Peru, and soon in Mexico and Spain. It allows merchants to collect payments electronically and customers to pay using their bank accounts (Checking, Savings, Electronic Checkbooks, etc.).

  Standard use of Khipu requires that the customer authorize the payment on Khipu's website or by installing a mobile app, the Khipu payment terminal.

  The Khipu SDK for Android/iOS allows merchants with an app (Android and/or iOS) to embed the payment authorization process directly in their app, thereby reducing friction in the buying process and, consequently, increasing the conversion rate of the entire process.
  DESC

  s.homepage         = 'https://github.com/khipu/KhipuClientIOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Khipu' => 'developers@khipu.com' }
  s.source           = { :git => 'https://github.com/khipu/KhipuClientIOS.git', :tag => s.version.to_s }

  s.ios.deployment_target = '12.0'

  s.source_files = 'KhipuClientIOS/Classes/**/*'
  s.resource_bundles = {
    'KhipuClientIOS' => ['KhipuClientIOS/Assets/**/*.{xcassets,json,ttf,html,js,css}']
  }

  s.dependency 'Socket.IO-Client-Swift', '16.1.0'
  s.dependency 'Starscream', '4.0.6'
  s.dependency 'KhenshinSecureMessage', '1.3.0'
  s.dependency 'KhenshinProtocol', '1.0.44'
  s.swift_versions = "5.0"
end
