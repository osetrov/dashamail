# frozen_string_literal: true
#
module Dashamail
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path('templates', __dir__)

    def generate_install
      copy_file 'dashamail.yml', 'config/dashamail.yml'
      copy_file 'dashamail.rb', 'config/initializers/dashamail.rb'
    end
  end
end

