class Pagination

  attr_reader :page, :limit, :klass, :order

  def initialize(klass, page: 0, limit: 10, order: 'created_at desc')
    @klass = klass
    @page = page.to_i
    @limit = limit
    @order = order
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
