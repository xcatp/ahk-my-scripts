此目录下所有脚本依赖于仓库`ahk-lib`，需要先`clone`该仓库。
克隆之后，还需做以下两步，修改此目录下脚本的`Include Path`：

第一步，修改`_IncludeResolve.ahk`中`targetDir`变量值为实际上的`ahk-lib`所在目录。
        可选的修改`outputDir`变量为脚本输出目录，否则直接替换脚本内容。
第二步，运行`_IncludeResolve.ahk`