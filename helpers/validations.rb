module Validations
  
  def validate_param_date(date)
    date = date ? date.to_date : Date.today + 1
    halt 400 unless date.is_a? Date
    date
  end

  def validate_param_limit(limit)
    limit = limit ? limit : 30
    halt 400 if (Integer limit) >= 0 and (Integer limit) > 365
    limit
  end

  def validate_param_status(status)
    status = params['status'] ? params['status'] : 'approved'
    halt 400 unless ['approved','pending','all'].include? status
    status = nil if status == 'all'
    status
  end

end
