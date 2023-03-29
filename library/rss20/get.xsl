<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>RSS 2.0 についての XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-12-06</xsltdoc:version>
		<xsltdoc:since>2011-12-06</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.rssboard.org/rss-specification"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>RSS 2.0のE-mailアドレスの型からE-mailアドレスと名前を取得する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:returnString xsltdoc:short="空白区切りのE-mailアドレスと名前を返す"/>
		<xsltdoc:public/>
		<xsltdoc:see rdf:resource="http://www.rssboard.org/rss-profile#data-types-email"/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:rss20.get.email">
		<xsl:param name="string" select="."/>

		<xsl:variable name="normalized" select="normalize-space($string)"/>
		<xsl:variable name="email">
			<xsl:call-template name="cxsltl:string.substringAfter">
				<xsl:with-param name="string">
					<xsl:call-template name="cxsltl:string.substringBefore">
						<xsl:with-param name="string" select="$normalized"/>
						<xsl:with-param name="substring" select="' '"/>
					</xsl:call-template>
				</xsl:with-param>
				<xsl:with-param name="substring">mailto:</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="name">
			<xsl:call-template name="cxsltl:string.bothTrim">
				<xsl:with-param name="string" select="substring-after($normalized, ' ')"/>
				<xsl:with-param name="charlist">()</xsl:with-param>
			</xsl:call-template>
		</xsl:variable>

		<xsl:if test="substring-before($email, '@') and substring-after($email, '@')">
			<xsl:value-of select="$email"/>
		</xsl:if>

		<xsl:text> </xsl:text>

		<xsl:if test="string($name)">
			<xsl:value-of select="$name"/>
		</xsl:if>
	</xsl:template>
</xsl:stylesheet>