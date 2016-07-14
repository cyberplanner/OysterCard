require "journey_log"

describe JourneyLog do
    let(:journey) { double :journey_class }
    subject {described_class.new(journey)}

    it "has a joureny object" do
        expect(subject.journey_class).to eq journey
    
    end
end