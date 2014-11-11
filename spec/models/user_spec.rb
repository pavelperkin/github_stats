require 'rails_helper'

RSpec.describe User, type: :model do

  describe '#find_user' do
    context 'if user exist' do
      it 'should return this user' do
        user = create(:user)
        mock = OpenStruct.new(id: 123456)
        expect(User.find_user(mock).id).to eql(user.id)
      end
    end
    context 'if user does not exist' do
      it 'should return nil' do
        mock = OpenStruct.new(id: 654321)
        expect(User.find_user(mock)).to eql(nil)
      end
    end
  end

end
