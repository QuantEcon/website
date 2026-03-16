---
layout: post
title: "New Tool: MyST Markdown Plugin for Neovim"
author: QuantEcon
excerpt: QuantEcon has released myst-markdown-tree-sitter.nvim, a Neovim plugin that provides syntax highlighting and filetype detection for MyST Markdown files using a tree-sitter backend.
tag: [tools]
---

QuantEcon has released [myst-markdown-tree-sitter.nvim](https://github.com/QuantEcon/myst-markdown-tree-sitter.nvim), a Neovim plugin that provides syntax highlighting and filetype detection for [MyST (Markedly Structured Text)](https://mystmd.org/) markdown files.

The plugin extends standard markdown highlighting with MyST-specific features, including:

- **Code-cell directive highlighting** with language-specific syntax highlighting for `{code-cell}` directives
- **Math directive highlighting** with LaTeX syntax highlighting for `{math}` directives
- **Automatic filetype detection** for MyST markdown files based on content patterns
- **Tree-sitter integration** for robust parsing
- **Comprehensive testing** with 170+ tests

The plugin supports a wide range of languages in code-cell directives, including Python, Julia, R, JavaScript, and more.

For installation instructions and documentation, visit the [project website](https://quantecon.github.io/myst-markdown-tree-sitter.nvim/).
