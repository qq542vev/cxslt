<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.opml20ToRdfXml.stylesheet"
	exclude-result-prefixes="cxsltl opml rdf xsl xsltdoc"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:foaf="http://xmlns.com/foaf/0.1/"
	xmlns:opml="http://opml.org/spec2"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:rdfs="http://www.w3.org/2000/01/rdf-schema#"
	xmlns:xhv="http://www.w3.org/1999/xhtml/vocab#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/date/common.xsl"/>
	<xsl:import href="../library/date/email.xsl"/>
	<xsl:import href="../library/opml20/get.xsl"/>
	<xsl:import href="../library/string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts OPML 2.0 format into RDF/XML format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">OPML 2.0 形式で書かれたファイルを RDF/XML 形式に変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-24</xsltdoc:version>
		<xsltdoc:since>2012-01-07</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.opml.org/spec2"/>
		<xsltdoc:output rdf:resource="http://www.w3.org/TR/rdf-syntax-grammar/"/>
	</xsltdoc:XSLT10Stylesheet>

	<xsl:output method="xml" encoding="UTF-8" version="1.0" indent="no" media-type="application/xml"/>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:opml20ToRdfXml.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opml20ToRdfXml.deny" select="/.."/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のOPML 2.0の要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			RDF/XMLへの変換はxsl:call-templateを使用しcxsltl:opml20ToRdfXml.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnNodeSet xsltdoc:short="RDF/XMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<rdf:RDF>
			<xsl:call-template name="cxsltl:opml20ToRdfXml.convert">
				<xsl:with-param name="node" select="opml"/>
			</xsl:call-template>
		</rdf:RDF>
	</xsl:template>

	<!-- ==============================
		## xsl:template for OPML 2.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:opml20ToRdfXml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToRdfXml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:opml20ToRdfXml.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opml}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{foaf:Document}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opml | opml:opml" mode="cxsltl:opml20ToRdfXml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToRdfXml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<foaf:Document rdf:about="">
			<xsl:apply-templates select="*[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<dcterms:conformsTo rdf:resource="http://www.w3.org/TR/rdf-syntax-grammar/"/>
		</foaf:Document>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{head}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="プロパティー要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="head | opml:head" mode="cxsltl:opml20ToRdfXml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToRdfXml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="*[not(
			self::ownerName | self::ownerEmail | self::ownerId |
			self::opml:ownerName | self::opml:ownerEmail | self::opml:ownerId
		)][count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>

		<xsl:if test="(ownerName | ownerEmail | ownerId | opml:ownerName | opml:ownerEmail | opml:ownerId)[count(. | $deny) != $denyCount]">
			<dcterms:creator rdf:parseType="Resource">
				<xsl:apply-templates select="(ownerName | ownerEmail | ownerId | opml:ownerName | opml:ownerEmail | opml:ownerId)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</dcterms:creator>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{title}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:title}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="title" mode="cxsltl:opml20ToRdfXml.converter">
		<dcterms:title>
			<xsl:value-of select="normalize-space()"/>
		</dcterms:title>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dateCreated}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:created}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="dateCreated" mode="cxsltl:opml20ToRdfXml.converter">
		<dcterms:created rdf:datatype="http://purl.org/dc/terms/W3CDTF">
			<xsl:call-template name="cxsltl:date.email.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
			</xsl:call-template>
		</dcterms:created>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dateModified}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:modified}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="dateModified" mode="cxsltl:opml20ToRdfXml.converter">
		<dcterms:modified rdf:datatype="http://purl.org/dc/terms/W3CDTF">
			<xsl:call-template name="cxsltl:date.email.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
			</xsl:call-template>
		</dcterms:modified>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{ownerName}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{foaf:name}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="ownerName" mode="cxsltl:opml20ToRdfXml.converter">
		<foaf:name>
			<xsl:value-of select="normalize-space()"/>
		</foaf:name>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{ownerEmail}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{foaf:mbox}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="ownerEmail" mode="cxsltl:opml20ToRdfXml.converter">
		<foaf:mbox rdf:resource="mailto:{normalize-space()}"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{ownerId}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:relation}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="ownerId" mode="cxsltl:opml20ToRdfXml.converter">
		<dcterms:relation rdf:resource="{normalize-space()}"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{body}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:hasPart}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="body | opml:body" mode="cxsltl:opml20ToRdfXml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToRdfXml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<dcterms:hasPart>
			<rdf:Seq>
				<xsl:apply-templates select="(outline | opml:outline)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</rdf:Seq>
		</dcterms:hasPart>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{outline}要素をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{rdf:li}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline | opml:outline" mode="cxsltl:opml20ToRdfXml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToRdfXml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<xsl:variable name="include">
			<xsl:call-template name="cxsltl:opml20.get.link">
				<xsl:with-param name="node" select="@*[count(. | $deny) != $denyCount]"/>
			</xsl:call-template>
		</xsl:variable>

		<rdf:li rdf:parseType="Resource">
			<xsl:apply-templates select="(
				@text | @url | @xmlUrl | @created | @category |
				@opml:text | @opml:url | @opml:xmlUrl | @opml:created | @opml:category
			)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>

			<xsl:variable name="children">
				<xsl:apply-templates select="(outline | opml:outline)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>

				<xsl:if test="string($include)">
					<xsl:apply-templates select="
						document($include)[count(. | $deny) != $denyCount]/opml[count(. | $deny) != $denyCount]/body[count(. | $deny) != $denyCount]/outline[count(. | $deny) != $denyCount] |
						document($include)[count(. | $deny) != $denyCount]/opml:opml[count(. | $deny) != $denyCount]/opml:body[count(. | $deny) != $denyCount]/opml:outline[count(. | $deny) != $denyCount]
					" mode="cxsltl:opml20ToRdfXml.converter">
						<xsl:with-param name="deny" select="$deny"/>
						<xsl:with-param name="denyCount" select="$denyCount"/>
					</xsl:apply-templates>
				</xsl:if>
			</xsl:variable>

			<xsl:if test="string($children)">
				<dcterms:hasPart>
					<rdf:Seq>
						<xsl:copy-of select="$children"/>
					</rdf:Seq>
				</dcterms:hasPart>
			</xsl:if>
		</rdf:li>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@text}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{rdfs:label}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@text | @opml:text" mode="cxsltl:opml20ToRdfXml.converter">
		<rdfs:label rdf:datatype="http://www.w3.org/1999/02/22-rdf-syntax-ns#HTML">
			<xsl:value-of select="."/>
		</rdfs:label>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@url}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:references}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@url | @opml:url" mode="cxsltl:opml20ToRdfXml.converter">
		<dcterms:references rdf:resource="{normalize-space()}"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@created}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:created}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@created | @opml:created" mode="cxsltl:opml20ToRdfXml.converter">
		<dcterms:created rdf:datatype="http://purl.org/dc/terms/W3CDTF">
			<xsl:call-template name="cxsltl:date.email.parse">
				<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
			</xsl:call-template>
		</dcterms:created>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@category}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:subject}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@category | @opml:category" mode="cxsltl:opml20ToRdfXml.converter">
		<xsl:call-template name="cxsltl:string.split">
			<xsl:with-param name="string" select="normalize-space()"/>
			<xsl:with-param name="callback" select="$cxsltl:opml20ToRdfXml.self/xsl:template[@name = 'cxsltl:opml20ToRdfXml.callback.category']"/>
			<xsl:with-param name="delimiter">,</xsl:with-param>
		</xsl:call-template>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@xmlUrl}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:references}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@xmlUrl | @opml:xmlUrl" mode="cxsltl:opml20ToRdfXml.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToRdfXml.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>

		<dcterms:references>
			<foaf:Document rdf:about="{normalize-space()}">
				<xsl:apply-templates select="(
						parent::outline/@title | parent::*/@opml:title |
						parent::outline/@description | parent::*/@opml:description |
						parent::outline/@htmlUrl | parent::*/@opml:htmlUrl |
						parent::outline/@language | parent::*/@opml:language |
						parent::outline/@version | parent::*/@opml:version
				)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</foaf:Document>
		</dcterms:references>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@title}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:title}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@title | @opml:title" mode="cxsltl:opml20ToRdfXml.converter">
		<dcterms:title>
			<xsl:value-of select="normalize-space()"/>
		</dcterms:title>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@description}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dcterms:description}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@description | @opml:description" mode="cxsltl:opml20ToRdfXml.converter">
		<dcterms:description>
			<xsl:value-of select="normalize-space()"/>
		</dcterms:description>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@htmlUrl}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{xhv:alternate}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@htmlUrl | @opml:htmlUrl" mode="cxsltl:opml20ToRdfXml.converter">
		<xhv:alternate rdf:resource="{normalize-space()}"/>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@language}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:language}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="
		outline/@language[normalize-space() != 'unknown'] |
		@opml:language[normalize-space() != 'unknown']
	" mode="cxsltl:opml20ToRdfXml.converter">
		<dc:language rdf:datatype="http://purl.org/dc/terms/ISO639-2">
			<xsl:value-of select="normalize-space()"/>
		</dc:language>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@version}属性をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:type}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@version | @opml:version" mode="cxsltl:opml20ToRdfXml.converter">
		<dc:type>
			<xsl:value-of select="normalize-space()"/>
		</dc:type>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>OPML 2.0をRDF/XMLに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:returnNodeSet xsltdoc:short="RDF/XMLを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opml20ToRdfXml.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:opml20ToRdfXml.deny"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToRdfXml.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{$string}を{dc:subject}要素に変換する</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:returnNodeSet xsltdoc:short="{dc:subject}要素を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opml20ToRdfXml.callback.category']" mode="cxsltl:callback" name="cxsltl:opml20ToRdfXml.callback.category">
		<xsl:param name="string" select="."/>

		<dc:subject>
			<xsl:value-of select="$string"/>
		</dc:subject>
	</xsl:template>
</xsl:stylesheet>