class ReportsController < ApplicationController
  before_action :set_entry, :set_paper_trail_whodunnit, :authenticate_user!
  before_action :set_report, except: [:new, :create]
  skip_before_action :verify_authenticity_token, :only => [:create]
  invisible_captcha only: [:create]
  before_action :require_username

  def new
    custom_meta_tags('Report Translation',
                     "Report translation.",
                     %w[report learn oshiwambo])

    @report = Report.new
  end

  def create
    @report = @entry.reports.build(report_params)

    @report.user_id = current_user.id
    if @report.save
      flash[:notice] = "Translation reported."
      redirect_to reports_path
    else
      flash.now[:error] = @report.errors.full_messages[0]
      render :new
    end
  end

  def destroy
    if @report.destroy

    else
      flash.now[:error] = @report.errors.full_messages[0]
    end
  end

  private

  def set_report
    @report = @entry.reports.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:content, entry: @entry, user: current_user)
  end

  def set_entry
    @entry = Entry.friendly.find(params[:entry_id])
  end
end
