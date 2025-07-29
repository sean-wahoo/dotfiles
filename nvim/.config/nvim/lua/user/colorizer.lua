local ok, colorizer = pcall(require, "colorizer")
if not ok then
	print("colorizer failed to load")
	return
end

colorizer.setup({
	"css",
})
