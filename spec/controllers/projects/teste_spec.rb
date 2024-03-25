RSpec.shared_context 'common' do
  before do
    @foods = []
  end

  def some_helper_method
    5
  end

  Rspec.describe 'first example group' do
    include_context 'common'


  end
end
