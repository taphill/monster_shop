class Cart
  attr_reader :contents

  def initialize(contents)
    @contents = contents
  end

  def add_item(item)
    @contents[item] = 0 if !@contents[item]
    @contents[item] += 1
  end

  def remove_one(item)
    @contents[item] -= 1
    if @contents[item] == 0
      @contents.delete(item)
    end
  end

  def total_items
    @contents.values.sum
  end

  def items
    item_quantity = {}
    @contents.each do |item_id,quantity|
      item_quantity[Item.find(item_id)] = quantity
    end
    item_quantity
  end

  def subtotal(item)
    return item.price * @contents[item.id.to_s] unless discount?(item)

    total = (item.price * @contents[item.id.to_s])
    discount = total / discount(item)

    total - discount
  end

  def discount(item)
    item.merchant.discounts
    .select(:percentage, :item_quantity)
    .where('item_quantity <= ?', 3)
    .order(item_quantity: :desc).limit(1)
    .first.percentage
  end

  def discount?(item)
    !(item.merchant.discounts
          .select(:item_quantity)
          .where('item_quantity <= ?', @contents[item.id.to_s])
          .empty?)
  end

  def total
    @contents.sum do |item_id,quantity|
      Item.find(item_id).price * quantity
    end
  end

  def inventory_check(item)
    @contents[item.id.to_s] < item.inventory
  end
end
