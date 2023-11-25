# frozen_string_literal: true

module ApplicationHelper
  FLASH_CLASSES = {
    'notice' => 'notification is-primary',
    'success' => 'notification is-success',
    'error' => 'notification is-danger',
    'alert' => 'notification is-warning'
  }.freeze

  def flash_class(level)
    FLASH_CLASSES[level]
  end

  private_constant :FLASH_CLASSES
end
