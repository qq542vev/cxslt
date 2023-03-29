<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.opml20ToIncludedOpml20.stylesheet"
	exclude-result-prefixes="cxsltl rdf xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">Include OPML XSLT</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">OPMLファイルを読み込んで一つのOPMLファイルにします。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-13</xsltdoc:version>
		<xsltdoc:since>2011-10-15</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.opml.org/spec2"/>
		<xsltdoc:output rdf:resource="http://www.opml.org/spec2"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/xml"/>

	<xsl:template match="/ | *" mode="cxsltl:opml20ToIncludedOpml20.converter">
		<xsl:copy>
			<xsl:apply-templates select="node() | @*" mode="cxsltl:opml20ToIncludedOpml20.converter"/>
		</xsl:copy>
	</xsl:template>

	<xsl:template match="text() | comment() | processing-instruction() | @*" mode="cxsltl:opml20ToIncludedOpml20.converter">
		<xsl:copy-of select="."/>
	</xsl:template>

	<xsl:template match="outline[@url][
		(translate(@type, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'include') or
		((translate(@type, 'ABCDEFGHIJKLMNOPQRSTUVWXYZ', 'abcdefghijklmnopqrstuvwxyz') = 'link') and (substring(@url, string-length(@url) - 4) = '.opml'))
	]" mode="cxsltl:opml20ToIncludedOpml20.converter">
		<outline type="text">
			<xsl:apply-templates select="@*[name() != 'type' and name() != 'url'] | document(@url)/opml/body/outline" mode="cxsltl:opml20ToIncludedOpml20.converter"/>
		</outline>
	</xsl:template>
</xsl:stylesheet>