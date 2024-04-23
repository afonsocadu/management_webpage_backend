# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'association' do
    it { is_expected.to belong_to(:project).optional }
    it { is_expected.to have_and_belong_to_many(:technologies) }

    it 'has factory that produces a valid employee' do
      employee = create(:employee)

      expect(employee).to be_valid
    end

    describe "can_be_associated_to_project" do
    let!(:technologies) { create_list(:technology, 2) }
    let!(:project) { create(:project, technologies: technologies) }
    let(:employee_right_technologies) { create(:employee, technologies: technologies) }

      context 'employee has the required technology' do
        it 'should return the right employee' do
          expect(Employee.can_be_associated_to_project(project.title)).to eq([employee_right_technologies])
        end
      end

      context 'employee has not the required technology' do
        let!(:wrong_technologies) { create_list(:technology, 2) }
        let(:employee_wrong_technologies) { create(:employee, technologies: wrong_technologies) }

        it 'should return the right employee' do
          expect(Employee.can_be_associated_to_project(project.title)).not_to eq([employee_wrong_technologies])
        end
      end
    end
  end
end
