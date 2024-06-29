# Configuration file for the Sphinx documentation builder.

# -- Project information

project = 'AsteRISC'
copyright = '2022-2024, Jonathan Saussereau'
author = 'Jonathan Saussereau'

#release = '0.1'
#version = '0.1.0'

# -- General configuration

extensions = [
    'sphinx.ext.duration',
    'sphinx.ext.doctest',
    'sphinx.ext.autodoc',
    'sphinx.ext.autosummary',
    'sphinx.ext.intersphinx',
    'sphinx_tabs.tabs',
#    'sphinx_inline_tabs',
]

intersphinx_mapping = {
    'python': ('https://docs.python.org/3/', None),
    'sphinx': ('https://www.sphinx-doc.org/en/master/', None),
}
intersphinx_disabled_domains = ['std']

templates_path = ['_templates']

# -- Options for HTML output

html_favicon = "images/asterisc_logo.png"
html_logo = "images/asterisc_infog.png"

#html_theme = 'sphinx_rtd_theme'
html_theme = 'furo'
#html_theme = 'sphinx_book_theme'
#html_theme = 'sphinxawesome_theme'

html_static_path = ['_static']
html_css_files = [
    'css/custom.css',
]

# -- Options for EPUB output
epub_show_urls = 'footnote'
