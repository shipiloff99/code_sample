# frozen_string_literal: true

require 'roo'

class ImportsController < ApplicationController
  def new; end

  def create
    file_format = params[:file].content_type
    return false unless file_format == 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'

    file = Roo::Excelx.new(params[:file].tempfile) # opening xlsx file for parsing rows with accounts.
    UploadAccountsFromXlsxToApiService.new.run(file)

    flash[:notice] = 'Successfully uploaded!'
    redirect_to new_import_path
  end
end
