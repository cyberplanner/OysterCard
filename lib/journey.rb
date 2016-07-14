class Journey
  PENALTY_FARE = 6
  attr_reader :entry_station, :exit_station

  def initialize(entry_station: nil, exit_station: nil)
    @entry_station = entry_station
    @exit_station = exit_station
    @fare = PENALTY_FARE
  end

  def start(station)
    @entry_station = station
  end

  def finish(station)
    @exit_station = station
    self
  end

  def complete?
    !!entry_station && !!exit_station
  end

  # def in_journey?
  #   !!entry_station && exit_station = nil
  # end

  def fare
    if complete?
      Oystercard::MINIMUM_FARE
    else
      PENALTY_FARE
    end
  end

end
