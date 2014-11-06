module ReposHelper

  def observe_label(repo)
    capture_haml do
      repo.observed ? active_label : inactive_label
    end
  end

  def active_label
    haml_tag(:span, class: "label label-success") { haml_concat('Active') }
  end

  def inactive_label
    haml_tag(:span, class: "label label-danger") { haml_concat('Inactive') }
  end

end
