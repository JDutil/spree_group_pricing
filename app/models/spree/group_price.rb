class Spree::GroupPrice < ActiveRecord::Base

  belongs_to :variant, touch: true

  acts_as_list scope: :variant

  validates :amount, presence: true
  validates :discount_type, presence: true, inclusion: {in: %w(price dollar percent), message: "%{value} is not a valid Group Price Type"}
  validates :range, format: {with: /\(?[0-9]+(?:\.{2,3}[0-9]+|\+\)?)/, message: "must be in one of the following formats: (a..b), (a...b), (a+)"}
  validates :variant, presence: true

  attr_accessor :end_range, :start_range
  attr_accessible :amount, :discount_type, :end_range, :name, :position, :range, :start_range, :variant

  before_validation :set_range

  OPEN_ENDED = /\(?[0-9]+\+\)?/

  def display_discount
    case discount_type
    when 'dollar' then "$#{amount.round(2)} off"
    when 'percent' then "#{amount.to_i}%"
    when 'price' then "price becomes $#{amount.round(2)}"
    end
  end

  def include?(quantity)
    if open_ended?
      bound = /\d+/.match(range)[0].to_i
      return quantity >= bound
    else
      range.to_range === quantity
    end
  end

  # indicates whether or not the range is a true Ruby range or an open ended range with no upper bound
  def open_ended?
    OPEN_ENDED =~ range
  end

  private

  def set_range
    if self.start_range.present? and self.end_range.present?
      self.range = "(#{self.start_range}..#{self.end_range})"
    elsif start_range.present?
      self.range = "(#{self.start_range}+)"
    end
  end

end
