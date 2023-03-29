<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
	<xsl:output method="text" encoding="UTF-8" media-type="application/json"/>

	<xsl:template match="/">
		<xsl:variable name="c" select="."/>
		<xsl:for-each select="xsl:stylesheet/namespace::*">
			<xsl:if test="name() != 'xml' and name() != 'cxsltl' and name() != 'xsltdoc' and name() != 'rdf' and (not($c//*[namespace-uri() = current()]))">
				<xsl:value-of select="concat(name(), '|')"/>
			</xsl:if>
		</xsl:for-each>

				<xsl:value-of select="'&#xA;'"/>

	</xsl:template>
</xsl:stylesheet>