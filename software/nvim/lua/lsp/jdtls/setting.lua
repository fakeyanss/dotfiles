local home = os.getenv('HOME')
local setting = {
    java = {
        jdt = {
            ls = {
                vmargs = "-XX:+UseParallelGC -XX:GCTimeRatio=4 -XX:AdaptiveSizePolicyWeight=90 -Dsun.zip.disableMemoryMapping=true -Xmx1G -Xms100m -XX:+UseStringDeduplication -javaagent:'" ..
                    home .. "/.local/share/nvim/lsp_servers/jdtls/lombok/lombok.jar'"
            }
        },
        eclipse = {
            downloadSources = true
        },
        format = {
            comments = {
                enabled = true
            },
            settings = {
                url = 'file://' .. home .. ".config/nvim/lua/lsp/jdtls/eclipse-java-google-style.xml",
                profile = "GoogleStyle"
            }
        },
        maxConcurrentBuilds = 5,
        saveActions = {
            organizeImports = true
        },
        trace = {
            server = "verbose"
        },
        referencesCodeLens = {
            enabled = true
        },
        implementationsCodeLens = {
            enabled = true
        },
        signatureHelp = {
            enabled = true
        },
        contentProvider = {
            preferred = 'fernflower'
        },
        templates = {
            typeComment = {"/**", " * @author: fakeyanss", " * @date: ${date}", " * @description: ", " */"}
        },
        import = {
            maven = {
                enabled = true
            },
            exclusions = {"**/node_modules/**", "**/.metadata/**", "**/archetype-resources/**", "**/META-INF/maven/**",
                          "**/Frontend/**", "**/CSV_Aggregator/**"}
        },
        maven = {
            downloadSources = true
        },
        autobuild = {
            enabled = true
        },
        completion = {
            filteredTypes = {"java.awt.List", "com.sun.*"},
            overwrite = false,
            guessMethodArguments = true,
            favoriteStaticMembers = {"org.hamcrest.MatcherAssert.assertThat", "org.hamcrest.Matchers.*",
                                     "org.hamcrest.CoreMatchers.*", "org.junit.jupiter.api.Assertions.*",
                                     "java.util.Objects.requireNonNull", "java.util.Objects.requireNonNullElse",
                                     "org.mockito.Mockito.*"}
        },
        sources = {
            organizeImports = {
                starThreshold = 9999,
                staticStarThreshold = 9999
            }
        },
        codeGeneration = {
            generateComments = true,
            useBlocks = true,
            toString = {
                template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
            }
        },
        decompiler = {
            fernflower = {
                asc = 1,
                ind = "    "
            }
        },
        home = "/usr/local/lib/jvm/java-11-openjdk/",
        configuration = {
            -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
            -- And search for `interface RuntimeOption`
            -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
            runtimes = {{
                name = "JavaSE-11",
                path = "/usr/local/lib/java/java-11-openjdk"
            }, {
                name = "JavaSE-1.8",
                path = "/usr/local/lib/java/java-8-openjdk",
                default = true
            }}
        }
    }
}

return setting
