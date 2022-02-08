prawn_document(filename: "my-file.pdf", disposition: "attachment") do |pdf|
  pdf.text "Mitgliedschaft Nr.: #{@membership.id}"
  pdf.text "Verteilerstelle: #{@membership.distribution_point.name}"

  pdf.move_down 20
  pdf.text "Zugeordnete Mitglieder:"
  members_table_data = @membership.people.collect { |p| [
    p.name,
    p.surname,
    p.email,
    p.phone
  ] }

  members_table_data.unshift(%w[Name Vorname E-Mail Telefon])

  pdf.table(members_table_data)

  pdf.move_down 20
  pdf.text "Zugeordnete Überweisungen:"
  transactions_table_data = @membership.transactions.collect { |p| [
    p.sender,
    p.description,
    p.entry_date,
    p.amount,
    p.status
  ] }

  transactions_table_data.unshift(%w[Absender Buchungstext Datum Betrag Status])

  pdf.table(transactions_table_data)
end
