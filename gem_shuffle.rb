##
# handles the modification of a Gemfile
#
require 'pry-byebug'

class GemFile
  ##
  # path(str): relative path to a project Gemfile
  def initialize(path)
    @path = path
    @gemfile_master = gemfile_master
  end

  ##
  # modifies the Gemfile based on options given
  # options (hash)
  # keys:
  #   engine: either :local or name of remote branch
  #   jade: either :local or name of remote branch
  # 
  # returns nothing
  def shuffle(options)
    @options = options
    output = @gemfile_master.split("\n").map { |line| process_gemfile_line(line) }.join("\n")
    write_output output
  end

  private

  def gemfile_master
    `"git show master:Gemfile"`
  end

  ##
  # process a line from the gemfile and return output
  def process_gemfile_line(line)

    matched = line.match(/gem '(.+?)'/)
    return line if matched.nil?
    gem_name = matched[1]

    case gem_name
    when /jade_/
      return new_lines gem_name, line, :engine
    when /jade\Z/
      return new_lines gem_name, line, :jade
    else
      return line
    end
  end

  ##
  # returns the new line(s) to add to the Gemfile based on a line from master
  # repo_name (str): the name of the repo this line is for (example, jade)
  # old_line (str) the income line to transform
  # gem_type: :engine or :jade
  def new_lines(repo_name, old_line, gem_type)

    case @options[gem_type]
    when :reset
      old_line
    when :local
      "gem '#{repo_name}', path: '../#{repo_name}'"
    else
      "gem '#{repo_name}', git: 'git@bitbucket.org:epub_dev/#{repo_name}.git', branch: '#{@options[gem_type]}'"
    end
  end

  ##
  # write output to disk
  # output (str) contents of new Gemfile
  def write_output(output)
    File.open(@path, 'w') { |file| file.write output }
  end
end
