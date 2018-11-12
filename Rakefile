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


namespace :cli do

  # add publish task for jekyll theme files
  desc [
    "copies Jekyll theme files into #{cli_default_bin_dir}",
    "this makes them available to the loomtasks scaffolding task",
  ].join("\n")
  task :copy_theme_files do |t, args|
    puts "[#{t.name}] copying theme files into #{cli_default_bin_dir}..."

    %w(
      _data
      _includes
      _layouts
    ).each do |dir|
      theme_dir = File.join('docs', dir)
      fail("could not find '#{theme_dir}' to copy") unless Dir.exists?(theme_dir)
      FileUtils.cp_r(theme_dir, cli_default_bin_dir)
    end

    puts "[#{t.name}] pre-task completed, theme files copied to #{cli_default_bin_dir}"
  end

  # add lsdoc loomlib to fixtures after compilation before running cli demo
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

Rake::Task['cli:install'].enhance { Rake::Task['cli:copy_theme_files'].invoke() }
Rake::Task['cli:run'].enhance ['cli:update_fixture']
