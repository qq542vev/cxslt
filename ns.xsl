<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
>
	<xsl:output method="text" encoding="UTF-8" media-type="application/json"/>

	<xsl:template match="/">
		<xsl:variable name="a">
		<xsl:for-each select="xsl:stylesheet/namespace::*">
			<xsl:if test="name() != 'xml'">
				<xsl:value-of select="concat(name(), '|')"/>
			</xsl:if>
		</xsl:for-each>
		</xsl:variable>


		<xsl:variable name="b">
		<xsl:for-each select="xsl:stylesheet/namespace::*">
				<xsl:sort select="name()"/>
			<xsl:if test="name() != 'xml'">
				<xsl:value-of select="concat(name(), '|')"/>
			</xsl:if>
		</xsl:for-each>
		</xsl:variable>

		<xsl:if test="xsl:stylesheet/namespace::rdf">
		<xsl:value-of select="concat($a = $b, '!', $a, '!', $b, '&#xA;')"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>