require 'rails_helper'

RSpec.describe Organization, type: :model do

  describe 'before_validation#strip_name' do
    it 'should strip name before save' do
      unstripped_name = '   rails    '
      org = create(:organization, name: unstripped_name)
      expect(org.name).to eql(unstripped_name.strip)
    end
  end

  describe 'validation#should_exist_on_github' do
    it 'should rollback if organization does not presence on github' do
      org = build(:organization, name: 'some_crazy_string'.reverse)
      expect(org.valid?).to eql false
    end
  end

  describe 'callback set_url' do
    it 'should get org url from github' do
      org = create(:organization)
      expect(org.url).to eql('https://github.com/rails')
    end
  end

  describe 'callback get org repos' do
    it 'should fetch org repos after create' do
      org = create(:organization)
      expect(org.repos.any?).to eql true
    end
  end

end
