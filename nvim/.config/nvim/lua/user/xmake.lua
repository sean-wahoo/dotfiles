local xmake_ok, xmake = pcall(require, "xmake")
if not xmake_ok then
	print("xmake oopsie!")
	return
end

xmake.setup()
