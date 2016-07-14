require "oystercard"

describe Oystercard do
let(:station) { double :station }
let(:maximum_balance) { Oystercard::MAXIMUM_BALANCE }
let(:minimum_balance) { Oystercard::MINIMUM_FARE }
let(:empty_card) { Oystercard.new }

describe '#balance' do
    it 'checks to see if the balance is 0' do
      expect(empty_card.balance).to eq 0
    end
  end

  describe "#top_up" do
    it "tops up the balance" do
      expect{ empty_card.top_up(minimum_balance) }.to change{ empty_card.balance }.by(minimum_balance)
    end
    it "raises error if exceeds the limit" do
      empty_card.top_up(maximum_balance)
      expect{ empty_card.top_up(minimum_balance) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end


  describe 'status of card' do

    describe 'after touch in' do

      it "New cards have an empty history" do
        expect(subject.journeies).to be_empty
      end

      before do
        empty_card.top_up(minimum_balance)
        empty_card.touch_in(station)
      end

      it 'charge balance on touch out' do
        expect{ empty_card.touch_out(station) }.to change{ empty_card.balance }.by -minimum_balance
      end

      it "the card keeps history" do
        empty_card.touch_out(station)
        expect(empty_card.journeies[0].entry_station).to eq station
      end
    end

    it "checks balance on touch in" do
      empty_card.balance < minimum_balance
      expect{ empty_card.touch_in(station) }.to raise_error "insufficient funds"
    end

  end

end
