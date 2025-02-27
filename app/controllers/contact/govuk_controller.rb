require 'slimmer/headers'

class Contact::GovukController < ContactController
  before_filter proc {
    hide_report_a_problem_form_in_response
  }, only: [:anonymous_feedback_thankyou, :named_contact_thankyou]

  def anonymous_feedback_thankyou
  end

  def named_contact_thankyou
  end

  private
  def ticket_class
    ContactTicket
  end

  def type
    :contact
  end
end
