Fabricator(:membership) do
  account!
  user!#_id { Fabricate(:user).id }
  role "editor"
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