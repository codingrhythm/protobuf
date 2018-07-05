# This file describes to Cocoapods how to integrate the Objective-C runtime into a dependent
# project.
# Despite this file being specific to Objective-C, it needs to be on the root of the repository.
# Otherwise, Cocoapods gives trouble like not picking up the license file correctly, or not letting
# dependent projects use the :git notation to refer to the library.
Pod::Spec.new do |s|
  s.name     = 'Protobuf-C++'
  s.version  = '3.6.0'
  s.summary  = 'Protocol Buffers v.3 runtime library for C++.'
  s.homepage = 'https://github.com/google/protobuf'
  s.license  = '3-Clause BSD License'
  s.authors  = { 'The Protocol Buffers contributors' => 'protobuf@googlegroups.com' }
  s.cocoapods_version = '>= 1.0'
  s.requires_arc = false
  #name = 'google'
  #s.module_name = name
  #s.header_dir = name
  s.libraries = 'c++'
  src_root = '$(PODS_ROOT)/Protobuf-C++'

  s.source = { :git => 'https://github.com/google/protobuf.git',
               :tag => "v#{s.version}" }

  s.source_files = 'config.h',
                   'src/google/protobuf/**/*.{h,cc}'
  s.compiler_flags = '-D_THREAD_SAFE'
  s.libraries = 'c++'
  # The following would cause duplicate symbol definitions. GPBProtocolBuffers is expected to be
  # left out, as it's an umbrella implementation file.
  s.exclude_files = 'src/**/compiler/cpp/**',
                    'src/**/compiler/python/**',
                    'src/**/compiler/java/**',
                    'src/**/compiler/csharp/**',
                    'src/**/compiler/js/**',
                    'src/**/compiler/objectivec/**',
                    'src/**/compiler/php/**',
                    'src/**/compiler/ruby/**',
                    'src/**/compiler/**',
                    'src/**/*unittest*',
                    'src/**/*test_util*',
                    'src/**/testdata/**',
                    'src/google/protobuf/any_test.cc'

  s.header_mappings_dir = 'src'

  # Set a CPP symbol so the code knows to use framework imports.
  s.user_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' }
  s.pod_target_xcconfig = { 'GCC_PREPROCESSOR_DEFINITIONS' => '$(inherited) GPB_USE_PROTOBUF_FRAMEWORK_IMPORTS=1' }

  s.ios.deployment_target = '7.0'
  s.osx.deployment_target = '10.9'
  s.tvos.deployment_target = '9.0'
  s.watchos.deployment_target = '2.0'
  s.requires_arc = false
end
