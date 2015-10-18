<?xml version="1.0" encoding="UTF-8"?>
<!--
	Copyright (C) 2015 Robert Winslow Dalpe

	This program is free software: you can redistribute it and/or modify
	it under the terms of the GNU Affero General Public License as published
	by the Free Software Foundation, either version 3 of the License, or
	(at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
	GNU Affero General Public License for more details.

	You should have received a copy of the GNU Affero General Public License
	along with this program. If not, see <http://www.gnu.org/licenses/>.
-->
<xsl:stylesheet
	version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:a="http://relaxng.org/ns/compatibility/annotations/1.0"
	xmlns:rng="http://relaxng.org/ns/structure/1.0"
	xmlns:h="http://www.w3.org/1999/xhtml"
	xmlns="http://www.w3.org/1999/xhtml">

	<xsl:param name="version" />

	<xsl:output
		method="html"
		omit-xml-declaration="yes"
		indent="yes"
		exclude-result-prefixes="xsl a rng " />

	<xsl:template match="text()|comment()|processing-instruction()" />

	<xsl:template match="/">
		<html>
			<head>
				<title>
					docbook-5.0-extension_rwdalpe-rpg version
					<xsl:value-of select="$version" />
					documentation
				</title>
				<style>
					<![CDATA[
						nav#toc {
							background-color: white;
							font-size: .75em;
							position: fixed;
							top: 0px;
							left: 0px;
							height: 100%;
							width: 30em;
							overflow-x: scroll;
							overflow-y: scroll;
							margin: 0px;
						}
						nav#toc ul {
							list-style-type:none;
							margin: 0px;
							padding: .5em;
						}
						body {
							margin-left: 24em;
						}
						section.define {
							border-top: 1px solid black;
						}
						section.define:last-of-type {
							border-bottom: 1px solid black;
						}
						section section {
							margin-left: 2em;
						}
						@media screen and (max-width:30em)
						{
							nav#toc {
								width: 100%;
								height: 13em;
							}
							body {
								margin: 0px;
								margin-top: 10em;
								word-wrap: break-word;
							}
							pre {
								word-wrap: break-word;
							}
							
							section section {
								margin-left: .5em;
							}
							section section ul {
								padding-left: .75em;
							}
						}
					]]>
				</style>
			</head>
			<body>
				<nav id="toc">
					<xsl:call-template name="toc" />
				</nav>
				<h1>
					docbook-5.0-extension_rwdalpe-rpg version
					<xsl:value-of select="$version" />
					documentation
				</h1>
				<aside>
					<p>
						These are schema extensions for DocBook 5.0 that provider a
						grammar for marking up concepts present in various table-top
						role-playing games (TTRPGs).
					</p>
					<p>
						See project details at
						<a href="https://github.com/rwdalpe/docbook-5.0-extension_rwdalpe-rpg">https://github.com/rwdalpe/docbook-5.0-extension_rwdalpe-rpg
						</a>
					</p>
					<p>
						Copyright (C) 2015 Robert Winslow Dalpe
					</p>
					<p>
						This program is free software: you can redistribute it and/or
						modify it under the terms of the GNU Affero General Public License
						as published by the Free Software Foundation, either version 3 of
						the License, or (at your option) any later version.
					</p>
					<p>
						This program is distributed in the hope that it will be useful,
						but WITHOUT ANY WARRANTY; without even the implied warranty of
						MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
						Affero General Public License for more details.
					</p>
					<p>
						You should have received a copy of the GNU Affero General Public
						License along with this program. If not, see
						<a href="http://www.gnu.org/licenses/">http://www.gnu.org/licenses/</a>
						.
					</p>
				</aside>
				<section id="general">
					<h2>General Documentation</h2>
					<xsl:for-each
						select="tokenize(/rng:grammar/a:documentation/text(),'&#xA;&#xA;')">
						<p>
							<xsl:value-of select="normalize-space(.)" />
						</p>
					</xsl:for-each>
				</section>
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="rng:define[not(starts-with(@name, 'db.'))]">
		<section class="define">
			<h2 id="{@name}">
				<xsl:choose>
					<xsl:when test="./rng:element">
						Element
						<span style="font-family: monospace;">
							<xsl:value-of select="./rng:element/@name" />
						</span>
					</xsl:when>
					<xsl:when test="./rng:attribute">
						Attribute
						<span style="font-family: monospace;">
							<xsl:value-of select="./rng:attribute/@name" />
						</span>
					</xsl:when>
					<xsl:otherwise>
						Logical Grouping
						<span style="font-family: monospace;">
							<xsl:value-of select="@name" />
						</span>
					</xsl:otherwise>
				</xsl:choose>
			</h2>
			<aside>
				<p>
					Schema identifier:
					<span style="font-family: monospace;">
						<xsl:value-of select="@name" />
					</span>
				</p>
			</aside>

			<xsl:if test="a:documentation">
				<section class="docs">
					<h3>Documentation</h3>
					<xsl:for-each select="tokenize(a:documentation/text(),'&#xA;&#xA;')">
						<p>
							<xsl:value-of select="normalize-space(.)" />
						</p>
					</xsl:for-each>
				</section>
			</xsl:if>
			<xsl:call-template name="linksToParents" />
			<xsl:call-template name="linksToChildren" />
		</section>
	</xsl:template>

	<xsl:template name="toc">
		<h2>Contents</h2>
		<ul>
			<li>
				<a href="#general">General Documentation</a>
			</li>
			<xsl:for-each
				select="/rng:grammar/rng:define[not(starts-with(@name, 'db.'))]">
				<li>
					<a href="#{@name}">
						<xsl:value-of select="@name" />
					</a>
				</li>
			</xsl:for-each>
		</ul>
	</xsl:template>

	<xsl:template name="linksToParents">
		<xsl:variable
			name="name"
			select="@name" />


		<xsl:variable
			name="parents"
			select="//rng:define[.//rng:ref[@name = $name]]" />

		<xsl:if test="$parents">
			<section class="parents">
				<h3>Parents</h3>

				<ul>
					<xsl:for-each select="$parents">
						<li>
							<xsl:choose>
								<xsl:when test="not(starts-with(@name, 'db.'))">
									<a href="#{@name}">
										<xsl:value-of select="@name" />
									</a>
								</xsl:when>
								<xsl:otherwise>
									<xsl:value-of select="@name" />
								</xsl:otherwise>
							</xsl:choose>
						</li>
					</xsl:for-each>
				</ul>
			</section>
		</xsl:if>
	</xsl:template>

	<xsl:template name="linksToChildren">
		<xsl:variable
			name="name"
			select="@name" />

		<xsl:variable
			name="hasChildren"
			select=".//rng:ref" />


		<xsl:if test="$hasChildren">
			<section class="children">
				<h3>Children</h3>
				<ul>
					<xsl:apply-templates mode="children" />
				</ul>
			</section>
		</xsl:if>
	</xsl:template>

	<xsl:template
		match="*"
		mode="children">
		<xsl:apply-templates
			select="./*"
			mode="children" />
	</xsl:template>

	<xsl:template
		match="rng:ref"
		mode="children">
		<li>
			<xsl:choose>
				<xsl:when test="not(starts-with(@name, 'db.'))">
					<a href="#{@name}">
						<xsl:value-of select="@name" />
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="@name" />
				</xsl:otherwise>
			</xsl:choose>
			<xsl:choose>
				<xsl:when test="parent::rng:optional">
					?
				</xsl:when>
				<xsl:when test="parent::rng:zeroOrMore">
					*
				</xsl:when>
				<xsl:when test="parent::rng:oneOrMore">
					+
				</xsl:when>
				<xsl:otherwise />
			</xsl:choose>
			<xsl:if
				test="((count(preceding-sibling::rng:*)+1) != count(../rng:*) and not(parent::rng:choice)) or (not(parent::rng:define) and (count(../preceding-sibling::rng:*)+1) != count(../../rng:*))">
				,
			</xsl:if>
		</li>
	</xsl:template>

	<xsl:template
		match="rng:choice"
		mode="children">
		<li>
			<xsl:choose>
				<xsl:when test="parent::rng:oneOrMore">
					one or more of:
				</xsl:when>
				<xsl:when test="parent::rng:zeroOrMore">
					zero or more of:
				</xsl:when>
				<xsl:when test="parent::rng:optional">
					optional single choice of:
				</xsl:when>
				<xsl:otherwise>
					one of:
				</xsl:otherwise>
			</xsl:choose>
			<ul>
				<xsl:apply-templates mode="children" />
			</ul>
		</li>
	</xsl:template>

	<xsl:template
		match="rng:group"
		mode="children">
		<li>
			<xsl:choose>
				<xsl:when test="parent::rng:oneOrMore">
					one or more of your
				</xsl:when>
				<xsl:when test="parent::rng:zeroOrMore">
					zero or more of your
				</xsl:when>
				<xsl:when test="parent::rng:optional">
					optional
				</xsl:when>
				<xsl:otherwise />
			</xsl:choose>
			(
			<ul>
				<xsl:apply-templates mode="children" />
			</ul>
			)
		</li>
	</xsl:template>

</xsl:stylesheet>