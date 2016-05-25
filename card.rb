class Card
  attr_reader :rank, :suit

  def initialize rank, suit
    @rank, @suit = rank, suit
  end

  def value
    case rank
    when :K, :Q, :J
      10
    when :A
      1
    else
      rank
    end
  end

  def to_s
    "#{rank}#{suit}"
  end
end
