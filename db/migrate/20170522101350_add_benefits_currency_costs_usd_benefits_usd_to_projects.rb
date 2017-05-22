class AddBenefitsCurrencyCostsUsdBenefitsUsdToProjects < ActiveRecord::Migration[5.0]
  def change
    add_column :projects, :benefits_currency, :string
    add_column :projects, :costs_usd, :float
    add_column :projects, :benefits_usd, :float
  end
end
