module CategoriesHelper
  def categories
    @categories ||= Category.all
  end

  def current_category
    if defined?(@category)
      @category
    else
      nil
    end
  end

  def current_category? category
    current_category == category
  end
end
