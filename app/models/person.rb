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
#
class Person < ApplicationRecord
  belongs_to :membership
  has_one :distribution_point

  def self.load_from_wordpress
    wp_user = ENV['WP_USER']
    wp_password = ENV['WP_PASSWORD']
    wp_base_url = ENV['WP_BASE_URL']

    conn = Faraday.new do |conn|
      conn.basic_auth(wp_user, wp_password)
      conn.response :logger
      conn.response :json, :content_type => /\bjson$/

      conn.adapter Faraday.default_adapter
    end

    loop.with_index do |_, index|
      puts index
      response = conn.get "#{wp_base_url}/wp-json/wp/v2/users" do |req|
        req.params['context'] = "edit"
        req.params['page'] = index +1
        req.headers['Content-Type'] = 'application/json'
      end

      users_chunk = response.body
      break if users_chunk.length == 0 || index > 30

      users_chunk.each do |user|
        user_id = user["id"]

        if Person.exists?(user_id)
          existing_person = Person.find(user_id)
          if existing_person.update(
            id: user["id"],
            name: user["first_name"],
            surname: user["last_name"],
            email: user["email"],
            phone: user["meta"]["phone_number"],
            website_account_status: user["meta"]["account_status"],
            membership_id: user["meta"]["membership_id"][1..-1]
          )
            puts "Successfully updated wp user as member: #{existing_person.inspect}"
          else
            puts "Failed to update member: #{existing_person.errors.inspect}"
          end
        else
          member = Person.new(
            id: user["id"],
            name: user["first_name"],
            surname: user["last_name"],
            email: user["email"],
            phone: user["meta"]["phone_number"],
            website_account_status: user["meta"]["account_status"],
            membership_id: user["meta"]["membership_id"][1..-1]
          )

          begin
            if member.save
              puts "Successfully persisted wp user as member: #{member.inspect}"
            else
              puts "Failed to persist wp user as member: #{member.errors.inspect}"
            end
          rescue ActiveRecord::RecordNotUnique
            puts "Member already exists: #{member.inspect}"
          end
        end
      end
    end
  end

  def full_name
    "#{name} #{surname}"
  end
end
