module PullsHelper
  def pull_state_panel(state)
    {'open' => 'panel-success',
     'closed' => 'panel-primary'}[state]
  end
end
