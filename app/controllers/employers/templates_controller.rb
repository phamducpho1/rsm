class Employers::TemplatesController < Employers::EmployersController
  before_action :load_templates, only: %i(index create)

  def index; end

  def new; end

  def create
    respond_to do |format|
      if @template.save
        format.js{@message = t"employers.templates.form.create"}
      else
        format.js
      end
    end
  end

  def show
    @template = Template.find_by id: params[:id]
    respond_to :js
  end

  def update
    respond_to do |format|
      if @template.update_attributes template_params
        load_templates
        format.js{@message = t "employers.templates.form.update"}
      else
        format.js
      end
    end
  end

  def destroy
    respond_to do |format|
      if @template.destroy
        load_templates
        format.js{@message = t "employers.templates.form.destroy"}
      else
        format.js
      end
    end
  end

  private

  def template_params
    params.require(:template).permit :name, :user_id, :template_body, :type_of
  end

  def load_templates
    @interviewers = Template.template_member.page(params[:page]).per Settings.templates.page
    @candidates = Template.template_user.page(params[:page]).per Settings.templates.page
    @page = params[:page]
  end
end

