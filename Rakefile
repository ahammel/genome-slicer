begin
  require 'bones'
rescue LoadError
  abort '### Please install the "bones" gem ###'
end

begin
  require 'reek/rake/task'
rescue LoadError
  abort '### Please install the "reek" gem ###'
end

begin
  require 'rspec/core/rake_task'
rescue LoadError
  abort '### Please install the "rspec" gem ###'
end

RSpec::Core::RakeTask.new(:spec)

Reek::Rake::Task.new do |t|
  t.fail_on_error = false
end

task 'test:run' => %w[reek spec]

task :default => %w[test:run]
task 'gem:release' => %w[test:run]

Bones {
  name         'genome-slicer'
  authors      'Alex Hammel'
  email        'ahammel87@gmail.com'
  url          'https://github.com/ahammel/genome-slicer'
  ignore_file  '.gitignore'
}

