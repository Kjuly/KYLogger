Pod::Spec.new do |spec|
  spec.name         = "KYLogger"
  spec.version      = "1.4.0"
  spec.summary      = "A local system logger for Apple platforms."
  spec.description  = <<-DESC
  This lightweight logging lib is serverless. It includes a debug logger and a file logger which will save logs locally on the device. Users can choose to send a log file when a bug is reported.
                   DESC
  spec.license      = "MIT"
  spec.source       = { :git => "https://github.com/Kjuly/KYLogger.git", :tag => spec.version.to_s }
  spec.homepage     = "https://github.com/Kjuly/KYLogger"

  spec.author             = { "Kjuly" => "dev@kjuly.com" }
  spec.social_media_url   = "https://twitter.com/kJulYu"

  spec.ios.deployment_target = "15.5"
  spec.osx.deployment_target = "12.0"
  spec.watchos.deployment_target = "6.0"

  spec.swift_version = '5.0'

  spec.source_files  = "KYLogger"
  spec.exclude_files = "KYLogger/KYLogger.docc"

  spec.requires_arc = true
end
