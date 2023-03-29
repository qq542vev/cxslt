<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:dc="http://purl.org/dc/elements/1.1/"
	xmlns:dcterms="http://purl.org/dc/terms/"
	xmlns:opml="http://opml.org/spec2"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../basicMetaInformation.xsl"/>
	<xsl:import href="../date/common.xsl"/>
	<xsl:import href="../date/email.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short>OPML 2.0 の基本メタ情報を扱う XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-11</xsltdoc:version>
		<xsltdoc:since>2011-11-05</xsltdoc:since>
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

	<xsl:variable name="cxsltl:opml20.basicMetaInformation.self" select="document('')/xsl:stylesheet"/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>OPML 2.0のデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:opml20.basicMetaInformation.defaultValue" select="$cxsltl:opml20.basicMetaInformation.self/rdf:Description[@xml:id = 'cxsltl.opml20.basicMetaInformation.defaultValue']"/>

	<!-- ==============================
		# rdf:Description Element
	 ============================== -->

	<rdf:Description rdf:about="#cxsltl.opml20.basicMetaInformation.defaultValue" xml:id="cxsltl.opml20.basicMetaInformation.defaultValue">
		<dcterms:title>Outline</dcterms:title>
		<dcterms:description>The OPML file. Outline list.</dcterms:description>
		<dcterms:conformsTo rdf:resource="http://www.opml.org/spec2"/>
		<dc:format>application/xml</dc:format>
	</rdf:Description>

	<!-- ==============================
		## xsl:template for OPML 2.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:opml20.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="node() | @*" mode="cxsltl:opml20.basicMetaInformation.geter">
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:opml20.basicMetaInformation.geter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{title}要素を{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="title | opml:title" mode="cxsltl:opml20.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="string" select="normalize-space()"/>
			<xsl:with-param name="type">title</xsl:with-param>
			<xsl:with-param name="position" select="position()"/>
			<xsl:with-param name="last" select="last()"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{dateCreated}要素、{dateModified}要素をISO 8601の日付形式に変換し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="dateCreated | opml:dateCreated | dateModified | opml:dateModified" mode="cxsltl:opml20.basicMetaInformation.geter">
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="string">
				<xsl:call-template name="cxsltl:date.email.parse">
					<xsl:with-param name="callback" select="$cxsltl:date.common.self/xsl:template[@name = 'cxsltl:date.common.toIso8601DateTime']"/>
				</xsl:call-template>
			</xsl:with-param>
			<xsl:with-param name="type">
				<xsl:choose>
					<xsl:when test="self::dateCreated | self::opml:dateCreated">created</xsl:when>
					<xsl:when test="self::dateModified | self::opml:dateModified">modified</xsl:when>
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
		<xsltdoc:short>{$node}から{$type}の値を取得し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="$nodeから取得する値のタイプ"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:return xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opml20.basicMetaInformation.get']" mode="cxsltl:callback" name="cxsltl:opml20.basicMetaInformation.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="/.."/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20.basicMetaInformation.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type">title</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>
		<xsl:variable name="head" select="($node/head | $node/opml:head)[count(. | $deny) != $denyCount]"/>

		<xsl:choose>
			<xsl:when test="(
					$head/title[$type = 'title'] |
					$head/opml:title[$type = 'title'] |
					$head/dateCreated[$type = 'created'] |
					$head/opml:dateCreated[$type = 'created'] |
					$head/dateModified[$type = 'modified'] |
					$head/opml:dateModified[$type = 'modified']
				)[count(. | $deny) != $denyCount]
			">
				<xsl:apply-templates select="(
					$head/title[$type = 'title'] |
					$head/opml:title[$type = 'title'] |
					$head/dateCreated[$type = 'created'] |
					$head/opml:dateCreated[$type = 'created'] |
					$head/dateModified[$type = 'modified'] |
					$head/opml:dateModified[$type = 'modified']
				)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20.basicMetaInformation.geter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="callback" select="$callback"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:when test="
				$type = 'author' and
				(
					$head/ownerName | $head/ownerEmail | $head/ownerId |
					$head/opml:ownerName | $head/opml:ownerEmail | $head/opml:ownerId
				)[count(. | $deny) != $denyCount]
			">
				<xsl:variable name="name" select="($head/ownerName | $head/opml:ownerName)[count(. | $deny) != $denyCount][1]"/>
				<xsl:variable name="email" select="($head/ownerEmail | $head/opml:ownerEmail)[count(. | $deny) != $denyCount][1]"/>
				<xsl:variable name="uri" select="($head/ownerId | $head/opml:ownerId)[count(. | $deny) != $denyCount][1]"/>

				<xsl:apply-templates select="$callback" mode="cxsltl:callback">
					<xsl:with-param name="nameNode" select="$name"/>
					<xsl:with-param name="emailNode" select="$email"/>
					<xsl:with-param name="uriNode" select="$uri"/>
					<xsl:with-param name="name" select="normalize-space($name)"/>
					<xsl:with-param name="email" select="normalize-space($email)"/>
					<xsl:with-param name="uri" select="normalize-space($uri)"/>
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
</xsl:stylesheet>