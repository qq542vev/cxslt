<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="library/string.xsl"/>

	<xsl:output method="text" encoding="UTF-8" media-type="text/plain"/>

	<xsl:template match="/">
		<xsl:variable name="c" select="."/>

		<xsl:for-each select="xsl:stylesheet/xsl:import/@href">
			<xsl:variable name="fi">
				<xsl:call-template name="cxsltl:string.lastSubstringAfter">
					<xsl:with-param name="substring">/</xsl:with-param>
				</xsl:call-template>
			</xsl:variable>

			<xsl:variable name="xxx" select="concat(substring-before($fi, '.'), '.')"/>

			<xsl:if test="not($c//@select[contains(., $xxx)] | $c//@name[contains(., $xxx)])">
				<xsl:message>
					<xsl:value-of select="$xxx"/>
					<xsl:value-of select="$c//xsltdoc:short"/>
				</xsl:message>
			</xsl:if>
		</xsl:for-each>

		<xsl:value-of select="'&#xA;'"/>
	</xsl:template>
</xsl:stylesheet>