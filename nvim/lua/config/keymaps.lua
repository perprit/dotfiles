local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "검색 하이라이트 끄기" })
map("n", "<leader>w", "<cmd>write<CR>", { desc = "저장" })
map("n", "<leader>q", "<cmd>quit<CR>", { desc = "닫기" })

-- 창 이동
map("n", "<C-h>", "<C-w>h", { desc = "왼쪽 창" })
map("n", "<C-j>", "<C-w>j", { desc = "아래 창" })
map("n", "<C-k>", "<C-w>k", { desc = "위 창" })
map("n", "<C-l>", "<C-w>l", { desc = "오른쪽 창" })

-- 선택 영역 유지한 채 들여쓰기
map("v", "<", "<gv")
map("v", ">", ">gv")
