# A sample Guardfile
# More info at https://github.com/guard/guard#readme
require 'active_support/inflector'

guard :minitest do
  # with Minitest::Unit
  watch(%r{^test/(.*)?_test\.rb$})
  watch(%r{^test/test_helper\.rb$})      { 'test' }

  # Rails 4
  watch(%r{^app/(.+)\.rb$})                               { |m| "test/#{m[1]}_test.rb" }
  watch(%r{^app/controllers/application_controller\.rb$}) { 'test/controllers' }
  watch(%r{^app/controllers/api/v1/api_controller\.rb$})  { 'test/controllers' }
  watch(%r{^app/serializers/(.+)$})                       { 'test/controllers' }
  watch(%r{^config/routes\.rb$})                          { 'test/controllers' }
  watch(%r{^test/fixtures/(.+)\.yml})                     { |m| "test/models/#{m[1].singularize}_test.rb" }
  watch(%r{^test/fixtures/(.+)\.yml})                     { |m| "test/controllers/#{m[1]}_controller_test.rb" }
  # watch(%r{^app/controllers/(.+)_controller\.rb$})        { |m| "test/integration/#{m[1]}_test.rb" }
  # watch(%r{^lib/(.+)\.rb$})                               { |m| "test/lib/#{m[1]}_test.rb" }
  # watch(%r{^test/.+_test\.rb$})
end
