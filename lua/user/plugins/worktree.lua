local worktree_setup, worktree = pcall(require, "worktree")
if not worktree_setup then
	return
end

worktree.setup()
