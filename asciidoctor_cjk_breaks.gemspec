Gem::Specification.new do |s|
  s.name        = 'asciidoctor_cjk_breaks'
  s.version     = '0.0.2'
  s.summary     = 'Suppress line breaks between east asian characters'
  s.description = 'An extension for Asciidoctor that suppresses line breaks between east asian characters.'
  s.authors     = ['Kaizhao Zhang']
  s.email       = 'zhangkaizhao@gmail.com'
  s.files       = ['README.adoc',
                   'lib/asciidoctor_cjk_breaks.rb',
                   'lib/asciidoctor/cjk_breaks_treeprocessor.rb',
                   'test/test_cjk_breaks.rb',
                   'test/fixtures/cjk_breaks.txt',
                   'test/fixtures/tengwanggexu-wangbo.txt']
  s.homepage    = 'https://github.com/zhangkaizhao/asciidoctor_cjk_breaks'
  s.license     = 'MIT'

  s.add_runtime_dependency 'asciidoctor', '~> 2'
  s.add_runtime_dependency 'east_asian_width', '~> 0'
end
