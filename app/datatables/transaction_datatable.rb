class TransactionDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegator :@view, :link_to
  def_delegator :@view, :edit_transaction_path
  def_delegator :@view, :membership_url

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      entry_date: { source: "Transaction.entry_date", cond: :like },
      sender: { source: "Transaction.sender", cond: :like },
      description: { source: "Transaction.description", cond: :like },
      amount: { source: "Transaction.amount", cond: :eq, searchable: false },
      currency: { source: "Transaction.currency", cond: :string_eq, searchable: false },
      membership_id: { source: "Transaction.membership_id", cond: :like },
      status_message: { source: "Transaction.status_message", cond: :like, searchable: false },
      status: { source: "Transaction.status", cond: :string_eq },
      details: { source: "Transaction.details", cond: :string_eq, searchable: false },
      edit: { source: "Transaction.edit", cond: :string_eq, searchable: false },
      delete: { source: "Transaction.delete", cond: :string_eq, searchable: false },
    }
  end

  def link_to_membership(id)
    id.nil? ? "" : link_to(id, membership_url(id), target: "_blank")
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        entry_date: record.entry_date,
        sender: record.sender,
        description: record.description,
        amount: record.amount,
        currency: record.currency,
        membership_id: link_to_membership(record.membership_id),
        status_message: record.status_message,
        status: record.status,
        details: link_to("Details", record, target: "_blank"),
        edit: link_to("Bearbeiten", edit_transaction_path(record), target: "_blank"),
        delete: link_to("Löschen", record, method: :delete, data: { confirm: 'Bist du sicher?' }),
      }
    end
  end

  def get_raw_records
    Transaction.all
  end
end
