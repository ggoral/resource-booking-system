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
    status = status ? status : 'approved'
    halt 400 unless ['approved','pending','all'].include? status
    status = nil if status == 'all'
    status
  end

  def validate_presence_param(param) 
    halt 400 if param.nil?
    param
  end

  def validate_permited_params(params,arr)
    halt 400 if (params.keys & arr).empty?
  end
end
