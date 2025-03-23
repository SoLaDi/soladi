prawn_document(filename: "vereinbarung_#{@membership.id}.pdf", disposition: "attachment") do |pdf|
  pdf.font 'Times-Roman'

  pdf.image "./app/assets//images/logo-bw.png", scale: 0.25

  pdf.indent(330, 5) do
    pdf.font_size 10
    pdf.text "Gärtnerei Apfeltraum, Glaser und Laufer GbR"
    pdf.text "Annette Glaser und Boris Laufer"
    pdf.text "15374 Müncheberg/ OT Eggersdorf"
    pdf.text "Tel.: 033432 - 71410"
    pdf.text "solawi@gaertnerei-apfeltraum.de"
  end
  pdf.move_down 50
  pdf.font_size 12

  pdf.text "SOLAWI-Vereinbarung mit der Gärtnerei Apfeltraum", align: :center, size: 16
  pdf.text "Für die Mitgliedschaft Nr. S#{@membership.id} und Wirtschaftsjahr 2025/2026", align: :center, size: 14
  pdf.move_down 5
  pdf.text "Vom 01.04.2025 - 30.06.2026", align: :center, size: 12
  pdf.move_down 50

  pdf.text "Mir ist bekannt, dass die Teilname an der Jahreshauptversammlung verbindlich ist. Anhand des dort vorgestellten Etats werden die Beiträge festgelegt. Ziel ist die gemeinsame Etatdeckung."
  pdf.move_down 20

  pdf.text "Ich werde mich vom <b>01.04.2025 bis 30.06.2026</b> mit <b>#{@bid.shares} Ernteanteil(en)</b>", inline_format: true
  pdf.text "mit einem monatlichen Gesamtbetrag von <b>#{@bid.monthly_amount}€</b> inkl. 7,8% MwSt beteiligen.", inline_format: true
  pdf.move_down 20
  pdf.text "Die Zahlung erfolgt monatlich bis zum 10. des laufenden Monats an folgende Bankverbindung:"
  pdf.move_down 10

  pdf.bounding_box([0, pdf.cursor], width: 210, height: 70) do
    pdf.transparent(0.5) { pdf.stroke_bounds }
    pdf.move_down 10
    pdf.indent(10, 10) do
      pdf.font_size 12
      pdf.text "Kontoinhaber: Boris Laufer"
      pdf.text "Verwendungszweck: <b>S#{@membership.id}</b>", inline_format: true
      pdf.text "IBAN: DE61 1705 4040 0020 0141 98"
      pdf.text "BIC: WELADED1MOL"
    end
  end

  pdf.move_down 80

  pdf.text 'Die Richtlinien der SOLAWI Gärtnerei Apfeltraum habe ich gelesen und zur Kenntnis genommen und akzeptiere sie als verbindliche Grundlage.'
  pdf.move_down 5
  pdf.font_size 8
  pdf.text "Richtlinie: https://solawi.gaertnerei-apfeltraum.de/wp-content/uploads/2025/03/Richtlinien-SOLAWI-2025.pdf"
  pdf.font_size 12
  pdf.move_down 50

  pdf.text "Ort, Datum: ___________________________"
  pdf.move_down 20
  pdf.text "Name: ________________________________"
  pdf.move_down 20
  pdf.text "Unterschrift: ___________________________"

end
