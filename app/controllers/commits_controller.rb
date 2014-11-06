class CommitsController < ApplicationController
  include ActionController::Live

  before_action :set_sse, only: :stream

  def stream
    begin
      @sse.write($redis.lpop("new_commits_for_#{params["org_id"]}_org"), event: 'results')
    ensure
      @sse.close
    end
  end

  private

  def set_sse
    response.headers['Content-Type'] = 'text/event-stream'
    @sse = SSE.new(response.stream, retry: 500)
  end

end
