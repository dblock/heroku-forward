module Heroku
  module Forward
    module Utils
      
      module Dir
      
        # Partially borrowed from ruby 1.9's Dir::Tmpname.make_tmpname for 1.8.7-compatibility.
        def self.tmp_filename(prefix, suffix)
          File.join ::Dir.tmpdir, "#{prefix}#{Time.now.strftime("%Y%m%d")}-#{$$}-#{rand(0x100000000).to_s(36)}#{suffix}"
        end
        
      end
      
    end
  end
end
