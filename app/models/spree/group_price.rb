class Spree::GroupPrice < ActiveRecord::Base

  belongs_to :variant, touch: true

  acts_as_list scope: :variant

  validates :amount, :name, :variant, presence: true
  validates :discount_type, presence: true, inclusion: { in: %w(price dollar percent), message: "%{value} #{Spree.t(:discount_type_presence, scope: :validation)}" }
  validates :range, format: { with: /\(?[0-9]+(?:\.{2,3}[0-9]+|\+\)?)/, message: Spree.t(:range_format, scope: :validation) }

  attr_accessor :end_range, :start_range

  before_validation :set_range

  OPEN_ENDED = /\(?[0-9]+\+\)?/

  def display_discount
    case discount_type
    when 'dollar'  then "#{Spree::Money.new(amount)} #{Spree.t(:dollar_off)}"
    when 'percent' then "#{amount.to_i}%"
    when 'price'   then "#{Spree.t(:price_becomes)} #{Spree::Money.new(amount)}"
    end
  end

  def end_range
    return @end_range if @end_range
    return nil if range.blank?
    range.gsub(/\(|\)/, '').split(/\.{2,3}|\+/)[1]
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

  def start_range
    return @start_range if @start_range
    return nil if range.blank?
    range.gsub(/\(|\)/, '').split(/\.{2,3}|\+/)[0]
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
