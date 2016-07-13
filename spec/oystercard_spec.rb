require "oystercard"

describe Oystercard do
let(:station) { double :station }

  it 'checks to see if the balance is 0' do
    expect(subject.balance).to eq 0
  end

  describe "#top_up" do
    it "top up the balance" do
      expect{ subject.top_up(Oystercard::MINIMUM_FARE) }.to change{ subject.balance }.by(Oystercard::MINIMUM_FARE)
    end
    it "raises error if exceeds the limit" do
      maximum_balance = Oystercard::MAXIMUM_BALANCE
      subject.top_up(maximum_balance)
      expect{ subject.top_up(Oystercard::MINIMUM_FARE) }.to raise_error "Maximum balance of #{maximum_balance} exceeded"
    end
  end

  describe 'status of card' do

    it 'is initially not in a journey' do
      expect(subject).not_to be_in_journey
    end

    it 'touch in' do
      subject.top_up(Oystercard::MINIMUM_FARE)
      subject.touch_in(station)
      expect(subject).to be_in_journey
    end
    it 'touch out' do
      subject.top_up(Oystercard::MINIMUM_FARE)
      subject.touch_in(station)
      subject.touch_out(station)
      expect(subject).not_to be_in_journey
    end
  end

    it "checks balance on touch in" do
      subject.balance < Oystercard::MINIMUM_FARE
      expect{ subject.touch_in(station) }.to raise_error "insufficient funds"
    end

    it 'charge balance on touch out' do
      subject.top_up(Oystercard::MINIMUM_FARE)
      subject.touch_in(station)
      expect{ subject.touch_out(station) }.to change{ subject.balance }.by -Oystercard::MINIMUM_FARE
    end

    it "remembers entry station" do
        subject.top_up(Oystercard::MINIMUM_FARE)
        subject.touch_in(station)
        expect(subject.entry_station).to eq station 
    end

    describe "#journeies" do
      it "New cards has empty history" do
      expect(subject.journeies).to be_empty
      end

      it "card keeps history" do
        subject.top_up(Oystercard::MINIMUM_FARE)
        subject.touch_in(station)
        subject.touch_out(station)
        expect(subject.journeies).not_to be_empty
      end

    end
    
end
