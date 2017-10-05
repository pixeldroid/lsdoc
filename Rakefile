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


@template_config = nil

def template_config_file()
  File.join('lib', 'ghpages-template', 'ghpages.config')
end

def template_config()
  @template_config || (@template_config = LoomTasks.parse_loom_config(template_config_file))
end

def write_template_config(config)
  LoomTasks.write_loom_config(template_config_file, config)
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


TEMPLATE = File.join('lib', 'ghpages-template')

namespace :template do

  desc [
    "packages #{TEMPLATE} for release",
    "the version value will be read from #{LIB_VERSION_FILE}",
    "it must match this regex: #{lib_version_regex}",
  ].join("\n")
  task :package do |t, args|
    lib_version = LoomTasks.lib_version(lib_version_file)
    template_release = "#{File.basename(TEMPLATE)}_v#{lib_version}.zip"
    released_template = File.join(release_dir, template_release)

    fail('zip archiving not yet supported on windows') if windows?
    cmd = "zip --quiet --recurse-paths #{released_template} #{TEMPLATE} --exclude '*.DS_Store'"

    Dir.mkdir(release_dir) unless Dir.exists?(release_dir)
    FileUtils.rm(released_template) if (File.exists?(released_template))
    try(cmd, "unable to create #{template_release}")

    puts "[#{t.name}] task completed, find #{template_release} in #{release_dir}/"
  end

  desc [
    "installs #{TEMPLATE} into #{lib_config['sdk_version']} SDK",
  ].join("\n")
  task :install => 'template:uninstall' do |t, args|
    sdk_version = lib_config['sdk_version']

    FileUtils.cp_r(TEMPLATE, LoomTasks.sdk_root(sdk_version))

    puts "[#{t.name}] task completed, #{TEMPLATE} installed for #{sdk_version}"
  end

  desc [
    "removes #{TEMPLATE} from #{lib_config['sdk_version']} SDK",
  ].join("\n")
  task :uninstall do |t, args|
    sdk_version = lib_config['sdk_version']
    sdk_dir = LoomTasks.sdk_root(sdk_version)
    template_dir = File.basename(TEMPLATE)
    installed_template = File.join(sdk_dir, template_dir)

    if (Dir.exists?(installed_template))
      FileUtils.rm_r(installed_template)
      puts "[#{t.name}] task completed, #{template_dir} removed from #{sdk_dir}"
    else
      puts "[#{t.name}] nothing to do; no #{template_dir} found in #{sdk_dir}"
    end
  end

end

Rake::Task["lib:release"].enhance ["template:package"]

Rake::Task["lib:version"].enhance do |t, args|
  lib_version = LoomTasks.lib_version(lib_version_file)
  template_config['template_version'] = lib_version
  write_template_config(template_config)
end
