Fabricator(:membership) do
  account!
  user!
  role "editor"
  invited_by { |m| m.account.owner }
  invitation_note  { Faker::Lorem.sentence }
end

Fabricator(:admin_membership, from: :membership) do
  role "admin"
end

Fabricator(:owner_membership, from: :admin_membership) do
  user { |m| m.account.owner }
end

Fabricator(:editor_membership, from: :membership) do
  role "editor"
end

Fabricator(:contributor_membership, from: :membership) do
  role "contributor"
end

Fabricator(:viewer_membership, from: :membership) do
  role "viewer"
end
