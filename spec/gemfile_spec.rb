# rubocop:disable Metrics/BlockLength
require './gem_shuffle'

RSpec.describe GemFile do
  let(:mock_File) { expect(File).to receive(:open).with(any_args, 'w').and_yield(@file) }
  before do
    @file = double
  end
  context 'pointing to engine' do
    before do
      GemFile.any_instance.stub(:gemfile_master).and_return(File.open('./spec/fixtures/engine_site.txt').read)
      @g = GemFile.new './sample_site/Gemfile'
      # @g.stub(:gemfile_master) { File.open('./spec/fixtures/engine_site.txt').read }
    end
    context 'pointing locally' do
      before do
        mock_File
      end

      it 'points to local engine' do
        local_re = Regexp.new "gem 'jade_bnp', path: '../jade_bnp"
        expect(@file).to receive(:write).with(local_re)
        @g.shuffle engine: :local
      end

      it 'does not point to gem server' do
        expect(@file).to receive(:write) do |arg|
          expect(arg).to_not match(%(gem 'jade_bnp', [ '~> 6.8.0', ">= 6.8.#{(Time.now - (60*60*24*30)).strftime('%Y%m%d001')}" ]))
        end
        @g.shuffle engine: :local
      end
    end

    context 'pointing to remote origin' do
      before do
        mock_File
      end

      it 'points to remote engine' do
        local_re = Regexp.new "gem 'jade_bnp', git: 'git@bitbucket.org:epub_dev/jade_bnp.git', branch: 'cr/new_branch'"
        expect(@file).to receive(:write).with(local_re)
        @g.shuffle engine: :'cr/new_branch'
      end

      it 'does not point to gem server' do
        expect(@file).to receive(:write) do |arg|
          expect(arg).to_not match(%(gem 'jade_bnp', [ '~> 6.8.0', ">= 6.8.#{(Time.now - (60*60*24*30)).strftime('%Y%m%d001')}" ]))
        end
        @g.shuffle engine: :'cr/new_branch'
      end

    end

    context 'reset to gem server' do
      before do
        mock_File
      end

      it 'points to gem server' do
        gem_server_re = /gem 'jade_bnp', .*?Time\.now/
        expect(@file).to receive(:write).with(gem_server_re)
        @g.shuffle engine: :reset
      end

    end

  end

  context 'pointing to jade' do
    before do
      GemFile.any_instance.stub(:gemfile_master).and_return(File.open('./spec/fixtures/jade_only.txt').read)
      @g = GemFile.new './sample_site/Gemfile'
    end
    context 'pointing locally' do
      before do
        mock_File
      end

      it 'points to local jade' do
        local_re = Regexp.new "gem 'jade', path: '../jade"
        expect(@file).to receive(:write).with(local_re)
        @g.shuffle jade: :local
      end

      it 'does not point to gem server' do
        expect(@file).to receive(:write) do |arg|
          expect(arg).to_not match(%(gem 'jade', [ '~> 6.8.0', ">= 6.8.#{(Time.now - (60*60*24*30)).strftime('%Y%m%d001')}" ]))
        end
        @g.shuffle jade: :local
      end
    end

    context 'pointing to remote origin' do
      before do
        mock_File
      end

      it 'points to remote jade' do
        local_re = Regexp.new "gem 'jade', git: 'git@bitbucket.org:epub_dev/jade.git', branch: 'cr/new_branch'"
        expect(@file).to receive(:write).with(local_re)
        @g.shuffle jade: :'cr/new_branch'
      end

      it 'does not point to gem server' do
        expect(@file).to receive(:write) do |arg|
          expect(arg).to_not match(%(gem 'jade', [ '~> 6.8.0', ">= 6.8.#{(Time.now - (60*60*24*30)).strftime('%Y%m%d001')}" ]))
        end
        @g.shuffle jade: :'cr/new_branch'
      end

    end

    context 'reset to gem server' do
      before do
        mock_File
      end

      it 'points to gem server' do
        gem_server_re = /gem 'jade', .*?Time\.now/
        expect(@file).to receive(:write).with(gem_server_re)
        @g.shuffle jade: :reset
      end

    end

  end
end
