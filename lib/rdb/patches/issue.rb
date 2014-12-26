module Rdb::Patch
  module Issue
    def rdb_id
      @rdb_id ||= begin
        if respond_to?(:issue_id)
          issue_id.to_s
        elsif project.rdb_abbreviation.present?
          "#{project.rdb_abbreviation}-#{id}"
        else
          "##{id}"
        end
      end
    end

    def rdb_css_classes(user = ::User.current)
      s = String.new
      s << ' closed' if closed?
      s << ' overdue' if overdue?
      s << ' child' if child?
      s << ' parent' unless leaf?
      s << ' private' if is_private?
      if user.logged?
        s << ' created-by-me' if author_id == user.id
        s << ' assigned-to-me' if assigned_to_id == user.id
        s << ' assigned-to-my-group' if user.groups.any?{|g| g.id == assigned_to_id}
      end
      s
    end
  end
end

Issue.send :include, Rdb::Patch::Issue
