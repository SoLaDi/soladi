class BidDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_bid_path
  def_delegator :@view, :membership_url
  def_delegator :@view, :person_url

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      membership_id: { source: "Bid.membership_id", cond: :like },
      start_date: { source: "Bid.start_date", cond: :like },
      end_date: { source: "Bid.end_date", cond: :like },
      amount: { source: "Bid.amount", cond: :eq },
      shares: { source: "Bid.shares", cond: :eq, searchable: false },
      contract_signed: { source: "Bid.contract_signed", cond: :string_eq, searchable: false },
      placed_by: { source: "Bid.person", cond: :string_eq, searchable: false , orderable: false},
      details: { source: "Bid.details", cond: :string_eq, searchable: false, orderable: false },
      edit: { source: "Bid.edit", cond: :string_eq, searchable: false, orderable: false },
      delete: { source: "Bid.delete", cond: :string_eq, searchable: false, orderable: false }
    }
  end

  def link_to_membership(id)
    id.nil? ? "" : link_to(id, membership_url(id), target: "_blank")
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        membership_id: link_to_membership(record.membership_id),
        start_date: record.start_date,
        end_date: record.end_date,
        amount: record.amount,
        shares: record.shares,
        contract_signed: record.contract_signed,
        placed_by: record.person ? (link_to "#{record.person.name} #{record.person.surname}", person_url(record.person.id)) : "n.a.",
        details: link_to("Details", record, target: "_blank"),
        edit: link_to("Bearbeiten", edit_bid_path(record), target: "_blank"),
        delete: link_to("Löschen", record, method: :delete, data: { confirm: 'Bist du sicher?' }),
      }
    end
  end

  def get_raw_records
    Bid.all
  end
end
