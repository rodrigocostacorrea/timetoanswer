class Site::SearchController < SiteController

  def questions
    @questions = Question._search_ params[:term], params[:page]
  end

  def subject
    @questions = Question._search_subject_ params[:subject_id], params[:page]
  end
end
