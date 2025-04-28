# frozen_string_literal: true
require 'rails_helper'

RSpec.describe Employees::Update do
  describe '#call' do
    context 'when both technologies and project exist' do
      before do
        create(:technology, name: 'Ruby')
        create(:technology, name: 'JavaScript')
        create(:project, title: 'Project A')
      end

      it 'returns data_to_update with the given technologies and project' do
        technologies = ['Ruby', 'JavaScript']
        project = 'Project A'
        data_to_update = { user_name: 'User 01' }
        response = described_class.new(technologies, project, data_to_update).call


        expect(response[:user_name]).to eq('User 01')
        expect(response[:technologies].map(&:name)).to match_array(technologies)
        expect(response[:project].title).to eq(project)
      end
    end

    context 'when only project exist' do
      before do
        create(:project, title: 'Project A')
      end

      it 'returns data_to_update with the given project and technology as []' do
        technologies = ['Ruby', 'JavaScript']
        project = 'Project A'
        data_to_update = { user_name: 'User 01' }
        response = described_class.new(technologies, project, data_to_update).call

        expect(response[:user_name]).to eq('User 01')
        expect(response[:technologies]).to be_empty
        expect(response[:project].title).to eq(project)
      end
    end

    context 'when only technology exists' do
      before do
        create(:technology, name: 'Ruby')
        create(:technology, name: 'JavaScript')
      end

      it 'returns the data_to_update with the given technologies and project as nil' do
        technologies = ['Ruby', 'JavaScript']
        project = 'Project A'
        data_to_update = { user_name: 'User 01' }
        response = described_class.new(technologies, project, data_to_update).call

        expect(response[:user_name]).to eq('User 01')
        expect(response[:technologies].map(&:name)).to match_array(technologies)
        expect(response[:project]).to eq(nil)
      end
    end

    context 'when neither technologies nor project are provided' do
      it 'returns technologies as [] and project as nil' do
        technologies = ['Ruby', 'JavaScript']
        project = 'Project A'
        data_to_update = { user_name: 'User 01' }
        response = described_class.new(technologies, project, data_to_update).call

        expect(response[:user_name]).to eq('User 01')
        expect(response[:technologies]).to be_empty
        expect(response[:project]).to eq(nil)
      end
    end
  end
end
