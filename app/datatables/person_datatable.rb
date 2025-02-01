class PersonDatatable < AjaxDatatablesRails::ActiveRecord
  extend Forwardable

  def_delegator :@view, :link_to
  def_delegator :@view, :mail_to
  def_delegator :@view, :edit_person_path
  def_delegator :@view, :membership_url
  def_delegator :@view, :person_url

  def initialize(params, opts = {})
    @view = opts[:view_context]
    super
  end

  def view_columns
    @view_columns ||= {
      id: { source: "Person.id", cond: :like },
      name: { source: "Person.name", cond: :like },
      surname: { source: "Person.surname", cond: :like },
      email: { source: "Person.email", cond: :like, searchable: true },
      phone: { source: "Person.phone", cond: :like, searchable: false },
      membership_id: { source: "Person.membership_id", cond: :like },
      website_account_status: { source: "Person.website_account_status", cond: :like, searchable: false },
      details: { source: "Person.details", cond: :string_eq, searchable: false },
      edit: { source: "Person.edit", cond: :string_eq, searchable: false },
      delete: { source: "Person.delete", cond: :string_eq, searchable: false },
    }
  end

  def link_to_membership(id)
    id.nil? ? "" : link_to(id, membership_url(id), target: "_blank")
  end

  def data
    records.map do |record|
      {
        DT_RowId: record.id,
        id: link_to(record.id, record, target: "_blank"),
        name: record.name,
        surname: record.surname,
        email: mail_to(record.email),
        phone: record.phone,
        membership_id: link_to_membership(record.membership_id),
        website_account_status: record.website_account_status,
        details: link_to("Details", record, target: "_blank"),
        edit: link_to("Bearbeiten", edit_person_path(record), target: "_blank"),
        delete: link_to("Löschen", record, method: :delete, data: { confirm: 'Bist du sicher?' }),
      }
    end
  end

  def get_raw_records
    Person.all
  end
end
