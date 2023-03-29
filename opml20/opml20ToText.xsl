<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
	version="1.0"
	id="cxsltl.opml20ToText.stylesheet"
	xmlns:cxsltl="http://purl.org/meta/ns/xslt/#"
	xmlns:opml="http://opml.org/spec2"
	xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
	xmlns:xsltdoc="http://purl.org/meta/ns/xslt/xsltdoc/#"
>
	<xsl:import href="../library/basicMetaInformation.xsl"/>
	<xsl:import href="../library/opml20/basicMetaInformation.xsl"/>
	<xsl:import href="../library/opml20/get.xsl"/>
	<xsl:import href="../library/template/text.xsl"/>
	<xsl:import href="../library/string.xsl"/>
	<xsl:import href="../library/xml/generate.xsl"/>

	<xsltdoc:XSLT10Stylesheet rdf:about="">
		<xsltdoc:short xml:lang="en">XSLT Stylesheet which converts OPML 2.0 format into Plain Text format.</xsltdoc:short>
		<xsltdoc:short xml:lang="ja">OPML 2.0 形式で書かれたファイルを整形済みテキストに変換する XSLT です。</xsltdoc:short>
		<xsltdoc:author rdf:resource="http://purl.org/meta/me/"/>
		<xsltdoc:version>2017-10-11</xsltdoc:version>
		<xsltdoc:since>2011-11-05</xsltdoc:since>
		<xsltdoc:license rdf:resource="https://creativecommons.org/licenses/by/4.0/"/>
		<xsltdoc:input rdf:resource="http://www.opml.org/spec2"/>
		<xsltdoc:output rdf:resource="https://michelf.ca/projects/php-markdown/extra/"/>
	</xsltdoc:XSLT10Stylesheet>

	<!-- ==============================
		# xsl:variable Element
	 ============================== -->

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>このスタイルシートのノード</xsltdoc:short>
		<xsltdoc:public/>
		<xsltdoc:final/>
	</xsltdoc:NodeSetVariable>

	<xsl:variable name="cxsltl:opml20ToText.self" select="document('')/xsl:stylesheet"/>

	<!-- ==============================
		# xsl:param Element
	 ============================== -->

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでの変換を除外するノードセット</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opml20ToText.deny" select="/.."/>

	<xsltdoc:NodeSetVariable>
		<xsltdoc:short>OPML 2.0のデフォルト値</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetVariable>

	<xsl:param name="cxsltl:opml20ToText.defaultValue" select="$cxsltl:opml20.basicMetaInformation.defaultValue"/>

	<xsltdoc:NodeSetParam>
		<xsltdoc:short>デフォルトでのコールバックするテンプレート</xsltdoc:short>
		<xsltdoc:public/>
	</xsltdoc:NodeSetParam>

	<xsl:param name="cxsltl:opml20ToText.callback" select="$cxsltl:template.text.layout"/>

	<!-- ==============================
		# Ruled xsl:template
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノード以下のOPML 2.0の要素を整形済みテキストに変換する</xsltdoc:short>
		<xsltdoc:detail>
			このXSLTでXMLを変換した場合、最初に呼び出される。
			アクセス修飾子はpublicとなっているが、xsl:apply-templatesからこのテンプレートを適用すべきではない。
			整形済みテキストへの変換はxsl:call-templateを使用しcxsltl:opml20ToText.convertを呼び出すべきである。
		</xsltdoc:detail>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:public/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/">
		<xsl:call-template name="cxsltl:opml20ToText.convert">
			<xsl:with-param name="node" select="opml"/>
		</xsl:call-template>
	</xsl:template>

	<!-- ==============================
		## xsl:template for OPML 2.0 element
	 ============================== -->

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>ルートノードと要素ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="OPML 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="/ | *" mode="cxsltl:opml20ToText.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToText.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20ToText.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opml20ToText.callback"/>

		<xsl:apply-templates select="(node() | @*)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToText.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>テキストノードと属性ノードのベーステンプレート</xsltdoc:short>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="text() | @*" mode="cxsltl:opml20ToText.converter"/>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{opml}要素を整形済みテキストに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="OPML 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="opml | opml:opml" mode="cxsltl:opml20ToText.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToText.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20ToText.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opml20ToText.callback"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="."/>
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$cxsltl:opml20ToText.self/xsl:template[@name = 'cxsltl:opml20ToText.get']"/>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{body}要素を整形済みテキストに変換して{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnString xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="body | opml:body" mode="cxsltl:opml20ToText.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToText.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>

		<xsl:apply-templates select="$callback" mode="cxsltl:callback">
			<xsl:with-param name="node" select="outline[count(. | $deny) != $denyCount]"/>
			<xsl:with-param name="string">
				<xsl:apply-templates select="outline[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToText.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="denyCount" select="$denyCount"/>
				</xsl:apply-templates>
			</xsl:with-param>
			<xsl:with-param name="type">content</xsl:with-param>
		</xsl:apply-templates>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{outline}要素を整形済みテキストに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNumber xsltdoc:name="denyCount" xsltdoc:short="{$deny}の個数"/>
		<xsltdoc:paramNumber xsltdoc:name="depth" xsltdoc:short="{outline}要素の深度"/>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline | opml:outline" mode="cxsltl:opml20ToText.converter">
		<xsl:param name="deny" select="$cxsltl:opml20ToText.deny"/>
		<xsl:param name="denyCount" select="count($deny)"/>
		<xsl:param name="depth" select="0"/>

		<xsl:variable name="text">
			<xsl:apply-templates select="(@text | @opml:text)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToText.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
			</xsl:apply-templates>
		</xsl:variable>
		<xsl:variable name="include">
			<xsl:call-template name="cxsltl:opml20.get.link">
				<xsl:with-param name="node" select="@*[count(. | $deny) != $denyCount]"/>
			</xsl:call-template>
		</xsl:variable>
		<xsl:variable name="link">
			<xsl:call-template name="cxsltl:opml20.get.link">
				<xsl:with-param name="node" select="@*[count(. | $deny) != $denyCount]"/>
			</xsl:call-template>
		</xsl:variable>

		<xsl:call-template name="cxsltl:string.repeat">
			<xsl:with-param name="string" select="' '"/>
			<xsl:with-param name="multiplier" select="($depth * 4) + string-length(last()) - string-length(position())"/>
		</xsl:call-template>

		<xsl:value-of select="concat(position(), '. ')"/>

		<xsl:choose>
			<xsl:when test="string($link)">
				<xsl:value-of select="concat('[', $text, '](', $link, ')')"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$text"/>
			</xsl:otherwise>
		</xsl:choose>

		<xsl:text>&#xA;</xsl:text>

		<xsl:apply-templates select="(outline | opml:outline)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToText.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="depth" select="$depth + 1"/>
		</xsl:apply-templates>

		<xsl:if test="string($include)">
				<xsl:apply-templates select="
					document($include)[count(. | $deny) != $denyCount]/opml[count(. | $deny) != $denyCount]/body[count(. | $deny) != $denyCount]/outline[count(. | $deny) != $denyCount] |
					document($include)[count(. | $deny) != $denyCount]/opml:opml[count(. | $deny) != $denyCount]/opml:body[count(. | $deny) != $denyCount]/opml:outline[count(. | $deny) != $denyCount]
				" mode="cxsltl:opml20ToText.converter">
				<xsl:with-param name="deny" select="$deny"/>
				<xsl:with-param name="denyCount" select="$denyCount"/>
				<xsl:with-param name="depth" select="$depth + 1"/>
			</xsl:apply-templates>
		</xsl:if>
	</xsl:template>

	<xsltdoc:RuledTemplate>
		<xsltdoc:short>{@text}属性を整形済みテキストに変換する</xsltdoc:short>
		<xsltdoc:returnString xsltdoc:short="タグを取り除いた値を返す"/>
		<xsltdoc:protected/>
	</xsltdoc:RuledTemplate>

	<xsl:template match="outline/@text | @opml:text" mode="cxsltl:opml20ToText.converter">
		<xsl:call-template name="cxsltl:xml.generate.removeTags"/>
	</xsl:template>

	<!-- ==============================
		# Named Template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>OPML 2.0を整形済みテキストに変換する</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="OPML 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:returnString xsltdoc:short="整形済みテキストを返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template name="cxsltl:opml20ToText.convert">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:opml20ToText.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20ToText.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:opml20ToText.callback"/>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:apply-templates select="$node[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToText.converter">
			<xsl:with-param name="deny" select="$deny"/>
			<xsl:with-param name="denyCount" select="$denyCount"/>
			<xsl:with-param name="defaultValue" select="$defaultValue"/>
			<xsl:with-param name="callback" select="$callback"/>
		</xsl:apply-templates>
	</xsl:template>

	<!-- ==============================
		# Callback xsl:template
	 ============================== -->

	<xsltdoc:NamedTemplate>
		<xsltdoc:short>{$node}から{$type}の値を取得し{$callback}にコールバックする</xsltdoc:short>
		<xsltdoc:paramNodeSet xsltdoc:name="node" xsltdoc:short="対象とするノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="deny" xsltdoc:short="変換を除外するノード"/>
		<xsltdoc:paramNodeSet xsltdoc:name="defaultValue" xsltdoc:short="OPML 2.0のデフォルト値"/>
		<xsltdoc:paramNodeSet xsltdoc:name="callback" xsltdoc:short="コールバックするテンプレート"/>
		<xsltdoc:paramString xsltdoc:name="type" xsltdoc:short="{$node}から取得する値のタイプ"/>
		<xsltdoc:returnString xsltdoc:short="コールバックした結果を返す"/>
		<xsltdoc:public/>
	</xsltdoc:NamedTemplate>

	<xsl:template match="xsl:template[@name = 'cxsltl:opml20ToText.get']" mode="cxsltl:callback" name="cxsltl:opml20ToText.get">
		<xsl:param name="node" select="."/>
		<xsl:param name="deny" select="$cxsltl:opml20ToText.deny"/>
		<xsl:param name="defaultValue" select="$cxsltl:opml20ToText.defaultValue"/>
		<xsl:param name="callback" select="$cxsltl:basicMetaInformation.self/xsl:template[@name = 'cxsltl:basicMetaInformation.callback.print']"/>
		<xsl:param name="type">content</xsl:param>

		<xsl:variable name="denyCount" select="count($deny)"/>

		<xsl:choose>
			<xsl:when test="$type = 'content'">
				<xsl:apply-templates select="($node/body | $node/opml:body)[count(. | $deny) != $denyCount]" mode="cxsltl:opml20ToText.converter">
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="callback" select="$callback"/>
				</xsl:apply-templates>
			</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="cxsltl:opml20.basicMetaInformation.get">
					<xsl:with-param name="node" select="$node"/>
					<xsl:with-param name="deny" select="$deny"/>
					<xsl:with-param name="defaultValue" select="$defaultValue"/>
					<xsl:with-param name="callback" select="$callback"/>
					<xsl:with-param name="type" select="$type"/>
				</xsl:call-template>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>