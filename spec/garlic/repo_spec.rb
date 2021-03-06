require File.expand_path(File.join(File.dirname(__FILE__), '../spec_helper'))

describe Garlic::Repo do
  describe "new(:url => 'some/local/repo', :path => 'some/dest')" do
    before { @repo = Garlic::Repo.new(:url => 'some/local/repo', :path => 'some/dest') }
    
    it "should expand the path" do
      @repo.path.should == File.expand_path('some/dest')
    end
    
    it "should expand the url" do
      @repo.url.should == File.expand_path('some/local/repo')
    end
    
    it "should have name == 'dest' (basename of path)" do
      @repo.name.should == 'dest'
    end
    
    describe '#install' do
      before do
        @repo.stub!(:puts) # silence!
      end
      
      it "should 'git clone <repo> <dest>" do
        @repo.should_receive(:sh).with("git clone #{@repo.url} #{@repo.path}")
        @repo.install
      end
    end
  end
  
  describe "new(:url => 'git://remote/repo', :path => 'some/dest')" do
    before { @repo = Garlic::Repo.new(:url => 'git://remote/repo', :path => 'some/dest') }
    
    it "should NOT expand the url" do
      @repo.url == 'git://remote/repo'
    end
  end
end