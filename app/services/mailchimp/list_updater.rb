# frozen_string_literal: true

class Mailchimp::ListUpdater
  # MailchimpFailed = Class.new(ServiceActionError)

  def initialize(user, subscribe = true)
    @list_id = Explorer.credentials[:mailchimp_audience_id]
    @mailchimp = Gibbon::Request
    @user = user
    @status = subscribe ? 'subscribed' : 'unsubscribed'
  end

  def call
    # raise MailchimpFailed.new unless @mailchimp
    @mailchimp.lists(@list_id).members.create(
        body: user_fields
    )
  rescue Gibbon::MailChimpError => error
    raise error
  end

  def merge_fields
    {
        FNAME: @user.name,
        EMAIL: @user.email
    }
  end

  def user_fields
    {
        email_address: @user.email,
        status: @status,
        merge_fields: merge_fields
    }
  end

end

