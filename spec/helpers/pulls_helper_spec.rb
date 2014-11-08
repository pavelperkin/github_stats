require 'rails_helper'

RSpec.describe PullsHelper, type: :helper do
  describe '#pull_state_panel' do
    context 'when pull request is open' do
      it 'return panel-success' do
        expect(pull_state_panel('open')).to eql('panel-success')
      end
    end

    context 'when pull request is closed' do
      it 'return panel-primary' do
        expect(pull_state_panel('closed')).to eql('panel-primary')
      end
    end
  end  
end
