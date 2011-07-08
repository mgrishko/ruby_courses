require 'spec_helper'

context 'Поставщик вошел.' do
  let (:user) do
    User.destroy_all
    Factory(:supplier)
  end
  let(:gpc) { Gpc.create(:code => '10000115', :name => 'Some Name')}
  let(:item) { Item.create(:user_id => user.id)}
  let(:country) { Country.create(:code=>'RU', :description=>'') }
  let(:base_item) { Factory(:base_item, :user_id=>user.id, :item_id=> item.id, :country_of_origin_code=> country.code, :gpc_code=> gpc.code) }
  before do
    visit login_path
    fill_in('Gln', :with=>user.gln)
    fill_in('Password', :with=>user.password)
    click_button('Login')
  end
  context "Открывает страницу base_item'a, нажимает кнопку правка." do
    before do
      visit base_item_path(base_item)
      click_button('Правка')
    end
    context "Ничего не изменяет." do
      before do
        click_button("Опубликовать")
      end
      it 'ID не должен меняться' do
        BaseItem.first(:conditions=>{:status=>'published', :gtin=>base_item.gtin}, :order=>" id DESC").id.should be_equal(base_item.id)
      end
    end
    context "Вносит изменения." do
      before do
        find("div[@id='base_item']/a").click
        fill_in("base_item_subbrand", :with=> 'another brand')
        click_button("Применить")
        click_button("Опубликовать")
      end
      it 'ID должен меняться' do
        BaseItem.first(:conditions=>{:status=>'published', :gtin=>base_item.gtin}, :order=>"id DESC").id.should_not be_equal(base_item.id)

      end
    end


  end
end

