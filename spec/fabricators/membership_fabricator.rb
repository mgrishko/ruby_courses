Fabricator(:membership) do
  account!
  user!
  role "editor"
  invited_by { |m| m.account.owner }
end

Fabricator(:admin_membership, from: :membership) do
  role "admin"
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
