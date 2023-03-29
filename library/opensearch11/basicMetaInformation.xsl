<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:moz="http://www.mozilla.org/2006/browser/search/"
	xmlns:opensearch="http://a9.com/-/spec/opensearch/1.1/"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../basicMetaInformation.xsl"/>
	<xsl:import href="../string.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>Open Search 1.1 の基本メタ情報を扱う XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2011-12-08</xsltdoc:version>
		<xsltdoc:since>2011-11-19</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:see rdf:resource="http://www.opensearch.org/Specifications/OpenSearch/1.1"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:opensearch11.basicMetaInformation.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>Open Search 1.1のデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:opensearch11.basicMetaInformation.defaultValue" select="$cxsltl:opensearch11.basicMetaInformation.self/rdf:Description[@xml:id = 'cxsltl.opensearch11.basicMetaInformation.defaultValue']"/>

	<!-- ==============================
		# rdf:Description Element
	 ============================== -->

	<rdf:Description rdf:about="#cxsltl.opensearch11.basicMetaInformation.defaultValue" xml:id="cxsltl.opensearch11.basicMetaInformation.defaultValue">
		<dcterms:title>Search</dcterms:title>
		<dcterms:description>The OpenSearch description document file. Search engine detale.</dcterms:description>
		<dcterms:conformsTo rdf:resource="http://www.opensearch.org/Specifications/OpenSearch/1.1"/>
		<dc:format>application/opensearchdescription+xml</dc:format>
	</rdf:Description>

	<!-- ==============================
		## xsl:template for Open Search 1.1 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:opensearch11.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="node() | @*" mode="cxsltl:opensearch11.basicMetaInformation.geter">
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:opensearch11.basicMetaInformation.geter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>要素を{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:ShortName | opensearch:Description | opensearch:Attribution | moz:SearchForm" mode="cxsltl:opensearch11.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="string" select="normalize-space()"/>
			<xsl:with-param name="type">
				<xsl:choose>
					<xsl:when test="self::opensearch:ShortName">title</xsl:when>
					<xsl:when test="self::opensearch:Description">description</xsl:when>
					<xsl:when test="self::opensearch:Attribution">rights</xsl:when>
					<xsl:when test="self::moz:SearchForm">alternate</xsl:when>
				</xsl:choose>
			</xsl:with-param>
			<xsl:with-param name="position" select="position()"/>
			<xsl:with-param name="last" select="last()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opensearch:Tags}要素を{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opensearch:Tags" mode="cxsltl:opensearch11.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:call-template name="cxsltl:string.split">
			<xsl:with-param name="callback" select="$cxsltl:opensearch11.basicMetaInformation.self/xsl:template[@name = 'cxsltl:opensearch11.basicMetaInformation.callback.Tags']"/>
			<xsl:with-param name="string" select="normalize-space()"/>
			<xsl:with-param name="param1" select="."/>
			<xsl:with-param name="param2" select="$callback"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{$node}から{$type}の値を取得し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="{$node}から取得する値のタイプ"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opensearch11.basicMetaInformation.get']" mode="cxsltl:callback" name="cxsltl:opensearch11.basicMetaInformation.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="defaultValue" select="$cxsltl:opensearch11.basicMetaInformation.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type">title</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="
				(
					$node/opensearch:ShortName[$type = 'title'] |
					$node/opensearch:Description[$type = 'description'] |
					$node/opensearch:Attribution[$type = 'rights'] |
					$node/opensearch:Tags[$type = 'tag'] |
					$node/moz:SearchForm[$type = 'alternate']
				)[count(. | $deny) != $denyCount]
			">
				<xsl:apply-templates select="
					(
						$node/opensearch:ShortName[$type = 'title'] |
						$node/opensearch:Description[$type = 'description'] |
						$node/opensearch:Attribution[$type = 'rights'] |
						$node/opensearch:Tags[$type = 'tag'] |
						$node/moz:SearchForm[$type = 'alternate']
					)[count(. | $deny) != $denyCount]
				" mode="cxsltl:opensearch11.basicMetaInformation.geter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="callback" select="$callback"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="
				$type = 'author' and
				(
					$node/opensearch:Developer |
					$node/opensearch:Contact
				)[count(. | $deny) != $denyCount]
			">
				<xsl:variable name="name" select="$node/opensearch:Developer[count(. | $deny) != $denyCount]"/>
				<xsl:variable name="email" select="$node/opensearch:Contact[count(. | $deny) != $denyCount]"/>

				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="nameNode" select="$name"/>
					<xsl:with-param name="emailNode" select="$email"/>
					<xsl:with-param name="uriNode" select="/.."/>
					<xsl:with-param name="name" select="normalize-space($name)"/>
					<xsl:with-param name="email" select="normalize-space($email)"/>
					<xsl:with-param name="uri"/>
					<xsl:with-param name="type" select="$type"/>
					<xsl:with-param name="position" select="1"/>
					<xsl:with-param name="last" select="1"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:basicMetaInformation.get">
					<xsl:with-param name="node" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="type" select="$type"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

	<xsltdoc:CallbackTemplate>
		<xsltdoc:short>{$string}を受け取り{$param2}にコールバックする</xsltdoc:short>
		<xsltdoc:paramString xsltdoc:name="string" xsltdoc:short="文字列"/>
		<xsltdoc:paramNumber xsltdoc:name="position" xsltdoc:short="文脈ポジション"/>
		<xsltdoc:paramNumber xsltdoc:name="count" xsltdoc:short="文脈サイズ"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param1" xsltdoc:short="元のノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="param2" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:CallbackTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opensearch11.basicMetaInformation.callback.Tags']" mode="cxsltl:callback" name="cxsltl:opensearch11.basicMetaInformation.callback.Tags">
		<xsl:param name="string"/>
		<xsl:param name="position"/>
		<xsl:param name="count"/>
		<xsl:param name="param1" select="/.."/>
		<xsl:param name="param2" select="/.."/>

		<xsl:apply-templates select="$param2" mode="cxsltl:callback">
			<xsl:with-param name="node" select="$param1"/>
			<xsl:with-param name="string" select="$string"/>
			<xsl:with-param name="type">tag</xsl:with-param>
			<xsl:with-param name="position" select="$position"/>
			<xsl:with-param name="last" select="$count"/>
		</xsl:apply-templates>
	</xsl:template>
</xsl:stylesheet>