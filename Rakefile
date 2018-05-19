LIB_NAME = 'LSDoc'
LIB_VERSION_FILE = File.join('lib', 'src', 'pixeldroid', 'lsdoc', 'LSDoc.ls')

begin
  load(File.join(ENV['HOME'], '.loom', 'tasks', 'loomlib.rake'))
rescue LoadError
  abort([
    'error: missing loomlib.rake',
    '  please install loomtasks before running this Rakefile:',
    '  https://github.com/pixeldroid/loomtasks/',
  ].join("\n"))
end


# add lsdoc loomlib to fixtures after compilation before running cli demo
namespace :cli do

  desc [
    "copies #{LIBRARY} into test/fixtures for use in doc gen demo",
  ].join("\n")
  task :update_fixture => LIBRARY do |t, args|
    lib = t.prerequisites[0]
    fixtures_dir = File.join('test', 'fixtures')

    puts "[#{t.name}] copying #{lib} into #{fixtures_dir}..."
    fail("could not find '#{lib}' to copy") unless File.exists?(lib)

    FileUtils.cp(lib, fixtures_dir)

    puts "[#{t.name}] pre-task completed, #{lib_file} copied to #{fixtures_dir}"
  end

end

Rake::Task["cli:run"].enhance ["cli:update_fixture"]
