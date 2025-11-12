# main.rb
# -----------------------------------------
# Acme Widget Co – Basket Pricing System
#
# Proof of concept for a sales system that:
#  - Applies delivery charge rules
#  - Applies offers (e.g. buy one get one half off)
#  - Calculates the total for a basket of products
#
# Run:
#   ruby main.rb
#
# -----------------------------------------

# --- Product class ---
class Product
  attr_reader :code, :name, :price

  def initialize(code:, name:, price:)
    @code = code
    @name = name
    @price = price
  end
end

# --- Offer base and specific offer ---
class Offer
  def apply(items)
    raise NotImplementedError, "Subclasses must implement `apply`"
  end
end

class BuyOneGetSecondHalfOffOffer < Offer
  def initialize(product_code)
    @product_code = product_code
  end

  def apply(items)
    product_items = items.select { |i| i.code == @product_code }
    count = product_items.size
    return 0 if count < 2

    product = product_items.first
    discount_pairs = count / 2
    discount_pairs * (product.price / 2.0)
  end
end

# --- Delivery rule ---
class DeliveryRule
  def cost(subtotal)
    case subtotal
    when 0...50 then 4.95
    when 50...90 then 2.95
    else 0.0
    end
  end
end

# --- Basket ---
class Basket
  def initialize(catalogue:, delivery_rule:, offers: [])
    @catalogue = catalogue
    @delivery_rule = delivery_rule
    @offers = offers
    @items = []
  end

  def add(product_code)
    product = @catalogue[product_code]
    raise ArgumentError, "Unknown product code: #{product_code}" unless product
    @items << product
  end

  def total
    subtotal = @items.sum(&:price)
    total_discount = @offers.sum { |offer| offer.apply(@items) }
    delivery_cost = @delivery_rule.cost(subtotal - total_discount)

    total = subtotal - total_discount + delivery_cost
    total.round(2)
  end
end

# --- Setup sample data ---
PRODUCTS = {
  'R01' => Product.new(code: 'R01', name: 'Red Widget', price: 32.95),
  'G01' => Product.new(code: 'G01', name: 'Green Widget', price: 24.95),
  'B01' => Product.new(code: 'B01', name: 'Blue Widget', price: 7.95)
}.freeze

DELIVERY_RULE = DeliveryRule.new
OFFERS = [BuyOneGetSecondHalfOffOffer.new('R01')]

# --- Demonstration tests ---
def test_basket(items)
  basket = Basket.new(catalogue: PRODUCTS, delivery_rule: DELIVERY_RULE, offers: OFFERS)
  items.each { |code| basket.add(code) }
  puts "Items: #{items.join(', ')} => Total: $#{'%.2f' % basket.total}"
end

puts "Example baskets:\n\n"
test_basket(%w[B01 G01])                # $37.85
test_basket(%w[R01 R01])                # $54.37
test_basket(%w[R01 G01])                # $60.85
test_basket(%w[B01 B01 R01 R01 R01])    # $98.27
