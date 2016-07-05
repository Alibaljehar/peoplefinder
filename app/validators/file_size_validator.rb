# A simple custom validator that validates the size attribute of
# the records specified file attribute.
#
# examples:
#   - validates :image, file_size: { maximum: 3.megabytes }
#   - validates :file, file_size: { range: 1.kilobyte..3.megabytes, message: 'not in 1KB to 3MB range' }
#
class FileSizeValidator < ActiveModel::EachValidator

  attr_reader :size

  def validate_each(record, attribute, value)
    options.assert_valid_keys :maximum, :range, :message
    @message = options[:message]
    @size = value.size
    add_error(record, attribute, max_message) if options[:maximum].present? && size > options[:maximum]
    add_error(record, attribute, range_message) if options[:range].present? && !options[:range].include?(size)
  end

  private

  def add_error(record, attribute, message)
    record.errors[attribute] << message
  end

  def max_message
    @message || "file size, #{human_size}, is too large"
  end

  def range_message
    @message || "file size, #{human_size}, is not in expected range"
  end

  def human_size
    ActionController::Base.helpers.number_to_human_size(size)
  end

end
