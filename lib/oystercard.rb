require_relative "journey"

class Oystercard
  MAXIMUM_BALANCE = 90
  MINIMUM_FARE = 1
  attr_reader :balance, :entry_station, :exit_station, :journeies

  def initialize
    @balance = 0
    @journeies = []
  end

  def top_up(amount)
    fail "Maximum balance of #{MAXIMUM_BALANCE} exceeded" if amount + balance > MAXIMUM_BALANCE
    @balance += amount
  end

  def touch_in(station)
    raise "insufficient funds" if balance < MINIMUM_FARE
    @entry_station = station
  end

  def touch_out(station)
    deduct(MINIMUM_FARE)
    @exit_station = station
    store_journey
    reset_journey
  end

  def in_journey?
    !!entry_station
  end

private
  def store_journey
    journey = Hash[:entry_station => @entry_station, :exit_station => @exit_station]
    @journeies << journey
  end

  def reset_journey
    @entry_station = nil
  end

  def deduct(amount)
    @balance -= amount
  end

end
