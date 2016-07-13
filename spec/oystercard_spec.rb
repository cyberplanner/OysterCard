require "oystercard"

describe Oystercard do
let(:station) { double :station }
let(:maximum_balance) { Oystercard::MAXIMUM_BALANCE }
let(:minimum_balance) { Oystercard::MINIMUM_FARE }
let(:empty_card) { Oystercard.new }
#let(:min_card) { empty_card.top_up(minimum_balance) }
#let(:max_card) { empty_card.top_up(maximum_balance) }

  it 'checks to see if the balance is 0' do
    expect(empty_card.balance).to eq 0
  end

  describe "#top_up" do
    it "top up the balance" do
      expect{ empty_card.top_up(minimum_balance) }.to change{ empty_card.balance }.by(minimum_balance)
    end
    it "raises error if exceeds the limit" do
      empty_card.top_up(maximum_balance)
      expect{ empty_card.top_up(minimum_balance) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe 'status of card' do

    it 'is initially not in a journey' do
      expect(empty_card).not_to be_in_journey
    end

    it 'touch in' do
      empty_card.top_up(minimum_balance)
      empty_card.touch_in(station)
      expect(empty_card).to be_in_journey
    end
    it 'touch out' do
      empty_card.top_up(minimum_balance)
      empty_card.touch_in(station)
      empty_card.touch_out(station)
      expect(empty_card).not_to be_in_journey
    end
  end

    it "checks balance on touch in" do
      empty_card.balance < minimum_balance
      expect{ empty_card.touch_in(station) }.to raise_error "insufficient funds"
    end

    it 'charge balance on touch out' do
      empty_card.top_up(minimum_balance)
      empty_card.touch_in(station)
      expect{ empty_card.touch_out(station) }.to change{ empty_card.balance }.by -minimum_balance
    end

    it "remembers entry station" do
        empty_card.top_up(minimum_balance)
        empty_card.touch_in(station)
        expect(empty_card.entry_station).to eq station 
    end

    describe "#journeies" do
      it "New cards has empty history" do
      expect(subject.journeies).to be_empty
      end

      it "card keeps history" do
        empty_card.top_up(minimum_balance)
        empty_card.touch_in(station)
        empty_card.touch_out(station)
        expect(empty_card.journeies).not_to be_empty
      end

    end
    
end
