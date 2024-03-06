# frozen_string_literal: true

module ApplicationHelper
  def formatted_file_name(file_name)
    file_name.split('tmp/repositories')[1].split('/')[2..].join('/')
  end

  def repository_link(full_name, commit_id, file_path)
    "https://github.com/#{full_name}/blob/#{commit_id}/#{file_path}"
  end

  def commit_link(full_name, commit_id)
    "https://github.com/#{full_name}/commit/#{commit_id}"
  end

  def flash_class(type)
    case type
    when 'success'
      'alert-success'
    when 'error'
      'alert-danger'
    when 'alert'
      'alert-warning'
    else
      'alert-info'
    end
  end
end
