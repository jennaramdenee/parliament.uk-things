require_relative '../rails_helper'

RSpec.describe ArticleHelper do

  it 'is a module' do
    expect(subject).to be_a(Module)
  end

  describe '#read_time' do
    context 'without images' do
      it 'calculates rounded-up read time based on number of words' do
        text = ''
        300.times { text = text + 'word '}
        expect(subject.read_time(text)).to eq(2)
      end
    end
  end
end
