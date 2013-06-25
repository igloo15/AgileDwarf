class Sprints < Version
  unloadable

  validate :start_and_end_dates

  class << self
    def open_sprints(project)
      scoped(:order => 'ir_start_date ASC, ir_end_date ASC', :conditions => [ "status = 'open' and project_id in (?)", project.shared_versions.all ])
    end
    def all_sprints(project)
      scoped(:order => 'ir_start_date ASC, ir_end_date ASC', :conditions => [ "project_id in (?)", project.shared_versions.all ])
    end
  end

  def start_and_end_dates
    errors.add_to_base("Sprint cannot end before it starts") if self.ir_start_date && self.ir_end_date && self.ir_start_date >= self.ir_end_date
  end

  def tasks
    SprintsTasks.get_tasks_by_sprint(self.project, self.id)
  end

end