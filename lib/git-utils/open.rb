require 'git-utils/command'

class Open < Command

  def parser
    OptionParser.new do |opts|
      opts.banner = "Usage: git open"
      opts.on_tail("-h", "--help", "this usage guide") do
        puts opts.to_s; exit 0
      end
    end
  end

  # Returns the URL for the repository page.
  def page_url
    if service == 'stash' && protocol == 'ssh'
      pattern = /(.*)@([^:]*):?([^\/]*)\/([^\/]*)\/(.*)\.git/
      replacement = 'https://\2/projects/\4/repos/\5/browse?at=' +
                    current_branch
    elsif service == 'stash' && protocol == 'http'
      pattern = /(.*)@([^:\/]*)(:?[^\/]*)\/(.*)scm\/([^\/]*)\/(.*)\.git/
      replacement = 'https://\2\3/\4projects/\5/repos/\6/browse?at=' +
                    current_branch
    elsif protocol == 'ssh'
      pattern = /(.*)@(.*):(.*)\.git/
      replacement = 'https://\2/\3/'
    elsif protocol == 'http'
      pattern = /https?\:\/\/(([^@]*)@)?(.*)\.git/
      replacement = 'https://\3/'
    end
    origin_url.sub(pattern, replacement)
  end

  # Returns a command appropriate for executing at the command line
  def cmd
    c = ["open #{page_url}"]
    c << argument_string(unknown_options) unless unknown_options.empty?
    c.join("\n")
  end
end