# class GitShow

#   ##
#   # path(string): relative path to the project's root
#   def initialize(path)
#     @path = path
#   end

#   def master
#     `git show Gemfile:master"`
#   end
# end

class Git
  def show
    `git show Gemfile:master`
  end
end