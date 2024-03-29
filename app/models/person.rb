# == Schema Information
#
# Table name: people
#
#  id                     :integer          not null, primary key
#  name                   :string
#  surname                :string
#  email                  :string
#  phone                  :string
#  membership_id          :integer          not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  website_account_status :string
#  login_token            :string
#
class Person < ApplicationRecord
  belongs_to :membership
  has_one :distribution_point

  has_paper_trail ignore: [:updated_at]

  after_create :create_login_token

  def create_login_token
    token = SecureRandom.hex(16)

    while Person.find_by(login_token: token).present?
      token = SecureRandom.hex(16)
    end

    self.update_attribute(:login_token, token)
  end

  def self.load_from_wordpress
    wp_user = ENV['WP_USER']
    wp_password = ENV['WP_PASSWORD']
    wp_base_url = ENV['WP_BASE_URL']

    conn = Faraday.new do |conn|
      conn.basic_auth(wp_user, wp_password)
      conn.response :logger
      conn.response :json, content_type: /\bjson$/

      conn.adapter Faraday.default_adapter
    end

    loop.with_index do |_, index|
      page = index + 1
      Rails.logger.info("Loading wordpress users page #{page}")
      response = conn.get "#{wp_base_url}/wp-json/wp/v2/users" do |req|
        req.params['context'] = 'edit'
        req.params['page'] = page
        req.headers['Content-Type'] = 'application/json'
      end

      users_chunk = response.body
      break if users_chunk.length == 0

      users_chunk.each do |user|
        user_id = user['id']

        if Person.exists?(user_id)
          existing_person = Person.find(user_id)
          if existing_person.update(
            id: user['id'],
            name: user['first_name'],
            surname: user['last_name'],
            email: user['email'],
            phone: user['meta']['phone_number'],
            website_account_status: user['meta']['account_status'],
            membership_id: user['meta']['membership_id'][1..]
          )
            Rails.logger.info "Successfully updated wp user as member: #{existing_person.inspect}"
          else
            Rails.logger.info "Failed to update member: #{existing_person.errors.inspect}"
          end
        else
          member = Person.new(
            id: user['id'],
            name: user['first_name'],
            surname: user['last_name'],
            email: user['email'],
            phone: user['meta']['phone_number'],
            website_account_status: user['meta']['account_status'],
            membership_id: user['meta']['membership_id'][1..]
          )

          begin
            if member.save
              Rails.logger.info "Successfully persisted wp user as member: #{member.inspect}"
            else
              Rails.logger.info "Failed to persist wp user as member: #{member.errors.inspect}"
            end
          rescue ActiveRecord::RecordNotUnique
            Rails.logger.info "Member already exists: #{member.inspect}"
          end
        end
      end
    end
  end

  def active?
    website_account_status == 'approved'
  end

  def full_name
    "#{name} #{surname}"
  end

  def bidding_app_url
    "#{ENV['BIDDING_APP_BASE_URL']}/mitgliedschaften/#{login_token}"
  end
end
