require "pry"

def consolidate_cart(cart)
  reformatted_cart = {}
  cart.each { |items|
    items.each { |item, info|
      reformatted_cart[item] = info

      if reformatted_cart[item][:count] == nil
        reformatted_cart[item][:count] = 1
      else
        reformatted_cart[item][:count] += 1
      end
    }
  }

  reformatted_cart
end

def apply_coupons(cart, coupons)
  coupons.each { |coupon|
    product = coupon[:item]

    if cart[product] != nil && cart[product][:count] >= coupon[:num] #if coupon is applicable to any item in cart and if there is, is the number of that product more than 1
      if cart["#{product} W/COUPON"] != nil  #if there already exists a K-V pair for W/COUPON item in the care
        cart["#{product} W/COUPON"][:count] += 1 #the increment by 1 the value
      else #if there is no W/COUPON item in the cart establish the info hash
        cart["#{product} W/COUPON"] = {:count => 1, :price => coupon[:cost], :clearance => cart[product][:clearance]}
      end
      #minus from the original product the number of items taken away by the Coupon
      cart[product][:count] -= coupon[:num]
    end
  }

  cart
end


def apply_clearance(cart)
  cart.each { |product_name, info|  #is item on clearence?
    info[:price] = (info[:price] * 0.8).round(2) if info[:clearance]
  }

  cart
end

def checkout(cart, coupons)
  consol_cart = consolidate_cart(cart)
  coupon_cart = apply_coupons(consol_cart, coupons)
  new_cart = apply_clearance(coupon_cart)

  price_total = 0
  new_cart.each { |product, info| price_total += info[:price] * info[:count]}

  price_total = (price_total * 0.9).round(2) if price_total > 100

  price_total
end
