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
		<xsltdoc:short>CSVを扱うスタイルシート</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-08-28</xsltdoc:version>
		<xsltdoc:since>2014-08-28</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="https://www.ietf.org/rfc/rfc4180.txt"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>CSVの特殊文字をエスケープする</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="エスケープを行う文字列"/>
		<xsltdoc:returnString xsltdoc:short="エスケープされた文字列を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:csv.generate.escape">
		<xsl:param name="string" select="."/>

		<xsl:text>"</xsl:text>

		<xsl:call-template name="cxsltl:string.replace">
			<xsl:with-param name="string" select="$string"/>
			<xsl:with-param name="src">"</xsl:with-param>
			<xsl:with-param name="dst">""</xsl:with-param>
		</xsl:call-template>

		<xsl:text>"</xsl:text>
	</xsl:template>
</xsl:stylesheet>
