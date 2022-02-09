class CreateOfferSecureTokenForEachPerson < ActiveRecord::Migration[6.0]
  class Person20220209071404 < ActiveRecord::Base
    self.table_name = 'people'
    self.inheritance_column = nil
  end

  def up
    Person20220209071404.reset_column_information

    Person20220209071404.all.each do |person|
      if person.offer_secure_token.nil?
        token = SecureRandom.hex(16)

        while Person20220209071404.find_by(offer_secure_token: token).present?
          token = SecureRandom.hex(16)
        end

        person.update_attribute(:offer_secure_token, token)
      end
    end
  end

  def down; end
end
