<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:opml="http://opml.org/spec2"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>OPML 2.0 のゲッター XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-12-11</xsltdoc:version>
		<xsltdoc:since>2017-12-11</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.opml.org/spec2"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:template name="cxsltl:opml20.get.include">
		<xsl:param name="node" select="@*"/>

		<xsl:variable name="type">
			<xsl:call-template name="cxsltl:opml20.get.type">
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="url" select="normalize-space($node[local-name() = 'url' and (not(namespace-uri()) or (namespace-uri() = 'http://opml.org/spec2'))])"/>

		<xsl:if test="
			(($type = 'include') and string($url)) or
			(($type = 'link') and (substring($url, string-length($url) - 4) = '.opml'))
		">
			<xsl:value-of select="$url"/>
		</xsl:if>
	</xsl:template>

	<xsl:template name="cxsltl:opml20.get.link">
		<xsl:param name="node" select="@*"/>
		<xsl:param name="include">
			<xsl:call-template name="cxsltl:opml20.get.include">
				<xsl:with-param name="node" select="$node"/>
			</xsl:call-template>
		</xsl:param>

		<xsl:choose>
			<xsl:when test="$node[local-name() = 'htmlUrl' and (not(namespace-uri()) or (namespace-uri() = 'http://opml.org/spec2'))]">
				<xsl:value-of select="normalize-space($node[local-name() = 'htmlUrl' and (not(namespace-uri()) or (namespace-uri() = 'http://opml.org/spec2'))])"/>
			</xsl:when>
			<xsl:when test="$node[local-name() = 'xmlUrl' and (not(namespace-uri()) or (namespace-uri() = 'http://opml.org/spec2'))]">
				<xsl:value-of select="normalize-space($node[local-name() = 'xmlUrl' and (not(namespace-uri()) or (namespace-uri() = 'http://opml.org/spec2'))])"/>
			</xsl:when>
			<xsl:when test="not(string($include)) and $node[local-name() = 'url' and (not(namespace-uri()) or (namespace-uri() = 'http://opml.org/spec2'))]">
				<xsl:value-of select="normalize-space($node[local-name() = 'url' and (not(namespace-uri()) or (namespace-uri() = 'http://opml.org/spec2'))])"/>
			</xsl:when>
		</xsl:choose>
	</xsl:template>

	<xsl:template name="cxsltl:opml20.get.type">
		<xsl:param name="node" select="@type | @opml:type"/>

		<xsl:value-of select="translate(
			normalize-space($node[local-name() = 'type' and (not(namespace-uri()) or (namespace-uri() = 'http://opml.org/spec2'))]),
			'ABCDEFGHIJKLMNOPQRSTUVWXYZ',
			'abcdefghijklmnopqrstuvwxyz'
		)"/>
	</xsl:template>
</xsl:stylesheet>