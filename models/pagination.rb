class Pagination

  attr_reader :page, :limit, :klass, :order

  def initialize(klass, page: page, limit: limit, order: order)
    @klass = klass
    @page = page.to_i || 0
    @limit = limit
    @order = order || 'created_at desc'
  end

  def count
    @count ||= klass.count
  end

  def entries
    klass.order(order).offset(offset).limit(limit)
  end

  def next_page
    self.page + 1
  end

  def last_page?
    page == max_pages
  end

  def prev_page
    self.page - 1
  end

  def first_page?
    page == 0
  end

  def offset
    page * limit
  end

  def max_pages
    count / limit
  end

end
