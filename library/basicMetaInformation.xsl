<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>XMLの基本メタ情報を扱う XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-22</xsltdoc:version>
		<xsltdoc:since>2017-10-22</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.opml.org/spec2"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:basicMetaInformation.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>XMLのデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:basicMetaInformation.defaultValue" select="$cxsltl:basicMetaInformation.self/rdf:Description[@xml:id = 'cxsltl.basicMetaInformation.defaultValue']"/>

	<!-- ==============================
		# rdf:Description Element
	 ============================== -->

	<rdf:Description rdf:about="#cxsltl.basicMetaInformation.defaultValue" xml:id="cxsltl.basicMetaInformation.defaultValue">
		<dcterms:title>XML file</dcterms:title>
		<dcterms:description>The Extensible Markup Language file.</dcterms:description>
		<dcterms:conformsTo rdf:resource="http://www.w3.org/TR/xml/"/>
		<dc:format>application/xml</dc:format>
	</rdf:Description>

	<!-- ==============================
		## xsl:template for element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="node() | @*" mode="cxsltl:basicMetaInformation.geter">
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:basicMetaInformation.geter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素を{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="dcterms:title | dcterms:description | dcterms:conformsTo/@rdf:resource | dc:format" mode="cxsltl:basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="string" select="normalize-space()"/>
			<xsl:with-param name="type">
				<xsl:choose>
					<xsl:when test="self::dc:format">mime</xsl:when>
					<xsl:when test="parent::dcterms:conformsTo">conform</xsl:when>
					<xsl:otherwise>
						<xsl:value-of select="normalize-space()"/>
					</xsl:otherwise>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="position" select="position()"/>
			<xsl:with-param name="last" select="last()"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>$nodeから$typeの値を取得し$callbackにコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="$nodeから取得する値のタイプ"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:basicMetaInformation.get']" mode="cxsltl:callback" name="cxsltl:basicMetaInformation.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="type"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="
			$node/dcterms:title[$type = 'title'] |
			$node/dcterms:description[$type = 'description'] |
			$node/dcterms:conformsTo[$type = 'conform'] |
			$node/dc:format[$type = 'mime']
		" mode="cxsltl:basicMetaInformation.geter">
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsl:template match="xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']" mode="cxsltl:callback" name="cxsltl:basicMetaInformation.callback.print">
		<xsl:param name="string"/>

		<xsl:copy-of select="$string"/>
	</xsl:template>
</xsl:stylesheet>