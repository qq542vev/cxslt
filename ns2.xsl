<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:output method="text" encoding="UTF-8" media-type="application/json"/>

	<xsl:template match="/">
		<xsl:for-each select="//xsltdoc:*/@xsltdoc:*">
			<xsl:value-of select="concat(name(), '&#xA;')"/>
		</xsl:for-each>
	</xsl:template>
</xsl:stylesheet>