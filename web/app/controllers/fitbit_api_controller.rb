class FitbitApiController < ApplicationController
  include FitbitApiHelper

  def overall
    devise_id = params[:id]
    @user = User.find_by(id: devise_id)
    client = @user.fitbit_client
    heart_parsed = client.heart_rate_on_date('today')['activities-heart'][0]['value']['restingHeartRate']
    sleep_parsed = client.sleep_logs_on_date('today')['summary']['totalMinutesAsleep']
    steps_parsed = client.steps_on_date('today')['activities-steps'][0]['value']
    @json = {
      'battery': client.device_info[0]['battery'],
      'lastSyncTime': client.device_info[0]['lastSyncTime'],
      'restingHeartRate': heart_parsed,
      'totalMinutesAsleep': format_sleep(sleep_parsed),
      'steps': steps_parsed,
      'status': bad_ok_good_status(heart_parsed, sleep_parsed, steps_parsed),
      'name': client.name['user']['fullName'],
      'avatar': client.name['user']['avatar']
    }
    render json: @json
  end

end
