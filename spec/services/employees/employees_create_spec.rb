# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employees::Create do
  let(:data_params) { { user_name: "User 01" } }
  let(:project) { "Project 1" }
  let(:technology_name) { ["Technology 1", "Technology 2"] }

  context 'when all params are valid' do
    before do
      create(:technology, name: 'Technology 1')
      create(:technology, name: 'Technology 2')
      create(:project, title: project)
    end

    it 'creates the employee' do
      expect { described_class.new(data_params, project, technology_name).call }
        .to change(Employee, :count).by(1)
    end

    it 'creates the employee with the correct attributes' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee.user_name).to eq(data_params[:user_name])
      expect(employee.project.title).to eq(project)
      expect(employee.technologies.pluck(:name)).to match_array(technology_name)
    end

    it 'assigns the correct project to the employee' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee.project.title).to eq(project)
    end

    it 'assigns the correct technologies to the employee' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee.technologies.pluck(:name)).to match_array(technology_name)
    end

    it 'persists the employee' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee).to be_persisted
    end
  end

  context 'when project is not found' do
    before do
      create(:technology, name: 'Technology 1')
      create(:technology, name: 'Technology 2')
    end

    it 'creates the employee' do
      expect { described_class.new(data_params, project, technology_name).call }
        .to change(Employee, :count).by(1)
    end

    it 'creates the employee with the correct attributes' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee.user_name).to eq(data_params[:user_name])
      expect(employee.project).to be_nil
      expect(employee.technologies.pluck(:name)).to match_array(technology_name)
    end

    it 'assigns the correct technologies to the employee' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee.technologies.pluck(:name)).to match_array(technology_name)
    end
  end

  context 'when technologies are not found' do
    before do
      create(:project, title: project)
    end

    it 'creates the employee' do
      expect { described_class.new(data_params, project, technology_name).call }
        .to change(Employee, :count).by(1)
    end

    it 'creates the employee with the correct attributes' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee.user_name).to eq(data_params[:user_name])
      expect(employee.project.title).to eq(project)
      expect(employee.technologies.pluck(:name)).to be_empty
    end

    it 'assigns the correct project to the employee' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee.project.title).to eq(project)
    end

    it 'does not assign any technologies to the employee' do
      employee = described_class.new(data_params, project, technology_name).call

      expect(employee.technologies.pluck(:name)).to be_empty
    end
  end
end
