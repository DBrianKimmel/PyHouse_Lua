-- info.lua

-- list the files
function ListFiles()
    print("List files")
    list = files.list()
    for k,v in pairs(list) do
        print(k.." : "..v)
    end
end
ListFiles()

-- END DBK