require 'rails_helper'

RSpec.describe Repo, type: :model do
  before(:all) do
    @org = create(:organization)
  end

  describe '#full_name' do
    it 'should return full name of repo' do
      repo = @org.repos.find_by(name: 'rails')
      expect(repo.full_name).to eql('rails/rails')
    end
  end

  describe '#last_updated' do
    context 'if repo has no commits' do
      it 'should return today date' do
        repo = @org.repos.find_by(name: 'rails')
        expect(repo.last_updated).to eql(Date.today)
      end
    end

    context 'if repo has commits' do
      it 'should return commited_at' do
        repo = @org.repos.find_by(name: 'rails')
        repo.get_commits(1.day.ago, 1)
        expect(repo.last_updated).to eql(repo.commits.last.commited_at)
      end
    end
  end
end
