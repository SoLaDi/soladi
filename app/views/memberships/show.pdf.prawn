prawn_document(filename: "mitgliedschaft_#{@membership.id}.pdf", disposition: "attachment") do |pdf|
  pdf.font 'Times-Roman'
  pdf.font_size 16
  pdf.text "Mitgliedschaft Nr.: #{@membership.id}"
  pdf.font_size 10
  pdf.text "Stand.: #{l(Date.today)}"
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

  pdf.table(members_table_data) do |t|
    t.row(0).background_color = 'dae0e5'
  end

  pdf.move_down 20
  pdf.text "Zugeordnete Überweisungen:"
  transactions_table_data = @membership.transactions.collect { |p| [
    p.sender,
    p.description,
    l(p.entry_date),
    number_with_delimiter(p.amount),
    p.status
  ] }

  transactions_table_data.unshift(%w[Absender Buchungstext Datum Betrag Status])

  pdf.table(transactions_table_data) do |t|
    t.row(0).background_color = 'dae0e5'
  end
end
