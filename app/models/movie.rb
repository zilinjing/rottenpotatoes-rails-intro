class Movie < ActiveRecord::Base
  def self.all_ratings
    # Returns an array of all unique ratings from the database
    ['G', 'PG', 'PG-13', 'R', 'NC-17']
  end

  def self.with_ratings(ratings_list)
    # if the rating_list is not empty
    if ratings_list.present?
      # make it case insentitive
      lowercase_ratings = ratings_list.map(&:downcase)

      # Movie.where() creates a SQL WHERE clause
      where("lower(rating) IN (?)", lowercase_ratings)
    else
      # return all
      all
    end
  end

  def self.sorted_by(sort_column)
    # Check if sort_column has a value and is valid
    if sort_column.present? && ['title', 'release_date'].include?(sort_column)
      # order(:title) sorts by title in ascending order (A to Z)
      order(sort_column.to_sym)
    else
      # If no valid sort column, return unsorted (or sorted by default)
      all
    end
  end

  def self.filtered_and_sorted(ratings_list, sort_column)
    # Start with all movies
    movies = all
    
    # Apply rating filter if present
    movies = movies.with_ratings(ratings_list) if ratings_list.present?
    
    # Apply sorting if present
    movies = movies.sorted_by(sort_column) if sort_column.present?
    
    # Return the combined query
    # ActiveRecord chains these together efficiently
    movies
  end
end
