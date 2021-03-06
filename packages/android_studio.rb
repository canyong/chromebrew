require 'package'

class Android_studio < Package
  description 'Android Studio is the official IDE for Android development.'
  homepage 'https://developer.android.com/studio'
  version '3.3.1.0'
  source_url 'https://dl.google.com/dl/android/studio/ide-zips/3.3.1.0/android-studio-ide-182.5264788-linux.zip'
  source_sha256 '82603100f772baf5b6b54532375ada756b4b2dc11854cabae267cd8bd8c4f039'

  depends_on 'jdk8'
  depends_on 'xdg_base'
  depends_on 'sommelier'

  abort 'Only x86_64 architecture is supported.'.lightred unless ARGV[0] == 'search' || ARCH == 'x86_64'

  if ARGV[0] == 'install' || ARGV[0] == 'upgrade' then
    free_space = `echo $(($(stat -f --format="%a*%S" .)))`.chomp
    abort 'Not enough free disk space.  You need at least 6 GB to install.'.lightred if free_space < '6442450944'
  end

  def self.install
    FileUtils.mkdir_p(CREW_DEST_PREFIX + '/share/android-studio')
    FileUtils.cp_r('.', CREW_DEST_PREFIX + '/share/android-studio/')
    FileUtils.mkdir_p(CREW_DEST_PREFIX + '/bin')
    FileUtils.cd(CREW_DEST_PREFIX + '/bin') do
      FileUtils.ln_s(CREW_PREFIX + '/share/android-studio/bin/studio.sh', 'studio')
    end
    FileUtils.mkdir_p(CREW_DEST_PREFIX + '/.config/.AndroidStudio3.3')
    FileUtils.mkdir_p(CREW_DEST_PREFIX + '/.config/Android')
    FileUtils.mkdir_p(CREW_DEST_HOME)
    FileUtils.cd(CREW_DEST_HOME) do
      FileUtils.ln_sf(CREW_PREFIX + '/.config/.AndroidStudio3.3/', '.AndroidStudio3.3')
      FileUtils.ln_sf(CREW_PREFIX + '/.config/Android/', 'Android')
    end
  end

  def self.postinstall
    puts
    puts 'To start using Android Studio, type `studio`.'.lightblue
    puts
    puts 'To completely remove Android Studio, including the'.lightblue
    puts 'settings, SDK and tools, execute the following:'.lightblue
    puts 'crew remove android_studio'.lightblue
    puts "rm -rf #{CREW_PREFIX}/.config/Android".lightblue
    puts "rm -rf #{CREW_PREFIX}/.config/.AndroidStudio3.3".lightblue
    puts
  end
end
