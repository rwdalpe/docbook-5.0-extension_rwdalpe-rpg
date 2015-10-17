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
			</head>
			<body>
				<nav>
					<xsl:call-template name="toc" />
				</nav>
				<xsl:apply-templates />
			</body>
		</html>
	</xsl:template>

	<xsl:template match="rng:define[not(starts-with(@name, 'db.'))]">
		<section>
			<h1 id="{@name}">
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

			</h1>
			<aside>
				<p>
					Schema identifier:
					<pre>
						<xsl:value-of select="@name" />
					</pre>
				</p>
			</aside>
			<xsl:if test="a:documentation">
				<h2>Documentation</h2>
				<xsl:for-each select="tokenize(a:documentation/text(),'&#xA;&#xA;')">
					<p>
						<xsl:value-of select="normalize-space(.)" />
					</p>
				</xsl:for-each>
			</xsl:if>
			<xsl:call-template name="linksToParents" />
			<xsl:call-template name="linksToChildren" />
		</section>
	</xsl:template>

	<xsl:template name="toc" />

	<xsl:template name="linksToParents">
		<xsl:variable
			name="name"
			select="@name" />


		<xsl:variable
			name="parents"
			select="//rng:define[.//rng:ref[@name = $name]]" />

		<xsl:if test="$parents">
			<h2>Parents</h2>

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
			<h2>Children</h2>
			<ul>
				<xsl:apply-templates mode="children" />
			</ul>
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
				test="(position() != last() and not(parent::rng:choice)) or ((count(../preceding-sibling::rng:*)+1) != count(../../rng:*))">
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