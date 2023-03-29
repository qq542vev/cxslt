<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:sy="http://purl.org/rss/1.0/modules/syndication/"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:template name="cxsltl:rss10.module.syndication.elementToSecond">
		<xsl:param name="period" select="sy:updatePeriod"/>
		<xsl:param name="frequency" select="sy:updateFrequency"/>

		<xsl:variable name="_period">
			<xsl:choose>
				<xsl:when test="$period = 'hourly'">3600</xsl:when><!-- 60 * 60 -->
				<xsl:when test="$period = 'daily'">86400</xsl:when><!-- 60 * 60 * 24 -->
				<xsl:when test="$period = 'weekly'">604800</xsl:when><!-- 60 * 60 * 24 * 7 -->
				<xsl:when test="$period = 'monthly'">2629746</xsl:when><!-- 60 * 60 * 24 * 365.2425 / 12 -->
				<xsl:when test="$period = 'yearly'">31556952</xsl:when><!-- 60 * 60 * 24 * 365.2425 -->
				<xsl:otherwise>86400</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:variable name="_frequency">
			<xsl:choose>
				<xsl:when test="$frequency">
					<xsl:value-of select="$frequency"/>
				</xsl:when>
				<xsl:otherwise>1</xsl:otherwise>
			</xsl:choose>
		</xsl:variable>

		<xsl:value-of select="$_period div $_frequency"/>
	</xsl:template>

	<xsl:template name="cxsltl:rss10.module.syndication.secondToElement">
		<xsl:param name="second" select="."/>

		<sy:updatePeriod>yearly</sy:updatePeriod>

		<sy:updateFrequency>
			<xsl:variable name="frequency" select="31556952 div ."/>

			<xsl:choose>
				<xsl:when test="$frequency &lt; 1">1</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="round($frequency)"/>
				</xsl:otherwise>
			</xsl:choose>
		</sy:updateFrequency>
	</xsl:template>
</xsl:stylesheet>